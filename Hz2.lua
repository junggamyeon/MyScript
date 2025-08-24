-- ====================== CONFIG ======================
local DOOR_TWEEN_TIME  = 2
local DOOR_HOVER_UP    = 5     -- bay thêm ở cửa cuối
local DOOR_STAND_ABOVE = 3     -- đứng cách mặt cửa
local DOOR_PAUSE       = 0.4   -- nghỉ giữa các cửa

local MOVE_LERP        = 0.6   -- 0..1
local FARM_LOOP_DELAY  = 0.03  -- giây
local BEHIND_OFFSET    = 2     -- đứng sau lưng quái 2 studs
local ABOVE_OFFSET     = 4     -- đứng cao hơn 4 studs

-- Bật tấn công/skill qua Remote (nếu game có). Nếu không, để false để tránh nil.
local ENABLE_REMOTE_ATTACK = true
local ENABLE_REMOTE_SKILLS = true

-- ==================== SERVICES/REFS ==================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Replicated   = game:GetService("ReplicatedStorage")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

-- Path: Doors (fallback sang Door)
local School = workspace:WaitForChild("School")
local Doors  = School:FindFirstChild("Doors") or School:FindFirstChild("Door")
if not Doors then
    error("[Flow] Không tìm thấy workspace.School.Doors (hoặc Door).")
end

local Entities = workspace:FindFirstChild("Entities")
if not Entities then
    error("[Flow] Không tìm thấy workspace.Entities.")
end

-- Remote (tùy game; chỉ dùng nếu bật ở config)
local Remote = Replicated:FindFirstChild("ByteNetReliable")
local HAS_BUFFER = (getfenv and getfenv().buffer and getfenv().buffer.fromstring) and true or (buffer and buffer.fromstring and true) or false
local function buf(s)  -- wrapper an toàn
    if HAS_BUFFER then
        if getfenv and getfenv().buffer and getfenv().buffer.fromstring then
            return getfenv().buffer.fromstring(s)
        elseif buffer and buffer.fromstring then
            return buffer.fromstring(s)
        end
    end
    return nil
end

-- ======================= STATE =======================
local STATE = "BOOT"   -- BOOT -> NEED_TWEEN -> FARM -> AWAIT_WAVE
local runningTween = false
local autoFarmOn   = false

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
        if d:IsA("BasePart") then
            m.PrimaryPart = d
            return true
        end
    end
    return false
end

local function countEntities()
    local n = 0
    for _, e in ipairs(Entities:GetChildren()) do
        if e:IsA("Model") and e:FindFirstChild("HumanoidRootPart") then
            n += 1
        end
    end
    return n
end

local function nearestEntity()
    local _hrp = safeHRP(); if not _hrp then return nil end
    local best, near = math.huge, nil
    for _, e in ipairs(Entities:GetChildren()) do
        local monHRP = e:FindFirstChild("HumanoidRootPart")
        if e:IsA("Model") and monHRP then
            local d = (monHRP.Position - _hrp.Position).Magnitude
            if d < best then best, near = d, e end
        end
    end
    return near
end

-- chống knockback (BodyVelocity)
local function enableVelocityLock()
    local _hrp = safeHRP(); if not _hrp then return end
    if not _hrp:FindFirstChild("Lock") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "Lock"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = _hrp
    end
end
local function disableVelocityLock()
    local _hrp = safeHRP(); if not _hrp then return end
    local bv = _hrp:FindFirstChild("Lock")
    if bv then bv:Destroy() end
end

-- ================== REMOTE ACTIONS ===================
local function remoteAttack(mon)
    if not (ENABLE_REMOTE_ATTACK and Remote and mon and mon:FindFirstChild("HumanoidRootPart")) then return end
    if not HAS_BUFFER then return end
    local ok, err = pcall(function()
        local args = { buf("\a\004\001"), {mon.HumanoidRootPart.Position.Magnitude} }
        if args[1] then
            Remote:FireServer(unpack(args))
        end
    end)
    if not ok then warn("[RemoteAttack]", err) end
end

