function eb()
    local rs = game:GetService("RunService")
    local plr = game:GetService("Players")
    local lgt = game:GetService("Lighting")
    local ws = game:GetService("Workspace")
    local done = {}

    local function fx(v)
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v:Destroy()
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("MeshPart") or v:IsA("Part") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.Transparency = 1
        elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") then
            v.Enabled = false
        elseif v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        elseif v:IsA("Model") then
            local n = v.Name:lower()
            if n:match("tree") or n:match("bush") or n:match("deco") then
                v:Destroy()
            end
        end
    end

    lgt.FogEnd = 1e5
    lgt.FogStart = 1e5
    lgt.GlobalShadows = false
    lgt.Brightness = 0
    lgt.ClockTime = 14
    pcall(function()
        game:GetService("UserInputService").MouseDeltaSensitivity = 1
        local b = lgt:FindFirstChildOfClass("BlurEffect")
        if b then b:Destroy() end
    end)

    local t = ws:FindFirstChildOfClass("Terrain")
    if t then
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 1
    end

    for _, p in pairs(plr:GetPlayers()) do
        local c = p.Character
        if c then
            for _, d in ipairs(c:GetDescendants()) do
                fx(d)
            end
        end
    end

    for _, o in ipairs(game:GetDescendants()) do
        if not done[o] then
            fx(o)
            done[o] = true
        end
    end

    game.DescendantAdded:Connect(function(o)
        task.wait()
        if not done[o] then
            fx(o)
            done[o] = true
        end
    end)

    plr.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c)
            task.wait(1)
            for _, d in ipairs(c:GetDescendants()) do
                fx(d)
            end
        end)
    end)
end

eb()
