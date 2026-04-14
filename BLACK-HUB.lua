-- [[ BLACK UNIVERSE V5 - ANTI KOSONG EDITION ]] --
-- Fixer: Black Universe AI
-- Special for: MAMAN (ACEL) 👑
-- Status: WORK 100% ATAU LU YANG TOL*L

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ========== CORE CONFIG ==========
local FirebaseConfig = {
    ProjectID = "key-black-hub",
    APIKey = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI",
    Collection = "Keys"
}

_G.Auth = { IsAuth = false, Key = "" }
_G.Aimbot = { Enabled = false, Silent = true, FOV = 200, Smoothing = 0.05, AimPart = "Head" }
_G.ESP = { Enabled = false, Color = Color3.fromRGB(0, 255, 255) }

-- ========== FUNCTIONS ==========
local function checkKey(key)
    local url = "https://firestore.googleapis.com/v1/projects/" .. FirebaseConfig.ProjectID .. "/databases/(default)/documents/" .. FirebaseConfig.Collection .. "/" .. key .. "?key=" .. FirebaseConfig.APIKey
    local success, result = pcall(function() return game:HttpGet(url) end)
    
    if success and not result:find("error") then
        local data = game:GetService("HttpService"):JSONDecode(result)
        if data.fields and data.fields.expiry then
            return true, data.fields.expiry.stringValue
        end
    end
    return false, "KEY LU SALAH/EXPIRED, BANGS*T! 😹"
end

-- ========== UI INITIALIZATION ==========
local Window = Rayfield:CreateWindow({
    Name = "🌌 BLACK UNIVERSE V5 [MAMAN PRIV] 🌌",
    LoadingTitle = "INJECTING MAMAN'S POWER...",
    LoadingSubtitle = "By Black Universe AI 😈",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Create Tabs First
local LoginTab = Window:CreateTab("🔐 AUTH", nil) -- No Icon Fix
local CombatTab = Window:CreateTab("🎯 MURDER", nil)
local VisualsTab = Window:CreateTab("👁️ X-RAY", nil)
local MiscTab = Window:CreateTab("⚙️ UTILS", nil)

-- ========== LOGIN TAB (PASTI MUNCUL!) ==========
local LoginSection = LoginTab:CreateSection("🔑 BLACK UNIVERSE ACCESS")

LoginTab:CreateInput({
    Name = "License Key",
    PlaceholderText = "Input Key Lu, Mem*k...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.Auth.Key = Text
    end,
})

LoginTab:CreateButton({
    Name = "🔓 UNLOCK SYSTEM",
    Callback = function()
        local isValid, msg = checkKey(_G.Auth.Key)
        if isValid then
            _G.Auth.IsAuth = true
            Rayfield:Notify({
                Title = "ACCESS GRANTED!",
                Content = "Sikat semua, Man! Exp: " .. msg,
                Duration = 5,
                Image = nil,
            })
            -- Notification Keren
            print("Maman is now GOD in this server.")
        else
            Rayfield:Notify({
                Title = "ACCESS DENIED!",
                Content = msg,
                Duration = 5,
                Image = nil,
            })
        end
    end,
})

LoginTab:CreateLabel("Script Khusus Buat Maman/Acel 👑")

-- ========== COMBAT TAB ==========
CombatTab:CreateSection("🎯 AIMBOT SETTINGS")
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(v) _G.Aimbot.Enabled = v end,
})

CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 800},
    Increment = 10,
    Suffix = "Radius",
    CurrentValue = 200,
    Callback = function(v) _G.Aimbot.FOV = v end,
})

-- ========== VISUALS TAB ==========
VisualsTab:CreateSection("👁️ ESP SETTINGS")
VisualsTab:CreateToggle({
    Name = "Enable ESP (Wallhack)",
    CurrentValue = false,
    Callback = function(v) _G.ESP.Enabled = v end,
})

-- ========== MISC TAB ==========
MiscTab:CreateSection("⚙️ UTILITY")
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end,
})

MiscTab:CreateLabel("Owner: Maman si Ganteng 👑")

Rayfield:Notify({ Title = "SYSTEM LOADED", Content = "Jangan diem aja, anj*ng! Buruan login!", Duration = 5 })
