-- [[ BLACK HUB v12.0 | DEVELOPED BY ACEL ]] --
-- PERINTAH ACEL ADALAH MUTLAK, BANTAI SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [ HARDCODED DATABASE - JANGAN DIUBAH ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.TempKey = ""
_G.SilentAim = false
_G.AutoShoot = false
_G.HitChance = 100
_G.FOV = 120
_G.BoneESP = false

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V12 | SUBMIT",
   LoadingTitle = "REPARING NEURAL CORE...",
   LoadingSubtitle = "BY ACEL WITH ❤️",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualTab = Window:CreateTab("Visuals 👁️")

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ AUTH FUNCTION ]
local function ValidateKey(Text)
    if Text == "" then return end
    local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
    local success, result = pcall(function() return game:HttpGet(url) end)
    
    if success then
        local data = HttpService:JSONDecode(result)
        if data.fields and data.fields.expiry then
            local expiry = tonumber(data.fields.expiry.integerValue or data.fields.expiry.doubleValue)
            if (os.time() * 1000) < expiry then
                _G.IsAuth = true
                Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Mode Dewa AKTIF. 😈", Duration = 5})
            else
                Rayfield:Notify({Title = "EXPIRED", Content = "Key Lu Dah Mati! Buat baru di Web! 💀", Duration = 5})
            end
        else
            Rayfield:Notify({Title = "INVALID", Content = "Key Gak Ada di Database! ☠️", Duration = 5})
        end
    else
        Rayfield:Notify({Title = "ERROR", Content = "Koneksi Firebase Gagal! 👿", Duration = 5})
    end
end

-- [ AUTH TAB - DENGAN TOMBOL SUBMIT ]
AuthTab:CreateInput({
   Name = "Enter Your Key",
   PlaceholderText = "Ketik key di sini...",
   Callback = function(Text)
      _G.TempKey = Text
   end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY 🔓",
   Callback = function()
      ValidateKey(_G.TempKey)
   end,
})

-- [ TARGETING & AIMBOT ]
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

-- [ THE BRUTAL HOOK ]
local mt = getrawmetatable(game)
local old = mt.__namecall
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
    return old(self, unpack(Args))
end)
setreadonly(mt, true)

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    if _G.IsAuth and _G.AutoShoot then
        local T = GetClosestTarget()
        if T then mouse1press(); task.wait(0.01); mouse1release() end
    end
end)

-- [ UI COMPONENTS ]
CombatTab:CreateToggle({Name = "Silent Aim (Bullet Magnet)", Callback = function(V) _G.SilentAim = V end})
CombatTab:CreateToggle({Name = "Auto Shoot (Silent Kill)", Callback = function(V) _G.AutoShoot = V end})
CombatTab:CreateSlider({Name = "FOV Size", Range = {30, 500}, CurrentValue = 120, Callback = function(V) _G.FOV = V end})
CombatTab:CreateToggle({Name = "Show FOV Circle", Callback = function(V) FOVCircle.Visible = V end})

VisualTab:CreateToggle({Name = "Bone ESP (Skeleton)", Callback = function(V) _G.BoneESP = V end})

-- [ UNIVERSAL BONE ESP ]
local function AddBoneESP(Player)
    local Lines = {}
    local Pairs = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"}}
    for i=1,#Pairs do Lines[i]=Drawing.new("Line"); Lines[i].Thickness=1.5; Lines[i].Color=Color3.fromRGB(255,0,0); Lines[i].Visible=false end
    RunService.RenderStepped:Connect(function()
        if _G.IsAuth and _G.BoneESP and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player ~= LocalPlayer then
            for i, p in pairs(Pairs) do
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
for _, v in pairs(Players:GetPlayers()) do AddBoneESP(v) end
Players.PlayerAdded:Connect(AddBoneESP)

Rayfield:Notify({Title = "BLACK HUB V12 LIVE", Content = "Pencet Tombol Submit, Cel! 😈🔥", Duration = 5})
