getgenv().InterfaceName = "Ant Simulator 2 - JG Hub"

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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
		Min = nil,
		Max = nil,
		FarmY = nil
	},
	RoamPoints = nil,
	RoamIndex = 1,
	SelectedToken = nil,
	LastRoamPos = nil
}

local function getChar()
	local c = lp.Character or lp.CharacterAdded:Wait()
	local hum = c:WaitForChild("Humanoid")
	local hrp = c:WaitForChild("HumanoidRootPart")
	return c, hum, hrp
end

local function normalizeTextNum(s)
	s = tostring(s or "")
	s = s:gsub("%s+", "")
	s = s:gsub(",", ".")
	return s
end
local function isBackpackFullByAlert()
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	if not pg then return false end

	local alertsRoot = pg:FindFirstChild("Alerts")
	alertsRoot = alertsRoot and alertsRoot:FindFirstChild("Alerts")
	if not alertsRoot then return false end

	for _, f in ipairs(alertsRoot:GetChildren()) do
		if f:IsA("Frame") then
			for _, d in ipairs(f:GetDescendants()) do
				if d:IsA("TextLabel") then
					if tostring(d.Text) == "Your backpack is Full!" then
						return true
					end
				end
			end
		end
	end
	return false
end

local function getCurrentPollenOnly()
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	if not pg then return nil end

	local selfView = pg:FindFirstChild("selfView")
	local metters = selfView and selfView:FindFirstChild("Metters")
	local pollenLabel = metters and metters:FindFirstChild("Pollen")
	if not pollenLabel then return nil end

	local txt = tostring(pollenLabel.Text or "")
	local left = txt:match("^%s*(.-)%s*/")
	if not left then return nil end

	left = left:gsub(",", "")
	return tonumber(left)
end

local function getPollenText()
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	if not pg then return "" end
	local selfView = pg:FindFirstChild("selfView")
	local metters = selfView and selfView:FindFirstChild("Metters")
	local pollenLabel = metters and metters:FindFirstChild("Pollen")
	if not pollenLabel then return "" end
	return tostring(pollenLabel.Text or "")
end

local function isPollenFull()
	local txt = getPollenText()
	if txt == "" then return false end
	local a, b = txt:match("^%s*(.-)%s*/%s*(.-)%s*$")
	if not a or not b then return false end
	return normalizeTextNum(a) ~= "" and normalizeTextNum(a) == normalizeTextNum(b)
end

local function setFlyStable()
	local _, hum, hrp = getChar()
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end)
	pcall(function()
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
	end)
end

local function moveStep(pos, speed)
	if not pos then return end
	local _, _, hrp = getChar()
	local d = (hrp.Position - pos).Magnitude
	if d <= 0.4 then
		hrp.CFrame = CFrame.new(pos)
		return
	end
	local t = math.min(0.18, d / (speed or 160))
	local tw = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	tw:Play()
	local done = false
	local conn = tw.Completed:Connect(function() done = true end)
	local start = os.clock()
	while not done and os.clock() - start < (t + 0.15) do
		RunService.Heartbeat:Wait()
	end
	if conn then conn:Disconnect() end
	pcall(function() tw:Cancel() end)
end

local function getFieldContainer(name)
	if not name then return nil end
	return FieldsRoot:FindFirstChild(name)
end

local function calcDominantY(container)
	local bins = {}
	local bestKey, bestCount = nil, 0
	local sampleY
	local function addY(y)
		sampleY = sampleY or y
		local key = math.floor(y + 0.5)
		bins[key] = (bins[key] or 0) + 1
		if bins[key] > bestCount then
			bestCount = bins[key]
			bestKey = key
		end
	end
	if container:IsA("BasePart") then
		addY(container.Position.Y)
	else
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("BasePart") then
				addY(d.Position.Y)
			end
		end
	end
	return bestKey or (sampleY and math.floor(sampleY + 0.5) or nil)
end

