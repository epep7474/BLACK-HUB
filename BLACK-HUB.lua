-- [[ BLACK UNIVERSE V6 - FLICK EDITION (NATIVE UI) PART 1/2 ]] --
-- Firebase: key-black-hub | Expiry: YYYY-MM-DD

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

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

-- Firebase Auth Check
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

-- ========== NATIVE UI CREATION ==========
local BlackUI = Instance.new("ScreenGui")
BlackUI.Name = "BlackUniverseV6"
BlackUI.Parent = CoreGui

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 350, 0, 400)
MainWindow.Position = UDim2.new(0.5, -175, 0.5, -200)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Parent = BlackUI

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "BLACK UNIVERSE V6 - LOGIN"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function() BlackUI:Destroy() end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainWindow

-- Login Page
local LoginPage = Instance.new("Frame")
LoginPage.Size = UDim2.new(1, 0, 1, 0)
LoginPage.BackgroundTransparency = 1
LoginPage.Parent = ContentFrame

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -20, 0, 25)
KeyLabel.Position = UDim2.new(0, 10, 0, 20)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Enter License Key:"
KeyLabel.TextColor3 = Color3.new(1, 1, 1)
KeyLabel.Font = Enum.Font.SourceSans
KeyLabel.TextSize = 14
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = LoginPage

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 0, 35)
KeyInput.Position = UDim2.new(0, 10, 0, 50)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.PlaceholderText = "XXXX-XXXX-XXXX"
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = LoginPage

local UnlockButton = Instance.new("TextButton")
UnlockButton.Size = UDim2.new(1, -20, 0, 40)
UnlockButton.Position = UDim2.new(0, 10, 0, 100)
UnlockButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
UnlockButton.Text = "UNLOCK"
UnlockButton.TextColor3 = Color3.new(1, 1, 1)
UnlockButton.Font = Enum.Font.SourceSansBold
UnlockButton.TextSize = 16
UnlockButton.Parent = LoginPage

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 160)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Waiting..."
StatusLabel.TextColor3 = Color3.new(1, 1, 0)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = LoginPage

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 40)
InfoLabel.Position = UDim2.new(0, 10, 1, -60)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Black Universe V6\nDedicated to louiss 👑"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextSize = 12
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = LoginPage

-- Menu Page (Akan dibuat setelah login)
local MenuPage = nil
-- [[ BLACK UNIVERSE V6 - PART 2/2 ]] --
-- Lanjutan: Menu Page & Unlock Logic

