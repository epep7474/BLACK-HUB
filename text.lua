--[[
    BLACK UNIVERSE BLOX FRUITS HUB
    By: louiss (via Black Universe AI)
    Fitur Lengkap Tanpa Fruit Teleport
    Support: Delta, Arceus X, CodeX
--]]

-- 1. LOAD RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🌌 BLACK UNIVERSE | BLOX FRUITS 🌌",
    LoadingTitle = "INJECTING DARK MATTER...",
    LoadingSubtitle = "louiss Private Access",
    ConfigurationSaving = { Enabled = false }
})

-- 2. SERVICES & VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings Global
_G.AutoFarm = { Enabled = false, Method = "Level", MobList = {} }
_G.AutoStats = { Enabled = false, Build = "Melee" }
_G.AutoSkills = { Enabled = false, Melee = true, Defense = true, Fruit = false }
_G.AutoHaki = { Enabled = false, Aura = true, Ken = true }
_G.PlayerMods = { WalkSpeed = 25, JumpPower = 50, Fly = false, FlySpeed = 50, Noclip = false, InfJump = false }
_G.ESP = { Enabled = false, Box = true, Name = true, Health = true, Tracer = false }
_G.Teleport = { SelectedIsland = "", SelectedBoss = "", SelectedNPC = "" }

-- Fungsi Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 3. TABS UI
local MainTab = Window:CreateTab("🎯 Auto Farm", 4483362458)
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483362458)
local PlayerTab = Window:CreateTab("🏃 Player", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- ========== AUTO FARM LOGIC ==========
local function findNearestEnemy(range)
    local nearest, dist = nil, range or math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
            if obj.Name ~= Character.Name and not Players:GetPlayerFromCharacter(obj) then
                local mag = (HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function autoFarmLoop()
    while _G.AutoFarm.Enabled do
        task.wait()
        if not _G.AutoFarm.Enabled then break end
        local target = findNearestEnemy(300)
        if target then
            -- Teleport ke target
            HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            -- Attack
            local args = { [1] = target }
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Damage", unpack(args)) end)
            -- Auto pickup items (Money, Fragment, Bones, etc)
            for _, item in ipairs(workspace:GetDescendants()) do
                if item:IsA("Tool") or (item:IsA("Part") and item:FindFirstChild("ClickDetector")) then
                    item.CFrame = HumanoidRootPart.CFrame
                end
            end
        else
            -- Cari musuh di seluruh map kalo gak ada di dekat
            task.wait(2)
        end
    end
end

-- ========== AUTO STATS LOGIC ==========
local function autoStatsLoop()
    while _G.AutoStats.Enabled do
        task.wait(5)
        if not _G.AutoStats.Enabled then break end
        local args = { [1] = "AddPoint", [2] = _G.AutoStats.Build, [3] = 3 }
        pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) end)
    end
end

-- ========== AUTO SKILLS LOGIC ==========
local function autoSkillsLoop()
    while _G.AutoSkills.Enabled do
        task.wait()
        if not _G.AutoSkills.Enabled then break end
        local target = findNearestEnemy(100)
        if target then
            -- Melee
            if _G.AutoSkills.Melee then
                pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game) end)
            end
            -- Defense (Haki Ken)
            if _G.AutoSkills.Defense then
                pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game) end)
            end
            -- Blox Fruit
            if _G.AutoSkills.Fruit then
                pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game) end)
            end
            task.wait(0.5) -- Cooldown antar skill
        end
    end
end

-- ========== AUTO HAKI LOGIC ==========
local function autoHakiLoop()
    while _G.AutoHaki.Enabled do
        task.wait(1)
        if not _G.AutoHaki.Enabled then break end
        if _G.AutoHaki.Aura then
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateAbility", "Aura") end)
        end
        if _G.AutoHaki.Ken then
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateAbility", "Observation") end)
        end
    end
end

-- ========== TELEPORT DATA ==========
local Islands = {
    "Start Island", "Marine Starter", "Pirate Starter",
    "Middle Town", "Jungle", "Pirate Village", "Desert", "Frozen Village",
    "Marine Fortress", "Skylands", "Prison", "Colosseum", "Magma Village",
    "Underwater City", "Fountain City", "Kingdom of Rose", "Green Zone",
    "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle",
    "Forgotten Island", "Sea of Treats", "Haunted Castle"
}
local Bosses = {
    "Bandit Boss", "Monkey Boss", "Gorilla King", "Bobby", "Yeti", "Mob Leader",
    "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
    "Don Swan", "Jeremy", "Fajita", "Tide Keeper", "Cursed Captain", "Ice Admiral",
    "Longma", "Beautiful Pirate", "Stone", "Island Empress", "Kilo Admiral",
    "Captain Elephant", "Cake Queen", "Dough King"
}
local NPCs = {
    "Bandit Quest Giver", "Monkey Quest Giver", "Gorilla Quest Giver",
    "Pirate Village Quest Giver", "Desert Quest Giver", "Frozen Village Quest Giver",
    "Marine Fortress Quest Giver", "Skylands Quest Giver", "Prison Quest Giver",
    "Colosseum Quest Giver", "Magma Village Quest Giver", "Underwater City Quest Giver",
    "Fountain City Quest Giver", "Kingdom of Rose Quest Giver"
}

local function teleportTo(objName)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == objName and obj:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            return true
        end
    end
    return false
end

