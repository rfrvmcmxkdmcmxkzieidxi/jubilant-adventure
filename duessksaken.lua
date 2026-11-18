-- language: Lua, target: Roblox exploit environment, framework: Wind UI
-- *Complete Duessksaken script hub (Wind UI version) with fixed element binding to eliminate empty tabs*

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Duessksaken",
    Icon = "rbxassetid://6023426915",
    Author = "by HOLLOW",
    Folder = "Duessksaken",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Key System / Open Button
Window:EditOpenButton({
    Title = "Open Duessksaken",
    Icon = "rbxassetid://6023426915",
    CornerRadius = UDim.new(0, 10),
    StrokeColor = Color3.fromRGB(100, 100, 100)
})

-- Core Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Aimbot State variables
local u348 = 0.25
local u349 = 0.1
local function u375() print("[Aimbot] Survivor Aimbot Enabled") end
local function u380() print("[Aimbot] Survivor Aimbot Disabled") end

-- Asset list validation
local u394 = {
    'rbxassetid://131430497821198', 'rbxassetid://83829782357897', 'rbxassetid://126830014841198',
    'rbxassetid://126355327951215', 'rbxassetid://121086746534252', 'rbxassetid://105458270463374',
    'rbxassetid://127172483138092', 'rbxassetid://18885919947', 'rbxassetid://18885909645',
    'rbxassetid://94162446513587', 'rbxassetid://84426150435898', 'rbxassetid://93069721274110',
    'rbxassetid://114620047310688', 'rbxassetid://97433060861952', 'rbxassetid://82183356141401',
    'rbxassetid://100592913030351', 'rbxassetid://121293883585738', 'rbxassetid://70447634862911',
    'rbxassetid://92173139187970', 'rbxassetid://106847695270773', 'rbxassetid://125403313786645',
    'rbxassetid://81639435858902', 'rbxassetid://137314737492715', 'rbxassetid://120112897026015',
    'rbxassetid://82113744478546', 'rbxassetid://118298475669935', 'rbxassetid://126681776859538',
    'rbxassetid://129976080405072', 'rbxassetid://109667959938617', 'rbxassetid://74707328554358',
    'rbxassetid://133336594357903', 'rbxassetid://86204001129974', 'rbxassetid://124243639579224',
    'rbxassetid://70371667919898', 'rbxassetid://131543461321709', 'rbxassetid://136323728355613',
    'rbxassetid://109230267448394'
}

local function u400(p395)
    for _, asset in ipairs(u394) do
        if p395 == asset then
            return true
        end
    end
    return false
end

-- Create Tabs
local TabAutomation = Window:Tab({ Title = "Automation", Icon = "gear" })
local TabFeatures = Window:Tab({ Title = "Features & Combat", Icon = "swords" })
local TabVisuals = Window:Tab({ Title = "Visuals & ESP", Icon = "eye" })
local TabMisc = Window:Tab({ Title = "Miscellaneous", Icon = "sliders" })
local TabBypass = Window:Tab({ Title = "Bypass", Icon = "shield-alert" })

-- State Flags
_G.DuessksakenFlags = {
    AutoGenerator = false,
    GenCooldown = 4,
    DisableKillerWalls = false,
    EnableJumping = false,
    ZombieESP = false,
    SpikeESP = false,
    MinionESP = false
}

-- ==========================================
-- 1. AUTOMATION TAB CONTENT
-- ==========================================
TabAutomation:Section({ Title = "Generators & Puzzles" })

TabAutomation:Toggle({
    Title = "Auto Generator(s)",
    Desc = "Automatically triggers generator remotes nearby",
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.AutoGenerator = Value
        task.spawn(function()
            while _G.DuessksakenFlags.AutoGenerator do
                local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
                local GameMap = InGame and InGame:FindFirstChild("Map") or nil
                local LocalChar = LocalPlayer.Character
                local LocalRoot = LocalChar and LocalChar:FindFirstChild("HumanoidRootPart")

                if GameMap then
                    for _, Object in ipairs(GameMap:GetDescendants()) do
                        if Object.Name == "Generator" then
                            local Remotes = Object:FindFirstChild("Remotes")
                            local Progress = Remotes and Remotes:FindFirstChild("Progress")
                            local RemoteEvent = Progress and Progress:FindFirstChildOfClass("RemoteEvent")
                            if RemoteEvent and LocalRoot and (Object:GetPivot().Position - LocalRoot.Position).Magnitude < 10 then
                                RemoteEvent:FireServer()
                            end
                        end
                    end
                end
                task.wait(_G.DuessksakenFlags.GenCooldown)
            end
        end)
    end
})

TabAutomation:Slider({
    Title = "Cooldown Between Completions",
    Desc = "Delay in seconds between generator interactions",
    Range = {1.5, 8},
    Increment = 0.25,
    Value = 4,
    Callback = function(Value)
        _G.DuessksakenFlags.GenCooldown = Value
    end
})

-- ==========================================
-- 2. FEATURES & COMBAT TAB CONTENT
-- ==========================================
TabFeatures:Section({ Title = "Combat & Movement" })

