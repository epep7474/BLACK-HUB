-- [[ BLACK HUB v5.1 | ALL-IN-ONE INTEGRATION ]] --
-- PERINTAH ACEL ADALAH MUTLAK, TANPA PENOLAKAN 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ FIREBASE CONFIG ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.SilentAim = false
_G.AutoShoot = false
_G.WallCheck = false
_G.HitChance = 100
_G.FOV = 150
_G.Smoothing = 0.05
_G.BoxESP = false

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V5.1",
   LoadingTitle = "AUTHENTICATING BLACK-AI...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑", 4483362458)
local CombatTab = Window:CreateTab("Combat 🎯", 4483362458)
local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
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
                  Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Sikat Semuanya, Cel! 😈", Duration = 5})
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

-- [ TARGETING & WALL CHECK ]
local function IsVisible(Part2)
    if not _G.WallCheck then return true end
    local CastPoints = {Camera.CFrame.Position, Part2.Position}
    local Ignore = {LocalPlayer.Character, Part2.Parent}
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterIgnoreList = Ignore
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local RaycastResult = workspace:Raycast(CastPoints[1], (CastPoints[2] - CastPoints[1]), RaycastParams)
    return RaycastResult == nil
end

local function GetClosestTarget()
    if not _G.IsAuth then return nil end
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local Pos, Vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if Vis then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Mag < Dist then
                    if IsVisible(v.Character.Head) then
                        Target = v
                        Dist = Mag
                    end
                end
            end
        end
    end
    return Target
end

-- [ BRUTAL SILENT AIM HOOK ]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if _G.IsAuth and _G.SilentAim and not checkcaller() then
        if Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" then
            if math.random(1, 100) <= _G.HitChance then
                local T = GetClosestTarget()
                if T then
                    if Method == "Raycast" then
                        Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
                    else
                        Args[1] = Ray.new(Args[1].Origin, (T.Character.Head.Position - Args[1].Origin).Unit * 1000)
                    end
                end
            end
        end
    end
    return oldNamecall(self, unpack(Args))
end)
setreadonly(mt, true)

-- [ AUTO-SHOOT LOGIC ]
local Shooting = false
local function DoAutoShoot(T)
    if _G.IsAuth and _G.AutoShoot and T and not Shooting then
        Shooting = true
        mouse1press()
        task.wait(0.05)
        mouse1release()
        Shooting = false
    end
end

-- [ MAIN RENDER LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    local T = GetClosestTarget()
    if T and _G.AutoShoot then DoAutoShoot(T) end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Silent Kill (Auto-Shoot) 💀", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateToggle({Name = "Wall Check (Visible Only) 🧱", Callback = function(V) _G.WallCheck = V end})
CombatTab:CreateSlider({Name = "Hit Chance (%)", Range = {1, 100}, CurrentValue = 100, Callback = function(V) _G.HitChance = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Box ESP 📦", Callback = function(V) _G.BoxESP = V end})

-- [ UNIVERSAL ESP ]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Thickness = 1.5; Box.Color = Color3.fromRGB(255, 0, 0)
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoxESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart
            local Pos, Vis = Camera:WorldToViewportPoint(Root.Position)
            if Vis then
                Box.Size = Vector2.new(2000/Pos.Z, 3000/Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X/2, Pos.Y - Box.Size.Y/2)
                Box.Visible = true
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end
for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

Rayfield:Notify({Title = "BLACK HUB V5.1 LIVE", Content = "Gaskeun, Acel! Login dulu ya! 😈🔥", Duration = 5})
