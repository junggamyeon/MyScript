-- === CONFIG ===
local DOOR_TWEEN_TIME  = 2
local DOOR_STAND_ABOVE = 0.1
local DOOR_HOVER_UP    = 5
local DOOR_PAUSE       = 0.1

local MOVE_LERP        = 0.6
local FARM_LOOP_DELAY  = 0.03
local BEHIND_OFFSET    = 2
local ABOVE_OFFSET     = 4

local ENABLE_REMOTE_ATTACK = true
local AUTOPROMPT_RADIUS    = 12
local LOOT_TELE_OFFSET_Y   = 3

-- === SERVICES & BASE ===
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Replicated   = game:GetService("ReplicatedStorage")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

local School     = workspace:WaitForChild("School")
local Doors      = School:FindFirstChild("Doors") or School:FindFirstChild("Door")
local Entities   = workspace:FindFirstChild("Entities")
local DropItems  = workspace:FindFirstChild("DropItems")

local Remote = Replicated:FindFirstChild("ByteNetReliable")
local HAS_BUFFER = (type(buffer)=="table" and type(buffer.fromstring)=="function")
local function buf(s) return HAS_BUFFER and buffer.fromstring(s) or nil end

-- === STATE ===
local runningTween = false
local doorTweened  = false
local RUNNING      = true

-- === UTILS ===
local function safeHRP()
    if not hrp or not hrp.Parent then
        char = plr.Character or plr.CharacterAdded:Wait()
        hrp  = char:WaitForChild("HumanoidRootPart")
    end
    return hrp
end

local function setPrimaryPartIfMissing(m)
    if m.PrimaryPart then return true end
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") then m.PrimaryPart = d return true end
    end
    return false
end

local function countEntities()
    local n=0
    for _, e in ipairs(Entities:GetChildren()) do
        if e:IsA("Model") and e:FindFirstChild("HumanoidRootPart") then n+=1 end
    end
    return n
end

local function nearestEntity()
    local _hrp=safeHRP(); if not _hrp then return nil end
    local best=math.huge; local near=nil
    for _, e in ipairs(Entities:GetChildren()) do
        local h=e:FindFirstChild("HumanoidRootPart")
        if e:IsA("Model") and h then
            local d=(h.Position - _hrp.Position).Magnitude
            if d<best then best=d; near=e end
        end
    end
    return near
end

local function enableVelocityLock()
    local _hrp=safeHRP(); if not _hrp then return end
    if not _hrp:FindFirstChild("Lock") then
        local bv=Instance.new("BodyVelocity")
        bv.Name="Lock"; bv.MaxForce=Vector3.new(9e9,9e9,9e9); bv.Velocity=Vector3.new(0,0,0); bv.Parent=_hrp
    end
end
local function disableVelocityLock()
    local _hrp=safeHRP(); if not _hrp then return end
    local bv=_hrp:FindFirstChild("Lock"); if bv then bv:Destroy() end
end

local function remoteAttack(mon)
    if not (ENABLE_REMOTE_ATTACK and Remote and HAS_BUFFER and mon) then return end
    local h = mon:FindFirstChild("HumanoidRootPart"); if not h then return end
    pcall(function() Remote:FireServer(buf("\a\004\001"), {h.Position.Magnitude}) end)
end

local function getSortedDoors()
    local _hrp=safeHRP(); if not _hrp then return {} end
    local list={}
    for _, m in ipairs(Doors:GetChildren()) do
        if m:IsA("Model") and setPrimaryPartIfMissing(m) and m.PrimaryPart then
            local dist=(m.PrimaryPart.Position - _hrp.Position).Magnitude
            table.insert(list,{model=m,distance=dist})
        end
    end
    table.sort(list,function(a,b) return a.distance<b.distance end)
    return list
end

