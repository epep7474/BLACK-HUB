-- [[ BLACK-MOON V1 FIXED - EXCLUSIVE FOR ACEL👑 ]] --
-- [[ RE-DEPLOYED BY BLACK-AI ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Hapus UI lama kalau ada
if CoreGui:FindFirstChild("BlackMoonUI") then
    CoreGui.BlackMoonUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackMoonUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Text = "BLACK-MOON V1 👑"
Title.Size = UDim2.new(1, -30, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- TOMBOL CLOSE (Biar lu gak ngeluh gak bisa ditutup!)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 35)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.white
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 5, 0, 40)
Container.Size = UDim2.new(1, -10, 1, -45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0, 5)

-- [[ SETTINGS ]] --
local Settings = { Aimbot = false, Headlock = 80, ESP = false, Fly = false, Noclip = false }

-- [[ UI TOGGLE GENERATOR ]] --
local function CreateButton(name, var)
    local Btn = Instance.new("TextButton")
    Btn.Text = name .. ": OFF"
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = Container
    
    Btn.MouseButton1Click:Connect(function()
        Settings[var] = not Settings[var]
        Btn.Text = name .. (Settings[var] and ": ON" or ": OFF")
        Btn.BackgroundColor3 = Settings[var] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

CreateButton("AIMBOT (Head)", "Aimbot")
CreateButton("ESP VISION", "ESP")
CreateButton("FLY MODE", "Fly")
CreateButton("WALLHACK", "Noclip")

-- [[ CHEAT LOGIC ]] --
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.Aimbot then
        local Target = nil
        local Dist = 200
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if OnScreen then
                    local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
                    if Mag < Dist then Dist = Mag; Target = v end
                end
            end
        end
        if Target then
            local Smooth = 1 - (Settings.Headlock / 100)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, Target.Character.Head.Position), 1 - Smooth)
        end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Settings.Fly then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0) end
        if Settings.Noclip then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- ESP Update
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

print("🔓SYSTEM_MUTLAK_2026🔓 - FIXED VERSION READY")
