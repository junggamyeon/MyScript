--[[
starlight_demo.lua
One-file bootstrap: tải Starlight & Nebula Icons bằng loadstring + dựng GUI “đủ đồ chơi”.
⚠️ Lưu ý:
- Đoạn mã này minh hoạ theo tài liệu công khai của Starlight UI lib (tạo Window → Tabs → Groupboxes → Elements,
  nested elements, notifications, config box, autoload, on-destroy).
- Mình KHÔNG hỗ trợ các executor vi phạm ToS. Bạn hãy sử dụng trong môi trường hợp lệ của bạn.
- Thay thế URL nếu nhà phát hành đổi đường dẫn.
]]

-- ────────────────────────────────────────────────────────────────────────────
-- 0) Tuỳ chọn đặt tên giao diện (docs gợi ý getgenv().InterfaceName)
--    Không bắt buộc, chỉ để phân biệt nhiều interface dùng chung lib.
pcall(function()
    if getgenv and (not getgenv().InterfaceName) then
        getgenv().InterfaceName = function()
            return "MyScriptInterface"
        end
    end
end)

-- ────────────────────────────────────────────────────────────────────────────
-- 1) Tải thư viện Starlight & Nebula Icons
local function _httpget(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        error("HttpGet failed for "..tostring(url)..": "..tostring(res))
    end
    return res
end

local function _load_from(url, what)
    local src = _httpget(url)
    local chunk, err = loadstring(src)
    if not chunk then
        error(("loadstring failed for %s: %s"):format(what or url, tostring(err)))
    end
    local ok, lib = pcall(chunk)
    if not ok then
        error(("executing loader for %s failed: %s"):format(what or url, tostring(lib)))
    end
    return lib
end

-- Thay URL nếu nhà phát hành đổi:
local STARLIGHT_URL   = "https://raw.nebulasoftworks.xyz/starlight"
local NEBULA_ICON_URL = "https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"

local Starlight   = _load_from(STARLIGHT_URL, "Starlight")
local NebulaIcons = nil
pcall(function()
    NebulaIcons = _load_from(NEBULA_ICON_URL, "Nebula Icon Loader")
end)

-- ────────────────────────────────────────────────────────────────────────────
-- 2) Tạo WINDOW
local Window = Starlight:CreateWindow({
    Name  = "MyScript",
    Subtitle = "Starlight UI Demo",
    Icon  = 0,  -- có thể thay icon asset id (số), 0 = không icon

    LoadingSettings = {
        Title    = "My Script Hub",
        Subtitle = "Initializing...",
        -- Icon = <asset_id>,
    },

    ConfigurationSettings = {
        FolderName = "MyScript",   -- nơi Starlight lưu config
        -- RootFolder = "MyHub",
    },

    -- DefaultSize = UDim2.fromOffset(900, 600),
    -- BuildWarnings = true,
    -- InterfaceAdvertisingPrompts = false,
    -- NotifyOnCallbackError = true,
})

-- ────────────────────────────────────────────────────────────────────────────
-- 3) TAB SECTIONS & TABS
local SectionHome = Window:CreateTabSection("Home", true)
local SectionMain = Window:CreateTabSection("Main")

local HomeTab = SectionHome:CreateTab({
    Name    = "Dashboard",
    Icon    = NebulaIcons and NebulaIcons:GetIcon('dashboard', 'Material') or nil,
    Columns = 2,
}, "HOME")

local MainTab = SectionMain:CreateTab({
    Name    = "Main",
    Icon    = NebulaIcons and NebulaIcons:GetIcon('view_in_ar', 'Material') or nil,
    Columns = 2,
}, "MAINTAB")

-- ────────────────────────────────────────────────────────────────────────────
-- 4) GROUPBOXES
local GB_Left  = MainTab:CreateGroupbox({ Name = "Controls", Column = 1 }, "GB_LEFT")
local GB_Right = MainTab:CreateGroupbox({ Name = "Info / Preview", Column = 2 }, "GB_RIGHT")

-- ────────────────────────────────────────────────────────────────────────────
-- 5) GLOBAL NOTIFICATION (demo)
Starlight:Notification({
    Title   = "Hello!",
    Icon    = NebulaIcons and NebulaIcons:GetIcon('sparkle', 'Material') or nil,
    Content = "Welcome to the Starlight full-feature demo.",
}, "WELCOME")

-- ────────────────────────────────────────────────────────────────────────────
-- 6) ELEMENTS

-- Button
GB_Left:CreateButton({
    Name = "Run Action",
    Icon = NebulaIcons and NebulaIcons:GetIcon('check', 'Material') or nil,
    Tooltip = "Click to run an action",
    Style = 1,             -- 1/2
    IndicatorStyle = 1,    -- 1 chevron / 2 fingerprint / nil none
    Callback = function()
        Starlight:Notification({
            Title = "Action",
            Content = "Button callback executed.",
            Icon = NebulaIcons and NebulaIcons:GetIcon('bolt', 'Material') or nil,
        }, "BTN_OK")
    end,
}, "BTN_RUN")

