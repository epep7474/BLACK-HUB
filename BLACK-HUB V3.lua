-- [[ BLACK HUB v22.0 | FIX CANNOT SHOOT BUG ]] --
-- PERINTAH ACEL ADALAH MUTLAK, BANTAI SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ INTERNAL DATA ]
_G.IsAuth = false
_G.AcelKey = ""
_G.Aimbot = false
_G.ESP = false
_G.FOV = 120
_G.Smooth = 0.08 -- Kecepatan nempel (0.01 - 1)

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V22 | KILLER",
   LoadingTitle = "FIXING AIM SYSTEM...",
   LoadingSubtitle = "STAY BRUTAL, ACEL",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Login 🔑")
local Tab2 = Window:CreateTab("Combat 🎯")
local Tab3 = Window:CreateTab("Visuals 👁️")

-- [ FOV CIRCLE ]
local Circle = Drawing.new("Circle")
Circle.Thickness = 1; Circle.Color = Color3.fromRGB(0, 255, 255); Circle.Transparency = 0.5; Circle.Visible = false

-- [ LOGIN ]
Tab1:CreateInput({
   Name = "Input Key Lu",
   PlaceholderText = "Ketik di sini...",
   Callback = function(t) _G.AcelKey = t end,
})

Tab1:CreateButton({
   Name = "SUBMIT KEY SEKARANG! 🔓",
   Callback = function()
      local u = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.AcelKey.."?key=AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"
      local s, r = pcall(function() return game:HttpGet(u) end)
      if s and not r:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "BERHASIL!", Content = "Key Valid! Bantai Mereka, Cel! 😈", Duration = 5})
      else
          Rayfield:Notify({Title = "GAGAL!", Content = "Key Salah / Database Error! ☠️", Duration = 5})
      end
   end,
})

-- [ TARGETING ]
local function GetClosestTarget()
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

-- [ COMBAT ]
Tab2:CreateToggle({
   Name = "Camera Lock Aimbot (Auto Look) 🎯", 
   Callback = function(v) _G.Aimbot = v end
})

Tab2:CreateSlider({
   Name = "Aim Smoothness (Halus)", 
   Range = {0.01, 1}, 
   CurrentValue = 0.08, 
   Callback = function(v) _G.Smooth = v end
})

Tab2:CreateSlider({
   Name = "FOV Size", 
   Range = {50, 600}, 
   CurrentValue = 120, 
   Callback = function(v) _G.FOV = v end
})

Tab2:CreateToggle({
   Name = "Show FOV ⭕", 
   Callback = function(v) Circle.Visible = v end
})

-- [ VISUALS ]
Tab3:CreateToggle({
   Name = "ESP Highlight (Permanen) 👁️", 
   Callback = function(v) _G.ESP = v end
})

-- [ ENGINE LOOP ]
RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Radius = _G.FOV
    
    -- [[ AIMBOT CAMERA LOCK - PASTI BISA NEMBAK ]] --
    if _G.IsAuth and _G.Aimbot and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.Touch)) then
        local T = GetClosestTarget()
        if T then
            -- Bikin kamera otomatis nengok ke kepala musuh
            local TargetPos = T.Character.Head.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), _G.Smooth)
        end
    end
    
    -- ESP LOGIC (STABLE)
    if _G.ESP and _G.IsAuth then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                local h = p.Character:FindFirstChild("BlackHub_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "BlackHub_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Enabled = true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("BlackHub_ESP") then
                p.Character.BlackHub_ESP.Enabled = false
            end
        end
    end
end)

Rayfield:Notify({Title = "BLACK HUB V22 READY", Content = "Aim Fix! Gak bakal nyangkut lagi! 😈🔥", Duration = 5})