-- === CORE ACTIONS ===
local function tweenDoorsOnce()
    local _hrp=safeHRP(); if not _hrp then return end
    local doors=getSortedDoors()
    if #doors==0 then return end
    runningTween = true
    disableVelocityLock()
    _hrp.Anchored  = true
    local info=TweenInfo.new(DOOR_TWEEN_TIME,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
    for i,entry in ipairs(doors) do
        local d=entry.model
        if d and d.PrimaryPart then
            _hrp=safeHRP(); if not _hrp then break end
            local baseCF = d.PrimaryPart.CFrame * CFrame.new(0, DOOR_STAND_ABOVE, 0)
            local tw = TweenService:Create(_hrp, info, {CFrame = baseCF})
            tw:Play(); tw.Completed:Wait()
            if i==#doors then
                local up = TweenService:Create(_hrp, TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
                    {CFrame = baseCF * CFrame.new(0, DOOR_HOVER_UP, 0)})
                up:Play(); up.Completed:Wait()
            else
                task.wait(DOOR_PAUSE)
            end
        end
    end
    _hrp.Anchored = false
    enableVelocityLock()
    runningTween = false
end

local function warpToNearest()
    local _hrp=safeHRP(); if not _hrp then return end
    local mon=nearestEntity(); if not mon then return end
    local h=mon:FindFirstChild("HumanoidRootPart"); if not h then return end
    local posBehind = h.Position + (-h.CFrame.LookVector * BEHIND_OFFSET) + Vector3.new(0, ABOVE_OFFSET, 0)
    _hrp.CFrame = CFrame.new(posBehind, h.Position)
end

local function farmTick()
    local _hrp=safeHRP(); if not _hrp then return end
    local mon=nearestEntity(); if not mon then return end
    local h=mon:FindFirstChild("HumanoidRootPart"); if not h then return end
    local posBehind=h.Position + (-h.CFrame.LookVector*BEHIND_OFFSET) + Vector3.new(0,ABOVE_OFFSET,0)
    _hrp.CFrame=_hrp.CFrame:lerp(CFrame.new(posBehind,h.Position),MOVE_LERP)
    local bv=_hrp:FindFirstChild("Lock"); if bv then bv.Velocity=Vector3.new(0,0,0) end
    remoteAttack(mon)
end

-- === DROP ITEMS COLLECTOR ===
local function collectDropItems()
    local _hrp = safeHRP(); if not _hrp then return end
    if not DropItems then return end
    for _, part in ipairs(DropItems:GetChildren()) do
        if not RUNNING then return end
        if part:IsA("BasePart") then
            _hrp.CFrame = part.CFrame + Vector3.new(0, LOOT_TELE_OFFSET_Y, 0)
            task.wait(0.05)
        end
    end
end

-- === AUTO PROXIMITY PROMPT (an toàn, chỉ cho vật thể trong map) ===
local function autoPromptNearby()
    local _hrp = safeHRP(); if not _hrp then return end
    local origin = _hrp.Position
    for _, inst in ipairs(workspace:GetDescendants()) do
        if not RUNNING then return end
        local pp = inst:IsA("ProximityPrompt") and inst or nil
        if pp and pp.Enabled and pp.Parent and pp.Parent:IsDescendantOf(workspace) then
            local part = pp.Parent:IsA("BasePart") and pp.Parent or pp.Parent:FindFirstChildWhichIsA("BasePart")
            if part and (part.Position - origin).Magnitude <= AUTOPROMPT_RADIUS then
                pcall(function() fireproximityprompt(pp) end)
                task.wait(0.02)
            end
        end
    end
end
-- (Ý tưởng kích prompt tự động được tham chiếu từ file bạn cung cấp, nhưng đã bỏ toàn bộ phần webhook/nhắm tới người chơi khác.) :contentReference[oaicite:1]{index=1}

-- === GUI TOGGLE ===
local function buildToggle()
    local sg = Instance.new("ScreenGui")
    sg.Name = "FarmToggleUI"
    sg.ResetOnSpawn = false
    sg.Parent = plr:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 120)
    btn.TextScaled = true
    btn.Text = "Running: ON"
    btn.BackgroundTransparency = 0.15
    btn.Parent = sg

    btn.MouseButton1Click:Connect(function()
        RUNNING = not RUNNING
        btn.Text = RUNNING and "Running: ON" or "Running: OFF"
    end)
end

-- === BOOT ===
enableVelocityLock()
buildToggle()

task.spawn(function()
    while true do
        if RUNNING then
            if countEntities() == 0 then
                doorTweened = false
                task.wait(0.2)
            else
                if not doorTweened and not runningTween then
                    tweenDoorsOnce()
                    doorTweened = true
                end
                warpToNearest()
                farmTick()
            end
        end
        task.wait(FARM_LOOP_DELAY)
    end
end)

task.spawn(function()
    while true do
        if RUNNING then
            collectDropItems()
        end
        task.wait(0.3)
    end
end)

task.spawn(function()
    while true do
        if RUNNING then
            autoPromptNearby()
        end
        task.wait(0.25)
    end
end)

plr.CharacterAdded:Connect(function(c)
    char=c; hrp=char:WaitForChild("HumanoidRootPart")
    enableVelocityLock()
end)
