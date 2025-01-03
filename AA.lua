repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/KamaadiN/DataStore/main/Notifier.lua"))()

local function InLobby()
    if game.PlaceId == 8304191830 then
        return true
    else
        return false
    end
end
local function InGame()
    if game.PlaceId == 8349889591 then
        return true
    else
        return false
    end
end

if loadstring(game:HttpGet("https://raw.githubusercontent.com/junggamyeon/MyScript/refs/heads/main/WL.lua.txt"))() and (InLobby() or InGame()) then

    function DataStore()
        local DS = {}

        function DS.GetAllMaps()
            return {
                {jojo = "Cape Canaveral"},
                {clover = "Clover Kingdom"},
                {jjk = "Cursed Academy"},
                {magnolia = "Magic Town"},
                {hxhant = "Ant Kingdom"},
                {hueco = "Hollow World"},
                {tokyoghoul = "Ghoul City"},
                {marineford = "Marine's Ford"},
                {naruto = "Hidden Sand Village"},
                {demonslayer = "Snowy Town"},
                {aot = "Shiganshinu District"},
                {namek = "Planet Namak"}
            }   
        end
        function DS.GetRaids()
            return {
                {west_city_raid = "West City"},
                {demonslayer_raid = "Infinity Train"},
                {naruto_raid = "Hidden Sand Village"},
                {aot_raid = "Shiganshinu District"}
            }
        end
        function DS.GetTeleports()
            return {
                {["Play"] = game:GetService("Workspace")["_teleports"].play.CFrame},
                {["Dungeons"] = game:GetService("Workspace")["_LOBBIES"]["story build"].Teleporter.beamholder.CFrame + Vector3.new(0,2,0)},
                {["Summon"] = game:GetService("Workspace")["_teleports"].summon.CFrame},
                {["Challenge"] = game:GetService("Workspace")["_CHALLENGES"].shell.floor.CFrame},
                {["Raid"] = game:GetService("Workspace")["_RAID"].shell.floor.CFrame},
                {["Leaderboards"] = game:GetService("Workspace")["_LEADERBOARDS_"].shell.floor.CFrame},
                {["Gojo Domain"] = game:GetService("Workspace")["_gojodomain"].entrance.CFrame},
                {["Infinity Castle"] = game:GetService("Workspace")["_infinity_castle"].entrance.CFrame},
                {["Sukuna Domain"] = game:GetService("Workspace")["_sukunadomain"].entrance.CFrame}
            }
        end

        function DS.Codes()
            return {
                "KARAKORA",
                "CLOVER2",
                "CLOVER",
                "HALLOWEEN",
                "CURSE2",
                "CURSE",
                "subtomaokuma",
                "TOADBOIGAMING",
                "SubToKelvingts",
                "SubToBlamspot",
                "FictioNTheFirst",
                "KingLuffy",
                "noclypso"
            }
        end

        return DS;
    end

    local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/KamaadiN/DataStore/main/MaterialLibrary.lua"))()
    local Data = DataStore()

    _G.Config = {
        IsA = "",
        GlobalLobby = "",

        Story = {
            Enabled = false,
            CompleteAllLevels = false,
            ErwinUntilBuff = false,
            Map = "namek",
            Level = "namek_level_1",
            Difficulty = "Normal",
            UpgradeMode = "Per Order",
            Units = {
                u1 = "",
                u2 = "",
                u3 = "",
                u4 = "",
                u5 = "",
                u6 = ""
            },
            SpawnCap = {
                u1 = 3,
                u2 = 6,
                u3 = 6,
                u4 = 6,
                u5 = 6,
                u6 = 6
            },
            UpgradeCap = {
                u1 = 15,
                u2 = 15,
                u3 = 15,
                u4 = 15,
                u5 = 15,
                u6 = 15
            }
        },
        Inf = {
            Enabled = false,
            Map = "namek",
            WaveToLose = 24,
            UpgradeMode = "Random",
            Units = {
                u1 = "",
                u2 = "",
                u3 = "",
                u4 = "",
                u5 = "",
                u6 = ""
            }
        },
        Chg = {
            Enabled = false,
            BlockedMaps = {},
            BlockedChgs = {},
            RewardsFilter = {},
            Lobby = "",
            Map = ""
        },
        Raid = {
            Enabled = false,
            MapsFilter = {},
            Map = "",
            Lobby = ""
        },
        InfCastle = {
            Enabled = false,
            Room = 1,
            Map = ""
        },
        Mission = {
            Enabled = false,
            Map = "",
            Name = "",
            Desc = "",
            Level = ""
        },
        CursedWomb = {
            Enabled = false,
            Map = "jjk"
        },
        LegendStage = {
            Enabled = false,
            Map = "clover_legend",
            Level = "clover_legend_1"
        },
        ChristmasChg = {
            Enabled = false,
            BlockedMaps = {},
            BlockedChgs = {},
            Lobby = "",
            Map = ""
        },

        WebhookURL = "",
        DiscordID = "",
        Mention = true,
        Notify = {
            Challenge = false,
            Raid = false,
            Summon = false,
            ["Game Results"] = false,
            ["Purchased Items"] = false,
        },

        SaveStatistics = false,
        Stats = {
            ["Gems Received"] = 0,
            ["XP Received"] = 0,
            ["Candies Received"] = 0,
            ["Levels Completed"] = 0
        },

        AutoSummon = false,
        Summoning = false,
        UnitsToGet = {},
        Banner = "Standard",
        SummonWith = "gems",
        RaritiesToSell = {},

        AcceptQuest = false,
        DailyRewards = false,
        RedeemQuests = false,

        BuyItem = false,
        ItemsToBuy = {},
        HideLeaderboard = false,
        HideName = false,

        SilentExec = false,
        FastQuit = false,
        Replay = false,
        WaveToQuit = 15,
        Keybind = "Enum.KeyCode.RightAlt",

        Collection = {
            Money = {},
            All = {}
        },
        ConfigChanges = 2.4 
    }

    local hubname = "MAZTER HUB"
    local configpath = "MazterHub/AnimeAdventures.txt"
    local shpath = "MazterHub/ServerHop.json"
    
    local function MergeConfig(OldConfig, NewConfig)

        local primaryTypes = {"string", "number", "boolean"}
        local othersTypes = {"table"}

        for k, v in pairs(OldConfig) do
            for k2, v2 in pairs(NewConfig) do
                if table.find(primaryTypes, type(v)) and table.find(primaryTypes, type(v2)) then
                    if k ~= "ConfigChanges" and k == k2 and v ~= v2 then
                        NewConfig[k] = v
                    end
                end
                if table.find(othersTypes, type(v)) and table.find(othersTypes, type(v2)) then
                    for k3, v3 in pairs(v) do
                        for k4, v4 in pairs(v2) do
                            if table.find({"string"}, type(k3)) then
                                if table.find(primaryTypes, type(v3)) and table.find(primaryTypes, type(v4)) then
                                    if k3 == k4 and v3 ~= v4 then
                                        NewConfig[k][k3] = v3
                                    end
                                end
                            end
                            if table.find({"number"}, type(k3)) then
                                if table.find(primaryTypes, type(v3)) and table.find(primaryTypes, type(v4)) then
                                    NewConfig[k][k3] = v3
                                end
                            end 
                            if table.find(othersTypes, type(v3)) and table.find(othersTypes, type(v4)) then
                                for k5, v5 in pairs(v3) do
                                    for k6, v6 in pairs(v4) do
                                        if table.find({"string"}, type(k5)) then
                                            if table.find(primaryTypes, type(v5)) and table.find(primaryTypes, type(v6)) then
                                                if k5 == k6 and v5 ~= v6 then
                                                    NewConfig[k][k3][k5] = v5
                                                end
                                            end
                                        end
                                        if table.find({"number"}, type(k5)) then
                                            if table.find(primaryTypes, type(v5)) and table.find(primaryTypes, type(v6)) then
                                                NewConfig[k][k3][k5] = v5
                                            end
                                        end 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local function LoadConfig()
        _G.AllIDs = {}
        if not isfolder("MazterHub") then
            makefolder("MazterHub")
        end
        if isfile(configpath) then
            local OldConfig = game:GetService("HttpService"):JSONDecode(readfile(configpath))
            if OldConfig["ConfigChanges"] ~= _G.Config.ConfigChanges then
                writefile(configpath, game:GetService("HttpService"):JSONEncode(_G.Config))
            else
                _G.Config = OldConfig
            end
        end
        if isfile(shpath) then
            _G.AllIDs = game:GetService("HttpService"):JSONDecode(readfile(shpath)) 
        else
            table.insert(_G.AllIDs, os.date("!*t").hour)
            pcall(function()
                writefile(shpath, game:GetService("HttpService"):JSONEncode(_G.AllIDs))
            end)
        end
        _G.StoryUnitDD = {}
        _G.InfUnitDD = {}
        _G.UpgCapSD = {}
        _G.Config.Raid.Lobby = ""
        _G.Config.Chg.Lobby = ""
        _G.Config.ChristmasChg.Lobby = ""
        _G.Config.Summoning = true
        if InLobby() then
            _G.Config.IsA = ""
        end
    end
    local function SaveConfig()
        if (writefile) then
            writefile(configpath, game:GetService("HttpService"):JSONEncode(_G.Config))
        end
    end
    LoadConfig()

    local function ServerHop(PlaceID)
        local FoundAnything = ""
        local Site;
        if FoundAnything == "" then
            Site = game:GetService("HttpService"):JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game:GetService("HttpService"):JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. FoundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            FoundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(_G.AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(os.date("!*t").hour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile(shpath)
                                _G.AllIDs = {}
                                table.insert(_G.AllIDs, os.date("!*t").hour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(_G.AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile(shpath, game:GetService("HttpService"):JSONEncode(_G.AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    local function GetUnitsID(unittype, unitname)
        local Units = require(game.ReplicatedStorage.src.Loader).load_data(script, "Units")
        local ids = {}
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("collection") then
            if unittype == "all" then
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.collection.grid.List.Outer.UnitFrames:GetChildren()) do
                    if v:IsA("ImageButton") then
                        local UnitName;
                        local UnitLevel;
                        for _, u in pairs(Units) do
                            if u["name"] == v.name.Text and not u["kill_rewards"] then
                                UnitName = u["id"]
                                UnitLevel = v.Main.Level.Text
                            end
                        end
                        if not table.find(ids, UnitName .. " - LV. " .. UnitLevel .. " - " .. v["_uuid"].Value) then
                            table.insert(ids, UnitName .. " - LV. " .. UnitLevel .. " - " .. v["_uuid"].Value)
                        end
                    end
                end
            elseif unittype == "money" then
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.collection.grid.List.Outer.UnitFrames:GetChildren()) do
                    if v:IsA("ImageButton") then
                        local UnitName = ""
                        local UnitLevel = ""
                        for k, u in pairs(Units) do
                            if k == "bulma" or k == "speedwagon" then
                                if u["name"] == v.name.Text then
                                    UnitName = u["id"]
                                    UnitLevel = v.Main.Level.Text
                                end
                            end
                        end
                        if UnitName ~= "" and UnitLevel ~= "" and not table.find(ids, UnitName .. " - LV. " .. UnitLevel .. " - " .. v["_uuid"].Value) then
                            table.insert(ids, UnitName .. " - LV. " .. UnitLevel .. " - " .. v["_uuid"].Value)
                        end
                    end
                end
            elseif unittype == "id" then
                for _, u in pairs(Units) do
                    if u["name"] == unitname and not u["kill_rewards"] then
                        return u["id"]
                    end
                end
            elseif unittype == "allgameunits" then
                local someunits = {}
                for v2, v3 in pairs(game:GetService("ReplicatedStorage").src.Data.Units:GetDescendants()) do
                    if v3:IsA("ModuleScript") and v3.Name ~= "UnitPresets" and not string.match(v3.Name, "_PVE") and not string.match(v3.Name, "Raid") and not string.match(v3.Name, "_Leaderboard") then
                        for v4, v5 in pairs(require(v3)) do
                            someunits[v4] = v5
                        end
                    end
                end
                for id, v in pairs(someunits) do
                    if not string.match(id, "_evolved") and not string.match(id, "_marineford") and not string.match(id, "big_test") then
                        if v["cost"] and v["cost"] ~= 1 then
                            table.insert(ids, id)
                        end
                    end
                end
            end
            table.sort(ids, function(a, b) return a:lower() < b:lower() end)
            return ids
        end
    end 
    local function CopyUnitsID(mode)
        local units = {}
        for i, v in pairs(_G.Config[mode].Units) do
            table.insert(units, v)
        end
        setclipboard(table.concat(units, "\n"))
    end
    local function EquipUnits(mode)
        game:GetService("ReplicatedStorage").endpoints.client_to_server.unequip_all:InvokeServer()
        wait()
        for pos = 1, 6 do
            if _G.Config[mode].Units["u"..pos] ~= "" then
                local id = string.split(_G.Config[mode].Units["u"..pos], " ")[3]
                game:GetService("ReplicatedStorage").endpoints.client_to_server.equip_unit:InvokeServer(id)
            end
            wait(0.55)
        end
    end
    local function UnitsPlaced(UnitID)
        local Units = 0
        for i, v in pairs(game:GetService("Workspace")["_UNITS"]:GetChildren()) do
            if v["_stats"].player.Value == game.Players.LocalPlayer then
                if v["_stats"].id.Value == UnitID then
                    Units += 1
                end
            end
        end
        return Units
    end
    local function GetCapsules()
        local c = {}
        for i, v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Items)) do
            if string.find(tostring(i), "capsule") then
            table.insert(c, v["name"])
            end
        end
        return c
    end
    local function GetCapsuleID(capsuleName)
        for i, v in pairs(require(game:GetService("ReplicatedStorage").src.Data.Items)) do
            if string.find(tostring(i), "capsule") then
                if v["name"] == capsuleName then
                    return v["id"]
                end
            end
        end
    end
    local function GetCapsuleName(capsuleId)
        local itemsMod = require(game:GetService("ReplicatedStorage").src.Data.Items)
        return itemsMod[capsuleId]["name"]
    end
    local function GetItemsForSale()
        local t = {}
        local items = require(game:GetService("ReplicatedStorage").src.Data.Items)
        for i, v in pairs(require(game:GetService("ReplicatedStorage").src.Data.ItemsForSale)) do
            table.insert(t, items[i]["name"].." - "..i)
        end
        table.sort(t, function(a, b) return a:lower() < b:lower() end)
        return t
    end
    local function GetItem(option, option2)
        local items = require(game:GetService("ReplicatedStorage").src.Data.Items)
        if option == "name" then
            return items[option2]["name"]
        end
    end
    local function GetMap(get, whats)
        if get == "all" then
            local t = {}
            for i, v in ipairs(Data.GetAllMaps()) do
                for id, name in pairs(v) do
                    table.insert(t, name)
                end
            end
            return t
        elseif get == "name" then
            for i, v in ipairs(Data.GetAllMaps()) do
                for id, name in pairs(v) do
                    if id == whats then
                        return name
                    end
                end
            end
        elseif get == "id" then
            for i, v in ipairs(Data.GetAllMaps()) do
                for id, name in pairs(v) do
                    if name == whats then
                        return id
                    end
                end
            end
        end
    end
    local function GetLevel(get, whats)
        local levels = require(game:GetService("ReplicatedStorage").src.Data.Levels)
        local t = {}
        if get == "all" then
            for k, v in pairs(levels) do
                if string.match(k, whats) and (string.match(k, "_level_") or string.match(whats, "legend") and string.match(k, "_legend_")) then
                    table.insert(t, v["name"])
                end
            end
            if string.match(t[1], "%d+") then
                table.sort(t, function(a, s)
                    local a1 = tonumber(string.match(a, "%d+"))
                    local b1 = tonumber(string.match(s, "%d+"))
                    return a1 < b1
                end)
            end
            return t
        elseif get == "id" then
            for k, v in pairs(levels) do
                if string.match(k, "_level_") or string.match(k, "_legend_") then
                    if v["name"] == whats then
                        return k
                    end
                end
            end
        elseif get == "name" then
            for k, v in pairs(levels) do
                if string.match(k, "_level_") or string.match(k, "_legend_") then
                    if k == whats then
                        return v["name"]
                    end
                end
            end
        end
    end
    local function GetChallenge(o1, o2)
        local cr = require(game:GetService("ReplicatedStorage").src.Data.ChallengeAndRewards)
        if o1 == "allnames" then
            local t = {}
            for i, v in pairs(cr["challenges"]) do
                if not table.find(t, v["name"]) then
                    table.insert(t, v["name"])
                end
            end
            return t
        elseif o1 == "id" then
            for id, chg in pairs(cr["challenges"]) do
                if chg["name"] == o2 then
                    return id
                end
            end
        elseif o1 == "name" then
            for id, chg in pairs(cr["challenges"]) do
                if id == o2 then
                    return chg["name"]
                end
            end
        end
    end
    local function GetChallengeGui()
        for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if v:IsA("SurfaceGui") and v:FindFirstChild("ChallengeCleared") then
                if v.LevelTitle.Text == "Current Challenge" then
                    return v
                end
            end
        end
    end
    local function GetRewards(o1, o2)
        local cr = require(game:GetService("ReplicatedStorage").src.Data.ChallengeAndRewards)
        if o1 == "allnames" then
            local t = {}
            for i, v in pairs(cr["rewards"]) do
                if not table.find(t, v["name"]) then
                    table.insert(t, v["name"])
                end
            end
            return t
        elseif o1 == "id" then
            for id, chg in pairs(cr["rewards"]) do
                if chg["name"] == o2 then
                    return id
                end
            end
        elseif o1 == "name" then
            for id, chg in pairs(cr["rewards"]) do
                if id == o2 then
                    return chg["name"]
                end
            end
        end
    end
    local function GetLastRoom()
        if InLobby() then
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("InfiniteTowerUI").LevelSelect.InfoFrame.LevelButtons:GetChildren()) do
                if v.Name == "FloorButton" then
                    if v:FindFirstChild("clear") then
                        if v.clear.Visible == false then
                            return tonumber(string.match(v.Main.text.Text, "%d+"))
                        end
                    end
                end
            end
        elseif InGame() then
            local leveldata = game:GetService("Workspace")["_MAP_CONFIG"].GetLevelData:InvokeServer()
            if leveldata["_infinite_tower_floor"] then
                return tonumber(leveldata["_infinite_tower_floor"])
            else
                return _G.Config.InfCastle.Room
            end
        end
    end
    local function GetLegend(option)
        local worlds = {
            {jojo_legend = "Cape Canaveral"},   
            {bleach_legend = "Hollow Invasion"},
            {clover_legend = "Clover Kingdom (Elf Invasion)"}
        }
        if option[1] == "all" then
            local t = {}
            for i, v in ipairs(worlds) do
                for i2, v2 in pairs(v) do
                    table.insert(t, v2)
                end
            end
            return t
        end
        if option[1] == "id" then
            for i, v in ipairs(worlds) do
                for i2, v2 in pairs(v) do
                    if v2 == option[2] then
                        return i2
                    end
                end
            end
        end
        if option[1] == "name" then
            for i, v in ipairs(worlds) do
                for i2, v2 in pairs(v) do
                    if i2 == option[2] then
                        return v2
                    end
                end
            end
        end
    end
    local function GetMission(option, option2)
        local missions = game:GetService("ReplicatedStorage").endpoints["client_to_server"]["request_mission_quests_data"]:InvokeServer()
        if option == "id" then
            for _, v in pairs(missions) do
                if v["quest_name"] == option2 then
                    return v["id"]
                end
            end
        elseif option == "name" then
            return missions[option2]["quest_name"]
        elseif option == "desc" then
            return missions[option2]["quest_desc"]
        elseif option == "level" then
            if string.match(option2, "kill") then
                return "magnolia_infinite"
            else
                return missions[option2]["quest_class"]["level_id"]
            end
        end
    end
    local function GetRaid(option, option2)
        if option == "all" then
            local t = {}
            for i, v in ipairs(Data.GetRaids()) do
                for id, name in pairs(v) do
                    table.insert(t, name)
                end
            end
            return t
        elseif option == "name" then
            for i, v in ipairs(Data.GetRaids()) do
                for id, name in pairs(v) do
                    if id == option2 then
                        return name
                    end
                end
            end
        elseif option == "id" then
            for i, v in ipairs(Data.GetRaids()) do
                for id, name in pairs(v) do
                    if name == option2 then
                        return id
                    end
                end
            end
        end
    end
    local function GetGamemode(id)
        local gamemode = ""
        if string.match(id, "_") then
            split = string.split(id, "_")
            gamemode = ""
            for i = 1, #split do
                if i == 1 then
                    gamemode = split[i]:sub(1, 1):upper() .."".. split[i]:sub(2) else
                    gamemode = gamemode .. " " .. split[i]:sub(1, 1):upper() .."".. split[i]:sub(2)
                end
            end
        else
            gamemode = string.upper(string.sub(id, 1, 1)) .."".. string.sub(id, 2)
        end
        return gamemode
    end
    local function GetMaxSpawn(Unit)
        local max = {
            u1 = 3,
            u2 = 6,
            u3 = 6,
            u4 = 6,
            u5 = 6,
            u6 = 6
        }
        return max["u"..Unit]
    end
    local function GetSpawnCap(Unit)
        local Units = require(game.ReplicatedStorage.src.Loader).load_data(script, "Units")
        if not Units[Unit]["spawn_cap"] then
            return 1
        else
            return Units[Unit]["spawn_cap"]
        end
    end
    local function GetUnit(mode, order)
        return string.split(_G.Config[mode].Units[order], " ")[1]
    end 
    local function GetChristmasMap(op, op2)
        local maps = {
            {namek = "Planet Namak (Frozen)"},
            {aot = "Shiganshinu District (Winter)"},
            {naruto = "Hidden Sand Village (Snow)"},
            {tokyoghoul = "Ghoul City (Winter)"},
            {magnolia = "Magic Town (Snow)"},
            {jjk = "Cursed Academy (Frozen)"}
        }
        if op == "all" then
            local t = {}
            for i, v in ipairs(maps) do
                for i2, v2 in pairs(v) do
                    table.insert(t, v2)
                end
            end
            return t
        end
        if op == "id" then
            for i, v in ipairs(maps) do
                for i2, v2 in pairs(v) do
                    if v2 == op2 then
                        return i2
                    end
                end
            end
        end
    end
    local function GetUpgrades(UnitID, UnitOrder, Mode)
        local units = require(game.ReplicatedStorage.src.Loader).load_data(script, "Units")
        local upgrades = #units[UnitID]["upgrade"]
        if Mode == "Inf" then
            return upgrades
        else
            if _G.Config[Mode].UpgradeCap[UnitOrder] > upgrades then
                return upgrades
            else
                return _G.Config[Mode].UpgradeCap[UnitOrder]
            end
        end
    end
    local function IsUpgraded(Unit, Mode)
        local Units = game:GetService("Workspace")["_UNITS"]:GetChildren()
        local UnitID = string.split(_G.Config[Mode].Units[Unit], " ")[1]
        local UnitsUpgraded = 0
        for i, v in next, Units do
            if v["_stats"].player.Value == game.Players.LocalPlayer then
                if string.match(v._stats.id.Value, UnitID) then
                    if v._stats.upgrade.Value >= GetUpgrades(v._stats.id.Value, Unit, Mode) then
                        UnitsUpgraded += 1
                    end
                end
            end
        end
        if UnitsUpgraded > 0 and UnitsPlaced(UnitID) > 0 then
            if UnitsUpgraded == UnitsPlaced(UnitID) then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    local function CheckRoom()
        _G.Config.InfCastle.Room = GetLastRoom()
        SaveConfig()
    end
    local function SendWebhook(WebhookData, CanMark)
        if CanMark and _G.Config.DiscordID ~= "" then
            _G.DiscordMark = "<@" .. _G.Config.DiscordID .. ">"
        elseif CanMark then
            _G.DiscordMark = "@everyone" 
        else
            _G.DiscordMark = ""
        end
        if _G.Config.WebhookURL ~= "" then
            WebhookData.content = _G.DiscordMark
            local request = http_request or request or HttpPost or syn.request
            local url = _G.Config.WebhookURL
            local Notifier = {Url = url, Body = game:GetService("HttpService"):JSONEncode(WebhookData), Method = "POST", Headers = {["content-type"] = "application/json"}}
            request(Notifier)
        end
    end
    local function AllMissions()
        local t = {}
        local missions = game:GetService("ReplicatedStorage").endpoints["client_to_server"]["request_mission_quests_data"]:InvokeServer()
        for i, v in pairs(missions) do
            table.insert(t, v["quest_name"])
        end
        return t
    end
    local function Search(op, texttofilter, unittype, ingame)
        if op == "itemsforsale" then
            local t = {}
            for i, v in pairs(GetItemsForSale()) do
                if string.match(string.lower(v), string.lower(texttofilter)) then
                    table.insert(t, v)
                end
            end
            table.sort(t, function(a, b) return a:lower() < b:lower() end)
            return t
        elseif op == "unitsid" then
            ingame = ingame or false
            local t = {}
            if ingame then
                for i, v in pairs(_G.Config.Collection[unittype]) do
                    local name = string.split(v, " ")[1]
                    if string.match(string.lower(name), string.lower(texttofilter)) then
                        table.insert(t, v)
                    end
                end
            else
                for i, v in pairs(GetUnitsID(unittype)) do
                    local name = string.split(v, " ")[1]
                    if string.match(string.lower(name), string.lower(texttofilter)) then
                        table.insert(t, v)
                    end
                end
            end
            table.sort(t, function(a, b) return a:lower() < b:lower() end)
            return t
        elseif op == "allgameunits" then
            local t = {}
            local someunits = {}
            for v2, v3 in pairs(game:GetService("ReplicatedStorage").src.Data.Units:GetDescendants()) do
                if v3:IsA("ModuleScript") and v3.Name ~= "UnitPresets" and not string.match(v3.Name, "_PVE") and not string.match(v3.Name, "Raid") and not string.match(v3.Name, "_Leaderboard") then
                    for v4, v5 in pairs(require(v3)) do
                        someunits[v4] = v5
                    end
                end
            end
            for id, v in pairs(someunits) do
                if not string.match(id, "_evolved") and not string.match(id, "_marineford") and not string.match(id, "big_test") then
                    if v["cost"] and v["cost"] ~= 1 then
                        if string.match(string.lower(id), string.lower(texttofilter)) then
                            table.insert(t, id)
                        end
                    end
                end
            end
            table.sort(t, function(a, b) return a:lower() < b:lower() end)
            return t
        end
    end
    local function SaveCollection()
        pcall(function()
            _G.Config.Collection.Money = GetUnitsID("money")
            _G.Config.Collection.All = GetUnitsID("all")
            SaveConfig()
        end)
    end
    local function HasItem(ItemID, ReturnType, Amount)
        if game:GetService("Players").LocalPlayer.PlayerGui.items.grid.List.Outer.ItemFrames:FindFirstChild(ItemID) then
            local ItemAmount = tonumber(game:GetService("Players").LocalPlayer.PlayerGui.items.grid.List.Outer.ItemFrames[ItemID].OwnedAmount.Text:match("%d+"))
            if ReturnType == ">" then
                if ItemAmount >= Amount then
                    return true
                else
                    return false
                end
            elseif ReturnType == "<" then
                if ItemAmount <= Amount then
                    return true
                else
                    return false
                end
            end
        elseif ReturnType == "<" then
            return true
        elseif ReturnType == ">" then
            return false
        end
    end
    local function SilentExecution()
        if _G.Config.SilentExec then
            while wait() do
                if game:GetService("CoreGui"):FindFirstChild(hubname) then
                    if not game:GetService("CoreGui")[hubname].Enabled then break end
                    if game:GetService("CoreGui")[hubname].Enabled then
                        game:GetService("CoreGui")[hubname].Enabled = false
                    end
                end
            end
        end
    end
    local function RemoveErrors()
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MessageGui") then
                game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MessageGui")["message_templates"].Error.Visible = false
            end
        end
    end
    local function HideLeaderboard()
        while wait() do
            pcall(function()
                if game:GetService('StarterGui') then
                    if _G.Config.HideLeaderboard then
                        game:GetService('StarterGui'):SetCoreGuiEnabled(0, false) else
                        game:GetService('StarterGui'):SetCoreGuiEnabled(0, true)
                    end
                end
            end)
        end
    end
    local function HideName()
        while wait() do
            pcall(function()
                if _G.Config.HideName then
                    if game.Players.LocalPlayer.Character then
                        if game.Players.LocalPlayer.Character:FindFirstChild("Head") then
                            for _, v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
                                if v.Name == "_overhead" then
                                    v:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    if InLobby() and not game:GetService("CoreGui"):FindFirstChild(hubname) then
        task.wait(5)
    elseif InGame() and not game:GetService("CoreGui"):FindFirstChild(hubname) then
        task.wait(18)
    end

    task.spawn(HideLeaderboard)
    task.spawn(SilentExecution)

    -- GUI

        if InLobby() then
            _G.UI = Material.Load({
                Title = hubname,
                SubTitle = "Anime Adventures",
                Style = 1,
                SizeX = 500,
                SizeY = 560,
                Theme = "VeryDark",
            })
        elseif InGame() then
            _G.UI = Material.Load({
                Title = hubname,
                SubTitle = "Anime Adventures",
                Style = 1,
                SizeX = 390,
                SizeY = 450,
                Theme = "VeryDark",
            })
        end

    -- PAGINAS

        local StoryPg = _G.UI.New({
            Title = "STORY"
        })
        local InfPg = _G.UI.New({
            Title = "INFINITE"
        })
        local OthersPg = _G.UI.New({
            Title = "OTHERS"
        })
        local WhPg = _G.UI.New({
            Title = "WEBHOOK"
        })
        if InLobby() then
            _G.TpPg = _G.UI.New({
                Title = "TELEPORTS"
            })
            _G.UiPg = _G.UI.New({
                Title = "UI"
            })
        end
        local StPg = _G.UI.New({
            Title = "STATS"
        })
        local MiscPg = _G.UI.New({
            Title = "MISC"
        })

    -- STORY
        
        StoryPg.Toggle({
            Text = "Auto Story",
            Callback = function(v)
                _G.Config.Story.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.Story.Enabled
        })
        _G.StoryMapDD = StoryPg.Dropdown({
            Text = "Select Map",
            Callback = function(op)
                _G.Config.Story.Map = GetMap("id", op)
                _G.LevelsDD:SetOptions(GetLevel("all", GetMap("id", op)))
                SaveConfig()
            end,
            Options = GetMap("all")
        })
        _G.LevelsDD = StoryPg.Dropdown({
            Text = "Select Level",
            Callback = function(op)
                _G.Config.Story.Level = GetLevel("id", op)
                SaveConfig()
            end,
            Options = GetLevel("all", _G.Config.Story.Map)
        })
        _G.Difficulty = StoryPg.Dropdown({
            Text = "Difficulty",
            Callback = function(op)
                _G.Config.Story.Difficulty = op
                SaveConfig()
            end,
            Options = {"Normal", "Hard"}
        })
        local StoryUpgDD = StoryPg.Dropdown({
            Text = "Upgrade Mode",
            Callback = function(op)
                _G.Config.Story.UpgradeMode = op
                SaveConfig()
            end,
            Options = {"Random", "Per Order"}
        })
        
        if InLobby() then
            StoryPg.TextField({
                Text = "Search Unit",
                Callback = function(v)
                    for i = 1, 6 do
                        if i == 1 then
                            _G.StoryUnitDD[i]:SetOptions(Search("unitsid", v, "money"))
                        else
                            _G.StoryUnitDD[i]:SetOptions(Search("unitsid", v, "all"))
                        end
                    end
                end
            })
            for i = 1, 6 do
                if i == 1 then
                    _G.StoryUnitDD[i] = StoryPg.Dropdown({
                        Text = "Unit "..i.." - Empty",
                        Callback = function(op)
                            local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                            if _G.Config.Story.Units["u"..i] == unit then
                                _G.Config.Story.Units["u"..i] = ""
                            else
                                _G.Config.Story.Units["u"..i] = unit
                            end
                            SaveConfig()
                        end,
                        Options = GetUnitsID("money")
                    })
                else
                    _G.StoryUnitDD[i] = StoryPg.Dropdown({
                        Text = "Unit "..i.." - Empty",
                        Callback = function(op)
                            local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                            if _G.Config.Story.Units["u"..i] == unit then
                                _G.Config.Story.Units["u"..i] = ""
                            else
                                _G.Config.Story.Units["u"..i] = unit
                            end
                            SaveConfig()
                        end,
                        Options = GetUnitsID("all")
                    })
                end
            end
            StoryPg.Button({
                Text = "Equip Units",
                Callback = function()
                    EquipUnits("Story")
                end
            })
            StoryPg.Button({
                Text = "Clear Units",
                Callback = function()
                    for i = 1, 6 do
                        _G.Config.Story.Units["u" .. i] = ""
                    end
                    SaveConfig()
                end
            })
            StoryPg.Button({
                Text = "Refresh Units",
                Callback = function()
                    for i = 1, 5 do
                        if i == 1 then
                            _G.StoryUnitDD[i]:SetOptions(GetUnitsID("money")) else
                            _G.StoryUnitDD[i]:SetOptions(GetUnitsID("all"))
                        end
                    end
                end
            })
            StoryPg.Button({
                Text = "Copy Infinite Units",
                Callback = function()
                    for i = 1, 6 do
                        _G.Config.Story.Units["u"..i] = _G.Config.Inf.Units["u"..i]
                    end
                    SaveConfig()
                end
            })
        elseif InGame() then
            pcall(function()
                if #_G.Config.Collection.Money > 0 and #_G.Config.Collection.All > 0 then
                    StoryPg.TextField({
                        Text = "Search Unit",
                        Callback = function(v)
                            for i = 1, 6 do
                                if i == 1 then
                                    _G.StoryUnitDD[i]:SetOptions(Search("unitsid", v, "Money", true))
                                else
                                    _G.StoryUnitDD[i]:SetOptions(Search("unitsid", v, "All", true))
                                end
                            end
                        end
                    })
                    for i = 1, 6 do
                        if i == 1 then
                            _G.StoryUnitDD[i] = StoryPg.Dropdown({
                                Text = "Unit "..i.." - Empty",
                                Callback = function(op)
                                    local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                                    if _G.Config.Story.Units["u"..i] == unit then
                                        _G.Config.Story.Units["u"..i] = ""
                                    else
                                        _G.Config.Story.Units["u"..i] = unit
                                    end
                                    SaveConfig()
                                end,
                                Options = _G.Config.Collection.Money
                            })
                        else
                            _G.StoryUnitDD[i] = StoryPg.Dropdown({
                                Text = "Unit "..i.." - Empty",
                                Callback = function(op)
                                    local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                                    if _G.Config.Story.Units["u"..i] == unit then
                                        _G.Config.Story.Units["u"..i] = ""
                                    else
                                        _G.Config.Story.Units["u"..i] = unit
                                    end
                                    SaveConfig()
                                end,
                                Options = _G.Config.Collection.All
                            })
                        end
                    end
                    StoryPg.Button({
                        Text = "Clear Units",
                        Callback = function()
                            for i = 1, 6 do
                                _G.Config.Story.Units["u" .. i] = ""
                            end
                            SaveConfig()
                        end
                    })
                    StoryPg.Button({
                        Text = "Copy Infinite Units",
                        Callback = function()
                            for i = 1, 6 do
                                _G.Config.Story.Units["u"..i] = _G.Config.Inf.Units["u"..i]
                            end
                            SaveConfig()
                        end
                    })
                else
                    for i = 1, 6 do
                        if _G.Config.Story.Units["u"..i] ~= "" then
                            local unit = string.split(_G.Config.Story.Units["u"..i], " ")[1]
                            StoryPg.Label({
                                Text = i.." - "..unit
                            })
                        end
                    end
                end
            end)
        end
        StoryPg.Label({Text = "SPAWN CAP"})
        for i = 1, 6 do
            StoryPg.Slider({
                Text = "[SPAWN CAP] - Unit "..i,
                Callback = function(v)
                    _G.Config.Story.SpawnCap["u"..i] = v
                    SaveConfig()
                end,
                Min = 1,
                Max = GetMaxSpawn(i),
                Def = _G.Config.Story.SpawnCap["u"..i]
            })
        end
        StoryPg.Label({Text = "UPGRADE CAP"})
        for i = 1, 6 do
            StoryPg.Slider({
                Text = "[UPGRADE CAP] - Unit "..i,
                Callback = function(v)
                    _G.Config.Story.UpgradeCap["u"..i] = v
                    SaveConfig()
                end,
                Min = 1,
                Max = 15,
                Def = _G.Config.Story.UpgradeCap["u"..i]
            })
        end

    -- INFINITE

        InfPg.Toggle({
            Text = "Auto Infinite",
            Callback = function(v)
                _G.Config.Inf.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.Inf.Enabled
        })
        local MapDD = InfPg.Dropdown({
            Text = "Select Map",
            Callback = function(op)
                _G.Config.Inf.Map = GetMap("id", op)
                SaveConfig()
            end,
            Options = GetMap("all")
        })
        local InfUpgDD = InfPg.Dropdown({
            Text = "Upgrade Mode",
            Callback = function(op)
                _G.Config.Inf.UpgradeMode = op
                SaveConfig()
            end,
            Options = {"Random", "Per Order"}
        })
        InfPg.Slider({
            Text = "Wave To Lose",
            Callback = function(v)
                _G.Config.Inf.WaveToLose = v
                SaveConfig()
            end,
            Min = 15,
            Max = 100,
            Def = _G.Config.Inf.WaveToLose
        })

        if InLobby() then
            InfPg.TextField({
                Text = "Search Unit",
                Callback = function(v)
                    for i = 1, 6 do
                        if i == 1 then
                            _G.InfUnitDD[i]:SetOptions(Search("unitsid", v, "money"))
                        else
                            _G.InfUnitDD[i]:SetOptions(Search("unitsid", v, "all"))
                        end
                    end
                end
            })
            for i = 1, 6 do
                if i == 1 then
                    _G.InfUnitDD[i] = InfPg.Dropdown({
                        Text = "Unit "..i.." - Empty",
                        Callback = function(op)
                            local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                            if _G.Config.Inf.Units["u"..i] == unit then
                                _G.Config.Inf.Units["u"..i] = ""
                            else
                                _G.Config.Inf.Units["u"..i] = unit
                            end
                            SaveConfig()
                        end,
                        Options = GetUnitsID("money")
                    })
                else
                    _G.InfUnitDD[i] = InfPg.Dropdown({
                        Text = "Unit "..i.." - Empty",
                        Callback = function(op)
                            local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                            if _G.Config.Inf.Units["u"..i] == unit then
                                _G.Config.Inf.Units["u"..i] = ""
                            else
                                _G.Config.Inf.Units["u"..i] = unit
                            end
                            SaveConfig()
                        end,
                        Options = GetUnitsID("all")
                    })
                end
            end
            InfPg.Button({
                Text = "Equip Units",
                Callback = function()
                    EquipUnits("Inf")
                end
            })
            InfPg.Button({
                Text = "Clear Units",
                Callback = function()
                    for i = 1, 6 do
                        _G.Config.Inf.Units["u" .. i] = ""
                    end
                    SaveConfig()
                end
            })
            InfPg.Button({
                Text = "Refresh Units",
                Callback = function()
                    for i = 1, 5 do
                        if i == 1 then
                            _G.InfUnitDD[i]:SetOptions(GetUnitsID("money")) else
                            _G.InfUnitDD[i]:SetOptions(GetUnitsID("all"))
                        end
                    end
                end
            })
            InfPg.Button({
                Text = "Copy Story Units",
                Callback = function()
                    for i = 1, 6 do
                        _G.Config.Inf.Units["u"..i] = _G.Config.Story.Units["u"..i]
                    end
                    SaveConfig()
                end
            })
        elseif InGame() then
            pcall(function()
                if #_G.Config.Collection.Money > 0 and #_G.Config.Collection.All > 0 then
                    InfPg.TextField({
                        Text = "Search Unit",
                        Callback = function(v)
                            for i = 1, 6 do
                                if i == 1 then
                                    _G.InfUnitDD[i]:SetOptions(Search("unitsid", v, "Money", true))
                                else
                                    _G.InfUnitDD[i]:SetOptions(Search("unitsid", v, "All", true))
                                end
                            end
                        end
                    })
                    for i = 1, 6 do
                        if i == 1 then
                            _G.InfUnitDD[i] = InfPg.Dropdown({
                                Text = "Unit "..i.." - Empty",
                                Callback = function(op)
                                    local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                                    if _G.Config.Inf.Units["u"..i] == unit then
                                        _G.Config.Inf.Units["u"..i] = ""
                                    else
                                        _G.Config.Inf.Units["u"..i] = unit
                                    end
                                    SaveConfig()
                                end,
                                Options = _G.Config.Collection.Money
                            })
                        else
                            _G.InfUnitDD[i] = InfPg.Dropdown({
                                Text = "Unit "..i.." - Empty",
                                Callback = function(op)
                                    local unit = string.gsub(op, string.match(op, "-%sLV.%s%d+%s"), "")
                                    if _G.Config.Inf.Units["u"..i] == unit then
                                        _G.Config.Inf.Units["u"..i] = ""
                                    else
                                        _G.Config.Inf.Units["u"..i] = unit
                                    end
                                    SaveConfig()
                                end,
                                Options = _G.Config.Collection.All
                            })
                        end
                    end
                    InfPg.Button({
                        Text = "Clear Units",
                        Callback = function()
                            for i = 1, 6 do
                                _G.Config.Inf.Units["u" .. i] = ""
                            end
                            SaveConfig()
                        end
                    })
                    InfPg.Button({
                        Text = "Copy Story Units",
                        Callback = function()
                            for i = 1, 6 do
                                _G.Config.Inf.Units["u"..i] = _G.Config.Story.Units["u"..i]
                            end
                            SaveConfig()
                        end
                    })
                else
                    for i = 1, 6 do
                        if _G.Config.Inf.Units["u"..i] ~= "" then
                            local unit = string.split(_G.Config.Inf.Units["u"..i], " ")[1]
                            InfPg.Label({
                                Text = i.." - "..unit
                            })
                        end
                    end
                end
            end)
        end

    -- RAID

        OthersPg.Toggle({
            Text = "Auto Raid",
            Callback = function(v)
                _G.Config.Raid.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.Raid.Enabled
        })
        local RaidMapDD = OthersPg.Dropdown({
            Text = "Maps Filter",
            Callback = function(op)
                if not table.find(_G.Config.Raid.MapsFilter, GetRaid("id", op)) then
                    table.insert(_G.Config.Raid.MapsFilter, GetRaid("id", op))
                else
                    table.remove(_G.Config.Raid.MapsFilter, table.find(_G.Config.Raid.MapsFilter, GetRaid("id", op)))
                end
                SaveConfig()
            end,
            Options = GetRaid("all")
        })

    -- CHALLENGE

        OthersPg.Toggle({
            Text = "Auto Challenge",
            Callback = function(v)
                _G.Config.Chg.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.Chg.Enabled
        })
        local ChgMapDD = OthersPg.Dropdown({
            Text = "Blocked Maps",
            Callback = function(op)
                if not table.find(_G.Config.Chg.BlockedMaps, GetMap("id", op)) then
                    table.insert(_G.Config.Chg.BlockedMaps, GetMap("id", op))
                else
                    table.remove(_G.Config.Chg.BlockedMaps, table.find(_G.Config.Chg.BlockedMaps, GetMap("id", op)))
                end
                SaveConfig()
            end,
            Options = GetMap("all")
        })
        local ChgsDD = OthersPg.Dropdown({
            Text = "Blocked Challenges",
            Callback = function(op)
                if not table.find(_G.Config.Chg.BlockedChgs, GetChallenge("id", op)) then
                    table.insert(_G.Config.Chg.BlockedChgs, GetChallenge("id", op))
                else
                    table.remove(_G.Config.Chg.BlockedChgs, table.find(_G.Config.Chg.BlockedChgs, GetChallenge("id", op)))
                end
                SaveConfig()
            end,
            Options = GetChallenge("allnames")
        })
        local ChgRwdDD = OthersPg.Dropdown({
            Text = "Filter Rewards",
            Callback = function(op)
                if not table.find(_G.Config.Chg.RewardsFilter, GetRewards("id", op)) then
                    table.insert(_G.Config.Chg.RewardsFilter, GetRewards("id", op))
                else
                    table.remove(_G.Config.Chg.RewardsFilter, table.find(_G.Config.Chg.RewardsFilter, GetRewards("id", op)))
                end
                SaveConfig()
            end,
            Options = GetRewards("allnames")
        })

    -- INFINITY CASTLE

        OthersPg.Toggle({
            Text = "Auto Infinity Castle",
            Callback = function(v)
                _G.Config.InfCastle.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.InfCastle.Enabled
        })
        local RoomLabel = OthersPg.Label({
            Text = "ROOM"
        })

    -- MISSION

        OthersPg.Toggle({
            Text = "Auto Missions",
            Callback = function(v)
                _G.Config.Mission.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.Mission.Enabled
        })
        local MissionNameLabel = OthersPg.Label({
            Text = "Name"
        })
        local MissionDescLabel = OthersPg.Label({
            Text = "Description"
        })
        local MissionLevelLabel = OthersPg.Label({
            Text = "Level"
        })

    -- CURSED WOMB

        OthersPg.Toggle({
            Text = "Auto Cursed Womb",
            Callback = function(v)
                _G.Config.CursedWomb.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.CursedWomb.Enabled
        })

    -- LEGEND STAGE

        OthersPg.Toggle({
            Text = "Auto Legend Stage",
            Callback = function(v)
                _G.Config.LegendStage.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.LegendStage.Enabled
        })
        _G.LegendMapDD = OthersPg.Dropdown({
            Text = "Select World",
            Callback = function(op)
                _G.Config.LegendStage.Map = GetLegend({"id", op})
                _G.LegendLevelDD:SetOptions(GetLevel("all", GetLegend({"id", op})))
                _G.Config.LegendStage.Level = GetLevel("id", GetLevel("all", _G.Config.LegendStage.Map)[1])
                SaveConfig()
            end,
            Options = GetLegend({"all"})
        })
        _G.LegendLevelDD = OthersPg.Dropdown({
            Text = "Select Level",
            Callback = function(op)
                _G.Config.LegendStage.Level = GetLevel("id", op)
                SaveConfig()
            end,
            Options = GetLevel("all", _G.Config.LegendStage.Map)
        })

    -- CHRISTMAS EVENT

        OthersPg.Toggle({
            Text = "Auto Christmas Challenge",
            Callback = function(v)
                _G.Config.ChristmasChg.Enabled = v
                SaveConfig()
            end,
            Enabled = _G.Config.ChristmasChg.Enabled
        })
        local ChristmasMapDD = OthersPg.Dropdown({
            Text = "Blocked Maps",
            Callback = function(op)
                if not table.find(_G.Config.ChristmasChg.BlockedMaps, GetChristmasMap("id", op)) then
                    table.insert(_G.Config.ChristmasChg.BlockedMaps, GetChristmasMap("id", op))
                else
                    table.remove(_G.Config.ChristmasChg.BlockedMaps, table.find(_G.Config.ChristmasChg.BlockedMaps, GetChristmasMap("id", op)))
                end
                SaveConfig()
            end,
            Options = GetChristmasMap("all")
        })
        local ChristmasChgsDD = OthersPg.Dropdown({
            Text = "Blocked Challenges",
            Callback = function(op)
                if not table.find(_G.Config.ChristmasChg.BlockedChgs, GetChallenge("id", op)) then
                    table.insert(_G.Config.ChristmasChg.BlockedChgs, GetChallenge("id", op))
                else
                    table.remove(_G.Config.ChristmasChg.BlockedChgs, table.find(_G.Config.ChristmasChg.BlockedChgs, GetChallenge("id", op)))
                end
                SaveConfig()
            end,
            Options = GetChallenge("allnames")
        })

    -- WEBHOOK
    
        local WhText = WhPg.TextField({
            Text = "Webhook URL",
            Callback = function(v)
                _G.Config.WebhookURL = v
                SaveConfig()
            end
        })
        local DcText = WhPg.TextField({
            Text = "Your Discord ID",
            Callback = function(v)
                _G.Config.DiscordID = v
                SaveConfig()
            end,
            Menu = {
                ["This is optional..."] = function(self)
                end
            }
        })
        WhPg.Toggle({
            Text = "Mention @everyone or Discord ID",
            Callback = function(v)
                _G.Config.Mention = v
                SaveConfig()
            end,
            Enabled = _G.Config.Mention
        })
        WhPg.Label({
            Text = "Notifiers"
        })
        for k, value in pairs(_G.Config.Notify) do
            WhPg.Toggle({
                Text = k,
                Callback = function(v)
                    _G.Config.Notify[k] = v
                    SaveConfig()
                end,
                Enabled = _G.Config.Notify[k]
            })
        end

    -- TELEPORTS

        if InLobby() then
            for i, v in ipairs(Data.GetTeleports()) do
                for k, v2 in pairs(v) do
                    _G.TpPg.Button({
                        Text = k,
                        Callback = function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v2
                        end
                    })
                end
            end
        end

    -- UI

        if InLobby() then
            _G.UiPg.Button({
                Text = "Evolve Machine",
                Callback = function()
                    fireproximityprompt(game:GetService("Workspace").evolvemachine.ProximityPrompt)
                end
            })
            _G.UiPg.Button({
                Text = "Time Machine",
                Callback = function()
                    fireproximityprompt(game:GetService("Workspace").timemachine.ProximityPrompt)
                end
            })
            _G.UiPg.Button({
                Text = "Trait Reroll",
                Callback = function()
                    fireproximityprompt(game:GetService("Workspace").traitrerollmachine.ProximityPrompt)
                end
            })
            _G.UiPg.Button({
                Text = "Curse Reroll",
                Callback = function()
                    local GuiService = require(game.ReplicatedStorage.src.Loader).load_client_service(script, "GUIService")
                    GuiService.curse_reroll_ui:toggle()
                end
            })
            _G.UiPg.Button({
                Text = "Craft Items",
                Callback = function()
                    local GuiService = require(game.ReplicatedStorage.src.Loader).load_client_service(script, "GUIService")
                    GuiService.craft_evolve_items_ui:toggle()
                end
            })
            _G.UiPg.Button({
                Text = "Travelling Merchant",
                Callback = function()
                    local GuiService = require(game.ReplicatedStorage.src.Loader).load_client_service(script, "GUIService")
                    GuiService.travelling_merchant_ui:toggle()
                end
            })
            _G.UiPg.Button({
                Text = "Event Shop",
                Callback = function()
                    local GuiService = require(game.ReplicatedStorage.src.Loader).load_client_service(script, "GUIService")
                    GuiService.event_shop:toggle()
                end
            })
        end

    -- STATISTICS

        StPg.Toggle({
            Text = "Save Statistics",
            Callback = function(v)
                _G.Config.SaveStatistics = v
                SaveConfig()
            end,
            Enabled = _G.Config.SaveStatistics
        })
        StPg.Button({
            Text = "Clear Statistics",
            Callback = function()
                for k, v in pairs(_G.Config.Stats) do
                    _G.Config.Stats[k] = 0
                end
                SaveConfig()
            end
        })

        local Labels = {}
        for k, v in pairs(_G.Config.Stats) do
            Labels[k] = StPg.Label({
                Text = k .. ": " .. _G.Config.Stats[k]
            })
        end

    -- MISC

        local CapsuleSelected = ""
        _G.OpenCapsules = false
        _G.SelectingHubKey = false
        _G.BlockedKeys = {"W", "A", "S", "D", "Space"}

        if InLobby() then
            MiscPg.Button({
                Text = "Rejoin",
                Callback = function()
                    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
                end
            })
        end
        if InGame() then
            MiscPg.Button({
                Text = "Return to Lobby",
                Callback = function()
                    game:GetService('TeleportService'):Teleport(8304191830, game.Players.LocalPlayer)
                end
            })
            MiscPg.Button({
                Text = "Legit Panel",
                Callback = function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/KamaadiN/Projects/main/AALP.lua"))()
                end
            })
        end
        
        _G.HubKeyBTN = MiscPg.Button({
            Text = "Hub Keybind",
            Callback = function(v)
                if not _G.SelectingHubKey then
                    _G.SelectingHubKey = true
                end
            end
        })
        MiscPg.Toggle({
            Text = "Silent Execute",
            Callback = function(v)
                _G.Config.SilentExec = v
                SaveConfig()
            end,
            Enabled = _G.Config.SilentExec
        })
        MiscPg.Toggle({
            Text = "Auto Replay",
            Callback = function(v)
                _G.Config.Replay = v
                SaveConfig()
            end,
            Enabled = _G.Config.Replay
        })
        MiscPg.Toggle({
            Text = "Fast Quit",
            Callback = function(v)
                _G.Config.FastQuit = v
                SaveConfig()
            end,
            Enabled = _G.Config.FastQuit
        })
        MiscPg.Slider({
            Text = "Wave To Fast Quit",
            Callback = function(v)
                _G.Config.WaveToQuit = v
                SaveConfig()
            end,
            Min = 5,
            Max = 100,
            Def = _G.Config.WaveToQuit
        })
        
        if InLobby() then
            MiscPg.Toggle({
                Text = "Auto Summon",
                Callback = function(v)
                    _G.Config.AutoSummon = v
                    SaveConfig()
                end,
                Enabled = _G.Config.AutoSummon
            })
            MiscPg.TextField({
                Text = "Search Unit",
                Callback = function(v)
                    _G.UnitsToGetDD:SetOptions(Search("allgameunits", v))
                end
            })
            _G.UnitsToGetDD = MiscPg.Dropdown({
                Text = "Units to Get",
                Callback = function(op)
                    if not table.find(_G.Config.UnitsToGet, op) then
                        table.insert(_G.Config.UnitsToGet, op)
                    else
                        table.remove(_G.Config.UnitsToGet, table.find(_G.Config.UnitsToGet, op))
                    end
                    SaveConfig()
                end,
                Options = GetUnitsID("allgameunits")
            })
            local BannerDD = MiscPg.Dropdown({
                Text = "Select Banner",
                Callback = function(op)
                    _G.Config.Banner = op
                    SaveConfig()
                end,
                Options = {"Standard", "EventClover"}
            })
            local SummonWithDD = MiscPg.Dropdown({
                Text = "Summon With",
                Callback = function(op)
                    _G.Config.SummonWith = op
                    SaveConfig()
                end,
                Options = {"gems", "gems10", "ticket"}
            })
            local RaritiesDD = MiscPg.Dropdown({
                Text = "Rarities To Sell",
                Callback = function(op)
                    if not table.find(_G.Config.RaritiesToSell, op) then
                        table.insert(_G.Config.RaritiesToSell, op)
                    else
                        table.remove(_G.Config.RaritiesToSell, table.find(_G.Config.RaritiesToSell, op))
                    end
                    SaveConfig()
                end,
                Options = {"Rare", "Epic", "Legendary", "Mythic"}
            })
        end

        MiscPg.Toggle({
            Text = "Buy Item",
            Callback = function(v)
                _G.Config.BuyItem = v
                SaveConfig()
            end,
            Enabled = _G.Config.BuyItem
        })
        MiscPg.TextField({
            Text = "Search Item",
            Callback = function(v)
                _G.ItemsDD:SetOptions(Search("itemsforsale", v))
            end
        })
        _G.ItemsDD = MiscPg.Dropdown({
            Text = "Select Items to Buy",
            Callback = function(op)
                local itemId = string.split(op, " ")[#string.split(op, " ")]
                if not table.find(_G.Config.ItemsToBuy, itemId) then
                    table.insert(_G.Config.ItemsToBuy, itemId)
                else
                    table.remove(_G.Config.ItemsToBuy, table.find(_G.Config.ItemsToBuy, itemId))
                end
                SaveConfig()
            end,
            Options = GetItemsForSale()
        })
        MiscPg.Button({
            Text = "Reset Items",
            Callback = function()
                _G.Config.ItemsToBuy = {}
                SaveConfig()
            end
        })

        if InLobby() then
            MiscPg.Toggle({
                Text = "Auto Open Capsules",
                Callback = function(v)
                    _G.OpenCapsules = v
                end,
                Enabled = false
            })
            _G.CapsulesDD = MiscPg.Dropdown({
                Text = "Select Capsule",
                Callback = function(op)
                    if op == CapsuleSelected then
                        CapsuleSelected = ""
                    else
                        CapsuleSelected = GetCapsuleID(op)
                    end
                end,
                Options = GetCapsules()
            })
        end
        
        MiscPg.Toggle({
            Text = "Auto Accept Secret Quest",
            Callback = function(v)
                _G.Config.AcceptQuest = v
                SaveConfig()
            end,
            Enabled = _G.Config.AcceptQuest
        })
        MiscPg.Toggle({
            Text = "Auto Claim Daily Rewards",
            Callback = function(v)
                _G.Config.DailyRewards = v
                SaveConfig()
            end,
            Enabled = _G.Config.DailyRewards
        })
        MiscPg.Toggle({
            Text = "Auto Redeem Quests",
            Callback = function(v)
                _G.Config.RedeemQuests = v
                SaveConfig()
            end,
            Enabled = _G.Config.RedeemQuests
        })
        MiscPg.Toggle({
            Text = "Hide Leaderboard",
            Callback = function(v)
                _G.Config.HideLeaderboard = v
                SaveConfig()
            end,
            Enabled = _G.Config.HideLeaderboard
        })
        MiscPg.Toggle({
            Text = "Hide Name",
            Callback = function(v)
                _G.Config.HideName = v
                SaveConfig()
            end,
            Enabled = _G.Config.HideName
        })

        if InLobby() then
            MiscPg.Button({
                Text = "Redeem All Codes",
                Callback = function()
                    for i, v in pairs(Data.Codes()) do
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.redeem_code:InvokeServer(v)
                    end
                end
            })
        end

    -- MAIN FUNCTIONS

        task.spawn(HideName)

        if InLobby() then

            task.spawn(SaveCollection)

            local CheckedMode = false
            local CheckedMission = false
            local ClaimedMission = false
            local ChallengeSent = false
            local RaidSent = false

            local function BuyItem()
                if _G.Config.BuyItem then
                    if game:GetService("Workspace")["travelling_merchant"]["is_open"].Value == true then
                        for _, v in pairs(game:GetService("Workspace")["travelling_merchant"].stand.items:GetChildren()) do
                            itemName = string.gsub(v.Name, "%d", "")
                            if table.find(_G.Config.ItemsToBuy, itemName) then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_travelling_merchant_item:InvokeServer(v.Name)
                                task.wait(1)
                                if _G.Config.Notify["Purchased Items"] then
                                    local Data = {
                                        ["username"] = "Mazter Notifier",
                                        ["avatar_url"] = "https://i.imgur.com/C3ANp9d.jpg",
                                        ["content"] = "",
                                        ["embeds"] = {{
                                            ["title"] = "Purchased Item",
                                            ["description"] = "<a:yellowsino_ILD:748565200499638353> ".. GetItem("name", itemName),
                                            ["type"] = "rich",
                                            ["color"] = tonumber(0xedce00)
                                        }}
                                    }
                                    SendWebhook(Data, _G.Config.Mention)
                                end
                            end
                        end
                    end
                end
            end
            local function OpenCapsules()
                while wait() do
                    pcall(function()
                        if _G.OpenCapsules then
                            if CapsuleSelected ~= "" then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.use_item:InvokeServer(CapsuleSelected)
                            end
                        end
                    end)
                end
            end
            
            local function CheckSummons()
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                    if v:IsA("SurfaceGui") and v:FindFirstChild("Main") then
                        local UnitsFound = 0
                        for i = 1, 6 do
                            for _, v2 in pairs(v.Main.Scroll[i].Main.petimage.WorldModel:GetChildren()) do
                                if table.find(_G.Config.UnitsToGet, v2.Name) then
                                    UnitsFound += 1
                                end
                            end
                        end
                        if UnitsFound > 0 and _G.Config.AutoSummon then
                            _G.Config.Summoning = true else
                            _G.Config.Summoning = false
                        end
                    end
                end
            end
            local function AutoSummon()
                if _G.Config.AutoSummon and (_G.Config.Banner == "Standard" and _G.Config.Summoning or _G.Config.Banner == "EventClover") then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_from_banner:InvokeServer(_G.Config.Banner, _G.Config.SummonWith)
                end
            end
            
            local function DailyRewards()
                if _G.Config.DailyRewards then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.claim_daily_reward:InvokeServer()
                end
            end
            local function RedeemQuests()
                if _G.Config.RedeemQuests or _G.Config.Mission.Enabled then
                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestsUI") then
                        for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content:GetDescendants()) do
                            if v:IsA("Frame") and v.Name ~= "Empty" and v.Parent.Name == "Scroll" then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.redeem_quest:InvokeServer(v.Name)
                            end
                        end
                    end
                end
            end
            local function AcceptQuest()
                if _G.Config.AcceptQuest then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.accept_npc_quest:InvokeServer("jjk_daily")
                end
            end

            local function HaveMission(option)
                if option == "claimed" then
                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestsUI") then
                        local scroll = game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.event.Scroll
                        local missions = 0
                        if scroll:FindFirstChild("Empty") then
                            return false
                        else
                            for _, v in pairs(scroll:GetChildren()) do
                                if v:IsA("Frame") then
                                    if table.find(AllMissions(), v.event.Text) then
                                        missions += 1
                                    end
                                end
                            end
                            if missions >= 1 then
                                return true
                            else
                                return false
                            end
                        end
                    end
                elseif option == "available" then
                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MissionUI") then
                        local scroll = game:GetService("Players").LocalPlayer.PlayerGui.MissionUI.Main.Main.Main.Content.main.Scroll
                        if scroll:FindFirstChild("Empty") then
                            return false
                        else
                            return true
                        end
                    end
                end
            end
            local function CheckMission()
                if HaveMission("claimed") then
                    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestsUI") then
                        local scroll = game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.event.Scroll
                        for _, v in pairs(scroll:GetChildren()) do
                            if v:IsA("Frame") then
                                if table.find(AllMissions(), v:WaitForChild("event").Text) then
                                    _G.Config.Mission.ID = GetMission("id", v.event.Text)
                                    _G.Config.Mission.Name = GetMission("name", GetMission("id", v.event.Text))
                                    _G.Config.Mission.Desc = GetMission("desc", GetMission("id", v.event.Text))
                                    _G.Config.Mission.Level = GetMission("level", GetMission("id", v.event.Text))
                                    SaveConfig()
                                    CheckedMission = true
                                    return
                                end
                            end
                        end
                    end
                end
            end
            local function ClaimMission()
                if not HaveMission("claimed") then
                    local missions = game:GetService("Players").LocalPlayer.PlayerGui.MissionUI.Main.Main.Main.Content.main.Scroll
                    for _, v in pairs(missions:GetChildren()) do
                        if not ClaimedMission then
                            if v:IsA("Frame") and v:FindFirstChild("event") then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.request_claim_mission:InvokeServer(string.gsub(GetMission("id", v.event.Text), "__quest", ""))
                                ClaimedMission = true
                            end
                        end
                    end
                end
            end

            local function CheckMode()
                if _G.Config.Raid.Lobby == "" and _G.Config.Chg.Lobby == "" and not CheckedMode then task.wait(1) end

                local RaidMap = game:GetService("Workspace")["_RAID"].Raid:FindFirstChildWhichIsA("Model").Level.Value
                local RaidState = game:GetService("Workspace")["_RAID"].shell.Barrier.Part.Surface.TextLabel.Text

                local ChallengeMap = string.split(game:GetService("Workspace")["_CHALLENGES"].Challenges:FindFirstChildWhichIsA("Model").Level.Value, "_")[1]
                local CurrentChg = game:GetService("Workspace")["_CHALLENGES"].Challenges:FindFirstChildWhichIsA("Model").Challenge.Value
                local ChallengeReward = game:GetService("Workspace")["_CHALLENGES"].Challenges:FindFirstChildWhichIsA("Model").Reward.Value

                local ChristmasMap = string.split(game:GetService("Workspace")["_EVENT_CHALLENGES"].Lobbies:FindFirstChildWhichIsA("Model").Level.Value, "_")[1]
                local ChristmasChg = game:GetService("Workspace")["_EVENT_CHALLENGES"].Lobbies:FindFirstChildWhichIsA("Model").Challenge.Value

                if _G.Config.Mission.Enabled and not HaveMission("available") and HaveMission("claimed") or _G.Config.Mission.Enabled and HaveMission("available") then
                    _G.Config.IsA = "Mission"
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.Raid.Enabled and table.find(_G.Config.Raid.MapsFilter, RaidMap) and string.match(RaidState, "CLOSES") then
                    _G.Config.IsA = "Raid"
                    _G.Config.Raid.Map = RaidMap
                    if not CheckedMode then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.buy_raid_ticket:InvokeServer()
                    end
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.Chg.Enabled and
                not table.find(_G.Config.Chg.BlockedMaps, ChallengeMap) and 
                not table.find(_G.Config.Chg.BlockedChgs, CurrentChg) and 
                table.find(_G.Config.Chg.RewardsFilter, ChallengeReward) then
                    local gui = GetChallengeGui()
                    if gui.ChallengeCleared.Visible == false then
                        _G.Config.IsA = "Chg"
                        _G.Config.Chg.Map = ChallengeMap
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.CursedWomb.Enabled and HasItem("sukuna_finger", "<", 19) and HasItem("key_jjk_finger", ">", 1) then
                        _G.Config.IsA = "CursedWomb"
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.ChristmasChg.Enabled and
                    not table.find(_G.Config.ChristmasChg.BlockedMaps, ChristmasMap) and
                    not table.find(_G.Config.ChristmasChg.BlockedChgs, ChristmasChg) then
                        _G.Config.IsA = "ChristmasChg"
                        _G.Config.ChristmasChg.Map = ChristmasMap
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.LegendStage.Enabled then
                        _G.Config.IsA = "LegendStage"
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.InfCastle.Enabled then
                        _G.Config.IsA = "InfCastle"
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.Inf.Enabled then
                        _G.Config.IsA = "Inf"
                        CheckedMode = true
                        SaveConfig()
                    elseif _G.Config.Story.Enabled then
                        _G.Config.IsA = "Story"
                        CheckedMode = true
                        SaveConfig()
                    end
                elseif _G.Config.CursedWomb.Enabled and HasItem("sukuna_finger", "<", 19) and HasItem("key_jjk_finger", ">", 1) then
                    _G.Config.IsA = "CursedWomb"
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.ChristmasChg.Enabled and
                not table.find(_G.Config.ChristmasChg.BlockedMaps, ChristmasMap) and
                not table.find(_G.Config.ChristmasChg.BlockedChgs, ChristmasChg) then
                    _G.Config.IsA = "ChristmasChg"
                    _G.Config.ChristmasChg.Map = ChristmasMap
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.LegendStage.Enabled then
                    _G.Config.IsA = "LegendStage"
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.InfCastle.Enabled then
                    _G.Config.IsA = "InfCastle"
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.Story.Enabled then
                    _G.Config.IsA = "Story"
                    CheckedMode = true
                    SaveConfig()
                elseif _G.Config.Inf.Enabled then
                    _G.Config.IsA = "Inf"
                    CheckedMode = true
                    SaveConfig()
                end
            end
            local function CheckLobby(mode)
                if mode == "Chg" then
                    if _G.Config.Chg.Lobby ~= "" then
                        local plrAmount = 0
                        for i, v in pairs(game:GetService("Workspace")["_CHALLENGES"].Challenges[_G.Config.Chg.Lobby]["Players"]:GetChildren()) do
                            plrAmount += 1
                        end
                        if plrAmount > 1 then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer(_G.Config.Chg.Lobby)
                            _G.Config.Chg.Lobby = ""
                        end
                    end
                elseif mode == "ChristmasChg" then
                    if _G.Config.ChristmasChg.Lobby ~= "" then
                        local plrAmount = 0
                        for i, v in pairs(game:GetService("Workspace")["_EVENT_CHALLENGES"].Lobbies[_G.Config.ChristmasChg.Lobby]["Players"]:GetChildren()) do
                            plrAmount += 1
                        end
                        if plrAmount > 1 then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer(_G.Config.ChristmasChg.Lobby)
                            _G.Config.ChristmasChg.Lobby = ""
                        end
                    end
                elseif mode == "Raid" then
                    local plrAmount = 0
                    for i, v in pairs(game:GetService("Workspace")["_RAID"].Raid[_G.Config.Raid.Lobby].Players:GetChildren()) do
                        plrAmount += 1
                    end
                    if plrAmount > 1 then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer(_G.Config.Raid.Lobby)
                        _G.Config.Raid.Lobby = ""
                    end
                elseif mode == "CursedWomb" then
                    local plrAmount = 0
                    for i, v in pairs(game:GetService("Workspace")["_DUNGEONS"].Lobbies["_lobbytemplate_event229"].Players:GetChildren()) do
                        plrAmount += 1
                    end
                    if plrAmount > 1 then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_leave_lobby:InvokeServer("_lobbytemplate_event229")
                        wait()
                        ServerHop(game.PlaceId)
                    end
                end
            end

            local function Join(mode)
                pcall(function()
                    if mode == "Story" or mode == "Inf" or mode == "Mission" or mode == "LegendStage" then
                        for _, v in pairs(game:GetService("Workspace")["_LOBBIES"].Story:GetChildren()) do
                            if v["Players"] and not v["Players"]:FindFirstChild("Value") then
                                _G.Config.GlobalLobby = v.Name
                            end
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(_G.Config.GlobalLobby)
                    elseif mode == "Chg" then
                        for _, v in pairs(game:GetService("Workspace")["_CHALLENGES"].Challenges:GetChildren()) do
                            if _G.Config.Chg.Lobby ~= "" then break end
                            if not v["Players"]:FindFirstChild("Value") then
                                _G.Config.Chg.Lobby = v.Name
                            end
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(_G.Config.Chg.Lobby)
                    elseif mode == "ChristmasChg" then
                        for _, v in pairs(game:GetService("Workspace")["_EVENT_CHALLENGES"].Lobbies:GetChildren()) do
                            if _G.Config.ChristmasChg.Lobby ~= "" then break end
                            if not v["Players"]:FindFirstChild("Value") then
                                _G.Config.ChristmasChg.Lobby = v.Name
                            end
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(_G.Config.ChristmasChg.Lobby)
                    elseif mode == "Raid" then
                        for _, v in pairs(game:GetService("Workspace")["_RAID"].Raid:GetChildren()) do
                            if _G.Config.Raid.Lobby ~= "" then break end
                            if not v["Players"]:FindFirstChild("Value") then
                                _G.Config.Raid.Lobby = v.Name
                            end
                        end
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer(_G.Config.Raid.Lobby)
                    elseif mode == "InfCastle" then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_infinite_tower:InvokeServer(_G.Config.InfCastle.Room)
                    elseif mode == "CursedWomb" then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_join_lobby:InvokeServer("_lobbytemplate_event229", {["selected_key"] = "key_jjk_finger"})
                    end
                end)
            end
            local function Create(mode)
                pcall(function()
                    if mode == "Story" then
                        local level = _G.Config.Story.Level
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(_G.Config.GlobalLobby, level, true, _G.Config.Story.Difficulty)
                    elseif mode == "Inf" then
                        local level = _G.Config.Inf.Map .."_infinite"
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(_G.Config.GlobalLobby, level, true, "Hard")
                    elseif mode == "Mission" then
                        if string.match(_G.Config.Mission.Level, "level") then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(_G.Config.GlobalLobby, _G.Config.Mission.Level, true, "Normal")
                        elseif string.match(_G.Config.Mission.Level, "infinite") then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(_G.Config.GlobalLobby, _G.Config.Mission.Level, true, "Hard")
                        end
                    elseif mode == "LegendStage" then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_lock_level:InvokeServer(_G.Config.GlobalLobby, _G.Config[mode].Level, true, "Hard")
                    end
                end)
            end
            local function Notifier()
                pcall(function()
                    if _G.Config.WebhookURL ~= "" then
                        -- CHALLENGE
                            local levels = require(game.ReplicatedStorage.src.Loader).load_data(script, "Levels")
                            local worlds = require(game.ReplicatedStorage.src.Loader).load_data(script, "Worlds")
                            local chg = require(game.ReplicatedStorage.src.Loader).load_data(script, "ChallengeAndRewards")

                            local ChallengeInfos = {
                                id = game:GetService("Workspace")["_LOBBIES"]["_DATA"]["_CHALLENGE"]["current_level_id"].Value,
                                type = game:GetService("Workspace")["_LOBBIES"]["_DATA"]["_CHALLENGE"]["current_challenge"].Value,
                                reward = game:GetService("Workspace")["_LOBBIES"]["_DATA"]["_CHALLENGE"]["current_reward"].Value
                            }
                            local ChallengeData = {
                                ["username"] = "Mazter Notifier",
                                ["avatar_url"] = "https://i.imgur.com/EOXGvcs.jpg",
                                ["content"] = "",
                                ["embeds"] = {{
                                    ["title"] = "Challenge",
                                    ["description"] = worlds[levels[ChallengeInfos.id]["world"]]["name"],
                                    ["type"] = "rich",
                                    ["color"] = tonumber(0xea00ff),
                                    ["fields"] = {
                                        {
                                            ["name"] = "Level:",
                                            ["value"] = levels[ChallengeInfos.id]["name"]
                                        },
                                        {
                                            ["name"] = "Challenge:",
                                            ["value"] = chg["challenges"][ChallengeInfos.type]["name"],
                                            ["inline"] = true
                                        },
                                        {
                                            ["name"] = "Reward:",
                                            ["value"] = chg["rewards"][ChallengeInfos.reward]["name"],
                                            ["inline"] = true
                                        }
                                    }
                                }}
                            }
                        
                        -- RAID
                            str = game:GetService("Workspace")["_RAID"].shell.Barrier.Part.Surface.TextLabel.Text
                            time = string.split(string.match(str, "%d+:%d+:%d+"), ":", "")
                            local RaidInfos = {
                                state = game:GetService("Workspace")["_LOBBIES"]["_DATA"]["raid_open"].Value,
                                remaining_time = time[1] .. "h " .. time[2] .. "min " .. time[3] .. "s",
                                id = game:GetService("Workspace")["_LOBBIES"]["_DATA"]["current_active_raid"].Value
                            }
                            local RaidData = {}
                            if RaidInfos.state == true then
                                RaidData = {
                                    ["username"] = "Mazter Notifier",
                                    ["avatar_url"] = "https://i.imgur.com/QgsxrlO.jpg",
                                    ["content"] = "",
                                    ["embeds"] = {{
                                        ["title"] = "Raid is Open",
                                        ["description"] = levels[RaidInfos.id]["name"],
                                        ["type"] = "rich",
                                        ["color"] = tonumber(0x11ff00),
                                        ["fields"] = {
                                            {
                                                ["name"] = "Closes in:",
                                                ["value"] = RaidInfos.remaining_time,
                                                ["inline"] = true
                                            }
                                        }
                                    }}
                                } else
                                RaidData = {
                                    ["username"] = "Mazter Notifier",
                                    ["avatar_url"] = "https://i.imgur.com/U69kBlB.jpg",
                                    ["content"] = "",
                                    ["embeds"] = {{
                                        ["title"] = "Raid is Closed",
                                        ["type"] = "rich",
                                        ["color"] = tonumber(0xff0000),
                                        ["fields"] = {
                                            {
                                                ["name"] = "Opens in:",
                                                ["value"] = RaidInfos.remaining_time,
                                                ["inline"] = true
                                            }
                                        }
                                    }}
                                }
                            end

                        if _G.Config.Notify.Challenge and not ChallengeSent then
                            SendWebhook(ChallengeData, _G.Config.Mention)
                            ChallengeSent = true
                        end
                        if _G.Config.Notify.Raid and not RaidSent then
                            SendWebhook(RaidData, _G.Config.Mention)
                            RaidSent = true
                        end
                    end
                end)
            end
            local function StartTP()
                pcall(function()
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.request_start_game:InvokeServer(_G.Config.GlobalLobby)
                end)
            end

            task.spawn(OpenCapsules)

            spawn(function()
                while wait() do
                    pcall(function()
                        CheckSummons()
                        AutoSummon()
                    end)
                end
            end)
            spawn(function()
                while wait() do
                    pcall(function()
                        BuyItem()
                        DailyRewards()
                        AcceptQuest()
                        RemoveErrors()
                    end)
                end
            end)
            spawn(function()
                while wait() do
                    pcall(function()
                        RedeemQuests()
                    end)
                end
            end)
            spawn(function()
                while wait() do
                    pcall(function()
                        CheckMode()
                        CheckRoom()
                        if not _G.Config.Summoning then
                            if _G.Config.Story.Enabled and _G.Config.IsA == "Story" or _G.Config.Inf.Enabled and _G.Config.IsA == "Inf" or _G.Config.LegendStage.Enabled and _G.Config.IsA == "LegendStage" then
                                Join(_G.Config.IsA)
                                task.wait(1)
                                Create(_G.Config.IsA)
                                task.wait(1)
                                Notifier()
                                task.wait(2)
                                StartTP()
                                task.wait(15)
                            elseif _G.Config.Chg.Enabled and _G.Config.IsA == "Chg" or _G.Config.Raid.Enabled and _G.Config.IsA == "Raid" or 
                            _G.Config.CursedWomb.Enabled and _G.Config.IsA == "CursedWomb" or 
                            _G.Config.ChristmasChg.Enabled and _G.Config.IsA == "ChristmasChg" then
                                Join(_G.Config.IsA)
                                CheckLobby(_G.Config.IsA)
                            elseif _G.Config.InfCastle.Enabled and _G.Config.IsA == "InfCastle" then
                                Join(_G.Config.IsA)
                                task.wait(10)
                            elseif _G.Config.Mission.Enabled and _G.Config.IsA == "Mission" then
                                CheckMission()
                                ClaimMission()
                                if CheckedMission then
                                    Join(_G.Config.IsA)
                                    task.wait()
                                    Create(_G.Config.IsA)
                                    task.wait(1)
                                    Notifier()
                                    task.wait(2)
                                    StartTP()
                                    task.wait(15)
                                end
                            end
                        end
                    end)
                end
            end)
            
        elseif InGame() then

            local SavedStatistics = false
            local NotifySent = false
            local CheckedMap = false
            _G.ObtainedItems = {}

            function HasPlaced(Unit)
                if UnitsPlaced(Unit) == GetSpawnCap(Unit) then
                    return true
                else
                    return false
                end
            end
            function PlaceToLoc(UnitID, Location)
                game:GetService("ReplicatedStorage").endpoints.client_to_server.spawn_unit:InvokeServer(UnitID, Location)
            end
            function UnitCFrames(CFrame, UnitAmount, Queue, OtherMultiplier)
                local table = {}
                local multiplier = 0
                if Queue == "x" then
                    for i = 1, UnitAmount do
                        table[i] = CFrame + Vector3.new((0.85 * multiplier), 0, (0.85 * OtherMultiplier))
                        multiplier = multiplier + 1
                    end
                elseif Queue == "z" then
                    for i = 1, UnitAmount do
                        table[i] = CFrame + Vector3.new((0.85 * OtherMultiplier), 0, (0.85 * multiplier))
                        multiplier = multiplier + 1
                    end
                elseif Queue == "money" then
                    for i = 1, UnitAmount do
                        table[i] = CFrame + Vector3.new(0, (5 * multiplier), 0)
                        multiplier = multiplier + 1
                    end
                end
                return table
            end
            function UnitPos(map, unit, pos)
                local UnitPos = {
                    ["jojo_legend"] = {
                        u1 = UnitCFrames(CFrame.new(-119, 50.25, -555), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 4)
                    },
                    ["jojo"] = {
                        u1 = UnitCFrames(CFrame.new(-119, 50.25, -555), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-119, 15.25, -555), 6, "z", 4)
                    },
                    ["bleach_legend"] = {
                        u1 = UnitCFrames(CFrame.new(-200.9, 110, 522.9), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-200.9, 36, 522.9), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-200.9, 36, 522.9), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-200.9, 36, 522.9), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-200.9, 36, 522.9), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-200.9, 36, 522.9), 6, "z", 4)
                    },
                    ["clover_legend"] = {
                        u1 = UnitCFrames(CFrame.new(-176.3, 44, -8.3), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-182.3, 1.24, -1.7), 6, "z", 0),
                        u4 = UnitCFrames(CFrame.new(-97.5, 1.24, -44.9), 6, "z", 0),
                        u5 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 1),
                        u6 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 2)
                    },
                    ["clover"] = {
                        u1 = UnitCFrames(CFrame.new(-176.3, 44, -8.3), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-140.3, 1.24, -44.6), 6, "z", 4)
                    },
                    ["thriller_bark"] = {
                        u1 = UnitCFrames(CFrame.new(-206, 125.16, -649.4), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-184, 109.4, -613), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-184, 109.4, -613), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-184, 109.4, -613), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-184, 109.4, -613), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-184, 109.4, -613), 6, "x", 4)
                    },
                    ["jjk"] = {
                        u1 = UnitCFrames(CFrame.new(378.5, 146, -78.5), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(364, 122, -87), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(364, 122, -87), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(364, 122, -87), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(364, 122, -87), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(364, 122, -87), 6, "z", 4)
                    },
                    ["magnolia"] = {
                        u1 = UnitCFrames(CFrame.new(-598, 22.5, -830.3), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-604, 7, -830), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-604, 7, -830), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-604, 7, -830), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-604, 7, -830), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-604, 7, -830), 6, "z", 4)
                    },
                    ["hxhant"] = {
                        u1 = UnitCFrames(CFrame.new(-166, 23, 2939), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-162, 23, 2953), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-162, 23, 2953), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-162, 23, 2953), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-162, 23, 2953), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-162, 23, 2953), 6, "x", 4)
                    },
                    ["hueco"] = {
                        u1 = UnitCFrames(CFrame.new(-154, 133, -725.65), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-188, 133, -761), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-188, 133, -761), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-188, 133, -761), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-188, 133, -761), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-188, 133, -761), 6, "z", 4)
                    },
                    ["tokyoghoul"] = {
                        u1 = UnitCFrames(CFrame.new(-3022.8, 58.5, -48.6), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-3000, 58.5, -48), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-3000, 58.5, -48), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-3000, 58.5, -48), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-3000, 58.5, -48), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-3000, 58.5, -48), 6, "x", 4)
                    },
                    ["marineford"] = {
                        u1 = UnitCFrames(CFrame.new(-2590, 34.5, -37), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-2553, 25.2, -38), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-2553, 25.2, -38), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-2553, 25.2, -38), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-2553, 25.2, -38), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-2553, 25.2, -38), 6, "x", 4)
                    },
                    ["naruto"] = {
                        u1 = UnitCFrames(CFrame.new(-878.5, 32, 328), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 4)
                    },
                    ["demonslayer"] = {
                        u1 = UnitCFrames(CFrame.new(-2971.5, 42.45, -170.8), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-2870, 34.3, -124), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-2870, 34.3, -124), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-2870, 34.3, -124), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-2870, 34.3, -124), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-2870, 34.3, -124), 6, "x", 4)
                    },
                    ["aot"] = {
                        u1 = UnitCFrames(CFrame.new(-2981, 42, -692), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 4)
                    },
                    ["namek"] = {
                        u1 = UnitCFrames(CFrame.new(-2926, 94.4, -750.3), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-2961, 91.8, -721), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-2961, 91.8, -721), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-2961, 91.8, -721), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-2961, 91.8, -721), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-2961, 91.8, -721), 6, "x", 4)
                    },
                    ["west_city_raid"] = {
                        u1 = UnitCFrames(CFrame.new(-2359, 40, -85), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-2359, 19.75, -85.8), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-2359, 19.75, -85.8), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-2359, 19.75, -85.8), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-2359, 19.75, -85.8), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-2359, 19.75, -85.8), 6, "z", 4)
                    },
                    ["demonslayer_raid"] = {
                        u1 = UnitCFrames(CFrame.new(86, -7, 318.8), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(35, -15, 325), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(35, -15, 325), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(35, -15, 325), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(35, -15, 325), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(35, -15, 325), 6, "z", 4)
                    },
                    ["naruto_raid"] = {
                        u1 = UnitCFrames(CFrame.new(-878.5, 32, 328), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 0),
                        u3 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 1),
                        u4 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 2),
                        u5 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 3),
                        u6 = UnitCFrames(CFrame.new(-894, 25.3, 312), 6, "x", 4)
                    },
                    ["aot_raid"] = {
                        u1 = UnitCFrames(CFrame.new(-2981, 42, -692), 3, "money"),
                        u2 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 0),
                        u3 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 1),
                        u4 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 2),
                        u5 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 3),
                        u6 = UnitCFrames(CFrame.new(-3014, 33.75, -682), 6, "z", 4)
                    }
                }
                return UnitPos[map][unit][pos]
            end

            function CheckMap(mode)
                local leveldata = game:GetService("Workspace")["_MAP_CONFIG"].GetLevelData:InvokeServer()
                local worlds = require(game:GetService("ReplicatedStorage").src.Data.Worlds)
                local levelid = worlds[leveldata["world"]].infinite["id"]
                local mapid = string.split(levelid, "_")[1]
                _G.Config[mode].Map = mapid
                CheckedMap = true
            end
            function StartGame()
                if game:GetService("Workspace")["_wave_num"].Value < 1 then
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
                end
            end
            function PlaceUnits(option)
                local wave = game:GetService("Workspace"):WaitForChild("_wave_num").Value
                if option == "Inf" then

                    local UnitID = {
                        string.split(_G.Config.Inf.Units["u1"], " "),
                        string.split(_G.Config.Inf.Units["u2"], " "),
                        string.split(_G.Config.Inf.Units["u3"], " "),
                        string.split(_G.Config.Inf.Units["u4"], " "),
                        string.split(_G.Config.Inf.Units["u5"], " "),
                        string.split(_G.Config.Inf.Units["u6"], " ")
                    }

                    if wave < _G.Config[option].WaveToLose and #UnitID[1] == 3 then
                        for i = 1, GetSpawnCap(UnitID[1][1]) do
                            PlaceToLoc(UnitID[1][3], UnitPos(_G.Config[option].Map, "u1", i))
                        end
                    end
                    if wave < _G.Config[option].WaveToLose and #UnitID[2] == 3 then
                        for i = 1, 6 do
                            PlaceToLoc(UnitID[2][3], UnitPos(_G.Config[option].Map, "u2", i))
                        end
                    end
                    if wave > 3 and wave < _G.Config[option].WaveToLose and #UnitID[3] == 3 then
                        for i = 1, 6 do
                            PlaceToLoc(UnitID[3][3], UnitPos(_G.Config[option].Map, "u3", i))
                        end
                    end
                    if wave > 9 and wave < _G.Config[option].WaveToLose and #UnitID[4] == 3 then
                        for i = 1, 6 do
                            PlaceToLoc(UnitID[4][3], UnitPos(_G.Config[option].Map, "u4", i))
                        end
                    end
                    if wave > 11 and wave < _G.Config[option].WaveToLose and #UnitID[5] == 3 then
                        for i = 1, 6 do
                            PlaceToLoc(UnitID[5][3], UnitPos(_G.Config[option].Map, "u5", i))
                        end
                    end
                    if wave > 15 and wave < _G.Config[option].WaveToLose and #UnitID[6] == 3 then
                        for i = 1, 6 do
                            PlaceToLoc(UnitID[6][3], UnitPos(_G.Config[option].Map, "u6", i))
                        end
                    end
                else
                    if wave < 15 and _G.Config.Story.Units["u1"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u1"], " ")
                        for i = 1, GetSpawnCap(uID[1]) do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u1", i))
                        end
                    end
                    if wave < 15 and _G.Config.Story.Units["u2"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u2"], " ")
                        for i = 1, _G.Config.Story.SpawnCap["u2"] do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u2", i))
                        end
                    end
                    if wave > 4 and wave < 15 and _G.Config.Story.Units["u3"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u3"], " ")
                        for i = 1, _G.Config.Story.SpawnCap["u3"] do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u3", i))
                        end
                    end
                    if wave > 5 and _G.Config.Story.Units["u4"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u4"], " ")
                        for i = 1, _G.Config.Story.SpawnCap["u4"] do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u4", i))
                        end
                    end
                    if wave > 6 and _G.Config.Story.Units["u5"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u5"], " ")
                        for i = 1, _G.Config.Story.SpawnCap["u5"] do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u5", i))
                        end
                    end
                    if wave > 6 and _G.Config.Story.Units["u6"] ~= "" then
                        local uID = string.split(_G.Config.Story.Units["u6"], " ")
                        for i = 1, _G.Config.Story.SpawnCap["u6"] do
                            PlaceToLoc(uID[3], UnitPos(_G.Config[option].Map, "u6", i))
                        end
                    end
                end
            end
            function AutoUpgrade(UpgType, mode)
                local wave = game:GetService("Workspace")["_wave_num"].Value
                pcall(function()
                    if UpgType == "Per Order" then
                        if wave > 4 then
                            if _G.Config[mode].Units["u1"] ~= "" then
                                local UnitID = GetUnit(mode, "u1")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u1", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                            if _G.Config[mode].Units["u2"] ~= "" and _G.Config[mode].Units["u1"] ~= "" and IsUpgraded("u1", mode) and not IsUpgraded("u2", mode) or 
                            _G.Config[mode].Units["u1"] == "" and _G.Config[mode].Units["u2"] ~= "" and not IsUpgraded("u2", mode) then
                                local UnitID = GetUnit(mode, "u2")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u2", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                            if _G.Config[mode].Units["u3"] ~= "" and _G.Config[mode].Units["u2"] ~= "" and IsUpgraded("u2", mode) and not IsUpgraded("u3", mode) or 
                            _G.Config[mode].Units["u2"] == "" and _G.Config[mode].Units["u3"] ~= "" and not IsUpgraded("u3", mode) then
                                local UnitID = GetUnit(mode, "u3")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u3", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                            if _G.Config[mode].Units["u4"] ~= "" and _G.Config[mode].Units["u3"] ~= "" and IsUpgraded("u3", mode) and not IsUpgraded("u4", mode) or 
                            _G.Config[mode].Units["u3"] == "" and _G.Config[mode].Units["u4"] ~= "" and not IsUpgraded("u4", mode) then
                                local UnitID = GetUnit(mode, "u4")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u4", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                            if _G.Config[mode].Units["u5"] ~= "" and _G.Config[mode].Units["u4"] ~= "" and IsUpgraded("u4", mode) and not IsUpgraded("u5", mode) or 
                            _G.Config[mode].Units["u4"] == "" and _G.Config[mode].Units["u5"] ~= "" and not IsUpgraded("u5", mode) then
                                local UnitID = GetUnit(mode, "u5")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u5", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                            if _G.Config[mode].Units["u6"] ~= "" and _G.Config[mode].Units["u5"] ~= "" and IsUpgraded("u5", mode) and not IsUpgraded("u6", mode) or 
                            _G.Config[mode].Units["u5"] == "" and _G.Config[mode].Units["u6"] ~= "" and not IsUpgraded("u6", mode) then
                                local UnitID = GetUnit(mode, "u6")
                                for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                    if v["_stats"].player.Value == game.Players.LocalPlayer then
                                        if string.match(v["_stats"].id.Value, UnitID) and v["_stats"].upgrade.Value < GetUpgrades(UnitID, "u6", mode) then
                                            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                        end
                                    end
                                end
                            end
                        end
                    elseif UpgType == "Random" then
                        if _G.Config[mode].Units["u1"] ~= "" then
                            for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                if tostring(v["_stats"].player.Value) == game.Players.LocalPlayer.Name then
                                    if string.match(v["_stats"].id.Value, "bulma") and wave > 4 or string.match(v["_stats"].id.Value, "speedwagon") and wave > 4 then
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                    elseif wave > 8 then
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                    end
                                end
                            end
                        else
                            for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                                if tostring(v["_stats"].player.Value) == game.Players.LocalPlayer.Name and wave > 4 then
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(v)
                                end
                            end
                        end
                    end
                end)
            end
            function AutoBuff()
                pcall(function()
                    if game:GetService("Workspace")["_wave_num"].Value > 4 then
                        for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                            if tostring(v["_stats"].player.Value) == game.Players.LocalPlayer.Name then
                                if string.match(v["_stats"].id.Value, "erwin") then
                                    if v:FindFirstChild("_stats").upgrade.Value >= 3 and v:FindFirstChild("_buffs")["damage_buff__erwin"].Value == 0 then
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.use_active_attack:InvokeServer(v)
                                    end
                                elseif string.match(v["_stats"].id.Value, "kisuke_evolved") then
                                    if v:FindFirstChild("_stats").upgrade.Value >= 6 and v:FindFirstChild("_buffs")["attack_cooldown_buff"].Value == 0 and v:FindFirstChild("_buffs")["range_buff"].Value == 0 then
                                        game:GetService("ReplicatedStorage").endpoints.client_to_server.use_active_attack:InvokeServer(v)
                                    end
                                elseif string.match(v["_stats"].id.Value, "gojo_evolved") then
                                    game:GetService("ReplicatedStorage").endpoints.client_to_server.use_active_attack:InvokeServer(v)
                                end
                            end
                        end
                    end
                end)
            end
            function AutoSell(mode)
                if mode == "Inf" then
                    if game:GetService("Workspace")["_wave_num"].Value >= _G.Config[mode].WaveToLose then
                        for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                            if tostring(v["_stats"].player.Value) == game.Players.LocalPlayer.Name then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.sell_unit_ingame:InvokeServer(v)
                            end
                        end
                    end
                elseif mode == "Mission" then
                    if game:GetService("Workspace")["_wave_num"].Value >= 25 then
                        for i, v in next, game:GetService("Workspace")["_UNITS"]:GetChildren() do
                            if tostring(v["_stats"].player.Value) == game.Players.LocalPlayer.Name then
                                game:GetService("ReplicatedStorage").endpoints.client_to_server.sell_unit_ingame:InvokeServer(v)
                            end
                        end
                    end
                end
            end
            function Notify()
                if game:GetService("Workspace")["_DATA"].GameFinished.Value == true then
                    if _G.Config.Notify["Game Results"] and not NotifySent or _G.Config.SaveStatistics and not SavedStatistics then
                        task.wait(4)
                        if game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Enabled then
                            pcall(function()
                                local timer = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Middle.Timer.Text
                                local leveldata = game:GetService("Workspace")["_MAP_CONFIG"].GetLevelData:InvokeServer()
                                local Result = {
                                    map = "**Map:** " .. leveldata["_location_name"],
                                    level = "**Level:** " .. leveldata["name"],
                                    gamemode = "**Gamemode:** " .. GetGamemode(leveldata["_gamemode"]),
                                    time = string.match(timer, "%d+") .. "min e " .. string.gsub(string.match(timer, ":%d+"), ":", "") .. "s",
                                    wave = string.match(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Middle.WavesCompleted.Text, "%d+"),
                                    gem = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame.GemReward.Main.Amount.Text,
                                    xp = string.match(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame.XPReward.Main.Amount.Text, "%d+"),
                                    items = table.concat(_G.ObtainedItems, "\n")
                                }
                                if game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame:FindFirstChild("ResourceReward") then
                                    Result.candy = string.match(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame.ResourceReward.Main.Amount.Text, "%d+")
                                else
                                    Result.candy = "99999"
                                end

                                if _G.Config.SaveStatistics and not SavedStatistics then
                                    if tonumber(Result.gem) < 1000 then
                                        _G.Config.Stats["Gems Received"] += tonumber(Result.gem)
                                    end
                                    if tonumber(Result.candy) < 10000 then
                                        _G.Config.Stats["Candies Received"] += tonumber(Result.candy)
                                    end 
                                    if tonumber(Result.xp) < 1000 then
                                        _G.Config.Stats["XP Received"] += tonumber(Result.xp)
                                    end 
                                    _G.Config.Stats["Levels Completed"] += 1
                                    SavedStatistics = true
                                    SaveConfig()
                                end
                                if tonumber(Result.gem) > 1000 then Result.gem = "Not Calculated" end
                                if tonumber(Result.candy) > 10000 then Result.candy = "Not Calculated" end
                                if #_G.ObtainedItems == 0 then Result.items = "None" end

                                local Data = {
                                    ["username"] = "Mazter Notifier",
                                    ["avatar_url"] = "https://i.imgur.com/luWHUeX.png",
                                    ["content"] = "",
                                    ["embeds"] = {{
                                        ["title"] = "Game Results",
                                        ["description"] = Result.map.."\n"..Result.level.."\n"..Result.gamemode,
                                        ["type"] = "rich",
                                        ["color"] = tonumber(0x000000),
                                        ["fields"] = {
                                            {
                                                ["name"] = "Total Time:",
                                                ["value"] = Result.time,
                                                ["inline"] = true
                                            },
                                            {
                                                ["name"] = "Waves Completed:",
                                                ["value"] = Result.wave,
                                                ["inline"] = true
                                            },
                                            {
                                                ["name"] = "Gems Received:",
                                                ["value"] = Result.gem,
                                                ["inline"] = false
                                            },
                                            {
                                                ["name"] = "Candies Received:",
                                                ["value"] = Result.candy,
                                                ["inline"] = true
                                            },
                                            {
                                                ["name"] = "Obtained Items:",
                                                ["value"] = Result.items,
                                                ["inline"] = false
                                            }
                                        }
                                    }}
                                }
                        
                                if _G.Config.WebhookURL ~= "" and _G.Config.Notify["Game Results"] and not NotifySent then
                                    SendWebhook(Data, _G.Config.Mention)
                                    NotifySent = true
                                end
                            end)
                        end
                    end
                end
            end
            function Teleport()
                if game:GetService("Workspace")["_DATA"].GameFinished.Value == true then
                    if _G.Config.Notify["Game Results"] or _G.Config.SaveStatistics then
                        task.wait(7)
                        if _G.Config.Replay then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote:InvokeServer("replay")
                            task.wait(30)
                            game:GetService('TeleportService'):Teleport(8304191830, game.Players.LocalPlayer)
                        else
                            game:GetService("ReplicatedStorage").endpoints["client_to_server"]["teleport_back_to_lobby"]:InvokeServer()
                            task.wait(10)
                        end
                    else
                        task.wait(4)
                        if _G.Config.Replay then
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote:InvokeServer("replay")
                            task.wait(30)
                            game:GetService('TeleportService'):Teleport(8304191830, game.Players.LocalPlayer)
                        else
                            game:GetService("ReplicatedStorage").endpoints["client_to_server"]["teleport_back_to_lobby"]:InvokeServer()
                            task.wait(10)
                        end
                    end
                end
            end
            function FastQuit()
                if _G.Config.FastQuit then
                    local wave = game:GetService("Workspace"):WaitForChild("_wave_num").Value
                    if wave >= _G.Config.WaveToQuit then
                        game:GetService('TeleportService'):Teleport(8304191830, game.Players.LocalPlayer)
                        task.wait(15)
                    end
                end
            end

            spawn(function()
                while wait() do
                    pcall(function()
                        RemoveErrors()
                        if _G.Config.Story.Enabled and _G.Config.IsA == "Story" or 
                        _G.Config.Raid.Enabled and _G.Config.IsA == "Raid" or 
                        _G.Config.CursedWomb.Enabled and _G.Config.IsA == "CursedWomb" or 
                        _G.Config.Chg.Enabled and _G.Config.IsA == "Chg" or
                        _G.Config.ChristmasChg.Enabled and _G.Config.IsA == "ChristmasChg" or 
                        _G.Config.LegendStage.Enabled and _G.Config.IsA == "LegendStage" then
                            StartGame()
                            PlaceUnits(_G.Config.IsA)
                            AutoUpgrade(_G.Config.Story.UpgradeMode, "Story")
                            AutoBuff()
                            Notify()
                            Teleport()
                            FastQuit()
                        elseif _G.Config.Inf.Enabled and _G.Config.IsA == "Inf" then
                            StartGame()
                            PlaceUnits(_G.Config.IsA)
                            AutoUpgrade(_G.Config.Inf.UpgradeMode, "Inf")
                            AutoBuff()
                            AutoSell(_G.Config.IsA)
                            Notify()
                            Teleport()
                            FastQuit()
                        elseif _G.Config.InfCastle.Enabled and _G.Config.IsA == "InfCastle" then
                            CheckRoom()
                            CheckMap(_G.Config.IsA)
                            if CheckedMap then PlaceUnits(_G.Config.IsA) end
                            StartGame()
                            AutoUpgrade(_G.Config.Story.UpgradeMode, "Story")
                            AutoBuff()
                            Notify()
                            Teleport()
                            FastQuit()
                        elseif _G.Config.Mission.Enabled and _G.Config.IsA == "Mission" then
                            StartGame()
                            CheckMap(_G.Config.IsA)
                            if CheckedMap then PlaceUnits(_G.Config.IsA) end
                            if string.match(_G.Config.Mission.Level, "infinite") then AutoUpgrade(_G.Config.Inf.UpgradeMode, "Inf") else AutoUpgrade(_G.Config.Story.UpgradeMode, "Story") end
                            AutoBuff()
                            if string.match(_G.Config.Mission.Level, "infinite") then AutoSell("Mission") end
                            Notify()
                            Teleport()
                            FastQuit()
                        end
                    end)
                end
            end)
        end

    -- MAIN SETTINGS

        if _G.Config.WebhookURL ~= "" then
            WhText:SetText(_G.Config.WebhookURL)
        end
        if _G.Config.DiscordID ~= "" then
            DcText:SetText(_G.Config.DiscordID)
        end

    -- MAIN SERVICES

        game:GetService("RunService").RenderStepped:Connect(function()

            do -- STORY

                pcall(function()
                    if InLobby() then
                        for i = 1, 6 do
                            local unit = string.split(_G.Config.Story.Units["u"..i], " ")[1]
                            if _G.Config.Story.Units["u"..i] ~= "" then
                                _G.StoryUnitDD[i]:SetText(i.." - ".. unit)
                            else
                                _G.StoryUnitDD[i]:SetText(i.." - Empty")
                            end
                        end
                    end
                    if InGame() and _G.StoryUnitDD then
                        pcall(function()
                            for i = 1, 6 do
                                local unit = string.split(_G.Config.Story.Units["u"..i], " ")[1]
                                if _G.Config.Story.Units["u"..i] ~= "" then
                                    _G.StoryUnitDD[i]:SetText(i.." - ".. unit)
                                else
                                    _G.StoryUnitDD[i]:SetText(i.." - Empty")
                                end
                            end
                        end)
                    end
                    _G.StoryMapDD:SetText("Map Selected: " .. GetMap("name", _G.Config.Story.Map))
                    _G.LevelsDD:SetText("Level Selected: " .. GetLevel("name", _G.Config.Story.Level))
                    _G.Difficulty:SetText("Difficulty Selected: " .. _G.Config.Story.Difficulty)
                    StoryUpgDD:SetText("Upgrade Mode: " .. _G.Config.Story.UpgradeMode)
                end)

            end

            do -- INFINITE

                pcall(function()
                    if InLobby() then
                        for i = 1, 6 do
                            local unit = string.split(_G.Config.Inf.Units["u"..i], " ")[1]
                            if _G.Config.Inf.Units["u"..i] ~= "" then
                                _G.InfUnitDD[i]:SetText(i.." - ".. unit)
                            else
                                _G.InfUnitDD[i]:SetText(i.." - Empty")
                            end
                        end
                    end
                    if InGame() and _G.InfUnitDD then
                        pcall(function()
                            for i = 1, 6 do
                                local unit = string.split(_G.Config.Inf.Units["u"..i], " ")[1]
                                if _G.Config.Inf.Units["u"..i] ~= "" then
                                    _G.InfUnitDD[i]:SetText(i.." - ".. unit)
                                else
                                    _G.InfUnitDD[i]:SetText(i.." - Empty")
                                end
                            end
                        end)
                    end
                    MapDD:SetText("Map Selected: " .. GetMap("name", _G.Config.Inf.Map))
                    InfUpgDD:SetText("Upgrade Mode: " .. _G.Config.Inf.UpgradeMode)
                end)

            end

            do -- OTHERS

                pcall(function()
                    if #_G.Config.Raid.MapsFilter > 0 then
                        RaidMapDD:SetText("Maps Filter: " .. table.concat(_G.Config.Raid.MapsFilter, ", ")) else
                        RaidMapDD:SetText("Maps Filter: None")
                    end
                    if #_G.Config.Chg.BlockedMaps > 0 then
                        ChgMapDD:SetText("Blocked Maps: " .. table.concat(_G.Config.Chg.BlockedMaps, ", ")) else
                        ChgMapDD:SetText("Blocked Maps: None")
                    end
                    if #_G.Config.Chg.BlockedChgs > 0 then
                        ChgsDD:SetText("Blocked Challenges: " .. table.concat(_G.Config.Chg.BlockedChgs, ", ")) else
                        ChgsDD:SetText("Blocked Challenges: None")
                    end
                    if #_G.Config.Chg.RewardsFilter > 0 then
                        ChgRwdDD:SetText("Rewards: " .. table.concat(_G.Config.Chg.RewardsFilter, ", ")) else
                        ChgRwdDD:SetText("Rewards Filter")
                    end

                    if #_G.Config.ChristmasChg.BlockedMaps > 0 then
                        ChristmasMapDD:SetText("Blocked Maps: " .. table.concat(_G.Config.ChristmasChg.BlockedMaps, ", ")) else
                        ChristmasMapDD:SetText("Blocked Maps: None")
                    end
                    if #_G.Config.ChristmasChg.BlockedChgs > 0 then
                        ChristmasChgsDD:SetText("Blocked Challenges: " .. table.concat(_G.Config.ChristmasChg.BlockedChgs, ", ")) else
                        ChristmasChgsDD:SetText("Blocked Challenges: None")
                    end

                    RoomLabel.SetText("CURRENT ROOM: ".. GetLastRoom())

                    MissionNameLabel.SetText("NAME: ".. _G.Config.Mission.Name)
                    MissionDescLabel.SetText("DESCRIPTION: ".. _G.Config.Mission.Desc)
                    MissionLevelLabel.SetText("LEVEL: ".. _G.Config.Mission.Level)

                    _G.LegendMapDD:SetText("Map Selected: ".. GetLegend({"name", _G.Config.LegendStage.Map}))
                    _G.LegendLevelDD:SetText("Level Selected: ".. GetLevel("name", _G.Config.LegendStage.Level))
                end)
            end

            do -- STATS

                pcall(function()
                    for k, v in pairs(_G.Config.Stats) do
                        Labels[k].SetText(k .. ": ".. _G.Config.Stats[k])
                    end
                end)

            end

            do -- MISC

                pcall(function()
                    if #_G.Config.UnitsToGet > 0 then
                        _G.UnitsToGetDD:SetText("Units to Get: ".. table.concat(_G.Config.UnitsToGet, ", ")) else
                        _G.UnitsToGetDD:SetText("Select Units to Get")
                    end
                    BannerDD:SetText("Open With Banner: ".. _G.Config.Banner)
                    SummonWithDD:SetText("Summon With: ".. _G.Config.SummonWith)
                    if #_G.Config.RaritiesToSell > 0 then
                        RaritiesDD:SetText("Sell Rarities: " .. table.concat(_G.Config.RaritiesToSell, ", ")) else
                        RaritiesDD:SetText("Rarities to Sell")
                    end

                    if #_G.Config.ItemsToBuy > 0 then
                        _G.ItemsDD:SetText("Items: " .. table.concat(_G.Config.ItemsToBuy, ", ")) else
                        _G.ItemsDD:SetText("Select Items to Buy")
                    end
                    if InLobby() then
                        if CapsuleSelected ~= "" then
                            _G.CapsulesDD:SetText("Capsule Selected: " .. GetCapsuleName(CapsuleSelected))
                        else
                            _G.CapsulesDD:SetText("Select Capsule")
                        end
                    end
                    if not _G.SelectingHubKey then
                        local key = string.gsub(_G.Config.Keybind, "Enum.KeyCode.", "")
                        _G.HubKeyBTN:SetText("Keybind: " .. key) else _G.HubKeyBTN:SetText("Keybind: ...")
                    end
                end)

            end

        end)
        game:GetService("UserInputService").InputBegan:connect(function(input, processed)
            if input.UserInputType == Enum.UserInputType.Keyboard and _G.SelectingHubKey then
                local key = string.split(tostring(input.KeyCode), ".")[3]
                if not table.find(_G.BlockedKeys, key) then
                    _G.SelectingHubKey = false
                    _G.Config.Keybind = tostring(input.KeyCode)
                    SaveConfig()
                end
            end
            if tostring(input.KeyCode) == _G.Config.Keybind and not processed then
                if game:GetService("CoreGui"):FindFirstChild(hubname) then
                    if game:GetService("CoreGui")[hubname].Enabled then
                        game:GetService("CoreGui")[hubname].Enabled = false
                    else
                        game:GetService("CoreGui")[hubname].Enabled = true
                    end
                end
            end
        end)
        game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("collection").grid.List.Outer.UnitFrames.ChildAdded:Connect(function(child)
            if child:IsA("ImageButton") then
                if _G.Config.AutoSummon and #_G.Config.RaritiesToSell > 0 then
                    local Units = require(game.ReplicatedStorage.src.Loader).load_data(script, "Units")
                    if table.find(_G.Config.RaritiesToSell, Units[GetUnitsID("id", child.name.Text)]["rarity"]) and not table.find(_G.Config.UnitsToGet, GetUnitsID("id", child.name.Text)) then
                        game:GetService("ReplicatedStorage").endpoints.client_to_server.sell_units:InvokeServer({child._uuid.Value})
                    end
                end
                if _G.Config.AutoSummon and table.find(_G.Config.UnitsToGet, GetUnitsID("id", child.name.Text)) then
                    _G.Config.Summoning = false
                    table.remove(_G.Config.UnitsToGet, table.find(_G.Config.UnitsToGet, GetUnitsID("id", child.name.Text)))
                    if _G.Config.Notify.Summon then
                        local Data = {
                            ["username"] = "Mazter Notifier",
                            ["avatar_url"] = "https://i.imgur.com/AdLs6AC.jpg",
                            ["content"] = "",
                            ["embeds"] = {{
                                ["title"] = "Unit Summoned",
                                ["description"] = "<a:setinhaSP:980508150878838784> ".. GetUnitsID("id", child.name.Text),
                                ["type"] = "rich",
                                ["color"] = tonumber(0x00A8A8)
                            }}
                        }
                        SendWebhook(Data, _G.Config.Mention)
                    end
                end
            end
        end)
        if InGame() then
            game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MessageGui").messages.ChildAdded:Connect(function(child)
                if child.Name == "Success" then
                    if child:FindFirstChild("Tex") then
                        if string.match(child.Tex.Text, "Obtained") then
                            local item = string.gsub(child.Tex.Text, "Obtained ", "")
                            local item2 = string.gsub(item, "!", "")
                            table.insert(_G.ObtainedItems, item2)
                        end
                    end
                end
            end)
            game:GetService("Players").LocalPlayer.PlayerGui.DropObtainedGUI.messages.ChildAdded:Connect(function(child)
                pcall(function()
                    if child.Name == "Frame" then
                        local new_item = string.split(child.Tex.Text, " ")[2]
                        local function stack_item()
                            for i, v in pairs(_G.ObtainedItems) do
                                local old_item = string.split(v, " ")[2]
                                if old_item == new_item then
                                    return true, i 
                                end
                            end
                            return false
                        end
                        local can_stack, item_index = stack_item()
                        if can_stack then
                            local old_item_name = string.split(_G.ObtainedItems[item_index], " ")
                            local new_item_name = {}
                            for i = 2, #old_item_name do
                                table.insert(new_item_name, old_item_name[i])
                            end
                            local amount = tonumber(string.match(_G.ObtainedItems[item_index], "%d+")) + tonumber(string.match(child.Tex.Text, "%d+"))
                            _G.ObtainedItems[item_index] = "+x"..amount.." "..table.concat(new_item_name, " ")
                        else
                            table.insert(_G.ObtainedItems, child.Tex.Text)
                        end
                    end
                end)
            end)
        end
else
    Notify.new("ERROR", "MAZTER HUB", "You are not whitelisted.", true, 10)
end
