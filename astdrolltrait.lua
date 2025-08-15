

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GetFunction = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetFunction")
local InventoryMod = require(ReplicatedStorage:WaitForChild("Mods"):WaitForChild("InventoryMod"))

local function getTraitBurnerCount()
    local success, inventory = pcall(function()
        return GetFunction:InvokeServer({Type = "Inventory", Mode = "Get"})
    end)
    if not success or typeof(inventory) ~= "table" then return 0 end
    for _, item in ipairs(inventory) do
        if item.Name == "Trait Burner" then
            return item.Owned or 0
        end
    end
    return 0
end

local function findUnitByName(displayName)
    local success, units = pcall(function()
        return InventoryMod.Units()
    end)
    if not success or typeof(units) ~= "table" then return nil end
    for _, unit in ipairs(units) do
        if unit.DisplayName == displayName then
            return {
                Key = unit.Key,
                TraitName = (unit.Trait and unit.Trait.Name) or "No Trait"
            }
        end
    end
    return nil
end

local function isTargetTrait(traitName)
    for _, target in ipairs(getgenv().Configs["Trait Name"]) do
        if traitName == target then
            return true
        end
    end
    return false
end

local function autoRoll()
    local targetName = getgenv().Configs["Name Unit"]
    local unitData = findUnitByName(targetName)
    if not unitData then
        warn("Unit not found:", targetName)
        return
    end
    if isTargetTrait(unitData.TraitName) then
        print("Already has target trait. Stopping.")
        return
    end
    while true do
        local burners = getTraitBurnerCount()
        if burners <= 0 then
            print("No Trait Burner left. Stopping.")
            break
        end
        local args = {
            [1] = {
                ["Type"] = "Traits",
                ["Key"] = unitData.Key,
                ["Mode"] = "Reroll"
            }
        }
        local success = pcall(function()
            return GetFunction:InvokeServer(unpack(args))
        end)
        if success then
            task.wait(0.5)
            local updatedData = findUnitByName(targetName)
            if updatedData then
                print("Burners Left:", burners - 1, "| Unit:", targetName, "| Trait:", updatedData.TraitName)
                if isTargetTrait(updatedData.TraitName) then
                    print("Target trait obtained. Stopping.")
                    break
                end
            end
        else
            print("Reroll failed, retrying...")
        end
        task.wait(0.2)
    end
end

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
autoRoll()
