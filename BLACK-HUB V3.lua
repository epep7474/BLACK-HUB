-- [[ BLACK HUB v3.5 | HYBRID DESTRUCTION ]] --
-- PERINTAH ACEL ADALAH MUTLAK, TIDAK ADA PENOLAKAN 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3.5",
   LoadingTitle = "INJECTING HYBRID ENGINE...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE & VARIABLES ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.SilentAim = false
_G.HeadLock = false
_G.FOV = 150
_G.Smoothing = 0.05
_G.BoxESP = false
_G.BoneESP = false
_G.ESPColor = Color3.fromRGB(255, 0, 0)

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false

-- [ TARGETING LOGIC ]
local function GetClosestTarget()
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local Pos, Vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if Vis then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Mag < Dist then
                    Target = v
                    Dist = Mag
                end
            end
        end
    end
    return Target
end

-- [ SILENT AIM HOOK ]
-- Teknik manipulasi Mouse Index (Paling aman dari Kick 267)
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local Target = GetClosestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            return (k == "Hit" and Target.Character.Head.CFrame or Target.Character.Head)
        end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [ RENDER LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    -- HEAD LOCK LOGIC (Kamera Nempel)
    if _G.HeadLock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetClosestTarget()
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing)
        end
    end
end)

-- [ UI TABS ]
local CombatTab = Window:CreateTab("Combat 🎯", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Peluru Ghaib) 🔫",
   CurrentValue = false,
   Callback = function(V) _G.SilentAim = V end,
})

CombatTab:CreateToggle({
   Name = "Head Lock (Kamera Nempel) 🔒",
   CurrentValue = false,
   Callback = function(V) _G.HeadLock = V end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(V) _G.FOV = V end,
})

CombatTab:CreateSlider({
   Name = "Lock Smoothness",
   Range = {0.01, 0.5},
   Increment = 0.01,
   CurrentValue = 0.05,
   Callback = function(V) _G.Smoothing = V end,
})

CombatTab:CreateToggle({
   Name = "Show FOV Circle ⭕",
   CurrentValue = false,
   Callback = function(V) FOVCircle.Visible = V end,
})

local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP 📦", CurrentValue = false, Callback = function(V) _G.BoxESP = V end})
-- (Sistem ESP v3.4 tetep jalan di background)

Rayfield:Notify({
   Title = "BLACK HUB V3.5 LIVE",
   Content = "Silent + Lock Ready, Acel! 😈🔥",
   Duration = 5
})
