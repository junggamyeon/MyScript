-- ====================== CONFIG ======================
local DOOR_TWEEN_TIME  = 2
local DOOR_HOVER_UP    = 5
local DOOR_STAND_ABOVE = 3
local DOOR_PAUSE       = 0.4

local MOVE_LERP        = 0.6
local FARM_LOOP_DELAY  = 0.03
local BEHIND_OFFSET    = 2
local ABOVE_OFFSET     = 4

-- Bật nếu game có remote + buffer, muốn spam skill/đánh
local ENABLE_REMOTE_ATTACK = false
local ENABLE_REMOTE_SKILLS = false

-- ==================== SERVICES/REFS ==================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Replicated   = game:GetService("ReplicatedStorage")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

-- Doors: ưu tiên "Doors", fallback "Door"
local School = workspace:WaitForChild("School")
local Doors  = School:FindFirstChild("Doors") or School:FindFirstChild("Door")
if not Doors then error("Không có workspace.School.Doors/Door") end

local Entities = workspace:FindFirstChild("Entities")
if not Entities then error("Không có workspace.Entities") end

-- Optional remote
local Remote = Replicated:FindFirstChild("ByteNetReliable")
local HAS_BUFFER = (type(buffer)=="table" and type(buffer.fromstring)=="function")
local function buf(s) return HAS_BUFFER and buffer.fromstring(s) or nil end

-- ======================= STATE =======================
local STATE = "BOOT"          -- BOOT | NEED_TWEEN | FARM | AWAIT_WAVE
local pauseFarmForTween = false
local awaitingWave = false
local runningTween = false

-- ====================== HELPERS ======================
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
        if d:IsA("BasePart") then m.PrimaryPart = d; return true end
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

-- velocity lock
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

-- ================ REMOTE OPS (tùy chọn) ==============
local function remoteAttack(mon)
    if not (ENABLE_REMOTE_ATTACK and Remote and HAS_BUFFER and mon and mon:FindFirstChild("HumanoidRootPart")) then return end
    pcall(function()
        Remote:FireServer(buf("\a\004\001"), {mon.HumanoidRootPart.Position.Magnitude})
    end)
end
local function remoteSkills()
    if not (ENABLE_REMOTE_SKILLS and Remote and HAS_BUFFER) then return end
    local pay={Z="\a\003\001",X="\a\005\001",C="\a\006\001",G="\a\a\001",E="\v"}
    for k,s in pairs(pay) do
        pcall(function()
            local a=buf(s)
            if a then
                if k=="E" then Remote:FireServer(a)
                else Remote:FireServer(a,{tick()}) end
            end
        end)
    end
end

-- ================== DOOR TWEEN (ONCE) =================
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

local function tweenDoorsOnce()
    local _hrp=safeHRP(); if not _hrp then return end
    local doors=getSortedDoors()
    if #doors==0 then warn("Doors rỗng/không có PrimaryPart"); return end

    runningTween=true
    pauseFarmForTween=true
    disableVelocityLock()

    local info=TweenInfo.new(DOOR_TWEEN_TIME,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
    for i,entry in ipairs(doors) do
        local d=entry.model
        if d and d.PrimaryPart then
            _hrp=safeHRP(); if not _hrp then break end
            local target=d.PrimaryPart.CFrame * CFrame.new(0,DOOR_STAND_ABOVE,0)
            local tw=TweenService:Create(_hrp,info,{CFrame=target}); tw:Play(); tw.Completed:Wait()
            task.wait(DOOR_PAUSE)
            if i==#doors then
                local up=TweenService:Create(_hrp,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
                    {CFrame=target*CFrame.new(0,DOOR_HOVER_UP,0)})
                up:Play(); up.Completed:Wait()
            end
        end
    end

    enableVelocityLock()
    runningTween=false
    pauseFarmForTween=false
end

-- ==================== FARM LOOP ======================
local function farmTick()
    if pauseFarmForTween then return end
    local _hrp=safeHRP(); if not _hrp then return end
    local mon=nearestEntity(); if not mon then return end
    local h=mon:FindFirstChild("HumanoidRootPart"); if not h then return end

    local posBehind=h.Position + (-h.CFrame.LookVector*BEHIND_OFFSET) + Vector3.new(0,ABOVE_OFFSET,0)
    _hrp.CFrame=_hrp.CFrame:lerp(CFrame.new(posBehind,h.Position),MOVE_LERP)

    local bv=_hrp:FindFirstChild("Lock"); if bv then bv.Velocity=Vector3.new(0,0,0) end
    remoteAttack(mon); remoteSkills()
end

-- ================== ENTITY WATCHER ===================
-- Quy tắc: 
--  - Khi Entities trống -> awaitingWave=true
--  - Khi có model mới và awaitingWave=true -> PAUSE farm, tween cửa, rồi farm tiếp
awaitingWave = (countEntities()==0)

Entities.ChildRemoved:Connect(function()
    if countEntities()==0 then
        awaitingWave = true
    end
end)

Entities.ChildAdded:Connect(function()
    -- Wave mới bắt đầu: bắt buộc tween cửa trước khi farm
    if awaitingWave and not runningTween then
        pauseFarmForTween = true   -- chặn farm ngay lập tức
        tweenDoorsOnce()           -- chạy tween cửa
        awaitingWave = false
        pauseFarmForTween = false  -- cho phép farm chạy tiếp
    end
end)

-- ===================== MAIN LOOP =====================
-- Khởi động: nếu đang có quái -> tween cửa 1 lần rồi bắt đầu farm
if countEntities() > 0 then
    tweenDoorsOnce()
    awaitingWave = false
else
    awaitingWave = true
end

enableVelocityLock()

task.spawn(function()
    while true do
        if not awaitingWave then
            farmTick()
        end
        task.wait(FARM_LOOP_DELAY)
    end
end)

-- giữ lock khi respawn
plr.CharacterAdded:Connect(function(c)
    char=c; hrp=char:WaitForChild("HumanoidRootPart"); enableVelocityLock()
end)
