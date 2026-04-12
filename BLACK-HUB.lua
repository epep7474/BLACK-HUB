-- [[ BLACK-MOON V4 | THE FINAL GHOST ]] --
-- UI FIX | NO IDENTITY | PURE MASSACRE 😈💀

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ SETTINGS ]] --
_G.Aimbot = false
_G.TargetMobs = false
_G.Smooth = 0.08
_G.FOV = 150
_G.ESP = false

-- [[ UI CONSTRUCT ]] --
local GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
GUI.Name = "BlackMoon_V4"

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 200, 0, 250)
Main.Position = UDim2.new(0.5, -100, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = " BLACK-MOON V4 🌑"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- BUTTON CONTAINER (BIAR GAK ILANG)
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -45)
Container.Position = UDim2.new(0, 5, 0, 40)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- TOGGLE FUNCTION
local function NewToggle(text, callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = text .. " [OFF]"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = state and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(25, 25, 25)
        Btn.TextColor3 = state and Color3.white or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- [[ INJECT BUTTONS ]] --
NewToggle("AIMBOT PLAYERS", function(v) _G.Aimbot = v end)
NewToggle("TARGET MOBS/NPC", function(v) _G.TargetMobs = v end)
NewToggle("ESP HIGHLIGHT", function(v) _G.ESP = v end)
NewToggle("SPEED BYPASS", function(v) LP.Character.Humanoid.WalkSpeed = v and 50 or 16 end)

-- [[ CORE ENGINE ]] --
local function GetClosest()
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
        local T = GetClosest()
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
