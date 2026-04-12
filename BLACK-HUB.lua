-- [[ BLACK-MOON V6 | THE FINAL RECKONING ]] --
-- HARDCODED UI | NO CLIP | PLAYER & MOB SLAYER 😈💀

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ CORE SETTINGS ]] --
_G.Aimbot = false
_G.TargetMobs = false
_G.Smooth = 0.07
_G.FOV = 150
_G.ESP = false

-- [[ UI CONSTRUCTION - FORCE RENDER ]] --
local GUI = Instance.new("ScreenGui")
GUI.Name = "BlackMoon_V6"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global -- Force Global Layer
GUI.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = GUI
Main.Size = UDim2.new(0, 210, 0, 260)
Main.Position = UDim2.new(0.5, -105, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(150, 0, 0)
Main.Active = true
Main.Draggable = true
Main.ZIndex = 10 -- Background layer

-- [[ HEADER ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
Header.BorderSizePixel = 0
Header.ZIndex = 11

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -65, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "BLACK-MOON V6 🌑"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.ZIndex = 12

-- [[ MINIMIZE & CLOSE ]] --
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = Color3.white
CloseBtn.ZIndex = 13

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.TextColor3 = Color3.white
MinBtn.ZIndex = 13

-- [[ BUTTON CONTAINER ]] --
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
Container.ZIndex = 11

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 4)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ TOGGLE ENGINE ]] --
local function MakeToggle(name, callback)
    local Tgl = Instance.new("TextButton", Container)
    Tgl.Size = UDim2.new(0.9, 0, 0, 35)
    Tgl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Tgl.Text = name .. " [OFF]"
    Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tgl.Font = Enum.Font.Gotham
    Tgl.TextSize = 11
    Tgl.ZIndex = 15 -- Paling depan
    
    local state = false
    Tgl.MouseButton1Click:Connect(function()
        state = not state
        Tgl.Text = name .. (state and " [ON]" or " [OFF]")
        Tgl.BackgroundColor3 = state and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(20, 20, 20)
        Tgl.TextColor3 = state and Color3.white or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- [[ LOAD FEATURES ]] --
MakeToggle("AIMBOT PLAYERS", function(v) _G.Aimbot = v end)
MakeToggle("TARGET MOBS (NPC)", function(v) _G.TargetMobs = v end)
MakeToggle("ESP PLAYER", function(v) _G.ESP = v end)
MakeToggle("SPEED HACK", function(v) LP.Character.Humanoid.WalkSpeed = v and 50 or 16 end)

-- [[ UI LOGIC ]] --
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    Container.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 210, 0, 35) or UDim2.new(0, 210, 0, 260), "Out", "Quad", 0.2, true)
    MinBtn.Text = isMin and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- [[ TARGETING ENGINE ]] --
local function GetTarget()
    local target, dist = nil, _G.FOV
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            table.insert(list, v.Character)
        end
    end
    if _G.TargetMobs then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") and not Players:GetPlayerFromCharacter(v) then
                if v.Humanoid.Health > 0 then table.insert(list, v) end
            end
        end
    end
    for _, char in pairs(list) do
        local pos, vis = Camera:WorldToViewportPoint(char.Head.Position)
        if vis then
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if mag < dist then target = char dist = mag end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local T = GetTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Head.Position), _G.Smooth) end
    end
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local h = p.Character:FindFirstChild("BM_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "BM_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.Enabled = true
            end
        end
    end
end)
