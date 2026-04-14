-- [[ BLACK UNIVERSE V3.2 - FLICK EDITION (SINGLE WINDOW FIX) ]] --
-- Firebase: key-black-hub | Format Expiry: YYYY-MM-DD
-- Fix: Login & Menu dalam SATU WINDOW (Anti Gagal Load)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ========== FIREBASE CONFIG ==========
local FirebaseConfig = {
    ProjectID = "key-black-hub",
    APIKey = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI",
    Collection = "Keys"
}

-- Global Settings
_G.Auth = { IsAuth = false, Key = "" }
_G.Aimbot = { 
    Enabled = false, Silent = true, FOV = 200, Smoothing = 0.03, 
    AimPart = "Head", ShowFOV = false, TriggerBot = false, TriggerDelay = 0.05 
}
_G.ESP = { 
    Enabled = false, Box = true, Name = true, Health = true, 
    Tracer = true, Distance = true, Color = Color3.fromRGB(255,0,0) 
}
_G.Misc = { AntiAFK = true, FPSBoost = true }

-- ========== FOV CIRCLE ==========
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ========== ESP STORAGE ==========
local ESPConnections = {}
local ESPElements = {}

-- ========== FUNCTIONS ==========

-- Firebase Auth Check (BACA STRING YYYY-MM-DD)
local function checkKey(key)
    local url = "https://firestore.googleapis.com/v1/projects/" .. FirebaseConfig.ProjectID .. "/databases/(default)/documents/" .. FirebaseConfig.Collection .. "/" .. key .. "?key=" .. FirebaseConfig.APIKey
    local success, result = pcall(function() return game:HttpGet(url) end)
    
    if success and not result:find("error") then
        local data = HttpService:JSONDecode(result)
        local fields = data.fields
        
        if fields and fields.expiry and fields.expiry.stringValue then
            local expiryDate = fields.expiry.stringValue
            local currentDate = os.date("%Y-%m-%d")
            
            if currentDate <= expiryDate then
                return true, expiryDate
            else
                return false, "Key expired on " .. expiryDate
            end
        else
            return false, "Invalid key format"
        end
    end
    return false, "Key not found"
end

-- Get Closest Player
local function getClosestPlayer()
    local target = nil
    local shortest = _G.Aimbot.FOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(_G.Aimbot.AimPart) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local part = plr.Character[_G.Aimbot.AimPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortest then
                    shortest = dist
                    target = plr
                end
            end
        end
    end
    return target
end

-- ESP Creation
local function createESP(player)
    local elements = {}
    local function cleanup()
        for _, d in pairs(elements) do if d.Remove then d:Remove() end end
        elements = {}
    end
    
    local function update()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            for _, d in pairs(elements) do d.Visible = false end
            return
        end
        local root = char.HumanoidRootPart
        local humanoid = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        
        if not onScreen or not _G.ESP.Enabled then
            for _, d in pairs(elements) do d.Visible = false end
            return
        end
        
        local boxSize = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
        local boxPos = Vector2.new(pos.X - boxSize.X/2, pos.Y - boxSize.Y/2)
        
        if _G.ESP.Box then
            local box = elements.Box or Drawing.new("Square")
            box.Visible = true; box.Color = _G.ESP.Color; box.Thickness = 1.5; box.Filled = false
            box.Size = boxSize; box.Position = boxPos; elements.Box = box
        end
        
        if _G.ESP.Name then
            local nameTag = elements.Name or Drawing.new("Text")
            nameTag.Visible = true; nameTag.Text = player.Name; nameTag.Color = Color3.fromRGB(255,255,255)
            nameTag.Size = 14; nameTag.Center = true; nameTag.Outline = true
            nameTag.Position = Vector2.new(pos.X, boxPos.Y - 15); elements.Name = nameTag
        end
        
        if _G.ESP.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
            local distTag = elements.Distance or Drawing.new("Text")
            distTag.Visible = true; distTag.Text = string.format("%.0f studs", dist)
            distTag.Color = Color3.fromRGB(200,200,200); distTag.Size = 12
            distTag.Center = true; distTag.Outline = true
            distTag.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 5); elements.Distance = distTag
        end
        
        if _G.ESP.Health then
            local healthBg = elements.HealthBg or Drawing.new("Square")
            healthBg.Visible = true; healthBg.Color = Color3.fromRGB(0,0,0); healthBg.Filled = true
            healthBg.Size = Vector2.new(boxSize.X, 4); healthBg.Position = Vector2.new(boxPos.X, boxPos.Y - 8)
            elements.HealthBg = healthBg
            
            local healthBar = elements.Health or Drawing.new("Square")
            healthBar.Visible = true; healthBar.Color = Color3.fromRGB(0,255,0); healthBar.Filled = true
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthBar.Size = Vector2.new(boxSize.X * healthPercent, 4)
            healthBar.Position = Vector2.new(boxPos.X, boxPos.Y - 8); elements.Health = healthBar
        end
        
        if _G.ESP.Tracer then
            local tracer = elements.Tracer or Drawing.new("Line")
            tracer.Visible = true; tracer.Color = _G.ESP.Color; tracer.Thickness = 1
            tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y); elements.Tracer = tracer
        end
    end
    
    local connection = RunService.RenderStepped:Connect(update)
    table.insert(ESPConnections, connection)
    return { Connection = connection, Elements = elements, Cleanup = cleanup }
