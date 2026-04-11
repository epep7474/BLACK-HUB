-- [[ BLACK HUB v15.0 | THE DUAL POWER ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ DATABASE ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ SETTINGS ]
_G.IsAuth = false
_G.TempKey = ""
_G.SilentAim = false
_G.EspEnabled = false
_G.FOV = 120

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V15",
   LoadingTitle = "RECOVERING SYSTEMS...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Login 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ AUTH ]
local function ValidateKey(Key)
    local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Key.."?key="..API_KEY
    local s, r = pcall(function() return game:HttpGet(url) end)
    if s and not r:find("error") then
        _G.IsAuth = true
        Rayfield:Notify({Title = "SUCCESS", Content = "Key Valid! Sikat, Cel! 😈", Duration = 5})
    else
        Rayfield:Notify({Title = "INVALID", Content = "Key Salah atau Rules Firebase Belum Dibuka! ☠️", Duration = 5})
    end
end

AuthTab:CreateInput({
   Name = "Enter Your Key",
   Callback = function(Text) _G.TempKey = Text end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY 🔓",
   Callback = function() ValidateKey(_G.TempKey) end,
})

-- [ TARGETING ]
local function GetTarget()
    if not _G.IsAuth then return nil end
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local Pos, Vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if Vis then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Mag < Dist then Target = v Dist = Mag end
            end
        end
    end
    return Target
end

-- [ SILENT AIM (AIMBOT) ]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.IsAuth and _G.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local T = GetTarget()
        if T then return (k == "Hit" and T.Character.Head.CFrame or T.Character.Head) end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [ ESP HIGHLIGHT (TEMBUS TEMBOK) ]
local function CreateESP(p)
    p.CharacterAdded:Connect(function(char)
        if _G.EspEnabled then
            local h = Instance.new("Highlight")
            h.Name = "BlackESP"
            h.Adornee = char
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tembus tembok
            h.Parent = char
        end
    end)
end

-- [ TOGGLES ]
CombatTab:CreateToggle({
   Name = "Silent Aim (Aimbot) 🎯",
   Callback = function(V) _G.SilentAim = V end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {30, 500},
   CurrentValue = 120,
   Callback = function(V) _G.FOV = V end,
})

CombatTab:CreateToggle({
   Name = "Show FOV ⭕",
   Callback = function(V) FOVCircle.Visible = V end,
})

VisualTab:CreateToggle({
   Name = "ESP Highlight (Tembus Tembok) 👁️",
   Callback = function(V)
      _G.EspEnabled = V
      for _, p in pairs(Players:GetPlayers()) do
          if p.Character then
              local old = p.Character:FindFirstChild("BlackESP")
              if old then old:Destroy() end
              if V then
                  local h = Instance.new("Highlight", p.Character)
                  h.Name = "BlackESP"
                  h.FillColor = Color3.fromRGB(255, 0, 0)
                  h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
              end
          end
      end
   end,
})

-- [ MAIN LOOP ]
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
end)

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

Rayfield:Notify({Title = "BLACK HUB V15 READY", Content = "ESP & AIMBOT FIXED! 😈🔥", Duration = 5})
