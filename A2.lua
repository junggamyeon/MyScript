getgenv().InterfaceName = "Ant Simulator 2 - JG Hub"

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

local FieldsFolder = workspace:WaitForChild("Fields")
local TokensFolder = workspace:WaitForChild("Tokens"):WaitForChild("Default")
local AnthillsFolder = workspace:WaitForChild("Anthills")

local State = {
	Field = nil,
	AutoFarm = false,
	AutoDig = false,
	AutoConvert = false,
	Converting = false,

	FarmY = nil,
	FarmYOffset = 4
}

local function getChar()
	local c = lp.Character or lp.CharacterAdded:Wait()
	return c, c:WaitForChild("HumanoidRootPart")
end

local function tweenTo(pos, speed)
	if not pos then return end
	local _, hrp = getChar()
	local d = (hrp.Position - pos).Magnitude
	local t = d / (speed or 80)
	local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	tw:Play()
	tw.Completed:Wait()
end

local function getBounds(obj)
	if not obj then return end
	if obj:IsA("BasePart") then
		return obj.CFrame, obj.Size
	end
	if obj:IsA("Model") then
		return obj:GetBoundingBox()
	end
	return nil
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
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	if not pg then return 0, 0 end

	local selfView = pg:FindFirstChild("selfView")
	local metters = selfView and selfView:FindFirstChild("Metters")
	local pollenLabel = metters and metters:FindFirstChild("Pollen")
	if not pollenLabel or not pollenLabel:IsA("TextLabel") then
		return 0, 0
	end

	local s = tostring(pollenLabel.Text or "")
	s = s:gsub(",", "")
	local a, b = s:match("(%d+)%s*/%s*(%d+)")
	return tonumber(a) or 0, tonumber(b) or 0
end

local function myAnthill()
	for _, a in ipairs(AnthillsFolder:GetChildren()) do
		local p = a:FindFirstChild("Platform")
		if p and p:FindFirstChild("Owner") and p.Owner.Value == lp.Name then
			return a
		end
	end
end

local function anthillPlatformPos()
	local a = myAnthill()
	if not a then return nil end
	local plat = a:FindFirstChild("Platform")
	if plat and plat:IsA("BasePart") then
		return plat.Position + Vector3.new(0, 5, 0)
	end
	return nil
end

local function getFieldContainer(fieldName)
	if not fieldName then return nil end
	return FieldsFolder:FindFirstChild(fieldName)
end

local function pickAnyPartIn(container)
	if not container then return nil end
	if container:IsA("BasePart") then return container end
	for _, d in ipairs(container:GetDescendants()) do
		if d:IsA("BasePart") then
			return d
		end
	end
	return nil
end

local function refreshFarmHeight()
	local container = getFieldContainer(State.Field)
	local p = pickAnyPartIn(container)
	if p then
		State.FarmY = p.Position.Y + (State.FarmYOffset or 4)
		return true
	end
	State.FarmY = nil
	return false
end

local function withFarmY(pos)
	if not pos then return pos end
	if State.FarmY then
		return Vector3.new(pos.X, State.FarmY, pos.Z)
	end
	return pos
end

local function fieldCenterPos(fieldObj)
	if not fieldObj then return nil end
	if fieldObj:IsA("BasePart") then
		return fieldObj.Position
	end
	if fieldObj:IsA("Model") then
		local cf = fieldObj:GetBoundingBox()
		return cf.Position
	end
	local p = pickAnyPartIn(fieldObj)
	return p and p.Position or nil
end

local function fieldList()
	local t = {}
	for _, f in ipairs(FieldsFolder:GetChildren()) do
		if f:IsA("BasePart") or f:IsA("Model") or f:IsA("Folder") then
			table.insert(t, f.Name)
		end
	end
	table.sort(t)
	return t
end

local fields = fieldList()
State.Field = fields[1]
refreshFarmHeight()

task.spawn(function()
	while task.wait(0.08) do
		if State.AutoDig and not State.Converting then
			pcall(function()
				ReplicatedStorage:WaitForChild("Events"):WaitForChild("Server_Event"):FireServer("UseTool", 2)
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.25) do
		if State.AutoConvert and not State.Converting then
			local c, m = getPollen()
			if m > 0 and c >= m then
				State.Converting = true

				local pos = anthillPlatformPos()
				if pos then
					tweenTo(pos, 120)
				end

				repeat
					task.wait(0.3)
					c, m = getPollen()
				until c <= 0 or not State.AutoConvert

				if State.Field then
					local f = getFieldContainer(State.Field)
					if f then
						if not State.FarmY then refreshFarmHeight() end
						local backPos = fieldCenterPos(f)
						if backPos then
							tweenTo(withFarmY(backPos), 120)
						end
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
			local f = getFieldContainer(State.Field)
			if f then
				if not State.FarmY then
					refreshFarmHeight()
				end

				local cf, size = getBounds(f)
				if not cf or not size then
					local sample = pickAnyPartIn(f)
					if sample then
						cf, size = sample.CFrame, sample.Size
					end
				end

				if cf and size then
					tweenTo(withFarmY(cf.Position), 120)

					for _ = 1, 6 do
						if not State.AutoFarm or State.Converting then break end

						tweenTo(withFarmY(randomInBounds(cf, size)), 90)

						for _, t in ipairs(TokensFolder:GetChildren()) do
							local p = t:FindFirstChildWhichIsA("BasePart", true)
							if p and inside(p.Position, cf, size) then
								tweenTo(withFarmY(p.Position), 140)
							end
						end
					end
				end
			end
		end
	end
end)

local function notify(s)
	pcall(function()
		Starlight:Notification({ Title = "Ant Simulator 2 - JG Hub", Content = tostring(s), Icon = 0 })
	end)
end

local Window = Starlight:CreateWindow({
	Name = "Ant Simulator 2 - JG Hub",
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

local FieldLabel = Left:CreateLabel({ Name = "Select Field" }, "FIELD_LBL")
FieldLabel:AddDropdown({
	Options = fields,
	CurrentOption = { State.Field },
	MultipleOptions = false,
	Callback = function(sel)
		State.Field = (type(sel) == "table" and sel[1]) or sel
		refreshFarmHeight()
		notify("Field: " .. tostring(State.Field))
	end
}, "FIELD_DD")

Left:CreateToggle({
	Name = "Auto Farm",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoFarm = v
		if v then refreshFarmHeight() end
		
	end
}, "TGL_AUTOFARM")

Left:CreateToggle({
	Name = "Auto Dig",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoDig = v
		
	end
}, "TGL_AUTODIG")

Left:CreateToggle({
	Name = "Auto Convert",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoConvert = v
		
	end
}, "TGL_AUTOCONVERT")