-- Toggle (với nested Bind + ColorPicker)
local Tog = GB_Left:CreateToggle({
    Name = "Master Toggle",
    CurrentValue = false,
    Style = 2, -- 1 checkbox / 2 switch
    Tooltip = "Enable or disable a feature",
    Callback = function(on)
        Starlight:Notification({
            Title = "Toggle",
            Content = ("Master is %s"):format(on and "ON" or "OFF")
        }, "TOG_NOTE")
    end,
}, "MASTER_TOGGLE")

-- Bind (nested vào Toggle/Label)
Tog:AddBind({
    HoldToInteract   = false,
    CurrentValue     = "Q",  -- string key, cũng có thể "MB1"/"MB2"
    SyncToggleState  = true,
    OnChangedCallback = function(newKey)
        Starlight:Notification({ Title = "Bind Changed", Content = "New key: "..tostring(newKey) }, "BIND_CHG")
    end,
}, "MASTER_BIND")

-- Color Picker (nested)
Tog:AddColorPicker({
    CurrentValue = Color3.fromRGB(33, 217, 64),
    -- Transparency = 0.25,
    Callback = function(color, alpha)
        Starlight:Notification({
            Title = "Color",
            Content = ("R:%d G:%d B:%d  α:%s")
                :format(color.R*255, color.G*255, color.B*255, alpha and tostring(alpha) or "nil")
        }, "COLOR_NOTE")
    end,
}, "MASTER_COLOR")

-- Label + Dropdown (nested vào Label)
local InfoLabel = GB_Left:CreateLabel({ Name = "Mode:" }, "LBL_MODE")
InfoLabel:AddDropdown({
    Options         = {"Steady", "Burst", "Wave"},
    CurrentOptions  = {"Steady"},
    MultipleOptions = false,
    Placeholder     = "Select Mode",
    Callback = function(options)
        Starlight:Notification({
            Title = "Mode",
            Content = "Selected: " .. table.concat(options, ", ")
        }, "MODE_NOTE")
    end,
}, "MODE_DD")

-- Slider
GB_Left:CreateSlider({
    Name       = "Intensity",
    Icon       = NebulaIcons and NebulaIcons:GetIcon('bar-chart', 'Lucide') or nil,
    Range      = {0, 100},
    Increment  = 1,
    Suffix     = "%",
    CurrentValue = 50,
    Callback = function(val)
        -- your logic here...
    end,
}, "SLD_INTENSITY")

-- Input
GB_Left:CreateInput({
    Name = "Tag",
    Icon = NebulaIcons and NebulaIcons:GetIcon('text-cursor-input', 'Lucide') or nil,
    CurrentValue = "",
    PlaceholderText = "Enter tag...",
    MaxCharacters = 24,
    Enter = true, -- callback khi nhấn Enter
    Callback = function(text)
        Starlight:Notification({
            Title = "Input",
            Content = "Tag set to: "..text
        }, "TAG_NOTE")
    end,
}, "INP_TAG")

-- Texts: Label & Paragraph & Divider
local StatusLbl = GB_Right:CreateLabel({ Name = "Status: Ready" }, "LBL_STATUS")
GB_Right:CreateParagraph({
    Name    = "Notes",
    Content = "This area can hold multi-line tips, docs, or runtime logs."
}, "PARA_NOTES")
GB_Right:CreateDivider()

-- Cập nhật nhãn sau 2s (demo .Set)
task.delay(2, function()
    if StatusLbl and StatusLbl.Set then
        StatusLbl:Set({ Name = "Status: Running" })
    end
end)

-- ────────────────────────────────────────────────────────────────────────────
-- 7) CONFIG UI + AUTOLOAD
-- Sinh groupbox quản lý config (save/load/delete/autoload)
MainTab:BuildConfigGroupbox(2)   -- hiển thị ở cột 2
Starlight:LoadAutoloadConfig()   -- tự load config đã gán autoload (nếu có)

-- ────────────────────────────────────────────────────────────────────────────
-- 8) CLEANUP khi đóng GUI
Starlight:OnDestroy(function()
    -- Tắt loop/connections, hoàn nguyên mọi thay đổi gameplay/visual tại đây.
end)

-- ────────────────────────────────────────────────────────────────────────────
-- 9) Trả về một API nhỏ (tuỳ chọn)
return {
    Window      = Window,
    Sections    = { Home = SectionHome, Main = SectionMain },
    Tabs        = { Home = HomeTab, Main = MainTab },
    Groupboxes  = { Left = GB_Left, Right = GB_Right },
    Flags = {
        MasterToggle = "MASTER_TOGGLE",
        ModeDropdown = "MODE_DD",
        Intensity    = "SLD_INTENSITY",
        TagInput     = "INP_TAG",
    }
}