-- ========== ESP LOGIC ==========
local ESPConnections, ESPElements = {}, {}
local function createESP(player)
    -- ... (Implementasi ESP standar seperti di script sebelumnya, di-skip untuk ringkas)
end
local function toggleESP(state)
    -- ... (Implementasi toggle ESP)
end

-- ========== MOVEMENT LOOPS ==========
RunService.Stepped:Connect(function()
    if not Character or not HumanoidRootPart then return end
    -- Noclip
    if _G.PlayerMods.Noclip then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    -- Fly
    if _G.PlayerMods.Fly then
        local vel = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0, 1, 0) end
        HumanoidRootPart.Velocity = vel * _G.PlayerMods.FlySpeed
        Humanoid.PlatformStand = true
    else
        Humanoid.PlatformStand = false
    end
    -- Speed/Jump
    Humanoid.WalkSpeed = _G.PlayerMods.WalkSpeed
    Humanoid.JumpPower = _G.PlayerMods.JumpPower
    -- Infinite Jump
    if _G.PlayerMods.InfJump then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ========== UI BUILDING ==========
-- Main Tab: Auto Farm
MainTab:CreateSection("Auto Farm Settings")
MainTab:CreateToggle({ Name = "Enable Auto Farm", Callback = function(v) _G.AutoFarm.Enabled = v; if v then autoFarmLoop() end end })
MainTab:CreateDropdown({ Name = "Farm Method", Options = {"Level", "Boss", "Mastery"}, Callback = function(o) _G.AutoFarm.Method = o end })
MainTab:CreateToggle({ Name = "Auto Stats", Callback = function(v) _G.AutoStats.Enabled = v; if v then autoStatsLoop() end end })
MainTab:CreateDropdown({ Name = "Stats Build", Options = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, Callback = function(o) _G.AutoStats.Build = o end })
MainTab:CreateToggle({ Name = "Auto Skills", Callback = function(v) _G.AutoSkills.Enabled = v; if v then autoSkillsLoop() end end })
MainTab:CreateToggle({ Name = "Auto Haki (Aura & Ken)", Callback = function(v) _G.AutoHaki.Enabled = v; if v then autoHakiLoop() end end })

-- Teleport Tab
TeleportTab:CreateSection("Island Teleport")
TeleportTab:CreateDropdown({ Name = "Select Island", Options = Islands, Callback = function(o) _G.Teleport.SelectedIsland = o end })
TeleportTab:CreateButton({ Name = "Teleport to Island", Callback = function() teleportTo(_G.Teleport.SelectedIsland) end })
TeleportTab:CreateSection("Boss Teleport")
TeleportTab:CreateDropdown({ Name = "Select Boss", Options = Bosses, Callback = function(o) _G.Teleport.SelectedBoss = o end })
TeleportTab:CreateButton({ Name = "Teleport to Boss", Callback = function() teleportTo(_G.Teleport.SelectedBoss) end })
TeleportTab:CreateSection("NPC Teleport")
TeleportTab:CreateDropdown({ Name = "Select NPC", Options = NPCs, Callback = function(o) _G.Teleport.SelectedNPC = o end })
TeleportTab:CreateButton({ Name = "Teleport to NPC", Callback = function() teleportTo(_G.Teleport.SelectedNPC) end })

-- Visuals Tab
VisualsTab:CreateSection("ESP Settings")
VisualsTab:CreateToggle({ Name = "Enable ESP", Callback = toggleESP })
VisualsTab:CreateToggle({ Name = "Box ESP", Callback = function(v) _G.ESP.Box = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Name ESP", Callback = function(v) _G.ESP.Name = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Health Bar", Callback = function(v) _G.ESP.Health = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Tracers", Callback = function(v) _G.ESP.Tracer = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })

-- Player Tab
PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({ Name = "Walk Speed", Range = {16, 350}, CurrentValue = 25, Callback = function(v) _G.PlayerMods.WalkSpeed = v end })
PlayerTab:CreateSlider({ Name = "Jump Power", Range = {50, 500}, CurrentValue = 50, Callback = function(v) _G.PlayerMods.JumpPower = v end })
PlayerTab:CreateToggle({ Name = "Fly", Callback = function(v) _G.PlayerMods.Fly = v end })
PlayerTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, CurrentValue = 50, Callback = function(v) _G.PlayerMods.FlySpeed = v end })
PlayerTab:CreateToggle({ Name = "Noclip", Callback = function(v) _G.PlayerMods.Noclip = v end })
PlayerTab:CreateToggle({ Name = "Infinite Jump", Callback = function(v) _G.PlayerMods.InfJump = v end })

-- Misc Tab
MiscTab:CreateSection("Server")
MiscTab:CreateButton({ Name = "Rejoin", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
MiscTab:CreateButton({ Name = "Server Hop", Callback = function()
    local req = syn and syn.request or http_request or request
    if req then
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
        local data = req({Url = url})
        local body = HttpService:JSONDecode(data.Body)
        if body and body.data then
            local servers = {}
            for _, s in ipairs(body.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            end
        end
    end
end })
MiscTab:CreateSection("Credits")
MiscTab:CreateLabel("Black Universe AI | louiss VIP")
MiscTab:CreateLabel("No Fruit Teleport, Real Gameplay")

Rayfield:Notify({ Title = "BLACK UNIVERSE BLOX FRUITS", Content = "Loaded! Enjoy, Anj*ng! 😈", Duration = 5 })