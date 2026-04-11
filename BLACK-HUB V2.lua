-- [[ BLACK HUB v2.0 - DEVELOPED BY ACEL ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB | BY ACEL 👑",
   LoadingTitle = "INJECTING BLACK-AI...",
   LoadingSubtitle = "STAY BRUTAL",
   ConfigurationSaving = { Enabled = false }
})

-- [ SETTINGS ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.AimbotFOV = 150
_G.AimbotSmoothing = 0.2
_G.ESPEnabled = false
_G.ESPBoxes = false

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ AIMBOT LOGIC ]
local function GetClosestPlayer()
    local Target = nil
    local Dist = _G.AimbotFOV
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

-- [ ESP LOGIC ]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if _G.ESPEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
                local RootPart = Player.Character.HumanoidRootPart
                local Pos, Visible = Camera:WorldToViewportPoint(RootPart.Position)
                
                if Visible then
                    local Scale = 1000 / Pos.Z
                    Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                    Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                    Box.Visible = _G.ESPBoxes
                else
                    Box.Visible = false
                end
            else
                Box.Visible = false
                if not Player.Parent then
                    Box:Remove()
                    Connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _, v in pairs(Players:GetPlayers()) do
    CreateESP(v)
end
Players.PlayerAdded:Connect(CreateESP)

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.AimbotFOV
    
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position), _G.AimbotSmoothing)
        end
    end
end)

-- [ UI TABS ]
local MainTab = Window:CreateTab("Combat 👽", 4483362458)

MainTab:CreateSection("Aimbot Settings")

MainTab:CreateToggle({
   Name = "Enable Aimbot 🎯",
   CurrentValue = false,
   Callback = function(Value) _G.AimbotEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "Show FOV ⭕",
   CurrentValue = false,
   Callback = function(Value) FOVCircle.Visible = Value end,
})

MainTab:CreateSlider({
   Name = "FOV Radius",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) _G.AimbotFOV = Value end,
})

local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)

VisualTab:CreateToggle({
   Name = "Master ESP 💀",
   CurrentValue = false,
   Callback = function(Value) _G.ESPEnabled = Value end,
})

VisualTab:CreateToggle({
   Name = "ESP Boxes 📦",
   CurrentValue = false,
   Callback = function(Value) _G.ESPBoxes = Value end,
})

Rayfield:Notify({
   Title = "BLACK HUB AKTIV",
   Content = "Selamat Berburu, Acel! 😈",
   Duration = 5
})