local function refreshFieldInfo()
	local container = getFieldContainer(State.Field)
	if not container then
		State.FieldInfo.Valid = false
		State.FieldInfo.Min = nil
		State.FieldInfo.Max = nil
		State.FieldInfo.FarmY = nil
		State.RoamPoints = nil
		State.RoamIndex = 1
		State.SelectedToken = nil
		State.LastRoamPos = nil
		return false
	end

	local minX, minZ = math.huge, math.huge
	local maxX, maxZ = -math.huge, -math.huge
	local any = false

	local function addPos(p)
		any = true
		if p.X < minX then minX = p.X end
		if p.Z < minZ then minZ = p.Z end
		if p.X > maxX then maxX = p.X end
		if p.Z > maxZ then maxZ = p.Z end
	end

	if container:IsA("BasePart") then
		addPos(container.Position)
	else
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("BasePart") then
				addPos(d.Position)
			end
		end
	end

	if not any then
		State.FieldInfo.Valid = false
		State.FieldInfo.Min = nil
		State.FieldInfo.Max = nil
		State.FieldInfo.FarmY = nil
		State.RoamPoints = nil
		State.RoamIndex = 1
		State.SelectedToken = nil
		State.LastRoamPos = nil
		return false
	end

	local domY = calcDominantY(container)
	if not domY then
		State.FieldInfo.Valid = false
		State.FieldInfo.Min = nil
		State.FieldInfo.Max = nil
		State.FieldInfo.FarmY = nil
		State.RoamPoints = nil
		State.RoamIndex = 1
		State.SelectedToken = nil
		State.LastRoamPos = nil
		return false
	end

	State.FieldInfo.Valid = true
	State.FieldInfo.Min = Vector3.new(minX, 0, minZ)
	State.FieldInfo.Max = Vector3.new(maxX, 0, maxZ)
	State.FieldInfo.FarmY = domY + (State.FarmYOffset or 4)

	State.RoamPoints = nil
	State.RoamIndex = 1
	State.SelectedToken = nil
	State.LastRoamPos = nil
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

local function pickFirstTokenInField()
	for _, t in ipairs(TokensFolder:GetChildren()) do
		if t:IsA("BasePart") then
			if tokenInField(t.Position) then
				return t
			end
		end
	end
	return nil
end

