local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local folderPath = "gamefolder"
local fileName = player.Name .. "_first.json"
local filePath = folderPath .. "/" .. fileName

if not isfolder(folderPath) then
    makefolder(folderPath)
end

function FirstGame()
    if isfile(filePath) then return end

    for _, code in ipairs(getgenv().Config.Code or {}) do
        game:GetService("ReplicatedStorage").Remotes.GetFunction:InvokeServer({
            Type = "Code",
            Mode = "Redeem",
            Code = code
        })
        task.wait(0.1)
    end

    local summonArgs = {
        {
            Type = "Gacha",
            Index = "StandardSummon",
            Auto = {
                T3 = false, S4 = false, T4 = false, T5 = false,
                N3 = false, N5 = false, N4 = false, S3 = false, S5 = false
            },
            Mode = "Purchase",
            Bundle = true
        }
    }

    for i = 1, (getgenv().Config.Summon or 0) do
        game:GetService("ReplicatedStorage").Remotes.GetFunction:InvokeServer(unpack(summonArgs))
        task.wait(0.2)
    end

    writefile(filePath, HttpService:JSONEncode({
        name = player.Name,
        timestamp = os.time()
    }))
end

FirstGame()
