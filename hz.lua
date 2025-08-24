-- // ===================== CONFIG =====================
local DOOR_TWEEN_TIME = 2
local DOOR_HOVER_UP  = 5       -- bay lên thêm ở cửa cuối
local DOOR_STOP_GAP  = 0.5     -- nghỉ giữa các tween cửa
local STAND_ABOVE    = 3       -- đứng cách PrimaryPart của cửa bao nhiêu stud
local AUTOFARM_STEP  = 0.6     -- tốc độ lerp tới quái (0..1)
local AUTOFARM_WAIT  = 0.03    -- delay vòng lặp autofarm
local AUTO_SKILL_INTERVAL = 1  -- giây

local START_AUTO_FARM  = true  -- bật AutoFarm sau lượt tween cửa đầu tiên
local START_AUTO_SKILL = true  -- bật AutoSkill sau lượt tween cửa đầu tiên

-- chọn skill mặc định
local selectedSkills = { Z = true, X = false, C = true, G = false, E = false }

-- // ================ SERVICES & REFS =================
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")
local Replicated   = game:GetService("ReplicatedStorage")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

local Doors     = workspace:WaitForChild("School"):WaitForChild("Door")
local Entities  = workspace:WaitForChild("Entities")
local remote    = Replicated:WaitForChild("ByteNetReliable")  -- từ script cũ

-- // ================== STATE FLAGS ====================
local autoFarmOn   = false
local autoSkillOn  = false
local pauseFarmForTween = false
local runningTween = false

-- giữ CanCollide gốc để Noclip on/off an toàn
local originalCanCollide = {}

-- // ================== UTILITIES ======================
local function safeGetHRP()
    if not hrp or not hrp.Parent then
        char = plr.Character or plr.CharacterAdded:Wait()
        hrp  = char:WaitForChild("HumanoidRootPart")
    end
    return hrp
end

-- Noclip
local function enableNoclip()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCanCollide[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end
local function disableNoclip()
    for part, state in pairs(originalCanCollide) do
        if part and part.Parent then part.CanCollide = state end
    end
    originalCanCollide = {}
end

-- BodyVelocity lock (chống knockback)
local function enableVelocity()
    local _hrp = safeGetHRP(); if not _hrp then return end
    if not _hrp:FindFirstChild("Lock") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "Lock"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = _hrp
    end
end
local function disableVelocity()
    local _hrp = safeGetHRP(); if not _hrp then return end
    local bv = _hrp:FindFirstChild("Lock")
    if bv then bv:Destroy() end
end

-- Skills (giữ nguyên kiểu gọi remote của bạn)
local Skills = {
    Z = function() local args = { buffer.fromstring("\a\003\001"), {1755858750.110956} }; remote:FireServer(unpack(args)) end,
    X = function() local args = { buffer.fromstring("\a\005\001"), {1755858758.302091} }; remote:FireServer(unpack(args)) end,
    C = function() local args = { buffer.fromstring("\a\006\001"), {1755858762.557009} }; remote:FireServer(unpack(args)) end,
    G = function() local args = { buffer.fromstring("\a\a\001"), {1755858775.553812} }; remote:FireServer(unpack(args)) end,
    E = function() local args = { buffer.fromstring("\v") }; remote:FireServer(unpack(args)) end,
}

-- Tìm entity gần nhất có HRP
local function getNearestEntity()
    local _hrp = safeGetHRP(); if not _hrp then return nil end
    local nearest, best = nil, math.huge
    for _, e in ipairs(Entities:GetChildren()) do
        if e:IsA("Model") and e:FindFirstChild("HumanoidRootPart") then
            local d = (e.HumanoidRootPart.Position - _hrp.Position).Magnitude
            if d < best then best, nearest = d, e end
        end
    end
    return nearest
end

-- Gọi tấn công (giống script cũ)
local function attackMonster(mon)
    if mon and mon:FindFirstChild("HumanoidRootPart") then
        local args = { buffer.fromstring("\a\004\001"), {mon.HumanoidRootPart.Position.Magnitude} }
        remote:FireServer(unpack(args))
    end
end

-- // ================ DOOR TWEEN LOGIC =================
local function getSortedDoors()
    local _hrp = safeGetHRP(); if not _hrp then return {} end
    local list = {}
    for _, m in ipairs(Doors:GetChildren()) do
        if m:IsA("Model") and m.PrimaryPart then
            local dist = (m.PrimaryPart.Position - _hrp.Position).Magnitude
            table.insert(list, {model = m, distance = dist})
        end
    end
    table.sort(list, function(a,b) return a.distance < b.distance end)
    return list
end

local function tweenToDoorsOnce(options)
    options = options or {}
    local hoverUp   = options.hoverUp   or DOOR_HOVER_UP
    local standUp   = options.standUp   or STAND_ABOVE
    local stopGap   = options.stopGap   or DOOR_STOP_GAP
    local tweenTime = options.tweenTime or DOOR_TWEEN_TIME

    runningTween = true
    pauseFarmForTween = true

    -- tạm tắt lock để tween mượt
    disableVelocity()

    local doors = getSortedDoors()
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    for i, entry in ipairs(doors) do
        local d = entry.model
        if d and d.PrimaryPart then
            local _hrp = safeGetHRP(); if not _hrp then break end
            local targetCF = d.PrimaryPart.CFrame * CFrame.new(0, standUp, 0)
            local tw = TweenService:Create(_hrp, tweenInfo, {CFrame = targetCF})
            tw:Play(); tw.Completed:Wait()
            task.wait(stopGap)

            if i == #doors then
                local finalCF = targetCF * CFrame.new(0, hoverUp, 0)
                local fly = TweenService:Create(_hrp, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = finalCF})
                fly:Play(); fly.Completed:Wait()
                -- KHÔNG anchor để còn farm; nếu muốn đứng yên giữa không trung, bật dòng dưới:
                -- _hrp.Anchored = true
            end
        end
    end

    -- bật lại lock sau khi tween xong
    enableVelocity()
    pauseFarmForTween = false
    runningTween = false