local SKILL_KEYS = {"Z","X","C","G","E"}  -- chọn theo ý bạn
local function remoteSkills()
    if not (ENABLE_REMOTE_SKILLS and Remote and HAS_BUFFER) then return end
    for _, k in ipairs(SKILL_KEYS) do
        local payloads = {
            Z = "\a\003\001",
            X = "\a\005\001",
            C = "\a\006\001",
            G = "\a\a\001",
            E = "\v",
        }
        local sig = payloads[k]
        if sig then
            pcall(function()
                local a = buf(sig)
                if a then
                    if k == "E" then
                        Remote:FireServer(a) -- E không kèm bảng số như script bạn
                    else
                        Remote:FireServer(a, {tick()}) -- số giả, tránh nil
                    end
                end
            end)
        end
    end
end

-- ================== DOOR TWEEN (ONCE) =================
local function getSortedDoors()
    local _hrp = safeHRP(); if not _hrp then return {} end
    local list = {}
    for _, m in ipairs(Doors:GetChildren()) do
        if m:IsA("Model") and setPrimaryPartIfMissing(m) and m.PrimaryPart then
            local dist = (m.PrimaryPart.Position - _hrp.Position).Magnitude
            table.insert(list, {model = m, distance = dist})
        end
    end
    table.sort(list, function(a,b) return a.distance < b.distance end)
    return list
end

local function tweenDoorsOnce()
    local _hrp = safeHRP(); if not _hrp then return end
    local doors = getSortedDoors()
    if #doors == 0 then
        warn("[Flow] Doors rỗng hoặc Model không có BasePart.")
        return
    end

    runningTween = true
    disableVelocityLock() -- cho tween mượt

    local info = TweenInfo.new(DOOR_TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    for i, entry in ipairs(doors) do
        local d = entry.model
        if d and d.PrimaryPart then
            _hrp = safeHRP(); if not _hrp then break end
            local targetCF = d.PrimaryPart.CFrame * CFrame.new(0, DOOR_STAND_ABOVE, 0)
            local t = TweenService:Create(_hrp, info, {CFrame = targetCF})
            t:Play(); t.Completed:Wait()
            task.wait(DOOR_PAUSE)
            if i == #doors then
                local up = TweenService:Create(_hrp, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                                               {CFrame = targetCF * CFrame.new(0, DOOR_HOVER_UP, 0)})
                up:Play(); up.Completed:Wait()
            end
        end
    end

    enableVelocityLock()
    runningTween = false
end

-- ==================== FARM LOOP ======================
local function farmTick()
    local _hrp = safeHRP(); if not _hrp then return end
    local mon = nearestEntity()
    if not mon then return end

    local monHRP = mon:FindFirstChild("HumanoidRootPart")
    if not monHRP then return end

    local posBehind = monHRP.Position + (-monHRP.CFrame.LookVector * BEHIND_OFFSET) + Vector3.new(0, ABOVE_OFFSET, 0)
    _hrp.CFrame = _hrp.CFrame:lerp(CFrame.new(posBehind, monHRP.Position), MOVE_LERP)

    local bv = _hrp:FindFirstChild("Lock")
    if bv then bv.Velocity = Vector3.new(0,0,0) end

    remoteAttack(mon)
    remoteSkills()
end

-- ================== STATE MACHINE ====================
local function toState(s)
    STATE = s
    print("[STATE] ->", s)
end

-- khởi động: quyết định NEED_TWEEN hay AWAIT_WAVE
if countEntities() > 0 then
    toState("NEED_TWEEN")
else
    toState("AWAIT_WAVE")
end

-- vòng điều khiển
task.spawn(function()
    while true do
        if STATE == "NEED_TWEEN" then
            tweenDoorsOnce()
            toState("FARM")

        elseif STATE == "FARM" then
            if countEntities() == 0 then
                toState("AWAIT_WAVE")
            else
                farmTick()
                task.wait(FARM_LOOP_DELAY)
            end

        elseif STATE == "AWAIT_WAVE" then
            -- chờ có quái mới sinh ra => vào màn mới
            if countEntities() > 0 and not runningTween then
                toState("NEED_TWEEN")
            else
                task.wait(0.1)
            end
        else
            toState("AWAIT_WAVE")
        end
    end
end)

-- giữ lock khi respawn
Players.LocalPlayer.CharacterAdded:Connect(function(c)
    char = c
    hrp  = char:WaitForChild("HumanoidRootPart")
    enableVelocityLock()
end)

-- bật lock ngay từ đầu
enableVelocityLock()
print("[Flow] Script started.")
