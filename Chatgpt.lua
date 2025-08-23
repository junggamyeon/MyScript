-- starlight_demo.lua (fixed)
-- One-file demo for Starlight: loads libs via loadstring + builds full UI.
-- NOTE: Use in a compliant environment. Replace URLs if the vendor changes them.

-- 0) Optional interface name (MUST be a STRING, not a function)
pcall(function()
    if getgenv then
        -- Starlight expects a string here
        if type(getgenv().InterfaceName) ~= "string" then
            getgenv().InterfaceName = "MyScriptInterface"
        end
    end
end)

-- 1) Load libs
local function _httpget(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok then error("HttpGet failed: "..tostring(res)) end
    return res
end

local function _load_from(url, label)
    local src = _httpget(url)
    local chunk, err = loadstring(src)
    if not chunk then error(("loadstring failed for %s: %s"):format(label or url, tostring(err))) end
    local ok, lib = pcall(chunk)
    if not ok then error(("executing loader for %s failed: %s"):format(label or url, tostring(lib))) end
    return lib
end

local STARLIGHT_URL   = "https://raw.nebulasoftworks.xyz/starlight"
local NEBULA_ICON_URL = "https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"

local Starlight   = _load_from(STARLIGHT_URL, "Starlight")
local NebulaIcons = nil
pcall(function() NebulaIcons = _load_from(NEBULA_ICON_URL, "Nebula Icon Loader") end)

-- 2) Window
local Window = Starlight:CreateWindow({
    Name  = "MyScript",
    Subtitle = "Starlight UI Demo",
    Icon  = 0,
    LoadingSettings = {
        Title = "My Script Hub",
        Subtitle = "Initializing..."
    },
    ConfigurationSettings = {
        FolderName = "MyScript"
    },
    -- DefaultSize = UDim2.fromOffset(900, 600),
    -- NotifyOnCallbackError = true
})

-- 3) Tab Sections & Tabs (all params passed as tables)
local SectionHome = Window:CreateTabSection("Home", true) -- (docs thường cho string+bool ở đây)
local SectionMain = Window:CreateTabSection("Main")

local HomeTab = SectionHome:CreateTab({
    Name    = "Dashboard",
    Icon    = NebulaIcons and NebulaIcons:GetIcon("dashboard", "Material") or nil,
    Columns = 2
}, "HOME")

local MainTab = SectionMain:CreateTab({
    Name    = "Main",
    Icon    = NebulaIcons and NebulaIcons:GetIcon("view_in_ar", "Material") or nil,
    Columns = 2
}, "MAINTAB")

-- 4) Groupboxes
local GB_Left  = MainTab:CreateGroupbox({ Name = "Controls",     Column = 1 }, "GB_LEFT")
local GB_Right = MainTab:CreateGroupbox({ Name = "Info / Preview", Column = 2 }, "GB_RIGHT")

-- 5) Notification
Starlight:Notification({
    Title   = "Hello!",
    Icon    = NebulaIcons and NebulaIcons:GetIcon("sparkle", "Material") or nil,
    Content = "Welcome to the Starlight full-feature demo."
}, "WELCOME")

-- 6) Elements ---------------------------------------------------------------
GB_Left:CreateButton({
    Name = "Run Action",
    Icon = NebulaIcons and NebulaIcons:GetIcon("check", "Material") or nil,
    Tooltip = "Click to run an action",
    Style = 1,
    IndicatorStyle = 1,
    Callback = function()
        Starlight:Notification({
            Title = "Action",
            Content = "Button callback executed.",
            Icon = NebulaIcons and NebulaIcons:GetIcon("bolt", "Material") or nil
        }, "BTN_OK")
    end
}, "BTN_RUN")

local Tog = GB_Left:CreateToggle({
    Name = "Master Toggle",
    CurrentValue = false,
    Style = 2,
    Tooltip = "Enable or disable a feature",
    Callback = function(on)
        Starlight:Notification({
            Title = "Toggle",
            Content = ("Master is %s"):format(on and "ON" or "OFF")
        }, "TOG_NOTE")
    end
}, "MASTER_TOGGLE")

Tog:AddBind({
    HoldToInteract   = false,
    CurrentValue     = "Q",
    SyncToggleState  = true,
    OnChangedCallback = function(newKey)
        Starlight:Notification({ Title = "Bind Changed", Content = "New key: "..tostring(newKey) }, "BIND_CHG")
    end
}, "MASTER_BIND")

Tog:AddColorPicker({
    CurrentValue = Color3.fromRGB(33, 217, 64),
    Callback = function(color, alpha)
        Starlight:Notification({
            Title = "Color",
            Content = ("R:%d G:%d B:%d  α:%s")
                :format(color.R*255, color.G*255, color.B*255, alpha and tostring(alpha) or "nil")
        }, "COLOR_NOTE")
    end
}, "MASTER_COLOR")

local InfoLabel = GB_Left:CreateLabel({ Name = "Mode:" }, "LBL_MODE")
InfoLabel:AddDropdown({
    Options         = { "Steady", "Burst", "Wave" },
    CurrentOptions  = { "Steady" },
    MultipleOptions = false,
    Placeholder     = "Select Mode",
    Callback = function(opts)
        Starlight:Notification({ Title = "Mode", Content = "Selected: "..table.concat(opts, ", ") }, "MODE_NOTE")
    end
}, "MODE_DD")

GB_Left:CreateSlider({
    Name         = "Intensity",
    Icon         = NebulaIcons and NebulaIcons:GetIcon("bar-chart", "Lucide") or nil,
    Range        = {0, 100},
    Increment    = 1,
    Suffix       = "%",
    CurrentValue = 50,
    Callback     = function(val) end
}, "SLD_INTENSITY")

GB_Left:CreateInput({
    Name            = "Tag",
    Icon            = NebulaIcons and NebulaIcons:GetIcon("text-cursor-input", "Lucide") or nil,
    CurrentValue    = "",
    PlaceholderText = "Enter tag...",
    MaxCharacters   = 24,
    Enter           = true,
    Callback        = function(text)
        Starlight:Notification({ Title = "Input", Content = "Tag set to: "..text }, "TAG_NOTE")
    end
}, "INP_TAG")

local StatusLbl = GB_Right:CreateLabel({ Name = "Status: Ready" }, "LBL_STATUS")
GB_Right:CreateParagraph({
    Name    = "Notes",
    Content = "This area can hold multi-line tips, docs, or runtime logs."
}, "PARA_NOTES")
GB_Right:CreateDivider()

task.delay(2, function()
    if StatusLbl and StatusLbl.Set then
        StatusLbl:Set({ Name = "Status: Running" })
    end
end)

-- 7) Config UI + Autoload
MainTab:BuildConfigGroupbox(2)
Starlight:LoadAutoloadConfig()

-- 8) Cleanup
Starlight:OnDestroy(function()
    -- clean up here if you changed gameplay/visual states
end)

return {
    Window      = Window,
    Sections    = { Home = SectionHome, Main = SectionMain },
    Tabs        = { Home = HomeTab, Main = MainTab },
    Groupboxes  = { Left = GB_Left, Right = GB_Right },
    Flags       = {
        MasterToggle = "MASTER_TOGGLE",
        ModeDropdown = "MODE_DD",
        Intensity    = "SLD_INTENSITY",
        TagInput     = "INP_TAG"
    }
}