end

-- // ================ AUTOFARM LOOPS ===================
local function startAutoFarm()
    if autoFarmOn then return end
    autoFarmOn = true
    enableNoclip(); enableVelocity()

    task.spawn(function()
        while autoFarmOn do
            if pauseFarmForTween then task.wait(0.1) goto continue end
            local _hrp = safeGetHRP()
            local target = getNearestEntity()
            if _hrp and target and target:FindFirstChild("HumanoidRootPart") then
                local monHRP = target.HumanoidRootPart
                local backOffset = -monHRP.CFrame.LookVector * 2
                local targetPos  = monHRP.Position + backOffset + Vector3.new(0, 4, 0)

                _hrp.CFrame = _hrp.CFrame:lerp(CFrame.new(targetPos, monHRP.Position), AUTOFARM_STEP)

                local bv = _hrp:FindFirstChild("Lock")
                if bv then bv.Velocity = Vector3.new(0,0,0) end

                attackMonster(target)
            end
            task.wait(AUTOFARM_WAIT)
            ::continue::
        end
    end)
end

local function stopAutoFarm()
    autoFarmOn = false
    disableNoclip(); disableVelocity()
end

local function startAutoSkill()
    if autoSkillOn then return end
    autoSkillOn = true
    task.spawn(function()
        while autoSkillOn do
            for key, on in pairs(selectedSkills) do
                if on and Skills[key] then
                    pcall(Skills[key])
                end
            end
            task.wait(AUTO_SKILL_INTERVAL)
        end
    end)
end
local function stopAutoSkill() autoSkillOn = false end

-- // ===== WATCHER: Entities rỗng -> đầy => tween cửa ====
local function watchEntitiesAndRetween()
    local lastCount = #Entities:GetChildren()
    local wasEmpty = (lastCount == 0)

    -- lắng nghe thay đổi để phản ứng tức thời
    Entities.ChildAdded:Connect(function()
        local count = #Entities:GetChildren()
        if wasEmpty and count > 0 and not runningTween then
            -- qua màn mới -> tween cửa
            tweenToDoorsOnce()
            wasEmpty = false
        end
    end)

    Entities.ChildRemoved:Connect(function()
        local count = #Entities:GetChildren()
        if count == 0 then
            wasEmpty = true -- đánh dấu đã xong màn hiện tại
        end
    end)
end

-- // ================== RESPAWN SAFETY ==================
plr.CharacterAdded:Connect(function(c)
    char = c
    hrp  = char:WaitForChild("HumanoidRootPart")
    if autoFarmOn then
        enableNoclip(); enableVelocity()
    end
end)

-- // ===================== MAIN FLOW ====================
-- 1) Tween qua cửa lần đầu
tweenToDoorsOnce()

-- 2) Bật AutoFarm / AutoSkill (tuỳ config)
if START_AUTO_FARM  then startAutoFarm()  end
if START_AUTO_SKILL then startAutoSkill() end

-- 3) Theo dõi Entities để tự tween cửa khi qua màn mới
watchEntitiesAndRetween()

-- Gợi ý: nếu muốn tắt thủ công
-- stopAutoFarm(); stopAutoSkill()