local function CreateMenuPage()
    if MenuPage then return end
    MenuPage = Instance.new("Frame")
    MenuPage.Size = UDim2.new(1, 0, 1, 0)
    MenuPage.BackgroundTransparency = 1
    MenuPage.Visible = false
    MenuPage.Parent = ContentFrame
    
    -- Tab System Sederhana
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 0, 30)
    TabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabFrame.Parent = MenuPage
    
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, -35)
    TabContent.Position = UDim2.new(0, 0, 0, 35)
    TabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContent.Parent = MenuPage
    
    local function createTab(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, #TabFrame:GetChildren() * 100, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.Parent = TabFrame
        
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = TabContent
        
        btn.MouseButton1Click:Connect(function()
            for _, p in ipairs(TabContent:GetChildren()) do p.Visible = false end
            page.Visible = true
        end)
        
        return page
    end
    
    local CombatPage = createTab("COMBAT")
    local VisualsPage = createTab("VISUALS")
    local MiscPage = createTab("MISC")
    
    -- Combat Page Elements
    local y = 10
    local function addToggle(page, text, default, callback)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1, -20, 0, 30)
        toggle.Position = UDim2.new(0, 10, 0, y)
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
        toggle.Text = text .. ": " .. (default and "ON" or "OFF")
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.Font = Enum.Font.SourceSans
        toggle.TextSize = 14
        toggle.Parent = page
        
        local state = default
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = text .. ": " .. (state and "ON" or "OFF")
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
            callback(state)
        end)
        y = y + 35
        return toggle
    end
    
    y = 10
    addToggle(CombatPage, "Enable Aimbot", false, function(v) _G.Aimbot.Enabled = v end)
    addToggle(CombatPage, "Silent Aimbot", true, function(v) _G.Aimbot.Silent = v end)
    addToggle(CombatPage, "Trigger Bot", false, function(v) _G.Aimbot.TriggerBot = v end)
    addToggle(CombatPage, "Show FOV Circle", false, function(v) _G.Aimbot.ShowFOV = v end)
    
    -- Sliders
    local function addSlider(page, text, min, max, default, callback)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, y)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = page
        y = y + 20
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, -20, 0, 30)
        input.Position = UDim2.new(0, 10, 0, y)
        input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        input.Text = tostring(default)
        input.TextColor3 = Color3.new(1, 1, 1)
        input.Font = Enum.Font.SourceSans
        input.TextSize = 14
        input.Parent = page
        
        input.FocusLost:Connect(function()
            local num = tonumber(input.Text)
            if num then
                num = math.clamp(num, min, max)
                input.Text = tostring(num)
                label.Text = text .. ": " .. num
                callback(num)
            end
        end)
        y = y + 35
        return input
    end
    
    y = y + 10
    addSlider(CombatPage, "FOV Radius", 50, 500, 200, function(v) _G.Aimbot.FOV = v end)
    addSlider(CombatPage, "Smoothing", 0.01, 0.3, 0.03, function(v) _G.Aimbot.Smoothing = v end)
    addSlider(CombatPage, "Trigger Delay", 0.01, 0.3, 0.05, function(v) _G.Aimbot.TriggerDelay = v end)
    
    -- Visuals Page
    y = 10
    addToggle(VisualsPage, "Enable ESP", false, toggleESP)
    addToggle(VisualsPage, "Box ESP", true, function(v) _G.ESP.Box = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end)
    addToggle(VisualsPage, "Name ESP", true, function(v) _G.ESP.Name = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end)
    addToggle(VisualsPage, "Health Bar", true, function(v) _G.ESP.Health = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end)
    addToggle(VisualsPage, "Tracers", true, function(v) _G.ESP.Tracer = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end)
    addToggle(VisualsPage, "Distance", true, function(v) _G.ESP.Distance = v; if _G.ESP.Enabled then toggleESP(false); toggleESP(true) end end)
    
    -- Misc Page
    y = 10
    addToggle(MiscPage, "Anti-AFK", true, function(v) _G.Misc.AntiAFK = v end)
    addToggle(MiscPage, "FPS Booster", true, function(v) _G.Misc.FPSBoost = v end)
    
    local function addButton(page, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.Parent = page
        btn.MouseButton1Click:Connect(callback)
        y = y + 40
    end
    
    y = y + 10
    addButton(MiscPage, "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    addButton(MiscPage, "Server Hop", function()
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
    end)
    
    -- Default buka Combat tab
    TabFrame:GetChildren()[1].MouseButton1Click:Fire()
end

-- Unlock Logic
UnlockButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == "" then
        StatusLabel.Text = "Status: Masukkan key dulu!"
        return
    end
    
    StatusLabel.Text = "Status: Checking..."
    local isValid, msg = checkKey(key)
    if isValid then
        _G.Auth.IsAuth = true
        TitleText.Text = "BLACK UNIVERSE V6 - MENU"
        StatusLabel.Text = "Status: Access Granted! Exp: " .. msg
        LoginPage.Visible = false
        
        CreateMenuPage()
        MenuPage.Visible = true
        
        -- Notifikasi
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(1, -20, 0, 30)
        notif.Position = UDim2.new(0, 10, 1, -40)
        notif.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        notif.Text = "✅ ACCESS GRANTED!"
        notif.TextColor3 = Color3.new(1, 1, 1)
        notif.Font = Enum.Font.SourceSansBold
        notif.TextSize = 14
        notif.Parent = ContentFrame
        task.wait(3)
        notif:Destroy()
    else
        StatusLabel.Text = "Status: " .. msg
    end
end)

-- Notifikasi awal
local startNotif = Instance.new("TextLabel")
startNotif.Size = UDim2.new(1, -20, 0, 30)
startNotif.Position = UDim2.new(0, 10, 1, -40)
startNotif.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
startNotif.Text = "🔐 Masukkan License Key!"
startNotif.TextColor3 = Color3.new(1, 1, 1)
startNotif.Font = Enum.Font.SourceSansBold
startNotif.TextSize = 14
startNotif.Parent = ContentFrame
task.wait(3)
startNotif:Destroy()
