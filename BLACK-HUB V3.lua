-- [[ BLACK HUB v6.0 | NEBULA ENGINE ]] --
-- PERINTAH ACEL ADALAH MUTLAK, ANCURIN SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ CONFIG FIREBASE ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.SilentAim = false
_G.AutoShoot = false
_G.WallHack = false -- Tembus tembok
_G.HitChance = 100
_G.FOV = 150
_G.BoxESP = false

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V6.0 | NEBULA",
   LoadingTitle = "RECONSTRUCTING BLACK-AI...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
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
                  Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Mode Pembantai AKTIV. 😈", Duration = 5})
              else
                  Rayfield:Notify({Title = "EXPIRED", Content = "Key Mati! Buat baru di Web! 💀", Duration = 5})
              end
          end
      else
          Rayfield:Notify({Title = "INVALID", Content = "Database Gak Kenal Key Lu! ☠️", Duration = 5})
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
                if Mag < Dist then
                    -- WALL HACK LOGIC (Kalau WallHack OFF, cek apakah terhalang tembok)
                    if not _G.WallHack then
                        local RaycastParams = RaycastParams.new()
                        RaycastParams.FilterIgnoreList = {LocalPlayer.Character, v.Character}
                        local RayResult = workspace:Raycast(Camera.CFrame.Position, (v.Character.Head.Position - Camera.CFrame.Position).Unit * 1000, RaycastParams)
                        if RayResult then continue end -- Terhalang tembok
                    end
                    Target = v
                    Dist = Mag
                end
            end
        end
    end
    return Target
end

-- [ PERFECT SILENT AIM ]
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

-- [ AUTO-SHOOT (SILENT KILL) ]
local function AutoShoot()
    if _G.IsAuth and _G.AutoShoot then
        local T = GetClosestTarget()
        if T then
            -- Bypass untuk Mobile Executor (Delta/Fluxus)
            keypress(0x01) -- Virtual Left Click
            task.wait(0.05)
            keyrelease(0x01)
        end
    end
end

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    if _G.IsAuth then
        AutoShoot()
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Auto Shoot (Silent Kill) 💀", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateToggle({Name = "Wall Hack (Shoot Thru Walls) 🧱", Callback = function(V) _G.WallHack = V end})
CombatTab:CreateSlider({Name = "Hit Chance", Range = {1, 100}, CurrentValue = 100, Callback = function(V) _G.HitChance = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Box ESP (Universal) 📦", Callback = function(V) _G.BoxESP = V end})

-- [ BETTER ESP LOGIC ]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Thickness = 2; Box.Color = Color3.fromRGB(255, 0, 0)
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoxESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart
            local Pos, Vis = Camera:WorldToViewportPoint(Root.Position)
            if Vis then
                Box.Size = Vector2.new(2500/Pos.Z, 3500/Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X/2, Pos.Y - Box.Size.Y/2)
                Box.Visible = true
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end
for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

Rayfield:Notify({Title = "BLACK HUB V6.0 LIVE", Content = "Sempurna & Brutal, Acel! 😈🔥", Duration = 5})
