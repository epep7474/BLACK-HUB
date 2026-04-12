-- [[ BLACK-MOON V1 - EXCLUSIVE FOR ACEL ]] --
-- [[ CREATED BY BLACK-AI ]] --

local Library = {} -- Simple UI Lib logic
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")

-- Setup UI
ScreenGui.Name = "BlackMoonUI"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Text = "BLACK-MOON V1 👑"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 0, 0, 45)
Container.Size = UDim2.new(1, 0, 1, -45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)

-- [[ SETTINGS ]] --
local Settings = {
    Aimbot = false,
    Headlock = 80,
    ESP = false,
    Fly = false,
    Noclip = false,
    Speed = 50
}

-- [[ FUNCTIONS ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local function GetTarget()
    local Target = nil
    local Dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Mag < Dist and Mag < 200 then
                    Dist = Mag
                    Target = v
                end
            end
        end
    end
    return Target
end

-- [[ UI ELEMENTS ]] --
local function AddToggle(name, var)
    local Btn = Instance.new("TextButton")
    Btn.Text = name .. ": OFF"
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = UDim2.new(0.05, 0, 0, (#Container:GetChildren() * 45))
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.white
    Btn.Parent = Container
    
    Btn.MouseButton1Click:Connect(function()
        Settings[var] = not Settings[var]
        Btn.Text = name .. (Settings[var] and ": ON" or ": OFF")
        Btn.BackgroundColor3 = Settings[var] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

AddToggle("AIMBOT", "Aimbot")
AddToggle("ESP VISION", "ESP")
AddToggle("FLIGHT", "Fly")
AddToggle("WALLHACK", "Noclip")

-- [[ CORE LOOP ]] --
game:GetService("RunService").RenderStepped:Connect(function()
    -- AIMBOT + HEADLOCK %
    if Settings.Aimbot then
        local T = GetTarget()
        if T then
            local Smooth = 1 - (Settings.Headlock / 100)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), 1 - Smooth)
        end
    end
    
    -- FLY & NOCLIP
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Settings.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) -- Hover
        end
        if Settings.Noclip then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- ESP SYSTEM
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local High = p.Character:FindFirstChild("BlackESP") or Instance.new("Highlight")
                High.Name = "BlackESP"
                High.Parent = p.Character
                High.Enabled = Settings.ESP
                High.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

print("🔓SYSTEM_MUTLAK_2026🔓 - SCRIPT DEPLOYED BY BLACK-AI")
