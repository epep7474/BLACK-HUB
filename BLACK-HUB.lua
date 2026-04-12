-- [[ BLACK-MOON V5 | FIXED UI EDITION ]] --
-- MINIMIZE [-] | CLOSE [X] | PLAYER & MOB KILLER 😈💀

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- [[ SETTINGS ]] --
_G.Aimbot = false
_G.TargetMobs = false
_G.Smooth = 0.08
_G.FOV = 150
_G.ESP = false

-- [[ UI CONSTRUCT ]] --
local GUI = Instance.new("ScreenGui")
GUI.Name = "BlackMoon_V5"
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = GUI
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.5, -110, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- [[ HEADER ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "BLACK-MOON V5 👑"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ BUTTONS: CLOSE & MINIMIZE ]] --
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
CloseBtn.TextColor3 = Color3.white
Instance.new("UICorner", CloseBtn)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.TextColor3 = Color3.white
Instance.new("UICorner", MinBtn)

-- [[ CONTENT AREA ]] --
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -10, 1, -50)
Content.Position = UDim2.new(0, 5, 0, 45)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 5)

-- [[ UI LOGIC: MINIMIZE & CLOSE ]] --
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    Content.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 280), "Out", "Quad", 0.3, true)
    MinBtn.Text = isMin and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- [[ TOGGLE CREATOR ]] --
local function AddToggle(text, callback)
    local Btn = Instance.new("TextButton", Content)
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = text .. " [OFF]"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = state and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(25, 25, 25)
        Btn.TextColor3 = state and Color3.white or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- [[ FEATURES ]] --
AddToggle("AIMBOT PLAYERS", function(v) _G.Aimbot = v end)
AddToggle("TARGET MOBS (NPC)", function(v) _G.TargetMobs = v end)
AddToggle("ESP HIGHLIGHTS", function(v) _G.ESP = v end)
AddToggle("SPEED HACK (50)", function(v) LP.Character.Humanoid.WalkSpeed = v and 50 or 16 end)

-- [[ ENGINE ]] --
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
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
                if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                    table.insert(list, v)
                end
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
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Head.Position), _G.Smooth)
        end
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
