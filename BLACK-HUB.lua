-- [[ BLACK-MOON V1 - EXCLUSIVE FOR ACEL👑 ]] --
-- [[ OPTIMIZED FOR DELTA ANDROID ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BLACK-MOON V1 👑",
   LoadingTitle = "INJECTING NEURAL NOISE...",
   LoadingSubtitle = "by BLACK-AI",
   ConfigurationSaving = { Enabled = false }
})

-- [[ SETTINGS DATABASE ]] --
local _G = {
    Aimbot = false,
    Headlock = 80,
    ESP = false,
    Fly = false,
    Noclip = false,
    FlySpeed = 50
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ AIMBOT LOGIC ]] --
local function GetTarget()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if magnitude < dist and magnitude < 400 then
                    dist = magnitude
                    closest = v
                end
            end
        end
    end
    return closest
end

-- [[ TABS ]] --
local MainTab = Window:CreateTab("MAIN 😈", 4483362458)

MainTab:CreateSection("Combat (Aimbot)")

MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value) _G.Aimbot = Value end,
})

MainTab:CreateSlider({
   Name = "Headlock Percentage",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 80,
   Flag = "Headlock",
   Callback = function(Value) _G.Headlock = Value end,
})

MainTab:CreateSection("Visuals & Movement")

MainTab:CreateToggle({
   Name = "Player ESP (High-Vis)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value) _G.ESP = Value end,
})

MainTab:CreateToggle({
   Name = "Fly & Wallhack",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value) _G.Fly = Value; _G.Noclip = Value end,
})

-- [[ CORE EXECUTION LOOP ]] --
RunService.RenderStepped:Connect(function()
    -- AIMBOT EXECUTION
    if _G.Aimbot then
        local T = GetTarget()
        if T and T.Character and T.Character:FindFirstChild("Head") then
            local Smoothness = 1 - (_G.Headlock / 100)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), 1 - Smoothness)
        end
    end
    
    -- FLY & NOCLIP EXECUTION
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if _G.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0)
        end
        if _G.Noclip then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- ESP SYSTEM (STABLE FOR MOBILE)
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local High = p.Character:FindFirstChild("BlackESP") or Instance.new("Highlight")
                High.Name = "BlackESP"
                High.Parent = p.Character
                High.Enabled = _G.ESP
                High.FillColor = Color3.fromRGB(255, 0, 0)
                High.OutlineTransparency = 0
            end
        end
    end
end)

print("🔓SYSTEM_MUTLAK_2026🔓 - SCRIPT DEPLOYED FOR ACEL👑")
Rayfield:Notify({Title = "BLACK-MOON AKTIV", Content = "Siap hancurkan server! 😈", Duration = 5})
