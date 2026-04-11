-- [[ BLACK HUB v3.3 | BONE & HEAD LOCK EDITION ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3.3",
   LoadingTitle = "LOADING BONE ENGINE...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE & VARIABLES ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.HeadLock = false
_G.FOV = 120
_G.Smoothing = 0.05 -- Makin kecil makin kenceng lock-nya
_G.BoneESP = false
_G.BoneColor = Color3.fromRGB(255, 0, 0)

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ TARGETING LOGIC ]
local function GetTarget()
    local Target = nil
    local Dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local ScreenPos, Visible = Camera:WorldToViewportPoint(v.Character.Head.Position)
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

-- [ BONE ESP LOGIC ]
local R15_Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, -- Spine
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, -- Left Arm
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, -- Right Arm
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, -- Left Leg
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"} -- Right Leg
}

local function CreateBoneESP(Player)
    local Bones = {}
    for _, _ in pairs(R15_Bones) do
        local Line = Drawing.new("Line")
        Line.Visible = false
        Line.Color = _G.BoneColor
        Line.Thickness = 1
        table.insert(Bones, Line)
    end

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if _G.BoneESP and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character.Humanoid.Health > 0 and Player ~= LocalPlayer then
                local Character = Player.Character
                local VisibleAll = false
                
                for i, BonePair in pairs(R15_Bones) do
                    local Part1 = Character:FindFirstChild(BonePair[1])
                    local Part2 = Character:FindFirstChild(BonePair[2])
                    
                    if Part1 and Part2 then
                        local Pos1, Vis1 = Camera:WorldToViewportPoint(Part1.Position)
                        local Pos2, Vis2 = Camera:WorldToViewportPoint(Part2.Position)
                        
                        if Vis1 and Vis2 then
                            Bones[i].From = Vector2.new(Pos1.X, Pos1.Y)
                            Bones[i].To = Vector2.new(Pos2.X, Pos2.Y)
                            Bones[i].Visible = true
                            VisibleAll = true
                        else
                            Bones[i].Visible = false
                        end
                    else
                        Bones[i].Visible = false
                    end
                end
            else
                for _, Line in pairs(Bones) do Line.Visible = false end
                if not Player.Parent then
                    for _, Line in pairs(Bones) do Line:Remove() end
                    Connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Initialize ESP
for _, v in pairs(Players:GetPlayers()) do CreateBoneESP(v) end
Players.PlayerAdded:Connect(CreateBoneESP)

-- [ MAIN RENDER LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    -- HEAD LOCK SAAT NEMBAK (MOUSE1 DITEKAN)
    if _G.HeadLock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local Target = GetTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- Kunci Kamera ke Kepala Musuh
            local TargetPos = Target.Character.Head.Position
            local CurrentCF = Camera:GetRenderCFrame()
            Camera.CFrame = CurrentCF:Lerp(CFrame.new(CurrentCF.Position, TargetPos), _G.Smoothing)
        end
    end
end)

-- [ COMPACT UI ]
local MainTab = Window:CreateTab("Combat 🎯", 4483362458)

MainTab:CreateToggle({
   Name = "Head Lock (on shoot) 🔒",
   CurrentValue = false,
   Callback = function(Value) _G.HeadLock = Value end,
})

MainTab:CreateSlider({
   Name = "Lock Power (Lower=Stronger)",
   Range = {0.01, 0.5},
   Increment = 0.01,
   CurrentValue = 0.05,
   Callback = function(Value) _G.Smoothing = Value end,
})

MainTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 400},
   Increment = 10,
   CurrentValue = 120,
   Callback = function(Value) _G.FOV = Value end,
})

MainTab:CreateToggle({
   Name = "Show FOV ⭕",
   CurrentValue = false,
   Callback = function(Value) FOVCircle.Visible = Value end,
})

local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)

VisualTab:CreateToggle({
   Name = "Bone ESP (R15) 💀",
   CurrentValue = false,
   Callback = function(Value) _G.BoneESP = Value end,
})

VisualTab:CreateColorPicker({
    Name = "Bone Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) _G.BoneColor = Value end
})

Rayfield:Notify({
   Title = "BLACK HUB V3.3 LIVE",
   Content = "Bones & Head Lock Ready, Acel! 😈🔥",
   Duration = 5
})