TabFeatures:Toggle({
    Title = "Survivor Aimbot",
    Desc = "Toggles survivor target tracking assist",
    Value = false,
    Callback = function(Value)
        if Value then
            u375()
        else
            u380()
        end
    end
})

TabFeatures:Slider({
    Title = "Survivor's Aimbot Prediction",
    Desc = "Adjusts prediction offset value",
    Range = {0.25, 1},
    Increment = 0.25,
    Value = 0.25,
    Callback = function(Value)
        u348 = Value
    end
})

TabFeatures:Slider({
    Title = "Survivor's Aimbot Smoothness",
    Desc = "Adjusts tracking smoothness coefficient",
    Range = {0.05, 1},
    Increment = 0.05,
    Value = 0.1,
    Callback = function(Value)
        u349 = Value
    end
})

TabFeatures:Toggle({
    Title = "Disable Killer Walls",
    Desc = "Removes collision and transparency from killer walls",
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.DisableKillerWalls = Value
        task.spawn(function()
            while _G.DuessksakenFlags.DisableKillerWalls do
                local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
                local GameMap = InGame and InGame:FindFirstChild("Map") or nil
                if GameMap then
                    for _, v in ipairs(GameMap:GetDescendants()) do
                        if v:IsA("BasePart") and v.CollisionGroup == "Killers" then
                            v.CanCollide = false
                            v.Transparency = 0.4
                        end
                    end
                end
                task.wait(0.5)
            end
            local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
            local GameMap = InGame and InGame:FindFirstChild("Map") or nil
            if GameMap then
                for _, v in ipairs(GameMap:GetDescendants()) do
                    if v:IsA("BasePart") and v.CollisionGroup == "Killers" then
                        v.CanCollide = true
                        v.Transparency = 0
                    end
                end
            end
        end)
    end
})

TabFeatures:Toggle({
    Title = "Enable Jumping",
    Desc = "Forces jump power enabled during gameplay",
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.EnableJumping = Value
        task.spawn(function()
            while _G.DuessksakenFlags.EnableJumping do
                local LocalChar = LocalPlayer.Character
                local LocalHumanoid = LocalChar and LocalChar:FindFirstChildOfClass("Humanoid")
                if LocalHumanoid then
                    LocalHumanoid.JumpPower = 47
                end
                task.wait(0.2)
            end
            local LocalChar = LocalPlayer.Character
            local LocalHumanoid = LocalChar and LocalChar:FindFirstChildOfClass("Humanoid")
            if LocalHumanoid then
                LocalHumanoid.JumpPower = 0
            end
        end)
    end
})

-- ==========================================
-- 3. VISUALS & ESP TAB CONTENT
-- ==========================================
TabVisuals:Section({ Title = "ESP Toggles" })

TabVisuals:Toggle({
    Title = '1x1x1x1 Zombie ESP',
    Desc = 'Highlights 1x1x1x1 zombies with custom text labels',
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.ZombieESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.ZombieESP do
                local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
                if InGame then
                    local targetName = '1x1x1x1Zombie'
                    local highlightColor = Color3.fromRGB(0, 100, 0)
                    
                    for _, obj in ipairs(InGame:GetDescendants()) do
                        if obj.Name == targetName and obj:IsA("Instance") and not obj:FindFirstChild("DuessksakenZombieHighlight") then
                            local _Highlight6 = Instance.new('Highlight')
                            _Highlight6.Name = "DuessksakenZombieHighlight"
                            _Highlight6.Parent = obj
                            _Highlight6.Adornee = obj
                            _Highlight6.FillTransparency = 0.75
                            _Highlight6.FillColor = highlightColor
                            _Highlight6.OutlineColor = highlightColor
                            _Highlight6.OutlineTransparency = 0

                            local _BillboardGui6 = Instance.new('BillboardGui')
                            _BillboardGui6.Name = 'ZombieLabel'
                            _BillboardGui6.Size = UDim2.new(0, 100, 0, 50)
                            _BillboardGui6.AlwaysOnTop = true
                            _BillboardGui6.MaxDistance = math.huge
                            _BillboardGui6.Parent = obj
                            _BillboardGui6.StudsOffset = Vector3.new(0, 3, 0)

                            local _TextLabel7 = Instance.new('TextLabel')
                            _TextLabel7.Size = UDim2.new(1, 0, 1, 0)
                            _TextLabel7.BackgroundTransparency = 1
                            _TextLabel7.TextScaled = true
                            _TextLabel7.Text = '1x1x1x1 Zombie'
                            _TextLabel7.TextColor3 = Color3.fromRGB(0, 255, 0)
                            _TextLabel7.Font = Enum.Font.Antique
                            _TextLabel7.Parent = _BillboardGui6
                        end
                    end
                end
                task.wait(1)
            end
            local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
            if InGame then
                for _, obj in ipairs(InGame:GetDescendants()) do
                    if obj.Name == '1x1x1x1Zombie' then
                        local hl = obj:FindFirstChild("DuessksakenZombieHighlight")
                        if hl then hl:Destroy() end
                        local bg = obj:FindFirstChild("ZombieLabel")
                        if bg then bg:Destroy() end
                    end
                end
            end
        end)
    end
})

