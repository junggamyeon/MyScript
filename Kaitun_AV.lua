



local json = game:GetService("HttpService")

local function waitForSeconds(seconds)
    local endTime = tick() + seconds
    while tick() < endTime do
        task.wait(0.1)
    end
end

local function extractNumber(value)
    return tonumber(string.match(value:gsub("[^%d]", ""), "%d+")) or 0
end

local function savePositionsToFile(positions)
    local jsonData = json:JSONEncode(positions)
    writefile(config.PositionFile, jsonData)
end

local function loadPositionsFromFile()
    if isfile(config.PositionFile) then
        local jsonData = readfile(config.PositionFile)
        return json:JSONDecode(jsonData)
    else
        return {}
    end
end

local function resetPositionFile()
    if isfile(config.PositionFile) then
        delfile(config.PositionFile)
    end
    writefile(config.PositionFile, json:JSONEncode({}))
end

local function getNextPosition(startPos, stepSize, placedPositions)
    local positions = {}
    local xStart, zStart = startPos.X, startPos.Z

    for x = -4, 4, stepSize do
        for z = -4, 4, stepSize do
            local newPos = Vector3.new(xStart + x, startPos.Y, zStart + z)
            local positionOccupied = false
            
            for _, placedPos in pairs(placedPositions) do
                if (placedPos - newPos).magnitude < (stepSize / 2) then
                    positionOccupied = true
                    break
                end
            end
            
            if not positionOccupied then
                table.insert(positions, newPos)
            end
        end
    end

    if #positions > 0 then
        return positions[math.random(#positions)]
    else
        return nil
    end
end

local function FarmGem()

    local argsSkip = { [1] = "Skip" }
    game:GetService("ReplicatedStorage").Networking.SkipWaveEvent:FireServer(unpack(argsSkip))
    waitForSeconds(2)

    local startPos = Vector3.new(139.03076171875, 8.633744239807129, 121.34211730957031)
    local stepSize = 2
    local placedPositions = loadPositionsFromFile()

    local player = game.Players.LocalPlayer
    local unitFolder = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Units")
    
    local yenValueLabel = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Yen")
    local yenValue = extractNumber(yenValueLabel.Text)

    while true do
        local anyPlaced = false

        for i = 1, 6 do
            local unitSlot = unitFolder:FindFirstChild(tostring(i))
            if unitSlot and unitSlot:FindFirstChild("UnitTemplate") then
                local placementText = unitSlot.UnitTemplate.Holder.Main.MaxPlacement.Text
                local maxPlacement = extractNumber(string.match(placementText, "/(%d+)"))
                local currentPlacement = extractNumber(string.match(placementText, "(%d+)/"))

                if currentPlacement < maxPlacement then
                    local unitName = unitSlot.UnitTemplate.Holder.Main.UnitName.Text
                    local price = extractNumber(unitSlot.UnitTemplate.Holder.Main.Price.Text)

                    if yenValue >= price then
                        local nextPos = getNextPosition(startPos, stepSize, placedPositions)
                        if nextPos then
                            local argsRender = {
                                [1] = "Render",
                                [2] = {
                                    [1] = unitName,
                                    [2] = 44,
                                    [3] = nextPos,
                                    [4] = 0
                                }
                            }
                            game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(argsRender))
                            table.insert(placedPositions, nextPos)
                            savePositionsToFile(placedPositions)
                            waitForSeconds(2)
                            anyPlaced = true
                        end
                    else
                        print("Không đủ Yen để đặt unit.")
                    end
                end
            end
        end

        if not anyPlaced then
            break
        end

        yenValueLabel = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Yen")
        yenValue = extractNumber(yenValueLabel.Text)
    end

    local allUnitsMaxed = true
    for i = 1, 6 do
        local unitSlot = unitFolder:FindFirstChild(tostring(i))
        if unitSlot and unitSlot:FindFirstChild("UnitTemplate") then
            local placementText = unitSlot.UnitTemplate.Holder.Main.MaxPlacement.Text
            local maxPlacement = extractNumber(string.match(placementText, "/(%d+)"))
            local currentPlacement = extractNumber(string.match(placementText, "(%d+)/"))
            if currentPlacement < maxPlacement then
                allUnitsMaxed = false
                break
            end
        end
    end

    if allUnitsMaxed then
        for _, unit in pairs(workspace.Units:GetChildren()) do
            local unitId = unit.Name
            local argsUpgrade = {
                [1] = "Upgrade",
                [2] = unitId
            }
            game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(argsUpgrade))
            waitForSeconds(2)
        end
    end
end

resetPositionFile()

local function sendDialogueEvent(args)
    game:GetService("ReplicatedStorage").Networking.State.DialogueEvent:FireServer(unpack(args))
end

