-- [[ BLACK UNIVERSE V7 - ORION EDITION ]] --
-- Library: Orion (Stable for Android)
-- Firebase: key-black-hub

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "BLACK UNIVERSE V7", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Firebase Config
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

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ESP Storage
local ESPConnections = {}
local ESPElements = {}

-- Functions
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

-- ESP Logic (sama seperti sebelumnya, disingkat agar muat)
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

-- Main Loops
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
-- PART 2: UI Creation & Auth

-- Create Tabs (akan diisi nanti)
local CombatTab, VisualsTab, MiscTab

-- Fungsi buat build UI setelah login
local function BuildMainUI()
    CombatTab = Window:MakeTab({Name = "COMBAT", Icon = "rbxassetid://4483362458", PremiumOnly = false})
    VisualsTab = Window:MakeTab({Name = "VISUALS", Icon = "rbxassetid://4483362458", PremiumOnly = false})
    MiscTab = Window:MakeTab({Name = "MISC", Icon = "rbxassetid://4483362458", PremiumOnly = false})
    
    -- Combat Tab
    CombatTab:AddToggle({Name = "Enable Aimbot", Default = false, Callback = function(v) _G.Aimbot.Enabled = v end})
    CombatTab:AddToggle({Name = "Silent Aimbot", Default = true, Callback = function(v) _G.Aimbot.Silent = v end})
    CombatTab:AddToggle({Name = "Trigger Bot", Default = false, Callback = function(v) _G.Aimbot.TriggerBot = v end})
    CombatTab:AddToggle({Name = "Show FOV Circle", Default = false, Callback = function(v) _G.Aimbot.ShowFOV = v end})
    CombatTab:AddSlider({Name = "FOV Radius", Min = 50, Max = 500, Default = 200, Color = Color3.fromRGB(255,0,0), Increment = 10, Callback = function(v) _G.Aimbot.FOV = v end})
    CombatTab:AddSlider({Name = "Smoothing", Min = 0.01, Max = 0.3, Default = 0.03, Color = Color3.fromRGB(255,0,0), Increment = 0.01, Callback = function(v) _G.Aimbot.Smoothing = v end})
    CombatTab:AddSlider({Name = "Trigger Delay", Min = 0.01, Max = 0.3, Default = 0.05, Color = Color3.fromRGB(255,0,0), Increment = 0.01, Callback = function(v) _G.Aimbot.TriggerDelay = v end})
    CombatTab:AddDropdown({Name = "Aim Part", Default = "Head", Options = {"Head","Torso","HumanoidRootPart"}, Callback = function(v) _G.Aimbot.AimPart = v end})
    
    -- Visuals Tab
    VisualsTab:AddToggle({Name = "Enable ESP", Default = false, Callback = toggleESP})
    VisualsTab:AddToggle({Name = "Box ESP", Default = true, Callback = function(v) _G.ESP.Box = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end})
    VisualsTab:AddToggle({Name = "Name ESP", Default = true, Callback = function(v) _G.ESP.Name = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end})
    VisualsTab:AddToggle({Name = "Health Bar", Default = true, Callback = function(v) _G.ESP.Health = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end})
    VisualsTab:AddToggle({Name = "Tracers", Default = true, Callback = function(v) _G.ESP.Tracer = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end})
    VisualsTab:AddToggle({Name = "Distance", Default = true, Callback = function(v) _G.ESP.Distance = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end})
    
    -- Misc Tab
    MiscTab:AddToggle({Name = "Anti-AFK", Default = true, Callback = function(v) _G.Misc.AntiAFK = v end})
    MiscTab:AddToggle({Name = "FPS Booster", Default = true, Callback = function(v) _G.Misc.FPSBoost = v end})
    MiscTab:AddButton({Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})
    MiscTab:AddButton({Name = "Server Hop", Callback = function()
        local req = syn and syn.request or http_request or request
        if req then
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
            local data = req({Url = url}); local body = HttpService:JSONDecode(data.Body)
            if body and body.data then
                local servers = {}
                for _, s in ipairs(body.data) do
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s.id) end
                end
                if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LocalPlayer) end
            end
        end
    end})
    
    OrionLib:MakeNotification({Name = "ACCESS GRANTED", Content = "Welcome to Black Universe V7", Time = 5})
end

-- Login Tab
local LoginTab = Window:MakeTab({Name = "LOGIN", Icon = "rbxassetid://4483362458", PremiumOnly = false})
LoginTab:AddTextbox({Name = "License Key", Default = "", TextDisappear = false, Callback = function(v) _G.Auth.Key = v end})
LoginTab:AddButton({Name = "UNLOCK", Callback = function()
    if _G.Auth.Key == "" then
        OrionLib:MakeNotification({Name = "ERROR", Content = "Masukkan key dulu!", Time = 3})
        return
    end
    local isValid, msg = checkKey(_G.Auth.Key)
    if isValid then
        _G.Auth.IsAuth = true
        OrionLib:MakeNotification({Name = "SUKSES", Content = "Key valid until: " .. msg, Time = 5})
        -- Hapus tab login, bangun menu utama
        Window:Destroy()
        Window = OrionLib:MakeWindow({Name = "BLACK UNIVERSE V7", HidePremium = false, SaveConfig = false, IntroEnabled = false})
        BuildMainUI()
        OrionLib:MakeNotification({Name = "READY", Content = "Fitur sudah aktif. Selamat berburu!", Time = 5})
    else
        OrionLib:MakeNotification({Name = "GAGAL", Content = msg, Time = 5})
    end
end})

OrionLib:MakeNotification({Name = "BLACK UNIVERSE", Content = "Masukkan license key untuk unlock!", Time = 5})
