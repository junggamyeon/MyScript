getgenv().InterfaceName = "FarmingHub"

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

local FieldsFolder = workspace.Zones.Fields
local TokensFolder = workspace.Tokens.Default
local AnthillsFolder = workspace.Anthills

local State = {
    Field = nil,
    AutoFarm = false,
    AutoDig = false,
    AutoConvert = false,
    Converting = false
}


local function getChar()
    local c = lp.Character or lp.CharacterAdded:Wait()
    return c, c:WaitForChild("HumanoidRootPart")
end

local function tweenTo(pos, speed)
    local _, hrp = getChar()
    local d = (hrp.Position - pos).Magnitude
    local t = d / (speed or 80)
    local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tw:Play()
    tw.Completed:Wait()
end

local function getBounds(model)
    if not model then return end
    return model:GetBoundingBox()
end

local function randomInBounds(cf, size)
    local h = size * 0.5
    local x = (math.random() * 2 - 1) * h.X
    local z = (math.random() * 2 - 1) * h.Z
    return cf:PointToWorldSpace(Vector3.new(x, h.Y + 6, z))
end

local function inside(point, cf, size)
    local p = cf:PointToObjectSpace(point)
    local h = size * 0.5
    return math.abs(p.X) <= h.X and math.abs(p.Z) <= h.Z
end

local function getPollen()
    local gui = lp.PlayerGui.selfView.Metters.Pollen.Text
    local s = tostring(gui.Text or "")
    local a,b = s:match("(%d+)%s*/%s*(%d+)")
    return tonumber(a) or 0, tonumber(b) or 0
end

local function myAnthill()
    for _,a in ipairs(AnthillsFolder:GetChildren()) do
        local p = a:FindFirstChild("Platform")
        if p and p:FindFirstChild("Owner") and p.Owner.Value == lp.Name then
            return a
        end
    end
end

task.spawn(function()
    while task.wait(0.08) do
        if State.AutoDig and not State.Converting then
            ReplicatedStorage.Events.Server_Event:FireServer("UseTool",2)
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if State.AutoConvert and not State.Converting then
            local c,m = getPollen()
            if m > 0 and c >= m then
                State.Converting = true
                local a = myAnthill()
                if a then
                    tweenTo(a:GetBoundingBox().Position + Vector3.new(0,5,0),120)
                end
                repeat task.wait(0.3) c,m = getPollen() until c <= 0
                if State.Field then
                    local f = FieldsFolder:FindFirstChild(State.Field)
                    if f then
                        tweenTo(f:GetBoundingBox().Position + Vector3.new(0,6,0),120)
                    end
                end
                State.Converting = false
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.AutoFarm and State.Field and not State.Converting then
            local f = FieldsFolder:FindFirstChild(State.Field)
            if f then
                local cf,size = getBounds(f)
                tweenTo(cf.Position + Vector3.new(0,6,0),120)
                for _=1,6 do
                    if not State.AutoFarm or State.Converting then break end
                    tweenTo(randomInBounds(cf,size),90)
                    for _,t in ipairs(TokensFolder:GetChildren()) do
                        local p = t:FindFirstChildWhichIsA("BasePart",true)
                        if p and inside(p.Position,cf,size) then
                            tweenTo(p.Position + Vector3.new(0,2,0),140)
                        end
                    end
                end
            end
        end
    end
end)
local function fieldList()
    local t={}
    for _,f in ipairs(FieldsFolder:GetChildren()) do
        table.insert(t,f.Name)
    end
    table.sort(t)
    return t
end
local fields = fieldList()
State.Field = fields[1]

local Window = Starlight:CreateWindow({
    Name = "FarmingHub",
    Subtitle = lp.Name,
    Icon = 0,
    LoadingEnabled = false,
    BuildWarnings = false,
    InterfaceAdvertisingPrompts = false,
    NotifyOnCallbackError = true,
    ConfigurationSettings = { Enabled = false, RootFolder = nil, FolderName = nil },
    KeySystem = { Enabled = false },
    Discord = { Enabled = false }
})

local Tabs = Window:CreateTabSection("Main")

local Tab = Tabs:CreateTab({
    Name = "Farming",
    Columns = 2,
    Icon = ""
}, "FARMING_TAB")

local Left = Tab:CreateGroupbox({ Name = "Farm", Column = 1, Style = 1 }, "FARM_GB")
local Right = Tab:CreateGroupbox({ Name = "Status", Column = 2, Style = 1 }, "STATUS_GB")

local DD = Left:CreateDropdown({
    Name = "Select Field",
    Options = fields,
    CurrentOption = { State.Field },
    MultipleOptions = false,
    Callback = function(sel)
        State.Field = (type(sel) == "table" and sel[1]) or sel
    end
}, "FIELD_DD")

local function notify(s)
    pcall(function()
        Starlight:Notification({ Title = "FarmingHub", Content = tostring(s), Icon = 0 })
    end)
end

local btnFarm, btnDig, btnConvert

btnFarm = Left:CreateButton({
    Name = "Auto Farm",
    Style = 2,
    Callback = function()
        State.AutoFarm = not State.AutoFarm
        notify("Auto Farm: " .. (State.AutoFarm and "ON" or "OFF"))
    end
}, "BTN_AUTOFARM")

btnDig = Left:CreateButton({
    Name = "Auto Dig",
    Style = 2,
    Callback = function()
        State.AutoDig = not State.AutoDig
        notify("Auto Dig: " .. (State.AutoDig and "ON" or "OFF"))
    end
}, "BTN_AUTODIG")

btnConvert = Left:CreateButton({
    Name = "Auto Convert",
    Style = 2,
    Callback = function()
        State.AutoConvert = not State.AutoConvert
        notify("Auto Convert: " .. (State.AutoConvert and "ON" or "OFF"))
    end
}, "BTN_AUTOCONVERT")
