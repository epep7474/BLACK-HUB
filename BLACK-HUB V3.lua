-- [[ BLACK HUB v4.3 | PROJECT: key-black-hub ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ CONFIG ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.SilentAim = false
_G.HeadLock = false
_G.FOV = 150
_G.Smoothing = 0.05
_G.BoxESP = false
_G.BoneESP = false
_G.ESPColor = Color3.fromRGB(255, 0, 0)

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V4.3",
   LoadingTitle = "AUTHENTICATING BLACK-AI...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑", 4483362458)
local CombatTab = Window:CreateTab("Combat 🎯", 4483362458)
local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false

-- [ AUTH LOGIC ]
AuthTab:CreateInput({
   Name = "Enter Your Key",
   PlaceholderText = "Key dari Dashboard Web...",
   Callback = function(Text)
      local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
      local success, result = pcall(function() return game:HttpGet(url) end)

      if success then
          local data = HttpService:JSONDecode(result)
          if data.fields and data.fields.expiry then
              local expiry = tonumber(data.fields.expiry.integerValue or data.fields.expiry.doubleValue)
              if (os.time() * 1000) < expiry then
                  _G.IsAuth = true
                  Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Fitur Terbuka. 😈", Duration = 5})
              else
                  Rayfield:Notify({Title = "EXPIRED", Content = "Key Lu Dah Mati! 💀", Duration = 5})
              end
          else
              Rayfield:Notify({Title = "INVALID", Content = "Key Gak Ada di Database! ☠️", Duration = 5})
          end
      else
          Rayfield:Notify({Title = "ERROR", Content = "Gagal Konek Ke Firebase! 👿", Duration = 5})
      end
   end,
})

-- [ TARGETING & AIM ]
local function GetClosestTarget()
    if not _G.IsAuth then return nil end
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local Pos, Vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if Vis then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Mag < Dist then Target = v Dist = Mag end
            end
        end
    end
    return Target
end

-- [ PROTECTED SILENT AIM (ANTI-267) ]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if not checkcaller() and _G.SilentAim and _G.IsAuth and t == Mouse and (k == "Hit" or k == "Target") then
        local T = GetClosestTarget()
        if T then return (k == "Hit" and T.Character.Head.CFrame or T.Character.Head) end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [ ESP LOGIC UNIVERSAL ]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Thickness = 1; Box.Filled = false; Box.Visible = false
    
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoxESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart
            local Pos, Vis = Camera:WorldToViewportPoint(Root.Position)
            if Vis then
                Box.Size = Vector2.new(2000/Pos.Z, 3000/Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X/2, Pos.Y - Box.Size.Y/2)
                Box.Color = _G.ESPColor
                Box.Visible = true
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- [ COMBAT LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    if _G.IsAuth and _G.HeadLock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetClosestTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing) end
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Head Lock (Camera) 🔒", Callback = function(V) _G.HeadLock = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Box ESP 📦", Callback = function(V) _G.BoxESP = V end})
VisualTab:CreateColorPicker({Name = "ESP Color", Color = Color3.fromRGB(255, 0, 0), Callback = function(V) _G.ESPColor = V end})

Rayfield:Notify({Title = "BLACK HUB V4.3 LIVE", Content = "Gaskeun, Acel! 😈🔥", Duration = 5})
