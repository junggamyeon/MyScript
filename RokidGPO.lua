
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

local requiredLevel = getgenv().Level

local function extractNumber(value)
    local strValue = tostring(value):gsub(",", ""):gsub("[^%d]", "")
    return tonumber(strValue)
end

local function checkLevel()
    local levelPath = player.PlayerGui.HUD.Main.Bars.Experience.Detail.Level

    if levelPath then
        local levelText = levelPath.Text or ""
        local levelNumber = extractNumber(levelText)
        return levelNumber >= requiredLevel
    end

    return false
end

local function notifyServer()
    request({
        Url = 'http://localhost:5000/api/changeacc',
        Method = 'POST',
        Headers = { ['content-type'] = 'application/json' },
        Body = HttpService:JSONEncode({ ['id'] = tostring(player.UserId) })
    })
end

print("[JG Hub] Bắt đầu kiểm tra level...")
spawn(function()
    local accChecked = false
    while true do
        wait(5)
        if checkLevel() then
            if not accChecked then
                print("[JG Hub] Level đạt yêu cầu.")
                wait(getgenv().Delay)
                notifyServer()
                accChecked = true
            end
        else
            print("[JG Hub] Acc chưa đạt level")
            accChecked = false
        end
    end
end)
