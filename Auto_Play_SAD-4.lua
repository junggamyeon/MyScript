

local unitNames = config.Units.Names
local unitIndex = config.Units.Index

local isSpawningActive = true 

if game.PlaceId ~= 15601725874 and config.enableGUI then
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = playerGui:FindFirstChild("InfoGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "InfoGui"
        screenGui.Parent = playerGui
    end

    local infoFrame = screenGui:FindFirstChild("InfoFrame")
    if not infoFrame then
        infoFrame = Instance.new("Frame")
        infoFrame.Name = "InfoFrame"
        infoFrame.Size = UDim2.new(0, 200, 0, 150)
        infoFrame.Position = UDim2.new(1, -210, 0, 10)
        infoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        infoFrame.BackgroundTransparency = 0.5
        infoFrame.Parent = screenGui
    end

    local waveLabel = infoFrame:FindFirstChild("WaveLabel")
    if not waveLabel then
        waveLabel = Instance.new("TextLabel")
        waveLabel.Name = "WaveLabel"
        waveLabel.Size = UDim2.new(1, 0, 0, 30)
        waveLabel.Position = UDim2.new(0, 0, 0, 0)
        waveLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        waveLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        waveLabel.Text = "Wave: N/A"
        waveLabel.Parent = infoFrame
    end

    local mapLabel = infoFrame:FindFirstChild("MapLabel")
    if not mapLabel then
        mapLabel = Instance.new("TextLabel")
        mapLabel.Name = "MapLabel"
        mapLabel.Size = UDim2.new(1, 0, 0, 30)
        mapLabel.Position = UDim2.new(0, 0, 0, 30)
        mapLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        mapLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        mapLabel.Text = "Map: N/A"
        mapLabel.Parent = infoFrame
    end

    local playersGemsLabel = Instance.new("TextLabel")
    playersGemsLabel.Name = "PlayersGemsLabel"
    playersGemsLabel.Size = UDim2.new(1, 0, 0, 30)
    playersGemsLabel.Position = UDim2.new(0, 0, 0, 60)
    playersGemsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    playersGemsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    playersGemsLabel.Text = "Gems: N/A"
    playersGemsLabel.Parent = infoFrame

    local playersCoinsLabel = Instance.new("TextLabel")
    playersCoinsLabel.Name = "PlayersCoinsLabel"
    playersCoinsLabel.Size = UDim2.new(1, 0, 0, 30)
    playersCoinsLabel.Position = UDim2.new(0, 0, 0, 90)
    playersCoinsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    playersCoinsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    playersCoinsLabel.Text = "Coins: N/A"
    playersCoinsLabel.Parent = infoFrame

    local function updateInfo()
        local waveFolder = Workspace:FindFirstChild("Info")
        if waveFolder then
            local wave = waveFolder:FindFirstChild("Wave")
            local currentWave = wave and wave.Value or "N/A"
            print("Current Wave: " .. tostring(currentWave))
            waveLabel.Text = "Wave: " .. currentWave
        else
            print("Wave folder not found")
        end

        local mapFolder = Workspace:FindFirstChild("Map")
        local mapName = "N/A"

        if mapFolder then
            for _, child in ipairs(mapFolder:GetChildren()) do
                if child:IsA("Folder") then
                    mapName = child.Name
                    break
                end
            end
            print("Current Map: " .. tostring(mapName))
            mapLabel.Text = "Map: " .. mapName
        else
            print("Map folder not found")
        end

        local playerFolder = Players:FindFirstChild(player.Name)
        if playerFolder then
            local gems = playerFolder:FindFirstChild("Gems")
            local coins = playerFolder:FindFirstChild("Coins")
            
            local gemsValue = gems and gems.Value or "N/A"
            local coinsValue = coins and coins.Value or "N/A"

            print("Player: " .. player.Name)
            print("Gems: " .. gemsValue)
            print("Coins: " .. coinsValue)

            playersGemsLabel.Text = "Gems: " .. gemsValue
            playersCoinsLabel.Text = "Coins: " .. coinsValue
        else
            print("Player folder not found for: " .. player.Name)
            playersGemsLabel.Text = "Gems: N/A"
            playersCoinsLabel.Text = "Coins: N/A"
        end
    end

    spawn(function()
        while true do
            updateInfo()
            wait(5)
        end
    end)
end

local function autoChallCheck()
    if game.PlaceId == 15601725874 and config.AutoChall then
        local challengeNumber = game.Workspace.ChallengeElevators.Data.ChallengeNumber.Value
        if challengeNumber ~= config.Chall then
            local player = game.Players.LocalPlayer
            player.Character:SetPrimaryPartCFrame(CFrame.new(131.874512, 7.22859669, -68.9522934, -1, 0, 0, 0, 1, 0, 0, 0, -1))
            wait(3)
            game:GetService("ReplicatedStorage").Functions.RequestChallengeStart:InvokeServer()
        end
    end
end

autoChallCheck()

if game.PlaceId ~= 15601725874 then
    local function onWaveChanged()
        local waveValue = game.Workspace.Info.Wave.Value
        print("Current wave is: " .. tostring(waveValue))

        if waveValue == config.waveToSellUnits then
            local towersFolder = workspace.Towers
            for _, tower in ipairs(towersFolder:GetChildren()) do
                if tower:IsA("Model") then
                    local args = {
                        [1] = tower
                    }
                    local sellFunction = game:GetService("ReplicatedStorage").Functions:FindFirstChild("SellTower")
                    if sellFunction then
                        sellFunction:InvokeServer(unpack(args))
                    end
                end
            end
            
            isSpawningActive = false
        end
    end

    local wave = game.Workspace:FindFirstChild("Info"):FindFirstChild("Wave")
    if wave then
        wave.Changed:Connect(onWaveChanged)
    end

    spawn(function()
        while isSpawningActive do
            wait(config.spawnInterval)
            
            if not isSpawningActive then
                break
            end

            local voteEvent = game:GetService("ReplicatedStorage").Events.Client:FindFirstChild("VoteStartGame")
            if voteEvent then
                voteEvent:FireServer()
            end

            local unitName = unitNames[unitIndex]
            local ownedTower = game:GetService("Players").LocalPlayer.OwnedTowers:FindFirstChild(unitName)
            if ownedTower then
                local mapFolder = game.Workspace:FindFirstChild("Map")
                if mapFolder then
                    for _, planet in ipairs(mapFolder:GetChildren()) do
                        local mapName = planet.Name
                        local waypointIndexToUse = config.waypointIndex 
                        if config.useMapSpecificWaypoints and config.maps[mapName] then
                            waypointIndexToUse = config.maps[mapName]
                        end

                        local waypointFolder = planet:FindFirstChild("Waypoints")
                        if waypointFolder then
                            local waypoint = waypointFolder:FindFirstChild(tostring(waypointIndexToUse))
                            if waypoint then
                                local waypointPosition = waypoint.Position
                                local args1 = {
                                    [1] = ownedTower,
                                    [2] = CFrame.new(waypointPosition), 
                                    [3] = false,
                                    [4] = true
                                }

                                local spawnFunction = game:GetService("ReplicatedStorage").Functions:FindFirstChild("SpawnTower")
                                if spawnFunction then
                                    spawnFunction:InvokeServer(unpack(args1))
                                end
                            else
                                warn("Waypoint not found for index: " .. tostring(waypointIndexToUse) .. " in map: " .. mapName)
                            end
                        else
                            warn("Waypoint folder not found in map: " .. mapName)
                        end
                    end
                else
                    warn("Map folder not found")
                end
            else
                warn("Owned tower not found: " .. unitName)
            end
            
            unitIndex = unitIndex + 1
            if unitIndex > #unitNames then
                unitIndex = 1
            end
        end
    end)

    spawn(function()
        while true do
            wait(config.upgradeInterval)
            local towers = workspace.Towers:GetChildren()
            if #towers > 0 then
                table.sort(towers, function(a, b)
                    local aPosition = a.PrimaryPart and a.PrimaryPart.Position or a:FindFirstChildWhichIsA("BasePart").Position
                    local bPosition = b.PrimaryPart and b.PrimaryPart.Position or b:FindFirstChildWhichIsA("BasePart").Position
                    return aPosition.Y < bPosition.Y
                end)

                for _, tower in ipairs(towers) do
                    local args2 = {
                        [1] = tower
                    }

                    local upgradeFunction = game:GetService("ReplicatedStorage").Functions:FindFirstChild("Upgrade")
                    if upgradeFunction then
                        upgradeFunction:InvokeServer(unpack(args2))
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            local messageValue = game.Workspace.Info.Message.Value
            if messageValue == "GAME OVER" or messageValue == "VICTORY" then
                if config.EndGame.Replay then
                    local args = {
                        [1] = "Replay"
                    }
                    game:GetService("ReplicatedStorage").Events.ExitGame:FireServer(unpack(args))
                elseif config.EndGame.Next then
                    local args = {
                        [1] = "Next"
                    }
                    game:GetService("ReplicatedStorage").Events.ExitGame:FireServer(unpack(args))
                elseif config.EndGame.Return then
                    local args = {
                        [1] = "Return"
                    }
                    game:GetService("ReplicatedStorage").Events.ExitGame:FireServer(unpack(args))
                end
                task.wait(1)
            end
            task.wait(1)
        end
    end)

    local args4 = {
        [1] = "VFX",
        [2] = false
    }
    game:GetService("ReplicatedStorage").Events.UpdateSetting:FireServer(unpack(args4))

    local args5 = {
        [1] = "DamageIndicator",
        [2] = false
    }
    game:GetService("ReplicatedStorage").Events.UpdateSetting:FireServer(unpack(args5))

    local args = {
        [1] = "2x"
    }
    game:GetService("ReplicatedStorage").Events.Client.SpeedRemote:FireServer(unpack(args))
end

autoChallCheck()
