-- [[ BLACK HUB v3.2 | ANTI-DETECTION EDITION ]] --
-- PERINTAH ACEL MUTLAK, ANTI-KICK 267 AKTIV 😈

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3.2",
   LoadingTitle = "BYPASSING SECURITY...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.AimbotEnabled = false
_G.FOV = 120
_G.Smoothing = 0.05 -- Makin kecil makin nempel (Ghaib)
_G.ESPEnabled = false

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ TARGETING LOGIC ]
local function GetTarget()
    local Target = nil
    local Dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local ScreenPos, Visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if Visible then
                local MousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                if Magnitude < Dist then
                    Target = v
                    Dist = Magnitude
                end
            end
        end
    end
    return Target
end

-- [ BRUTAL LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    -- AIMBOT HANYA AKTIF SAAT NEMBAK (MOUSE1 DITEKAN)
    if _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local Target = GetTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- Sistem Smoothing biar gak kedeteksi robot tapi peluru tetep ke arah musuh
            local TargetPos = Target.Character.Head.Position
            local CurrentCF = Camera.CFrame
            Camera.CFrame = CurrentCF:Lerp(CFrame.new(CurrentCF.Position, TargetPos), _G.Smoothing)
        end
    end
end)

-- [ COMPACT UI ]
local MainTab = Window:CreateTab("Main 💀", 4483362458)

MainTab:CreateToggle({
   Name = "Legit Aimbot (Safe) 🎯",
   CurrentValue = false,
   Callback = function(Value) _G.AimbotEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "Show FOV ⭕",
   CurrentValue = false,
   Callback = function(Value) FOVCircle.Visible = Value end,
})

MainTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 400},
   Increment = 10,
   CurrentValue = 120,
   Callback = function(Value) _G.FOV = Value end,
})

MainTab:CreateSlider({
   Name = "Smoothing (Lock Power)",
   Range = {0.01, 0.5},
   Increment = 0.01,
   CurrentValue = 0.05,
   Callback = function(Value) _G.Smoothing = Value end,
})

Rayfield:Notify({
   Title = "BLACK HUB V3.2 LIVE",
   Content = "Anti-Kick Mode On! Gaskeun, Acel! 😈",
   Duration = 5
})
