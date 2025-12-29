getgenv().InterfaceName = "Ant Simulator 2 - JG Hub"

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

local FieldsRoot = workspace:WaitForChild("Fields")
local TokensFolder = workspace:WaitForChild("Tokens"):WaitForChild("Default")
local AnthillsFolder = workspace:WaitForChild("Anthills")

local State = {
	Field = nil,
	AutoFarm = false,
	AutoDig = false,
	AutoConvert = false,
	Converting = false,
	FarmYOffset = 4,
	FieldInfo = {
		Valid = false,
		FarmY = nil,
		Min = nil,
		Max = nil
	},
	RoamTarget = nil,
	NextRoamTime = 0
}

local function getChar()
	local c = lp.Character or lp.CharacterAdded:Wait()
	return c, c:WaitForChild("HumanoidRootPart")
end

local function tweenTo(pos, speed)
	if not pos then return end
	local _, hrp = getChar()
	local d = (hrp.Position - pos).Magnitude
	local t = d / (speed or 90)
	local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	tw:Play()
	tw.Completed:Wait()
end

local function getFieldContainer(name)
	if not name then return nil end
	return FieldsRoot:FindFirstChild(name)
end

local function refreshFieldInfo()
	local container = getFieldContainer(State.Field)
	if not container then
		State.FieldInfo.Valid = false
		State.FieldInfo.FarmY = nil
		State.FieldInfo.Min = nil
		State.FieldInfo.Max = nil
		return false
	end

	local anyPart
	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

	if container:IsA("BasePart") then
		anyPart = container
		local p = container.Position
		minX, minY, minZ = p.X, p.Y, p.Z
		maxX, maxY, maxZ = p.X, p.Y, p.Z
	else
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("BasePart") then
				anyPart = anyPart or d
				local p = d.Position
				if p.X < minX then minX = p.X end
				if p.Y < minY then minY = p.Y end
				if p.Z < minZ then minZ = p.Z end
				if p.X > maxX then maxX = p.X end
				if p.Y > maxY then maxY = p.Y end
				if p.Z > maxZ then maxZ = p.Z end
			end
		end
	end

	if not anyPart then
		State.FieldInfo.Valid = false
		State.FieldInfo.FarmY = nil
		State.FieldInfo.Min = nil
		State.FieldInfo.Max = nil
		return false
	end

	State.FieldInfo.Valid = true
	State.FieldInfo.FarmY = anyPart.Position.Y + (State.FarmYOffset or 4)
	State.FieldInfo.Min = Vector3.new(minX, minY, minZ)
	State.FieldInfo.Max = Vector3.new(maxX, maxY, maxZ)
	return true
end

local function withFarmY(pos)
	if not pos then return nil end
	if State.FieldInfo.Valid and State.FieldInfo.FarmY then
		return Vector3.new(pos.X, State.FieldInfo.FarmY, pos.Z)
	end
	return pos
end

local function tokenInField(pos)
	if not (State.FieldInfo.Valid and State.FieldInfo.Min and State.FieldInfo.Max) then
		return false
	end
	local minv, maxv = State.FieldInfo.Min, State.FieldInfo.Max
	return pos.X >= minv.X and pos.X <= maxv.X and pos.Z >= minv.Z and pos.Z <= maxv.Z
end

local function randomPointInField()
	if not (State.FieldInfo.Valid and State.FieldInfo.Min and State.FieldInfo.Max and State.FieldInfo.FarmY) then
		return nil
	end
	local minv, maxv = State.FieldInfo.Min, State.FieldInfo.Max
	local x = minv.X + math.random() * (maxv.X - minv.X)
	local z = minv.Z + math.random() * (maxv.Z - minv.Z)
	return Vector3.new(x, State.FieldInfo.FarmY, z)
end

local function getNearestToken()
	local _, hrp = getChar()
	local best, bestD = nil, math.huge
	for _, t in ipairs(TokensFolder:GetChildren()) do
		if t:IsA("BasePart") then
			local pos = t.Position
			if tokenInField(pos) then
				local d = (hrp.Position - pos).Magnitude
				if d < bestD then
					bestD = d
					best = t
				end
			end
		end
	end
	return best
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

local function fieldCenterPos()
	if not (State.FieldInfo.Valid and State.FieldInfo.Min and State.FieldInfo.Max and State.FieldInfo.FarmY) then
		return nil
	end
	local minv, maxv = State.FieldInfo.Min, State.FieldInfo.Max
	return Vector3.new((minv.X + maxv.X) * 0.5, State.FieldInfo.FarmY, (minv.Z + maxv.Z) * 0.5)
end

local function fieldList()
	local t = {}
	for _, f in ipairs(FieldsRoot:GetChildren()) do
		if f:IsA("Folder") or f:IsA("Model") or f:IsA("BasePart") then
			table.insert(t, f.Name)
		end
	end
	table.sort(t)
	return t
end

local fields = fieldList()
State.Field = fields[1]
refreshFieldInfo()

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
	while task.wait(0.2) do
		if State.AutoConvert and not State.Converting then
			local c, m = getPollen()
			if m > 0 and c >= m then
				State.Converting = true
				local pos = anthillPlatformPos()
				if pos then
					tweenTo(pos, 130)
				end
				repeat
					task.wait(0.3)
					c, m = getPollen()
				until c <= 0 or not State.AutoConvert
				if State.AutoFarm and State.Field then
					if not State.FieldInfo.Valid then refreshFieldInfo() end
					local back = fieldCenterPos()
					if back then
						tweenTo(back, 130)
					end
				end
				State.Converting = false
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.05) do
		if not (State.AutoFarm and State.Field and not State.Converting) then
			continue
		end

		if not State.FieldInfo.Valid then
			refreshFieldInfo()
			State.RoamTarget = nil
			task.wait(0.1)
			continue
		end

		local tok = getNearestToken()
		if tok then
			tweenTo(withFarmY(tok.Position + Vector3.new(0, 2, 0)), 160)
			continue
		end

		local now = os.clock()
		local _, hrp = getChar()

		if (not State.RoamTarget)
			or ((hrp.Position - State.RoamTarget).Magnitude <= 6)
			or (now >= (State.NextRoamTime or 0))
		then
			State.RoamTarget = randomPointInField()
			State.NextRoamTime = now + 1.6
		end

		if State.RoamTarget then
			tweenTo(withFarmY(State.RoamTarget), 95)
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
		State.FieldInfo.Valid = false
		State.RoamTarget = nil
		refreshFieldInfo()
		notify("Field: " .. tostring(State.Field))
	end
}, "FIELD_DD")

Left:CreateToggle({
	Name = "Auto Farm",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoFarm = v
		if v then
			State.FieldInfo.Valid = false
			State.RoamTarget = nil
			refreshFieldInfo()
		end
		notify("Auto Farm: " .. (v and "ON" or "OFF"))
	end
}, "TGL_AUTOFARM")

Left:CreateToggle({
	Name = "Auto Dig",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoDig = v
		notify("Auto Dig: " .. (v and "ON" or "OFF"))
	end
}, "TGL_AUTODIG")

Left:CreateToggle({
	Name = "Auto Convert",
	CurrentValue = false,
	Style = 1,
	Callback = function(v)
		State.AutoConvert = v
		notify("Auto Convert: " .. (v and "ON" or "OFF"))
	end
}, "TGL_AUTOCONVERT")
