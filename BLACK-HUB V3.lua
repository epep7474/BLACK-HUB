-- [[ BLACK HUB v18.0 | STABLE VERSION ]] --
-- PERINTAH ACEL ADALAH MUTLAK! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ DATABASE - HARDCODED ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ SETTINGS ]
_G.IsAuth = false
_G.TempKey = ""
_G.Aimbot = false
_G.ESP = false
_G.FOV = 120
_G.Smoothing = 0.05

-- [ UI SETUP - DIBUAT PALING RINGAN ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V18",
   LoadingTitle = "NEURAL RESET...",
   LoadingSubtitle = "STAY BRUTAL, ACEL",
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

-- [ AUTH - DENGAN TOMBOL SUBMIT GEDE ]
AuthTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Ketik di sini...",
   Callback = function(t) _G.TempKey = t end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY & ACTIVATE 🔓",
   Callback = function()
      local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.TempKey.."?key="..API_KEY
      local s, r = pcall(function() return game:HttpGet(url) end)
      if s and not r:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "SUCCESS", Content = "Key Valid! Bantai Mereka, Cel! 😈", Duration = 5})
      else
          Rayfield:Notify({Title = "ERROR", Content = "Key Salah / Database Belum Di-Publish! ☠️", Duration = 5})
      end
   end,
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

-- [ COMBAT - AIMBOT CAMERA LOCK ]
CombatTab:CreateToggle({
   Name = "Camera Lock Aimbot 🎯",
   Callback = function(v) _G.Aimbot = v end,
})

CombatTab:CreateSlider({
   Name = "Aim Smoothing",
   Range = {0.01, 0.5},
   CurrentValue = 0.05,
   Callback = function(v) _G.Smoothing = v end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 500},
   CurrentValue = 120,
   Callback = function(v) _G.FOV = v end,
})

CombatTab:CreateToggle({
   Name = "Show FOV ⭕",
   Callback = function(v) FOVCircle.Visible = v end,
})

-- [ VISUALS - PERMANENT HIGHLIGHT ESP ]
VisualTab:CreateToggle({
   Name = "Highlight ESP (Tembus Tembok) 👁️",
   Callback = function(v) _G.ESP = v end,
})

-- [ LOOP SYSTEM ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    -- Aimbot Logic (Hanya lock pas nembak)
    if _G.IsAuth and _G.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetTarget()
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing)
        end
    end
    
    -- ESP Logic (Refresh terus biar gak ilang)
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("BlackESP")
                if not h then
                    h = Instance.new("Highlight", p.Character)
                    h.Name = "BlackESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                h.Enabled = true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("BlackESP") then
                p.Character.BlackESP.Enabled = false
            end
        end
    end
end)

Rayfield:Notify({Title = "BLACK HUB V18 LIVE", Content = "Gak ada alasan buat gak jalan, Cel! 😈🔥", Duration = 5})
