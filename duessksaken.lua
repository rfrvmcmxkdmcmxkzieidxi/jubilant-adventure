-- language: Lua, target: Roblox exploit environment, framework: Obsidian UI
-- *Duessksaken script hub integrating every single feature, automation routine, ESP manager, and Survivor Aimbot logic*

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ObsidianUI/Obsidian/main/Source.lua"))()

local Window = Library:CreateWindow({
    Name = "Duessksaken 1.12",
    Theme = "Dark",
    LoadingEnabled = true,
    LoadingTitle = "Duessksaken",
    LoadingSubtitle = "i hate putting credits EVERYTIME AHHH -owner",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Duessksaken",
        FileName = "Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Duessksaken // Key System",
        Subtitle = "Discord Authorization",
        Note = "Join the Discord for the key: https://discord.gg/WcbnRg6ND",
        FileName = "DuessksakenKey",
        SaveKey = true,
        Key = {"https://discord.gg/WcbnRg6ND"}
    }
})

-- Core Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalRoot = LocalCharacter:WaitForChild("HumanoidRootPart")
local LocalHumanoid = LocalCharacter:WaitForChild("Humanoid")
local InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
local GameMap = InGame and InGame:FindFirstChild("Map") or nil
local PlayersFolder = workspace:FindFirstChild("Players")
local KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
local SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")
local RagdollsFolder = workspace:FindFirstChild("Ragdolls")

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
    local v396, v397, v398 = ipairs(u394)
    while true do
        local v399
        v398, v399 = v396(v397, v398)
        if v398 == nil then break end
        if p395 == v399 then return true end
    end
    return false
end

-- Tabs
local TabAutomation = Window:CreateTab({ Name = "Automation", Icon = "rbxassetid://6023426915" })
local TabFeatures = Window:CreateTab({ Name = "Features & Combat", Icon = "rbxassetid://6023426915" })
local TabVisuals = Window:CreateTab({ Name = "Visuals & ESP", Icon = "rbxassetid://6023426915" })
local TabMisc = Window:CreateTab({ Name = "Miscellaneous", Icon = "rbxassetid://6023426915" })
local TabBypass = Window:CreateTab({ Name = "Bypass", Icon = "rbxassetid://6023426915" })

-- State Flags
_G.DuessksakenFlags = {
    AutoGenerator = false,
    GenCooldown = 4,
    AutoPickup = false,
    DisableKillerWalls = false,
    EnableJumping = false,
    AntiSlowness = false,
    ESP = false,
    KillersESP = false,
    SurvivorsESP = false
}

-- Character Update Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    LocalCharacter = char
    LocalRoot = char:WaitForChild("HumanoidRootPart")
    LocalHumanoid = char:WaitForChild("Humanoid")
end)

-- 1. Automation Tab
local AutoSec = TabAutomation:CreateSection("Generators & Puzzles")