end

-- Toggle ESP
local function toggleESP(state)
    _G.ESP.Enabled = state
    for _, conn in ipairs(ESPConnections) do conn:Disconnect() end
    ESPConnections = {}
    for _, elem in pairs(ESPElements) do if elem.Cleanup then elem.Cleanup() end end
    ESPElements = {}
    
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then ESPElements[plr.UserId] = createESP(plr) end
        end
        Players.PlayerAdded:Connect(function(plr)
            if _G.ESP.Enabled then ESPElements[plr.UserId] = createESP(plr) end
        end)
        Players.PlayerRemoving:Connect(function(plr)
            if ESPElements[plr.UserId] then ESPElements[plr.UserId].Cleanup(); ESPElements[plr.UserId] = nil end
        end)
    end
end

-- ========== MAIN LOOPS ==========
RunService.RenderStepped:Connect(function()
    if not _G.Auth.IsAuth then return end
    if _G.Aimbot.ShowFOV then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircle.Radius = _G.Aimbot.FOV; FOVCircle.Visible = true
    else FOVCircle.Visible = false end
    
    if _G.Aimbot.Enabled and not _G.Aimbot.Silent and UserInputService:IsMouseButtonPressed(1) then
        local target = getClosestPlayer()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(_G.Aimbot.AimPart)
            if aimPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.Aimbot.Smoothing)
            end
        end
    end
end)

local lastTrigger = 0
RunService.Heartbeat:Connect(function()
    if not _G.Auth.IsAuth then return end
    local now = tick()
    
    if _G.Aimbot.Enabled and _G.Aimbot.Silent and UserInputService:IsMouseButtonPressed(1) then
        local target = getClosestPlayer()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(_G.Aimbot.AimPart)
            if aimPart then
                local oldCFrame = Camera.CFrame
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                pcall(function() VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0) end)
                task.wait(0.01)
                pcall(function() VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0) end)
                Camera.CFrame = oldCFrame
            end
        end
    end
    
    if _G.Aimbot.TriggerBot and now - lastTrigger >= _G.Aimbot.TriggerDelay then
        local target = getClosestPlayer()
        if target then
            pcall(function() VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0) end)
            task.wait(0.05)
            pcall(function() VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0) end)
        end
        lastTrigger = now
    end
end)

-- Anti-AFK & FPS Boost
if _G.Misc.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame); task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end
if _G.Misc.FPSBoost then
    game:GetService("Lighting").GlobalShadows = false
    workspace.Terrain.WaterWaveSize = 0
end

-- ========== UI CREATION (SATU WINDOW, DUA TAB) ==========
local Window = Rayfield:CreateWindow({
    Name = "🌌 BLACK UNIVERSE V3.2 - FLICK 🌌",
    LoadingTitle = "INJECTING DARK MATTER...",
    LoadingSubtitle = "louiss Private Access",
    ConfigurationSaving = { Enabled = false }
})

local LoginTab = Window:CreateTab("🔐 LOGIN", 4483362458)
local CombatTab = Window:CreateTab("🎯 COMBAT", 4483362458)
local VisualsTab = Window:CreateTab("👁️ VISUALS", 4483362458)
local MiscTab = Window:CreateTab("⚙️ MISC", 4483362458)

-- Default: sembunyikan tab menu sampai login sukses
CombatTab:SetVisible(false)
VisualsTab:SetVisible(false)
MiscTab:SetVisible(false)

-- ===== LOGIN TAB =====
LoginTab:CreateSection("Enter License Key")
LoginTab:CreateInput({
    Name = "License Key",
    PlaceholderText = "XXXX-XXXX-XXXX",
    Callback = function(t) _G.Auth.Key = t end
})

