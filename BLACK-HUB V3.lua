-- [[ BLACK HUB v3.1 | STABILIZED EDITION ]] --
-- PERINTAH ACEL MUTLAK, ANTI-KICK AKTIV 😈

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3.1",
   LoadingTitle = "STABILIZING BLACK-AI...",
   LoadingSubtitle = "BY ACEL 👑",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.SilentAim = false
_G.FOV = 120
_G.ESPEnabled = false

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ STABILIZED TARGETING ]
local function GetTarget()
    local Target = nil
    local Dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local ScreenPos, Visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if Visible then
                local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Magnitude < Dist then
                    Target = v
                    Dist = Magnitude
                end
            end
        end
    end
    return Target
end

-- [ STABILIZED SILENT AIM ]
-- Pake sistem Index Hook biar gak gampang kena 273
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local Target = GetTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            return (k == "Hit" and Target.Character.Head.CFrame or Target.Character.Head)
        end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- [ RENDER LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOV
end)

-- [ COMPACT UI ]
local MainTab = Window:CreateTab("Main 💀", 4483362458)

MainTab:CreateToggle({
   Name = "Silent Aim (Safe) 🎯",
   CurrentValue = false,
   Callback = function(Value) _G.SilentAim = Value end,
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

Rayfield:Notify({
   Title = "BLACK HUB STABILIZED",
   Content = "Gak bakal mental lagi, Acel! 😈",
   Duration = 5
})
