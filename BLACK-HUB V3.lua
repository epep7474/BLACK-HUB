-- [[ BLACK HUB v7.0 | DEVELOPED BY ACEL ]] --
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
_G.WallHack = false 
_G.AutoShoot = false
_G.HitChance = 100
_G.FOV = 150
_G.BoneESP = false
_G.WalkSpeed = 16

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V7.0",
   LoadingTitle = "INJECTING FINAL CARNAGE...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")
local MiscTab = Window:CreateTab("Misc 👽")

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(255, 0, 0); FOVCircle.Visible = false

-- [ AUTH LOGIC ]
AuthTab:CreateInput({
   Name = "Enter Your Key",
   Callback = function(Text)
      local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
      local success, result = pcall(function() return game:HttpGet(url) end)
      if success then
          local data = HttpService:JSONDecode(result)
          if data.fields and data.fields.expiry then
              local expiry = tonumber(data.fields.expiry.integerValue or data.fields.expiry.doubleValue)
              if (os.time() * 1000) < expiry then
                  _G.IsAuth = true
                  Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Selamat Berburu, Acel! 😈", Duration = 5})
              end
          end
      end
   end,
})

-- [ TARGETING & WALL HACK LOGIC ]
local function GetClosestTarget()
    if not _G.IsAuth then return nil end
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local Pos, Vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if Vis then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Mag < Dist then
                    Target = v
                    Dist = Mag
                end
            end
        end
    end
    return Target
end

-- [ BRUTAL SILENT AIM (WALL HACK INTEGRATED) ]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if _G.IsAuth and _G.SilentAim and not checkcaller() then
        if Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" then
            local T = GetClosestTarget()
            if T and math.random(1, 100) <= _G.HitChance then
                if Method == "Raycast" then
                    Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
                else
                    Args[1] = Ray.new(Args[1].Origin, (T.Character.Head.Position - Args[1].Origin).Unit * 1000)
                end
            end
        end
    end
    return oldNamecall(self, unpack(Args))
end)
setreadonly(mt, true)

-- [ BONE ESP ENGINE ]
local function CreateBoneESP(Player)
    local Bones = {}
    local Pairs = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, 
        {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
    }
    for i=1, #Pairs do Bones[i] = Drawing.new("Line"); Bones[i].Thickness = 1.5; Bones[i].Color = Color3.fromRGB(255, 0, 0); Bones[i].Visible = false end

    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoneESP and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player ~= LocalPlayer then
            for i, BonePair in pairs(Pairs) do
                local p1, p2 = Player.Character:FindFirstChild(BonePair[1]), Player.Character:FindFirstChild(BonePair[2])
                if p1 and p2 then
                    local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                    if vis1 and vis2 then
                        Bones[i].From = Vector2.new(pos1.X, pos1.Y); Bones[i].To = Vector2.new(pos2.X, pos2.Y); Bones[i].Visible = true
                    else Bones[i].Visible = false end
                else Bones[i].Visible = false end
            end
        else
            for _, line in pairs(Bones) do line.Visible = false end
        end
    end)
end
for _, v in pairs(Players:GetPlayers()) do CreateBoneESP(v) end
Players.PlayerAdded:Connect(CreateBoneESP)

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2); FOVCircle.Radius = _G.FOV
    if _G.IsAuth and _G.AutoShoot then
        local T = GetClosestTarget()
        if T then mouse1press(); task.wait(0.02); mouse1release() end
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Silent Kill (Auto-Shoot) 💀", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateSlider({Name = "Hit Chance", Range = {1, 100}, CurrentValue = 100, Callback = function(V) _G.HitChance = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Bone ESP (Kerangka Musuh) 💀", Callback = function(V) _G.BoneESP = V end})

MiscTab:CreateSlider({Name = "WalkSpeed Hack", Range = {16, 200}, CurrentValue = 16, Callback = function(V) LocalPlayer.Character.Humanoid.WalkSpeed = V end})

Rayfield:Notify({Title = "BLACK HUB V7.0 LIVE", Content = "Ancurin Semuanya, Acel! 😈🔥", Duration = 5})
