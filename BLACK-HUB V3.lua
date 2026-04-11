-- [[ BLACK HUB v4.5 | INTEGRATED KEY SYSTEM ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

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
_G.HeadLock = false
_G.AutoShoot = false
_G.HitChance = 100
_G.FOV = 150
_G.Smoothing = 0.05
_G.BoxESP = false

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V4.5",
   LoadingTitle = "CONNECTING TO BLACK-AI...",
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
              local expiryValue = data.fields.expiry.integerValue or data.fields.expiry.doubleValue
              local expiry = tonumber(expiryValue)
              if (os.time() * 1000) < expiry then
                  _G.IsAuth = true
                  Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Fitur Pembantai Terbuka. 😈", Duration = 5})
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

-- [ TARGETING LOGIC ]
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

-- [ BRUTAL SILENT AIM HOOK ]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if _G.SilentAim and _G.IsAuth and not checkcaller() then
        if Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" or Method == "FindPartOnRay" then
            if math.random(1, 100) <= _G.HitChance then
                local T = GetClosestTarget()
                if T then
                    local Origin = Args[1]
                    if typeof(Origin) == "Vector3" then 
                        Args[2] = (T.Character.Head.Position - Origin).Unit * 1000
                    elseif typeof(Origin) == "Ray" then
                        Args[1] = Ray.new(Origin.Origin, (T.Character.Head.Position - Origin.Origin).Unit * 1000)
                    end
                end
            end
        end
    end
    return oldNamecall(self, unpack(Args))
end)

-- [ MAIN RENDER LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    local T = GetClosestTarget()
    
    -- Silent Kill (Auto-Shoot)
    if _G.IsAuth and _G.AutoShoot and T then
        mouse1click() 
    end

    -- Stealth Head Lock
    if _G.IsAuth and _G.HeadLock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and T then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing)
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Silent Kill (Auto-Shoot) 💀", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateToggle({Name = "Stealth Head Lock 🔒", Callback = function(V) _G.HeadLock = V end})
CombatTab:CreateSlider({Name = "Hit Chance (%)", Range = {1, 100}, CurrentValue = 100, Callback = function(V) _G.HitChance = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Box ESP 📦", Callback = function(V) _G.BoxESP = V end})

Rayfield:Notify({Title = "BLACK HUB V4.5 READY", Content = "Login Dulu, Acel! 😈🔥", Duration = 5})
