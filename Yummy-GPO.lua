
local player = game:GetService("Players").LocalPlayer
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

local function createFile()
    local fileName = player.Name .. ".txt" 
    local content = "Yummytool" 
    writefile(fileName, content)
    print("[JG Hub] Đã tạo file " .. fileName .. " với nội dung: " .. content)
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
                createFile()
                accChecked = true
            end
        else
            print("[JG Hub] Acc chưa đạt level")
            accChecked = false
        end
    end
end)
