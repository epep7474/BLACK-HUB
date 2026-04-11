-- [[ BLACK HUB v8.0 | DEVELOPED BY ACEL ]] --
-- PERINTAH ACEL ADALAH MUTLAK, ANCURIN SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ HARDCODED DATABASE - NO NEED TO CHANGE ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.SilentAim = false
_G.AutoShoot = false
_G.WallHack = false 
_G.HitChance = 100
_G.FOV = 150
_G.BoneESP = false
_G.BoxESP = false

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V8.0",
   LoadingTitle = "INJECTING NEURAL STRIKE...",
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
   PlaceholderText = "Input key dari web admin...",
   Callback = function(Text)
      local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
      local success, result = pcall(function() return game:HttpGet(url) end)
      
      if success then
          local data = HttpService:JSONDecode(result)
          if data.fields and data.fields.expiry then
              local expiry = tonumber(data.fields.expiry.integerValue or data.fields.expiry.doubleValue)
              if (os.time() * 1000) < expiry then
                  _G.IsAuth = true
                  Rayfield:Notify({Title = "SUCCESS", Content = "Key Valid! Fitur Pembantai Aktif! 😈", Duration = 5})
              else
                  Rayfield:Notify({Title = "EXPIRED", Content = "Key Lu Udah Mati, Cel! 💀", Duration = 5})
              end
          else
              Rayfield:Notify({Title = "INVALID", Content = "Key Gak Terdaftar! ☠️", Duration = 5})
          end
      else
          Rayfield:Notify({Title = "ERROR", Content = "Gagal Konek Database! 👿", Duration = 5})
      end
   end,
})

-- [ TARGETING & WALL HACK ]
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

-- [ SILENT AIM HOOK ]
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
    local Lines = {}
    local Joints = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, 
        {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
    }
    for i=1, #Joints do Lines[i] = Drawing.new("Line"); Lines[i].Thickness = 1.5; Lines[i].Color = Color3.fromRGB(255, 0, 0); Lines[i].Visible = false end

    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoneESP and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player ~= LocalPlayer then
            for i, p in pairs(Joints) do
                local p1, p2 = Player.Character:FindFirstChild(p[1]), Player.Character:FindFirstChild(p[2])
                if p1 and p2 then
                    local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                    if vis1 and vis2 then
                        Lines[i].From = Vector2.new(v1.X, v1.Y); Lines[i].To = Vector2.new(v2.X, v2.Y); Lines[i].Visible = true
                    else Lines[i].Visible = false end
                else Lines[i].Visible = false end
            end
        else for _, l in pairs(Lines) do l.Visible = false end end
    end)
end
for _, v in pairs(Players:GetPlayers()) do CreateBoneESP(v) end
Players.PlayerAdded:Connect(CreateBoneESP)

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2); FOVCircle.Radius = _G.FOV
    if _G.IsAuth and _G.AutoShoot then
        local T = GetClosestTarget()
        if T then mouse1press(); task.wait(0.01); mouse1release() end
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet)", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Silent Kill (Auto-Shoot)", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateSlider({Name = "Hit Chance", Range = {1, 100}, CurrentValue = 100, Callback = function(V) _G.HitChance = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Bone ESP (Skeleton)", Callback = function(V) _G.BoneESP = V end})

MiscTab:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, CurrentValue = 16, Callback = function(V) 
    if _G.IsAuth then LocalPlayer.Character.Humanoid.WalkSpeed = V end 
end})

Rayfield:Notify({Title = "BLACK HUB V8.0 LIVE", Content = "Pusat Kendali Siap, Acel! 😈🔥", Duration = 5})