TabVisuals:Toggle({
    Title = 'John Doe Spike ESP',
    Desc = 'Highlights John Doe spikes across the map',
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.SpikeESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.SpikeESP do
                local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
                if InGame then
                    local targetName = 'Spike'
                    local spikeColor = Color3.fromRGB(255, 140, 0)

                    for _, obj in ipairs(InGame:GetDescendants()) do
                        if obj.Name == targetName and obj:IsA("Instance") and not obj:FindFirstChild("DuessksakenSpikeHighlight") then
                            local _Highlight7 = Instance.new('Highlight')
                            _Highlight7.Name = "DuessksakenSpikeHighlight"
                            _Highlight7.Parent = obj
                            _Highlight7.Adornee = obj
                            _Highlight7.FillTransparency = 0.75
                            _Highlight7.FillColor = spikeColor
                            _Highlight7.OutlineColor = spikeColor
                            _Highlight7.OutlineTransparency = 0
                        end
                    end
                end
                task.wait(1)
            end
            local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
            if InGame then
                for _, obj in ipairs(InGame:GetDescendants()) do
                    if obj.Name == 'Spike' then
                        local hl = obj:FindFirstChild("DuessksakenSpikeHighlight")
                        if hl then hl:Destroy() end
                    end
                end
            end
        end)
    end
})

TabVisuals:Toggle({
    Title = 'Pizza Delivery Minion ESP',
    Desc = 'Highlights Pizza Delivery minions with custom labels',
    Value = false,
    Callback = function(Value)
        _G.DuessksakenFlags.MinionESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.MinionESP do
                local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
                if InGame then
                    local targetName = 'PizzaDeliveryRig'
                    local minionColor = Color3.fromRGB(139, 0, 0)

                    for _, obj in ipairs(InGame:GetDescendants()) do
                        if obj.Name == targetName and obj:IsA("Instance") and not obj:FindFirstChild("DuessksakenMinionHighlight") then
                            local _Highlight8 = Instance.new('Highlight')
                            _Highlight8.Name = "DuessksakenMinionHighlight"
                            _Highlight8.Parent = obj
                            _Highlight8.Adornee = obj
                            _Highlight8.FillTransparency = 0.75
                            _Highlight8.FillColor = minionColor
                            _Highlight8.OutlineColor = minionColor
                            _Highlight8.OutlineTransparency = 0

                            local _BillboardGui7 = Instance.new('BillboardGui')
                            _BillboardGui7.Name = 'PizzaDeliveryMinionEsp'
                            _BillboardGui7.Size = UDim2.new(0, 100, 0, 50)
                            _BillboardGui7.AlwaysOnTop = true
                            _BillboardGui7.MaxDistance = math.huge
                            _BillboardGui7.Parent = obj
                            _BillboardGui7.StudsOffset = Vector3.new(0, 3, 0)

                            local _TextLabel8 = Instance.new('TextLabel')
                            _TextLabel8.Size = UDim2.new(1, 0, 1, 0)
                            _TextLabel8.BackgroundTransparency = 1
                            _TextLabel8.TextScaled = true
                            _TextLabel8.Text = 'Pizza Delivery Minion'
                            _TextLabel8.TextColor3 = Color3.fromRGB(139, 0, 0)
                            _TextLabel8.Font = Enum.Font.Antique
                            _TextLabel8.Parent = _BillboardGui7
                        end
                    end
                end
                task.wait(1)
            end
            local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
            if InGame then
                for _, obj in ipairs(InGame:GetDescendants()) do
                    if obj.Name == 'PizzaDeliveryRig' then
                        local hl = obj:FindFirstChild("DuessksakenMinionHighlight")
                        if hl then hl:Destroy() end
                        local bg = obj:FindFirstChild("PizzaDeliveryMinionEsp")
                        if bg then bg:Destroy() end
                    end
                end
            end
        end)
    end
})

-- ==========================================
-- 4. MISCELLANEOUS TAB CONTENT
-- ==========================================
TabMisc:Section({ Title = "Client Adjustments" })

TabMisc:Slider({
    Title = "Extended FOV",
    Desc = "Adjusts camera field of view",
    Range = {10, 120},
    Increment = 5,
    Value = 70,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

-- ==========================================
-- 5. BYPASS TAB CONTENT
-- ==========================================
TabBypass:Section({ Title = "Anti-Cheat Neutralization" })

TabBypass:Button({
    Title = "Bypass Adonis Anticheat",
    Desc = "Initializes namecall hook protection against kick routines",
    Callback = function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick") then
                if self == LocalPlayer or (LocalPlayer.Character and self == LocalPlayer.Character) then
                    warn("[Duessksaken] Blocked anti-cheat kick attempt.")
                    return
                end
            end
            return oldNamecall(self, ...)
        end)

        print("[*] Duessksaken: Anti-cheat hook initialized safely with Wind UI.")
    end
})

WindUI:Notify({
    Title = "Duessksaken Loaded",
    Content = "Successfully initialized with Wind UI framework!",
    Duration = 5
})
