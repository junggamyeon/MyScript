-- ====================== CONFIG ======================
local DOOR_TWEEN_TIME   = 2
local DOOR_HOVER_UP     = 5      -- bay thêm ở cửa cuối
local STOP_GAP_BETWEEN  = 0.5    -- nghỉ giữa các tween
local STAND_ABOVE       = 3      -- đứng cách PrimaryPart của cửa

local AUTOFARM_STEP     = 0.6    -- mức lerp 0..1
local AUTOFARM_DELAY    = 0.03   -- delay vòng farm

-- Tùy chọn tấn công qua Remote (mặc định tắt để tránh lỗi nil)
local ENABLE_REMOTE_ATTACK = false

-- ==================== SERVICES/REFS ==================
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local Replicated    = game:GetService("ReplicatedStorage")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

-- workspace paths (Doors có thể là Door -> fallback)
local School = workspace:WaitForChild("School")
local Doors  = School:FindFirstChild("Doors") or School:FindFirstChild("Door")
if not Doors then
    error("[Rework] Không tìm thấy workspace.School.Doors (hoặc Door).")
end

local Entities = workspace:FindFirstChild("Entities")
if not Entities then
    error("[Rework] Không tìm thấy workspace.Entities.")
end

-- Remote (chỉ dùng nếu ENABLE_REMOTE_ATTACK = true và đầy đủ)
local Remote = Replicated:FindFirstChild("ByteNetReliable")
local hasBuffer = (typeof(buffer) == "table" and typeof(buffer.fromstring) == "function")

-- ======================= STATE =======================
local runningTween        = false
local pauseFarmForTween   = false
local autoFarmOn          = false

local originalCanCollide  = {}

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
    -- cố gắng chọn BasePart đầu tiên làm PrimaryPart
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") then
            m.PrimaryPart = d
            return true
        end
    end
    return false
end

-- Noclip on/off
local function enableNoclip()
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            originalCanCollide[p] = p.CanCollide
            p.CanCollide = false
        end
    end
end
local function disableNoclip()
    for part, state in pairs(originalCanCollide) do
        if part and part.Parent then part.CanCollide = state end
    end
    originalCanCollide = {}
end

-- Chống knockback (BodyVelocity 0)
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

-- Lấy list cửa đã sort theo khoảng cách
local function getSortedDoors()
    local _hrp = safeHRP(); if not _hrp then return {} end
    local list = {}
    for _, m in ipairs(Doors:GetChildren()) do
        if m:IsA("Model") and setPrimaryPartIfMissing(m) and m.PrimaryPart then
            local dist = (m.PrimaryPart.Position - _hrp.Position).Magnitude
            table.insert(list, {model = m, distance = dist})
        end
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    return list
end

-- ================== DOOR TWEEN (ONCE) =================
local function tweenToDoorsOnce()
    local _hrp = safeHRP(); if not _hrp then return end

    local doors = getSortedDoors()
    if #doors == 0 then
        warn("[Rework] Không có Model hợp lệ trong Doors (cần có BasePart để set PrimaryPart).")
        return
    end

    runningTween = true
    pauseFarmForTween = true
    disableVelocityLock() -- tránh gây cản trong lúc tween

    local info = TweenInfo.new(DOOR_TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    for i, entry in ipairs(doors) do
        local d = entry.model
        if d and d.PrimaryPart then
            _hrp = safeHRP(); if not _hrp then break end
            local targetCF = d.PrimaryPart.CFrame * CFrame.new(0, STAND_ABOVE, 0)

            local t = TweenService:Create(_hrp, info, {CFrame = targetCF})
            t:Play(); t.Completed:Wait()
            task.wait(STOP_GAP_BETWEEN)

            -- cửa cuối: bay lên thêm
            if i == #doors then
                local finalCF = targetCF * CFrame.new(0, DOOR_HOVER_UP, 0)
                local fly = TweenService:Create(_hrp, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = finalCF})
                fly:Play(); fly.Completed:Wait()

                -- Nếu muốn đứng yên trên không thì mở dòng dưới:
                -- _hrp.Anchored = true
            end
        end
    end

    enableVelocityLock()
    pauseFarmForTween = false
    runningTween = false
end

-- =================== AUTOFARM MOVE ====================
local function nearestEntity()
    local _hrp = safeHRP(); if not _hrp then return nil end
    local best, near = math.huge, nil
    for _, e in ipairs(Entities:GetChildren()) do
        if e:IsA("Model") and e:FindFirstChild("HumanoidRootPart") then
            local d = (e.HumanoidRootPart.Position - _hrp.Position).Magnitude
            if d < best then best = d; near = e end
        end
    end
    return near
end

-- ATTACK (OPTIONAL) — mặc định tắt để tránh nil do buffer/remote
local function attack(mon)
    if not ENABLE_REMOTE_ATTACK then return end
    if not (Remote and mon and mon:FindFirstChild("HumanoidRootPart")) then return end
    if not hasBuffer then return end
    -- Tham số giả lập theo script cũ; giữ pcall để an toàn
    pcall(function()
        local args = { buffer.fromstring("\a\004\001"), {mon.HumanoidRootPart.Position.Magnitude} }
        Remote:FireServer(unpack(args))
    end)
end

local function startAutoFarm()
    if autoFarmOn then return end
    autoFarmOn = true
    enableNoclip()
    enableVelocityLock()

    task.spawn(function()
        while autoFarmOn do
            if pauseFarmForTween then task.wait(0.1); goto continue end
            local _hrp = safeHRP()
            local target = nearestEntity()
            if _hrp and target and target:FindFirstChild("HumanoidRootPart") then
                local monHRP = target.HumanoidRootPart
                local back   = -monHRP.CFrame.LookVector * 2
                local pos    = monHRP.Position + back + Vector3.new(0, 4, 0)
                _hrp.CFrame  = _hrp.CFrame:lerp(CFrame.new(pos, monHRP.Position), AUTOFARM_STEP)

                local bv = _hrp:FindFirstChild("Lock")
                if bv then bv.Velocity = Vector3.new(0,0,0) end

                attack(target)
            end
            task.wait(AUTOFARM_DELAY)
            ::continue::
        end
    end)
end

local function stopAutoFarm()
    autoFarmOn = false
    disableNoclip()
    disableVelocityLock()
end

-- ========== WATCHER: Entities rỗng -> đầy => tween ==========
local function watchEntitiesAndRetween()
    local wasEmpty = (#Entities:GetChildren() == 0)

    Entities.ChildAdded:Connect(function()
        local count = #Entities:GetChildren()
        if wasEmpty and count > 0 and not runningTween then
            tweenToDoorsOnce()
            wasEmpty = false
        end
    end)

    Entities.ChildRemoved:Connect(function()
        if #Entities:GetChildren() == 0 then
            wasEmpty = true
        end
    end)
end

-- =============== RESPAWN SAFETY =================
plr.CharacterAdded:Connect(function(c)
    char = c
    hrp  = char:WaitForChild("HumanoidRootPart")
    if autoFarmOn then
        enableNoclip()
        enableVelocityLock()
    end
end)

-- ===================== MAIN =====================
tweenToDoorsOnce()
startAutoFarm()
watchEntitiesAndRetween()

-- Nếu muốn tắt tay:
-- stopAutoFarm()
