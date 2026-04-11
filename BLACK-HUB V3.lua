-- [[ BLACK HUB v13.0 | DEVELOPED BY ACEL ]] --
-- PERINTAH ACEL ADALAH MUTLAK, BANTAI SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ DATABASE - PROJECT ID: key-black-hub ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ SETTINGS ]
_G.IsAuth = false
_G.TempKey = ""
_G.SilentAim = false
_G.AutoShoot = false
_G.FOV = 100
_G.BoneESP = false
_G.HitChance = 100

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V13 | FINAL",
   LoadingTitle = "RECONSTRUCTING NEURAL SYSTEM...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Login 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ KEY VALIDATION ]
local function ValidateKey(Key)
    if Key == "" then return end
    local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Key.."?key="..API_KEY
    local s, r = pcall(function() return game:HttpGet(url) end)
    
    if s then
        local data = HttpService:JSONDecode(r)
        if data.fields and data.fields.expiry then
            _G.IsAuth = true
            Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Mode Dewa AKTIF. 😈", Duration = 5})
        else
            Rayfield:Notify({Title = "INVALID", Content = "Key Gak Ada di Database! ☠️", Duration = 5})
        end
    else
        Rayfield:Notify({Title = "ERROR", Content = "Gagal Konek Firebase! 👿", Duration = 5})
    end
end

-- [ AUTH TAB ]
AuthTab:CreateInput({
   Name = "Input Key",
   PlaceholderText = "Ketik key di sini...",
   Callback = function(Text) _G.TempKey = Text end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY 🔓",
   Callback = function() ValidateKey(_G.TempKey) end,
})

-- [ GET TARGET ]
local function GetClosest()
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

-- [ THE REAL SILENT AIM (HOOKING) ]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if _G.IsAuth and _G.SilentAim and not checkcaller() then
        if m == "FindPartOnRayWithIgnoreList" or m == "Raycast" or m == "FindPartOnRay" then
            local T = GetClosest()
            if T and math.random(1, 100) <= _G.HitChance then
                if m == "Raycast" then
                    a[2] = (T.Character.Head.Position - a[1]).Unit * 1000
                else
                    a[1] = Ray.new(a[1].Origin, (T.Character.Head.Position - a[1].Origin).Unit * 1000)
                end
                return old(self, unpack(a))
            end
        end
    end
    return old(self, unpack(a))
end)
setreadonly(mt, true)

-- [ AUTO SHOOT ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    if _G.IsAuth and _G.AutoShoot then
        local T = GetClosest()
        if T then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end
    end
end)

-- [ COMBAT UI ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Silent Kill (Auto-Shoot) 💀", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {30, 600}, CurrentValue = 100, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle ⭕", Callback = function(V) FOVCircle.Visible = V end})

-- [ UNIVERSAL BONE ESP ]
local function AddESP(P)
    local Lines = {}
    local Joints = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"}}
    for i=1,#Joints do Lines[i]=Drawing.new("Line"); Lines[i].Thickness=1.5; Lines[i].Color=Color3.fromRGB(255,0,0); Lines[i].Visible=false end
    
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoneESP and P.Character and P.Character:FindFirstChild("Humanoid") and P ~= LocalPlayer then
            for i, j in pairs(Joints) do
                local p1, p2 = P.Character:FindFirstChild(j[1]), P.Character:FindFirstChild(j[2])
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

for _, v in pairs(Players:GetPlayers()) do AddESP(v) end
Players.PlayerAdded:Connect(AddESP)

VisualTab:CreateToggle({Name = "Bone ESP (Skeleton) 💀", Callback = function(V) _G.BoneESP = V end})

Rayfield:Notify({Title = "BLACK HUB V13 READY", Content = "Gaskeun, Acel! Submit Key-nya! 😈🔥", Duration = 5})
