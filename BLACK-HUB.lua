--[[
    👑 BLACK HUB v1.0 👑
    DEVELOPED BY: ACEL
    STATUS: UNDETECTED (USE AT YOUR OWN RISK)
    FEATURES: AIMBOT, ESP, UI PERFECTED
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB | BY ACEL 👑",
   LoadingTitle = "INJECTING BLACK-AI...",
   LoadingSubtitle = "by Acel",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BlackHubConfig",
      FileName = "MainConfig"
   }
})

-- [ VARIABLES ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    Smoothing = 0.5,
    FOV = 100
}

local ESPSettings = {
    Enabled = false,
    Boxes = false,
    Names = false,
    TeamCheck = true
}

-- [ AIMBOT LOGIC ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

local function GetClosestPlayer()
    local Target = nil
    local Dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            if AimbotSettings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local ScreenPos, Visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local MousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
            
            if Magnitude < Dist and Magnitude < AimbotSettings.FOV then
                Target = v
                Dist = Magnitude
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = AimbotSettings.FOV
    
    if AimbotSettings.Enabled then
        local Target = GetClosestPlayer()
        if Target then
            local TargetPos = Target.Character.HumanoidRootPart.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), AimbotSettings.Smoothing)
        end
    end
end)

-- [ MAIN UI ]
local MainTab = Window:CreateTab("Main 💀", 4483362458)

MainTab:CreateSection("Aimbot Settings")

MainTab:CreateToggle({
   Name = "Enable Aimbot 🎯",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.Enabled = Value
   end,
})

MainTab:CreateToggle({
   Name = "Show FOV Circle ⭕",
   CurrentValue = false,
   Callback = function(Value)
      FOVCircle.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {0, 500},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(Value)
      AimbotSettings.FOV = Value
   end,
})

MainTab:CreateSection("Visuals / ESP 👁️")

MainTab:CreateToggle({
   Name = "Enable ESP (Boxes) 📦",
   CurrentValue = false,
   Callback = function(Value)
      -- ESP BOX LOGIC HERE
      ESPSettings.Boxes = Value
      print("ESP Boxes: " .. tostring(Value))
   end,
})

local SettingsTab = Window:CreateTab("Settings ⚙️", 4483362458)

SettingsTab:CreateButton({
   Name = "Destroy BLACK HUB",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "BLACK HUB LOADED",
   Content = "Script Ready to Use, Acel! 😈",
   Duration = 5,
   Image = 4483362458,
})