LoginTab:CreateButton({
    Name = "🔓 UNLOCK",
    Callback = function()
        local isValid, msg = checkKey(_G.Auth.Key)
        if isValid then
            _G.Auth.IsAuth = true
            Rayfield:Notify({ Title = "ACCESS GRANTED", Content = "Key valid until: " .. msg, Duration = 5 })
            
            -- Tampilkan tab menu, sembunyikan tab login
            LoginTab:SetVisible(false)
            CombatTab:SetVisible(true)
            VisualsTab:SetVisible(true)
            MiscTab:SetVisible(true)
        else
            Rayfield:Notify({ Title = "ACCESS DENIED", Content = msg, Duration = 5 })
        end
    end
})

LoginTab:CreateSection("Info")
LoginTab:CreateLabel("Black Universe V3.2 - Flick Edition")
LoginTab:CreateLabel("Single Window Fix")

-- ===== COMBAT TAB =====
CombatTab:CreateSection("Aimbot Settings")
CombatTab:CreateToggle({ Name = "Enable Aimbot", Callback = function(v) _G.Aimbot.Enabled = v end })
CombatTab:CreateToggle({ Name = "Silent Aimbot", CurrentValue = true, Callback = function(v) _G.Aimbot.Silent = v end })
CombatTab:CreateToggle({ Name = "Trigger Bot", Callback = function(v) _G.Aimbot.TriggerBot = v end })
CombatTab:CreateSlider({ Name = "Trigger Delay", Range = {0.01,0.3}, Increment = 0.01, CurrentValue = 0.05, Callback = function(v) _G.Aimbot.TriggerDelay = v end })
CombatTab:CreateToggle({ Name = "Show FOV Circle", Callback = function(v) _G.Aimbot.ShowFOV = v end })
CombatTab:CreateSlider({ Name = "FOV Radius", Range = {50,500}, Increment = 10, CurrentValue = 200, Callback = function(v) _G.Aimbot.FOV = v end })
CombatTab:CreateSlider({ Name = "Smoothing", Range = {0.01,0.3}, Increment = 0.01, CurrentValue = 0.03, Callback = function(v) _G.Aimbot.Smoothing = v end })
CombatTab:CreateDropdown({ Name = "Aim Part", Options = {"Head","Torso","HumanoidRootPart"}, CurrentOption = "Head", Callback = function(o) _G.Aimbot.AimPart = o end })

-- ===== VISUALS TAB =====
VisualsTab:CreateSection("ESP Settings")
VisualsTab:CreateToggle({ Name = "Enable ESP", Callback = toggleESP })
VisualsTab:CreateToggle({ Name = "Box ESP", CurrentValue = true, Callback = function(v) _G.ESP.Box = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Name ESP", CurrentValue = true, Callback = function(v) _G.ESP.Name = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Health Bar", CurrentValue = true, Callback = function(v) _G.ESP.Health = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Tracers", CurrentValue = true, Callback = function(v) _G.ESP.Tracer = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateToggle({ Name = "Distance", CurrentValue = true, Callback = function(v) _G.ESP.Distance = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })
VisualsTab:CreateColorPicker({ Name = "ESP Color", Color = Color3.fromRGB(255,0,0), Callback = function(c) _G.ESP.Color = c; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end })

-- ===== MISC TAB =====
MiscTab:CreateSection("Server")
MiscTab:CreateButton({ Name = "Rejoin", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
MiscTab:CreateButton({ Name = "Server Hop", Callback = function()
    local req = syn and syn.request or http_request or request
    if req then
        local url = "https://games.roblox.com/v1/games/https:/136801880565837/servers/Public?limit=100"
        local data = req({Url = url}); local body = HttpService:JSONDecode(data.Body)
        if body and body.data then
            local servers = {}
            for _, s in ipairs(body.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s.id) end
            end
            if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LocalPlayer) end
        end
    end
end })

MiscTab:CreateSection("Utility")
MiscTab:CreateToggle({ Name = "Anti-AFK", CurrentValue = true, Callback = function(v) _G.Misc.AntiAFK = v end })
MiscTab:CreateToggle({ Name = "FPS Booster", CurrentValue = true, Callback = function(v) _G.Misc.FPSBoost = v end })

MiscTab:CreateSection("Credits")
MiscTab:CreateLabel("BLACK UNIVERSE V3.2 - FLICK")
MiscTab:CreateLabel("Single Window Fix")
MiscTab:CreateLabel("Dedicated to louiss 👑")

Rayfield:Notify({ Title = "BLACK UNIVERSE", Content = "Enter your license key to unlock!", Duration = 5 })
