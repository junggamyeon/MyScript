

local unitIdMap = {
    Itochi = 10,
    Agony = 15,
    Goi = 12,
    ["Grim Wow"] = 14,
    ["Cha-In"] = 22,
    ["Song Jinwu"] = 21,
    Aligator = 32,
    Sanjo = 43,
    Roku = 41,
    Vogita = 45,
    Noruto = 40,
    Luffo = 39,
    Jon = 38,
    Kinnua = 31,
    Pickleo = 34,
    Kinaru = 13
}

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
    writefile(getgenv().SettingFarm.PositionFile, jsonData)
end


local function loadPositionsFromFile()
    if isfile(getgenv().SettingFarm.PositionFile) then
        local jsonData = readfile(getgenv().SettingFarm.PositionFile)
        return json:JSONDecode(jsonData)
    else
        return {}
    end
end

local function getNextPosition(startPos, currentPos, stepSize, endPos)
    local nextZ = currentPos.Z - stepSize
    local nextX = currentPos.X

    if nextZ < endPos.Z then
        nextZ = startPos.Z -- reset Z về giá trị ban đầu
        nextX = currentPos.X - stepSize -- chuyển sang cột tiếp theo, giảm X
    end

    -- Nếu vượt quá giới hạn X, trả về nil để dừng quá trình đặt unit
    if nextX < endPos.X then
        return nil
    end

    return Vector3.new(nextX, startPos.Y, nextZ)
end

local function isPositionOccupied(newPos, stepSize)
    for _, unit in pairs(workspace.Units:GetChildren()) do
        local unitPos = unit.PrimaryPart.Position
        if math.abs(unitPos.X - newPos.X) < stepSize and math.abs(unitPos.Z - newPos.Z) < stepSize then
            return true
        end
    end
    return false
end

local function FarmGem()
    local player = game.Players.LocalPlayer
    local unitFolder = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Units")
    
    local argsSkip = { [1] = "Skip" }
    game:GetService("ReplicatedStorage").Networking.SkipWaveEvent:FireServer(unpack(argsSkip))
    wait(2)
    
    
    local startPos = Vector3.new(140.06515502929688, 8.752506256103516, 123.34211730957031)
    local endPos = Vector3.new(129.9888153076172, 8.752506256103516, 117.63985443115234)
    local stepSize = 2
    local currentPos = startPos
    local pendingPositions = {}

    while true do
        local yenValueLabel = player:WaitForChild("PlayerGui"):WaitForChild("Hotbar"):WaitForChild("Main"):WaitForChild("Yen")
        local yenValue = extractNumber(yenValueLabel.Text)
        local anyPlaced = false
        local enoughMoney = false

        for i = 1, 6 do
            local unitSlot = unitFolder:FindFirstChild(tostring(i))
            if unitSlot and unitSlot:FindFirstChild("UnitTemplate") then
                local unitName = unitSlot.UnitTemplate.Holder.Main.UnitName.Text
                local unitId = unitIdMap[unitName]
                local placementText = unitSlot.UnitTemplate.Holder.Main.MaxPlacement.Text
                local maxPlacement = extractNumber(string.match(placementText, "/(%d+)"))
                local currentPlacement = extractNumber(string.match(placementText, "(%d+)/"))

                if currentPlacement < maxPlacement then
                    local price = extractNumber(unitSlot.UnitTemplate.Holder.Main.Price.Text)

                    if #pendingPositions > 0 then
                        local savedPos = table.remove(pendingPositions, 1)

                        if yenValue >= price then
                            local argsRender = {
                                [1] = "Render",
                                [2] = {
                                    [1] = unitName,
                                    [2] = unitId,
                                    [3] = savedPos,
                                    [4] = 0
                                }
                            }
                            game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(argsRender))
                            wait(2)
                            anyPlaced = true
                            yenValue = yenValue - price
                        else
                            table.insert(pendingPositions, savedPos)
                        end
                    end

                    if yenValue >= price then
                        while currentPos do
                            if not isPositionOccupied(currentPos, stepSize) then
                                local argsRender = {
                                    [1] = "Render",
                                    [2] = {
                                        [1] = unitName,
                                        [2] = unitId,
                                        [3] = currentPos,
                                        [4] = 0
                                    }
                                }
                                game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(argsRender))
                                wait(2)
                                anyPlaced = true
                                yenValue = yenValue - price
                                currentPos = getNextPosition(startPos, currentPos, stepSize, endPos)
                                enoughMoney = true
                                break
                            else
                                currentPos = getNextPosition(startPos, currentPos, stepSize, endPos)
                            end
                        end
                    else
                        if currentPos then
                            table.insert(pendingPositions, currentPos)
                            currentPos = getNextPosition(startPos, currentPos, stepSize, endPos)
                        end
                    end
                end
            end
        end

        if not enoughMoney then
            print("Không đủ yen để đặt unit, tạm dừng...")
            wait(5)
        end

        if not anyPlaced and #pendingPositions == 0 and not currentPos then
            print("Hoàn thành việc đặt tất cả các units.")
            break
        end
    end

    -- Tự động nâng cấp tất cả các units sau khi đặt xong
    while true do
        local anyUpgraded = false

        for _, unit in pairs(workspace.Units:GetChildren()) do
            local unitId = unit.Name
            local argsUpgrade = {
                [1] = "Upgrade",
                [2] = unitId
            }
            local upgradeResponse = game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(argsUpgrade))
            wait(2)

            -- Kiểm tra phản hồi xem có nâng cấp thành công không
            if upgradeResponse and upgradeResponse.Success then
                anyUpgraded = true
            end
        end
    end
end

local function sendDialogueEvent(args)
    game:GetService("ReplicatedStorage").Networking.State.DialogueEvent:FireServer(unpack(args))
end

local function enterCodes(codes)
    for _, code in pairs(getgenv().SettingFarm.Codes) do
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

    enterCodes(getgenv().SettingFarm.Codes)


    game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer("Toggle", "SkipSummonAnimation")
    game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer("Toggle", "AutoSkipWaves")
    
    for i = 1, 6 do
        game:GetService("ReplicatedStorage").Networking.Units.SummonEvent:FireServer("SummonTen", "Special")
        waitForSeconds(1)
    end

    claimTutorial()
    if getgenv().SettingFarm.Equipment.Enable then
        local success = equipUnits(getgenv().SettingFarm.Equipment.Units, getgenv().SettingFarm.Equipment.BackupUnits)
        if success then
            performLobbyActions()
        else
            print("Cannot equip enough units from main and backup list.")
        end
    end
end

main()
runFarmGem()