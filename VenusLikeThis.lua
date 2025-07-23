if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function getMaxPart(folder)
    local maxPart = nil
    local maxNum = -math.huge
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("BasePart") then
            local num = tonumber(obj.Name)
            if num and num > maxNum then
                maxNum = num
                maxPart = obj
            end
        end
    end
    return maxPart
end

local function getAllMaxParts()
    local parts = {}
    local paths = Workspace:FindFirstChild("Paths")
    if not paths then return parts end
    for _, folder in ipairs(paths:GetChildren()) do
        if folder:IsA("Folder") then
            local part = getMaxPart(folder)
            if part then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

local function getModelPosition(model)
    if model.PrimaryPart then
        return model:GetPrimaryPartCFrame().Position
    else
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position end
    end
    return nil
end

local function getNearestEnemyTo(part)
    local enemyFolder = Workspace:FindFirstChild("EnemyFolder")
    if not enemyFolder then return nil end
    local closest = nil
    local shortest = math.huge
    for _, model in ipairs(enemyFolder:GetChildren()) do
        if model:IsA("Model") then
            local pos = getModelPosition(model)
            if pos then
                local dist = (pos - part.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = model
                end
            end
        end
    end
    return closest
end

while true do
    local hrp = getHRP()
    local parts = getAllMaxParts()
    for _, part in ipairs(parts) do
        local enemy = getNearestEnemyTo(part)
        if enemy then
            local pos = getModelPosition(enemy)
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                wait(getgenv().Config["Delay TP"] or 2)
            end
        end
    end
    wait(1)
end
