local config = {
    Equipment = {
        Enable = true,
        Units = { "Luffo", "Noruto", "Roku" } -- Danh sách các unit cần equip
    },
    Codes = { "300KPLAYERS", "800KLIKES", "100MVISITS" } -- Danh sách các code cần nhập
}

-- Hàm chờ trong thời gian nhất định
local function waitForSeconds(seconds)
    local start = os.clock()
    repeat until os.clock() - start >= seconds
end

-- Nhập từng mã từ danh sách code
local args1 = {
    [1] = "Interact",
    [2] = {
        [1] = "StarterUnitDialogue",
        [2] = 1,
        [3] = "Okay!"
    }
}
game:GetService("ReplicatedStorage").Networking.State.DialogueEvent:FireServer(unpack(args1))

-- Chờ 3 giây
waitForSeconds(10)

-- 2. Chạy đoạn mã thứ hai
local args2 = {
    [1] = "Interact",
    [2] = {
        [1] = "StarterUnitDialogue",
        [2] = 2,
        [3] = "Yeah!"
    }
}
game:GetService("ReplicatedStorage").Networking.State.DialogueEvent:FireServer(unpack(args2))

waitForSeconds(10)

local args3 = {
    [1] = "Interact",
    [2] = {
        [1] = "StarterUnitDialogue",
        [2] = 3,
        [3] = "Yeah!"
    }
}
game:GetService("ReplicatedStorage").Networking.State.DialogueEvent:FireServer(unpack(args3))

-- Chờ 5 giây
waitForSeconds(5)

-- 3. Chạy đoạn mã chọn unit
local selectArgs = {
    [1] = "Select",
    [2] = "Luffo"
}
game:GetService("ReplicatedStorage").Networking.Units.UnitSelectionEvent:FireServer(unpack(selectArgs))

-- Chờ 3 giây
waitForSeconds(3)

-- 4. Nhập từng mã từ danh sách code
for _, code in pairs(config.Codes) do
    local codeArgs = {
        [1] = code
    }
    game:GetService("ReplicatedStorage").Networking.CodesEvent:FireServer(unpack(codeArgs))
    waitForSeconds(2) -- Chờ 2 giây giữa mỗi lần nhập code
end

local skipAnim = {
    [1] = "Toggle",
    [2] = "SkipSummonAnimation"
}

game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer(unpack(skipAnim))

local skipWave = {
    [1] = "Toggle",
    [2] = "AutoSkipWaves"
}

game:GetService("ReplicatedStorage").Networking.Settings.SettingsEvent:FireServer(unpack(skipWave))

local summonArgs = {
    [1] = "SummonTen",
    [2] = "Special"
}
    game:GetService("ReplicatedStorage").Networking.Units.SummonEvent:FireServer(unpack(summonArgs))
waitForSeconds(5)

local tutorial = {
    [1] = "ClaimTutorial",
    [2] = "SummonTutorial"
}

game:GetService("ReplicatedStorage").Networking.ClientListeners.TutorialEvent:FireServer(unpack(tutorial))

local summonArgs1 = {
    [1] = "SummonTen",
    [2] = "Special"
}
for i = 1, 5 do
    game:GetService("ReplicatedStorage").Networking.Units.SummonEvent:FireServer(unpack(summonArgs1))
    waitForSeconds(5)
end

-- Equip và chạy các hành động sau đó
if config.Equipment.Enable then
    local player = game.Players.LocalPlayer
    local unitFolder = player:WaitForChild("PlayerGui"):WaitForChild("Windows"):WaitForChild("Units"):WaitForChild("Holder"):WaitForChild("Main"):WaitForChild("Units")

    -- Duyệt qua từng unit cần equip trong danh sách
    for _, targetUnit in pairs(config.Equipment.Units) do
        -- Duyệt qua tất cả các file trong thư mục Units
        for _, unitFile in pairs(unitFolder:GetChildren()) do
            local fileName = unitFile.Name

            -- Bỏ qua các file không cần thiết (UI files)
            if not (fileName:sub(1, 2) == "Ui" or fileName == "UIPadding" or fileName == "UICorner" or fileName == "UIGridLayout") then
                -- Truy cập vào Holder và Main để lấy UnitName
                local unitHolder = unitFile:FindFirstChild("Holder")
                if unitHolder then
                    local unitMain = unitHolder:FindFirstChild("Main")
                    if unitMain then
                        local unitNameObj = unitMain:FindFirstChild("UnitName")
                        if unitNameObj then
                            local unitName = unitNameObj.Text

                            -- Kiểm tra xem tên unit có khớp với tên trong danh sách không
                            if unitName == targetUnit then
                                -- In ra tên unit và file để xác nhận
                                print("Đã tìm thấy Unit: " .. unitName .. " trong file: " .. fileName)

                                -- Equip unit bằng cách gọi sự kiện FireServer
                                local args7 = {
                                    [1] = "Equip",
                                    [2] = fileName -- UUID của unitFile
                                }
                                game:GetService("ReplicatedStorage").Networking.Units.EquipEvent:FireServer(unpack(args7))
                                print("Đã equip unit: " .. unitName)
                                
                                -- Chạy đoạn mã "ClaimTutorial" và "PlayTutorial"
                                local claimArgs = {
                                    [1] = "ClaimTutorial",
                                    [2] = "PlayTutorial"
                                }
                                game:GetService("ReplicatedStorage").Networking.ClientListeners.TutorialEvent:FireServer(unpack(claimArgs))
                                
                                -- Chờ 5 giây
                                waitForSeconds(5)
                                
                                local args8 = {
                                    [1] = "Equip",
                                    [2] = fileName -- UUID của unitFile
                                }
                                game:GetService("ReplicatedStorage").Networking.Units.EquipEvent:FireServer(unpack(args8))
                                print("Đã equip unit: " .. unitName)
                                waitForSeconds(5)

                                -- Chạy đoạn mã tiếp theo (Enter lobby)
                                local enterLobbyArgs = {
                                    [1] = "Enter",
                                    [2] = workspace.MainLobby.Lobby.Lobby
                                }
                                game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(enterLobbyArgs))

                                -- Chờ 2 giây
                                waitForSeconds(2)

                                -- Chạy đoạn mã tiếp theo (Confirm Story)
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

                                -- Chờ 2 giây
                                waitForSeconds(2)

                                -- Chạy đoạn mã tiếp theo (Start lobby)
                                local startLobbyArgs = {
                                    [1] = "Start",
                                    [2] = workspace.MainLobby.Lobby.Lobby
                                }
                                game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(startLobbyArgs))

                                -- Chờ 5 giây trước khi equip unit tiếp theo
                                waitForSeconds(5)
                                break
                            end
                        else
                            print("UnitName không tồn tại trong file: " .. fileName)
                        end
                    end
                end
            end
        end
    end
end
