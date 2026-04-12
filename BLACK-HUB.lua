-- [[ BLACK-MOON V3.3 | ANONYMOUS SLAYER ]] --
-- DATA IDENTITY: DELETED | CORE ENGINE: ACTIVE 😈💀

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

-- [[ UI CONSTRUCT (CLEAN VERSION) ]] --
local GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
GUI.Name = "BlackMoon_Ghost"

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.5, -110, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

-- [[ HEADER (NO DATA) ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "BLACK-MOON GHOST 🌑"
Title.TextColor3 = Color3.white
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1
Title.Font = "GothamBold"
Title.TextSize = 14

-- [[ MINIMIZE ]] --
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
MinBtn.TextColor3 = Color3.white

local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    if not isMin then
        Main:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        MinBtn.Text = "+"
        isMin = true
    else
        Main:TweenSize(UDim2.new(0, 220, 0, 280), "Out", "Quad", 0.3, true)
        MinBtn.Text = "-"
        isMin = false
    end
end)

-- [[ SIMPLE TOGGLES ]] --
local function AddButton(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = "Gotham"
    Instance.new("UICorner", btn)
    
    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.TextColor3 = act and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 200, 200)
        btn.BackgroundColor3 = act and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(20, 20, 20)
        callback(act)
    end)
end

AddButton("AIMBOT PLAYER", 60, function(v) _G.Aimbot = v end)
AddButton("TARGET MOBS (NPC)", 105, function(v) _G.TargetMobs = v end)
AddButton("ESP HIGHLIGHT", 150, function(v) _G.ESP = v end)
AddButton("SPEED BYPASS (50)", 195, function(v) LP.Character.Humanoid.WalkSpeed = v and 50 or 16 end)

-- [[ ENGINE ]] --
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