local function buildRoamPoints()
	if not (State.FieldInfo.Valid and State.FieldInfo.Min and State.FieldInfo.Max and State.FieldInfo.FarmY) then
		return nil
	end
	local minv, maxv = State.FieldInfo.Min, State.FieldInfo.Max
	local cx = (minv.X + maxv.X) * 0.5
	local cz = (minv.Z + maxv.Z) * 0.5
	local rx = math.max(10, (maxv.X - minv.X) * 0.5)
	local rz = math.max(10, (maxv.Z - minv.Z) * 0.5)

	local pts = {}
	local n = 10
	for i = 1, n do
		local a = (i - 1) * (math.pi * 2 / n)
		local x = cx + math.cos(a) * rx * 0.92
		local z = cz + math.sin(a) * rz * 0.92
		pts[#pts + 1] = Vector3.new(x, State.FieldInfo.FarmY, z)
	end
	for i = 1, 8 do
		local x = minv.X + math.random() * (maxv.X - minv.X)
		local z = minv.Z + math.random() * (maxv.Z - minv.Z)
		pts[#pts + 1] = Vector3.new(x, State.FieldInfo.FarmY, z)
	end
	return pts
end

local function getMyAnthillPlatform()
	for _, a in ipairs(AnthillsFolder:GetChildren()) do
		local owner = a:FindFirstChild("Owner")
		local plat = a:FindFirstChild("Platform")
		if owner and plat and plat:IsA("BasePart") and owner.Value == lp.Name then
			return a, plat
		end
	end
	return nil, nil
end

local function ensureTeleToPlatform(plat)
	if not plat then return false end
	setFlyStable()
	local goal = plat.Position + Vector3.new(0, 5, 0)
	for _ = 1, 80 do
		if not (plat and plat.Parent) then return false end
		if not State.AutoConvert and State.Converting then break end
		local _, _, hrp = getChar()
		if (hrp.Position - goal).Magnitude <= 4 then
			return true
		end
		moveStep(goal, 190)
		task.wait(0.02)
	end
	local _, _, hrp = getChar()
	return (hrp.Position - goal).Magnitude <= 6
end

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
	while task.wait(0.15) do
		if not State.AutoConvert or State.Converting then
			continue
		end

		if not isBackpackFullByAlert() then
			continue
		end

		State.Converting = true

		if State.ActiveTween then
			pcall(function()
				State.ActiveTween:Cancel()
			end)
			State.ActiveTween = nil
		end

		local _, platform = getMyAnthillPlatform()
		if platform then
			ensureTeleToPlatform(platform)
			task.wait(0.5)

			pcall(function()
				ReplicatedStorage.Events.Server_Function:InvokeServer(
					"ActionCall",
					"Anthill",
					platform
				)
			end)
		end

		local start = os.clock()
		while true do
			task.wait(0.3)

			local cur = getCurrentPollenOnly()
			if cur and cur <= 0 then
				break
			end

			if os.clock() - start >= 12 then
				break
			end
		end

		task.wait(5)
		State.Converting = false
	end
end)

task.spawn(function()
	while task.wait(0.05) do
		if not (State.AutoFarm and State.Field and not State.Converting) then
			State.SelectedToken = nil
			task.wait(0.08)
			continue
		end

		if not State.FieldInfo.Valid then
			refreshFieldInfo()
			task.wait(0.08)
			continue
		end

		setFlyStable()

		if State.SelectedToken and (not State.SelectedToken.Parent) then
			State.SelectedToken = nil
		end

		if not State.SelectedToken then
			local t = pickFirstTokenInField()
			if t then
				State.SelectedToken = t
				local _, _, hrp = getChar()
				State.LastRoamPos = Vector3.new(hrp.Position.X, State.FieldInfo.FarmY, hrp.Position.Z)
			end
		end

		if State.SelectedToken then
			while State.AutoFarm and not State.Converting do
				if not (State.SelectedToken and State.SelectedToken.Parent) then
					State.SelectedToken = nil
					break
				end
				if not tokenInField(State.SelectedToken.Position) then
					State.SelectedToken = nil
					break
				end
				moveStep(withFarmY(State.SelectedToken.Position + Vector3.new(0, 2, 0)), 210)
				task.wait(0.02)
			end
			if State.LastRoamPos and State.AutoFarm and not State.Converting then
				for _ = 1, 18 do
					if not (State.AutoFarm and not State.Converting) then break end
					if pickFirstTokenInField() then break end
					moveStep(withFarmY(State.LastRoamPos), 190)
					task.wait(0.02)
				end
			end
			task.wait(0.03)
			continue
		end

		if not State.RoamPoints then
			State.RoamPoints = buildRoamPoints()
			State.RoamIndex = 1
		end

		if not State.RoamPoints or #State.RoamPoints == 0 then
			task.wait(0.05)
			continue
		end

		if State.RoamIndex > #State.RoamPoints then
			State.RoamPoints = buildRoamPoints()
			State.RoamIndex = 1
		end

		local target = State.RoamPoints[State.RoamIndex]
		if target then
			local _, _, hrp = getChar()
			local d = (hrp.Position - target).Magnitude
			if d <= 7 then
				State.RoamIndex = State.RoamIndex + 1
			else
				moveStep(target, 155)
			end
		else
			State.RoamIndex = State.RoamIndex + 1
		end
	end
end)

local function fieldList()
	local t = {}
	for _, f in ipairs(FieldsRoot:GetChildren()) do
		if f:IsA("Folder") or f:IsA("Model") or f:IsA("BasePart") then
			t[#t + 1] = f.Name
		end
	end
	table.sort(t)
	return t
end

local fields = fieldList()
State.Field = fields[1]
refreshFieldInfo()

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
		State.RoamPoints = nil
		State.RoamIndex = 1
		State.SelectedToken = nil
		State.LastRoamPos = nil
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
		State.SelectedToken = nil
		State.RoamPoints = nil
		State.RoamIndex = 1
		State.LastRoamPos = nil
		if v then
			State.FieldInfo.Valid = false
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
