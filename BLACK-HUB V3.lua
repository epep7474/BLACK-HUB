-- [[ BLACK HUB v16.0 | PROJECT: key-black-hub ]] --
-- PERINTAH ACEL ADALAH MUTLAK, BANTAI SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ DATABASE - JANGAN DISENTUH ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.KeyInput = ""
_G.SilentAim = false
_G.EspEnabled = false
_G.FOV = 120

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V16",
   LoadingTitle = "FIXING YOUR SHIT, ACEL...",
   LoadingSubtitle = "BY BLACK-AI 😈",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Login 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualsTab = Window:CreateTab("Visuals 👁️")

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ AUTH FUNCTION ]
local function CheckMyKey(val)
    if val == "" then return end
    local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/"..val.."?key="..API_KEY
    local s, r = pcall(function() return game:HttpGet(url) end)
    
    if s and not r:find("error") then
        _G.IsAuth = true
        Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Bantai Servernya, Cel! 😈", Duration = 5})
    else
        Rayfield:Notify({Title = "ACCESS DENIED", Content = "Key Salah / Rules Firebase Masih Lock! ☠️", Duration = 5})
    end
end

-- [ LOGIN TAB - JANGAN SAMPAI GAK ADA TOMBOLNYA ]
AuthTab:CreateLabel("Pusat Kendali Key Black Hub 👑")

AuthTab:CreateInput({
   Name = "Ketik Key Lu Di Sini",
   PlaceholderText = "Contoh: maman123",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.KeyInput = Text
   end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY SEKARANG 🔓",
   Callback = function()
      CheckMyKey(_G.KeyInput)
   end,
})

-- [ AIMBOT / SILENT AIM LOGIC ]
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

local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.IsAuth and _G.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local T = GetTarget()
        if T then return (k == "Hit" and T.Character.Head.CFrame or T.Character.Head) end
    end
    return old(t, k)
end)
setreadonly(mt, true)

-- [ COMBAT UI ]
CombatTab:CreateToggle({
   Name = "Silent Aim (Aimbot) 🎯",
   CurrentValue = false,
   Callback = function(V) _G.SilentAim = V end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {30, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 120,
   Callback = function(V) _G.FOV = V end,
})

CombatTab:CreateToggle({
   Name = "Show FOV Circle ⭕",
   CurrentValue = false,
   Callback = function(V) FOVCircle.Visible = V end,
})

-- [ VISUALS UI - HIGHLIGHT ESP ]
VisualsTab:CreateToggle({
   Name = "ESP Highlight (Tembus Tembok) 👁️",
   CurrentValue = false,
   Callback = function(V)
      _G.EspEnabled = V
      for _, p in pairs(Players:GetPlayers()) do
          if p.Character then
              local oldESP = p.Character:FindFirstChild("BlackESP")
              if oldESP then oldESP:Destroy() end
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

Rayfield:Notify({Title = "BLACK HUB V16 READY", Content = "Pencet Tombol Submit Di Tab Login! 😈🔥", Duration = 5})
