-- [[ BLACK-MOON V3 | CUSTOM MINIMALIST ENGINE ]] --
-- PERINTAH ACEL ADALAH MUTLAK! 😈💀

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- [[ SETTINGS ]] --
_G.Aimbot = false
_G.TargetPlayers = true
_G.TargetMobs = false -- TARGET NPC/MOB
_G.Smooth = 0.08
_G.FOV = 150
_G.ESP = false

-- [[ CUSTOM UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BlackMoonV3"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Biar bisa digeser

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BLACK-MOON V3 👑"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- [[ MINIMIZE BUTTON ]] --
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
MinBtn.TextColor3 = Color3.white

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        isMinimized = true
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 300), "Out", "Quad", 0.3, true)
        isMinimized = false
        MinBtn.Text = "-"
    end
end)

-- [[ UI BUTTON CREATOR ]] --
local function CreateToggle(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

CreateToggle("Target Player", 60, function(v) _G.TargetPlayers = v end)
CreateToggle("Target Mobs (NPC)", 105, function(v) _G.TargetMobs = v end)
CreateToggle("Aimbot Lock", 150, function(v) _G.Aimbot = v end)
CreateToggle("Player ESP", 195, function(v) _G.ESP = v end)

-- [[ TARGETING LOGIC ]] --
local function GetClosestTarget()
    local target = nil
    local dist = _G.FOV
    
    local potentialTargets = {}
    
    -- Ambil Player
    if _G.TargetPlayers then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                table.insert(potentialTargets, v.Character)
            end
        end
    end
    
    -- Ambil Mobs/NPC (Cari di Workspace)
    if _G.TargetMobs then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
                if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                    table.insert(potentialTargets, v)
                end
            end
        end
    end
    
    for _, char in pairs(potentialTargets) do
        local pos, vis = Camera:WorldToViewportPoint(char.Head.Position)
        if vis then
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if mag < dist then
                target = char
                dist = mag
            end
        end
    end
    return target
end

-- [[ ENGINE LOOP ]] --
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local T = GetClosestTarget()
        if T and T:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Head.Position), _G.Smooth)
        end
    end
    
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("BM_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "BM_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.Enabled = true
            end
        end
    end
end)

Rayfield:Notify({Title = "V3 READY", Content = "Custom UI Loaded, Cel! 💀", Duration = 3})