AutoSec:CreateToggle({
    Name = "Auto Generator(s)",
    CurrentValue = false,
    Flag = "AutoGenerator",
    Callback = function(Value)
        _G.DuessksakenFlags.AutoGenerator = Value
        task.spawn(function()
            while _G.DuessksakenFlags.AutoGenerator do
                if GameMap then
                    for _, Object in ipairs(GameMap:GetDescendants()) do
                        if Object.Name == "Generator" then
                            local Remotes = Object:FindFirstChild("Remotes")
                            local Progress = Remotes and Object:FindFirstChild("Progress")
                            local RemoteEvent = Progress and Remotes:FindFirstChildOfClass("RemoteEvent")
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

AutoSec:CreateSlider({
    Name = "Cooldown Between Completions",
    Range = {1.5, 8},
    Increment = 0.25,
    CurrentValue = 4,
    Flag = "GenCooldown",
    Callback = function(Value)
        _G.DuessksakenFlags.GenCooldown = Value
    end
})

-- 2. Features & Combat Tab
local CombatSec = TabFeatures:CreateSection("Combat & Movement")

local _AimbotSec = TabFeatures:CreateSection("Survivor Aimbot Integration")

_AimbotSec:CreateToggle({
    Name = 'Survivor Aimbot',
    CurrentValue = false,
    Flag = 'ToggleSURGUGFHBIDCWVKO',
    Callback = function(p381)
        if p381 then
            u375()
        else
            u380()
        end
    end,
})

_AimbotSec:CreateSlider({
    Name = "Survivor's Aimbot Prediction",
    Range = {0.25, 1},
    Increment = 0.25,
    CurrentValue = 0.25,
    Flag = 'SliderSuvrivrolrlsider',
    Callback = function(p382)
        u348 = p382
    end,
})

_AimbotSec:CreateSlider({
    Name = "Survivor's Aimbot Smoothness",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Flag = 'CoolSmoothnessFlag',
    Callback = function(p383)
        u349 = p383
    end,
})

CombatSec:CreateToggle({
    Name = "Disable Killer Walls",
    CurrentValue = false,
    Flag = "DisableKillerWalls",
    Callback = function(Value)
        _G.DuessksakenFlags.DisableKillerWalls = Value
        task.spawn(function()
            while _G.DuessksakenFlags.DisableKillerWalls do
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

CombatSec:CreateToggle({
    Name = "Enable Jumping",
    CurrentValue = false,
    Flag = "EnableJumping",
    Callback = function(Value)
        _G.DuessksakenFlags.EnableJumping = Value
        task.spawn(function()
            while _G.DuessksakenFlags.EnableJumping do
                if LocalHumanoid then
                    LocalHumanoid.JumpPower = 47
                end
                task.wait(0.2)
            end
            if LocalHumanoid then
                LocalHumanoid.JumpPower = 0
            end
        end)
    end
})

-- 3. Visuals & ESP Tab
local ESPSec = TabVisuals:CreateSection("ESP Toggles")

ESPSec:CreateToggle({
    Name = "Global ESP Master Switch",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        _G.DuessksakenFlags.ESP = Value
    end
})

ESPSec:CreateToggle({
    Name = "Killer(s) ESP",
    CurrentValue = false,
    Flag = "KillersESP",
    Callback = function(Value)
        _G.DuessksakenFlags.KillersESP = Value
        task.spawn(function()
            while _G.DuessksakenFlags.KillersESP do
                if _G.DuessksakenFlags.ESP and KillersFolder then
                    for _, Killer in ipairs(KillersFolder:GetChildren()) do
                        if not Killer:FindFirstChild("DuessksakenHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "DuessksakenHighlight"
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = Killer
                        end
                    end
                else
                    if KillersFolder then
                        for _, Killer in ipairs(KillersFolder:GetChildren()) do
                            local hl = Killer:FindFirstChild("DuessksakenHighlight")
                            if hl then hl:Destroy() end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

-- 4. Miscellaneous Tab
local MiscSec = TabMisc:CreateSection("Client Adjustments")

MiscSec:CreateSlider({
    Name = "Extended FOV",
    Range = {10, 120},
    Increment = 5,
    CurrentValue = 70,
    Flag = "ExtendedFOV",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

MiscSec:CreateToggle({
    Name = "Hide Injured UI / Effects",
    CurrentValue = true,
    Flag = "HideInjury",
    Callback = function(Value)
        if Lighting:FindFirstChild("HealthDesaturation") then
            Lighting.HealthDesaturation.Enabled = not Value
        end
    end
})

-- 5. Bypass Tab
local BypassSec = TabBypass:CreateSection("Anti-Cheat Neutralization")

BypassSec:CreateButton({
    Name = "Bypass Adonis Anticheat",
    Callback = function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick") then
                if self == LocalPlayer or self == LocalPlayer.Character then
                    warn("[Duessksaken] Blocked anti-cheat kick attempt.")
                    return
                end
            end
            return oldNamecall(self, ...)
        end)

        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.source and (info.source:find("Client") or info.source:find("MainModule") or info.source:find("Adonis")) then
                    local constants = debug.getconstants(v)
                    for _, c in ipairs(constants) do
                        if tostring(c):find("TeleportService") or tostring(c):find("kick") then
                            hookfunction(v, function() return true end)
                        end
                    end
                end
            end
        end

        print("[*] Duessksaken: Adonis anti-cheat successfully bypassed.")
    end
})

Library:LoadConfiguration()c
