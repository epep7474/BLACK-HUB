-- [[ BLACK HUB v9.0 | NEURAL REBIRTH ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ DATABASE ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ SETTINGS ]
_G.IsAuth = false
_G.SilentAim = false
_G.AutoShoot = false
_G.HitChance = 100
_G.FOV = 120
_G.BoneESP = false
_G.BoxESP = false

-- [ COMPACT UI ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V9",
   LoadingTitle = "REBIRTHING SYSTEM...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")

-- [ FOV CIRCLE FIX - TIPIS & TRANSPARAN ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1 -- Tipis biar gak ganggu
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.5 -- Transparan biar kelihatan tembus
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ AUTH ]
AuthTab:CreateInput({
   Name = "Input Key",
   Callback = function(Text)
      local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
      local s, r = pcall(function() return game:HttpGet(url) end)
      if s then
          local d = HttpService:JSONDecode(r)
          if d.fields and d.fields.expiry then
              _G.IsAuth = true
              Rayfield:Notify({Title = "SUCCESS", Content = "Key Valid! Sikat, Cel! 😈", Duration = 3})
          end
      end
   end,
})

-- [ TARGETING ]
local function GetTarget()
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

-- [ SILENT AIM HOOK ]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if _G.IsAuth and _G.SilentAim and (m == "Raycast" or m == "FindPartOnRayWithIgnoreList") then
        local T = GetTarget()
        if T and math.random(1,100) <= _G.HitChance then
            if m == "Raycast" then a[2] = (T.Character.Head.Position - a[1]).Unit * 1000
            else a[1] = Ray.new(a[1].Origin, (T.Character.Head.Position - a[1].Origin).Unit * 1000) end
        end
    end
    return old(self, unpack(a))
end)
setreadonly(mt, true)

-- [ BONE ESP FIXED ]
local function AddBoneESP(P)
    local Lines = {}
    local Pairs = {
        {"Head","UpperTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"UpperTorso","LowerTorso"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"}
    }
    for i=1,#Pairs do Lines[i]=Drawing.new("Line"); Lines[i].Thickness=1; Lines[i].Color=Color3.fromRGB(255,0,0); Lines[i].Visible=false end
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoneESP and P.Character and P.Character:FindFirstChild("Humanoid") and P ~= LocalPlayer then
            for i, bp in pairs(Pairs) do
                local p1, p2 = P.Character:FindFirstChild(bp[1]), P.Character:FindFirstChild(bp[2])
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
for _, v in pairs(Players:GetPlayers()) do AddBoneESP(v) end
Players.PlayerAdded:Connect(AddBoneESP)

-- [ AUTO SHOOT ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    if _G.IsAuth and _G.AutoShoot then
        local T = GetTarget()
        if T then mouse1press(); task.wait(); mouse1release() end
    end
end)

-- [ TAB COMBAT ]
CombatTab:CreateToggle({Name = "Silent Aim (Magnet)", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Auto Shoot (On FOV)", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {30, 500}, CurrentValue = 120, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV", Callback = function(V) FOVCircle.Visible = V end})

-- [ TAB VISUAL ]
VisualTab:CreateToggle({Name = "Bone ESP (Skeleton)", Callback = function(V) _G.BoneESP = V end})

Rayfield:Notify({Title = "BLACK HUB V9", Content = "Fixed & Light! 😈🔥", Duration = 3})
