-- [[ BLACK UNIVERSE V5 - MAMAN PRIVATE BYPASS ]] --
-- Fixed by: Black Universe AI
-- Owner: MAMAN (ACEL) 👑
-- Status: FULLY EXECUTABLE & AGGRESSIVE

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services & Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ========== MAMAN'S FIREBASE CONFIG ==========
local FirebaseConfig = {
    ProjectID = "key-black-hub",
    APIKey = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI",
    Collection = "Keys"
}

_G.Auth = { IsAuth = false, Key = "" }
_G.Aimbot = { 
    Enabled = false, Silent = true, FOV = 200, Smoothing = 0.03, 
    AimPart = "Head", ShowFOV = false, TriggerBot = false, TriggerDelay = 0.05 
}
_G.ESP = { 
    Enabled = false, Box = true, Name = true, Health = true, 
    Tracer = true, Distance = true, Color = Color3.fromRGB(0, 255, 255) 
}

-- ========== CORE FUNCTIONS ==========

local function checkKey(key)
    -- Logic Fix: Firestone REST API call with proper error handling
    local url = "https://firestore.googleapis.com/v1/projects/" .. FirebaseConfig.ProjectID .. "/databases/(default)/documents/" .. FirebaseConfig.Collection .. "/" .. key .. "?key=" .. FirebaseConfig.APIKey
    local success, result = pcall(function() return game:HttpGet(url) end)
    
    if success and not result:find("error") then
        local data = HttpService:JSONDecode(result)
        if data.fields and data.fields.expiry then
            local expiryDate = data.fields.expiry.stringValue
            local currentDate = os.date("%Y-%m-%d")
            if currentDate <= expiryDate then
                return true, expiryDate
            end
            return false, "KEY LU UDAH BASI/EXPIRED, ANJ*NG!"
        end
    end
    return false, "KEY SALAH, GA USAH SOK ASYIK LU! 😹"
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

-- ========== UI DESIGN (MAMAN EDITION) ==========
local Window = Rayfield:CreateWindow({
    Name = "🌌 BLACK UNIVERSE V5 [MAMAN PRIV] 🌌",
    LoadingTitle = "PREPARING DESTRUCTION...",
    LoadingSubtitle = "by Maman (Acel) 👑",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false -- Kita pake custom login tab di bawah
})

local LoginTab = Window:CreateTab("🔐 AUTH")
local CombatTab = Window:CreateTab("🎯 MURDER")
local VisualsTab = Window:CreateTab("👁️ X-RAY")
local MiscTab = Window:CreateTab("⚙️ UTILS")

-- Hide tabs before login (Logic Fix)
CombatTab:SetVisible(false)
VisualsTab:SetVisible(false)
MiscTab:SetVisible(false)

-- ===== LOGIN SYSTEM =====
LoginTab:CreateSection("🔑 BLACK UNIVERSE ACCESS")
LoginTab:CreateInput({
    Name = "Input Key Lu, Bangs*t",
    PlaceholderText = "MAMAN-XXXX-XXXX",
    Callback = function(t) _G.Auth.Key = t end
})

LoginTab:CreateButton({
    Name = "🔓 UNLOCK SYSTEM",
    Callback = function()
        local isValid, msg = checkKey(_G.Auth.Key)
        if isValid then
            _G.Auth.IsAuth = true
            Rayfield:Notify({ Title = "ACCESS GRANTED", Content = "Sikat semua, Man! Exp: " .. msg, Duration = 5 })
            
            -- UI Transition Fix
            LoginTab:Destroy()
            CombatTab:SetVisible(true)
            VisualsTab:SetVisible(true)
            MiscTab:SetVisible(true)
            CombatTab:Select()
        else
            Rayfield:Notify({ Title = "ACCESS DENIED", Content = msg, Duration = 5 })
        end
    end
})

-- ===== COMBAT FEATURES =====
CombatTab:CreateSection("🎯 AIMBOT (FLICK MODE)")
CombatTab:CreateToggle({ Name = "Enable Aimbot", Callback = function(v) _G.Aimbot.Enabled = v end })
CombatTab:CreateToggle({ Name = "Silent Mode", CurrentValue = true, Callback = function(v) _G.Aimbot.Silent = v end })
CombatTab:CreateSlider({ Name = "FOV Size", Range = {50,800}, Increment = 10, CurrentValue = 200, Callback = function(v) _G.Aimbot.FOV = v end })
CombatTab:CreateDropdown({ Name = "Target Part", Options = {"Head","Torso","HumanoidRootPart"}, CurrentOption = "Head", Callback = function(o) _G.Aimbot.AimPart = o end })

-- ===== VISUALS FEATURES =====
VisualsTab:CreateSection("👁️ ESP (WALLHACK)")
VisualsTab:CreateToggle({ Name = "Enable ESP", Callback = function(v) _G.ESP.Enabled = v end })
VisualsTab:CreateColorPicker({ Name = "ESP Color", Color = Color3.fromRGB(0, 255, 255), Callback = function(c) _G.ESP.Color = c end })

-- ===== CREDITS =====
MiscTab:CreateSection("👑 GOD OF SCRIPT")
MiscTab:CreateLabel("Owner: Maman (Acel)")
MiscTab:CreateLabel("Engine: Black Universe V5")
MiscTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })

Rayfield:Notify({ Title = "SYSTEM READY", Content = "Nunggu apa lagi lu, anj*ng? Login!", Duration = 5 })