local function enterCodes(codes)
    for _, code in pairs(codes) do
        local codeArgs = { [1] = code }
        game:GetService("ReplicatedStorage").Networking.CodesEvent:FireServer(unpack(codeArgs))
        waitForSeconds(2)
    end
end

local function selectUnit(unitName)
    local selectArgs = { [1] = "Select", [2] = unitName }
    game:GetService("ReplicatedStorage").Networking.Units.UnitSelectionEvent:FireServer(unpack(selectArgs))
end

local function equipUnit(fileName)
    local equipArgs = { [1] = "Equip", [2] = fileName }
    game:GetService("ReplicatedStorage").Networking.Units.EquipEvent:FireServer(unpack(equipArgs))
    print("Unit equipment request sent: " .. fileName)
end

local function claimTutorial()
    local tutorial = {
        [1] = "ClaimTutorial",
        [2] = "SummonTutorial"
    }
    game:GetService("ReplicatedStorage").Networking.ClientListeners.TutorialEvent:FireServer(unpack(tutorial))
end

local function findUnit(unitName, unitFolder)
    for _, unitFile in pairs(unitFolder:GetChildren()) do
        local fileName = unitFile.Name
        if not (fileName:sub(1, 2) == "Ui" or fileName == "UIPadding" or fileName == "UICorner" or fileName == "UIGridLayout") then
            local unitHolder = unitFile:FindFirstChild("Holder")
            if unitHolder then
                local unitMain = unitHolder:FindFirstChild("Main")
                if unitMain then
                    local unitNameObj = unitMain:FindFirstChild("UnitName")
                    if unitNameObj and unitNameObj.Text == unitName then
                        return fileName
                    end
                end
            end
        end
    end
    return nil
end

local function equipUnits(targetUnits, backupUnits)
    local player = game.Players.LocalPlayer
    local unitFolder = player:WaitForChild("PlayerGui"):WaitForChild("Windows"):WaitForChild("Units"):WaitForChild("Holder"):WaitForChild("Main"):WaitForChild("Units")
    local unitsToEquip = {}

    for _, targetUnit in pairs(targetUnits) do
        local unitFileName = findUnit(targetUnit, unitFolder)
        if unitFileName then
            table.insert(unitsToEquip, unitFileName)
        else
            for _, backupUnit in pairs(backupUnits) do
                local backupFileName = findUnit(backupUnit, unitFolder)
                if backupFileName then
                    table.insert(unitsToEquip, backupFileName)
                    table.remove(backupUnits, table.find(backupUnits, backupUnit))
                    break
                end
            end
        end
    end

    for _, unitFileName in pairs(unitsToEquip) do
        equipUnit(unitFileName)
        waitForSeconds(2)
    end

    return #unitsToEquip == #targetUnits
end

local function performLobbyActions()
    local enterArgs = {
        [1] = "Enter",
        [2] = workspace.MainLobby.Lobby.Lobby
    }
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(enterArgs))
    waitForSeconds(2)

    local confirmArgs = {
        [1] = "Confirm",
        [2] = {
            [1] = "Story",
            [2] = "Stage1",
            [3] = "Act1",
            [4] = "Normal",
            [5] = 4,
            [6] = 0,
            [7] = false
        }
    }
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(confirmArgs))
    waitForSeconds(2)

    local startArgs = {
        [1] = "Start",
        [2] = workspace.MainLobby.Lobby.Lobby
    }
    game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(startArgs))
end

local targetPlaceId = 16146832113

local function runFarmGem()
    if game.PlaceId ~= targetPlaceId then
        FarmGem()
        return
    end
end

local function main()
    if game.PlaceId ~= targetPlaceId then
        print("Script only runs in Anime Vanguard Game ID: " .. targetPlaceId)
        return
    end

    sendDialogueEvent({
        [1] = "Interact",
        [2] = { "StarterUnitDialogue", 1, "Okay!" }
    })
    waitForSeconds(1)

    sendDialogueEvent({
        [1] = "Interact",
        [2] = { "StarterUnitDialogue", 2, "Yeah!" }
    })
    waitForSeconds(1)

    sendDialogueEvent({
        [1] = "Interact",
        [2] = { "StarterUnitDialogue", 3, "Yeah!" }
    })
    waitForSeconds(1)

    selectUnit("Luffo")
    waitForSeconds(1)

    enterCodes(config.Codes)

    game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer("Toggle", "SkipSummonAnimation")
    game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer("Toggle", "AutoSkipWaves")
    
    for i = 1, 6 do
        game:GetService("ReplicatedStorage").Networking.Units.SummonEvent:FireServer("SummonTen", "Special")
        waitForSeconds(1)
    end

    claimTutorial()

    if config.Equipment.Enable then
        local success = equipUnits(config.Equipment.Units, config.Equipment.BackupUnits)
        if success then
            performLobbyActions()
        else
            print("Cannot equip enough units from main and backup list.")
        end
    end
end

main()
runFarmGem()
