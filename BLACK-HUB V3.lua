-- [[ BLACK HUB v3.4 | UNIVERSAL ESP EDITION ]] --
-- PERINTAH ACEL ADALAH MUTLAK, ANCURIN SEMUANYA 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3.4",
   LoadingTitle = "REFIXING ESP ENGINE...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE & SETTINGS ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.HeadLock = false
_G.FOV = 120
_G.Smoothing = 0.05
_G.BoneESP = false
_G.BoxESP = false
_G.ESPColor = Color3.fromRGB(255, 0, 0)

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false

-- [ BONE STRUCTURES ]
local R15_Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
}
local R6_Bones = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

-- [ ESP FUNCTION ]
local function CreateESP(Player)
    local Lines = {}
    local Box = Drawing.new("Square")
    Box.Thickness = 1
    Box.Filled = false
    Box.Visible = false
    Box.Color = _G.ESPColor

    for i = 1, 15 do
        local Line = Drawing.new("Line")
        Line.Visible = false
        Line.Color = _G.ESPColor
        Line.Thickness = 1
        table.insert(Lines, Line)
    end

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 and Player ~= LocalPlayer then
                local Char = Player.Character
                local Root = Char.HumanoidRootPart
                local Pos, Visible = Camera:WorldToViewportPoint(Root.Position)

                -- [ BOX ESP ]
                if _G.BoxESP and Visible then
                    local Scale = 1000 / Pos.Z
                    Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                    Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                    Box.Visible = true
                    Box.Color = _G.ESPColor
                else
                    Box.Visible = false
                end

                -- [ BONE ESP ]
                if _G.BoneESP and Visible then
                    local Bones = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and R15_Bones or R6_Bones
                    for i, BonePair in pairs(Bones) do
                        local p1, p2 = Char:FindFirstChild(BonePair[1]), Char:FindFirstChild(BonePair[2])
                        if p1 and p2 then
                            local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                            if vis1 and vis2 then
                                Lines[i].From = Vector2.new(pos1.X, pos1.Y)
                                Lines[i].To = Vector2.new(pos2.X, pos2.Y)
                                Lines[i].Visible = true
                                Lines[i].Color = _G.ESPColor
                            else Lines[i].Visible = false end
                        else Lines[i].Visible = false end
                    end
                else
                    for _, l in pairs(Lines) do l.Visible = false end
                end
            else
                Box.Visible = false
                for _, l in pairs(Lines) do l.Visible = false end
                if not Player.Parent then
                    Box:Remove()
                    for _, l in pairs(Lines) do l:Remove() end
                    Connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- [ AIMBOT LOGIC ]
local function GetTarget()
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

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    if _G.HeadLock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing) end
    end
end)

-- [ UI ]
local MainTab = Window:CreateTab("Combat 🎯", 4483362458)
MainTab:CreateToggle({Name = "Head Lock 🔒", CurrentValue = false, Callback = function(V) _G.HeadLock = V end})
MainTab:CreateSlider({Name = "FOV Size", Range = {50, 500}, Increment = 10, CurrentValue = 120, Callback = function(V) _G.FOV = V end})
MainTab:CreateToggle({Name = "Show FOV ⭕", CurrentValue = false, Callback = function(V) FOVCircle.Visible = V end})

local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP 📦", CurrentValue = false, Callback = function(V) _G.BoxESP = V end})
VisualTab:CreateToggle({Name = "Bone ESP 💀", CurrentValue = false, Callback = function(V) _G.BoneESP = V end})
VisualTab:CreateColorPicker({Name = "ESP Color", Color = Color3.fromRGB(255, 0, 0), Callback = function(V) _G.ESPColor = V end})

Rayfield:Notify({Title = "BLACK HUB V3.4", Content = "ESP Fixed & Universal! 😈🔥", Duration = 5})
