-- [[ BLACK-MOON V2 | STEALTH EDITION ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ STEALTH SETTINGS ]] --
_G.IsAuth = false
_G.Key = ""
_G.Aimbot = false
_G.Smooth = 0.05 -- Diperhalus biar gak instan (Code 2A Fix)
_G.FOV = 100     -- FOV lebih kecil biar gak narik ekstrem
_G.ESP = false
_G.Fly = false
_G.SafeMode = true -- Mencegah deteksi berlebih

-- [[ VISUAL FOV ]] --
local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.Color = Color3.fromRGB(255, 0, 0)
Circle.Transparency = 0.5
Circle.Visible = false

-- [[ UI DEPLOYMENT ]] --
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK-MOON V2 | STEALTH",
   LoadingTitle = "RECALIBRATING NEURAL BYPASS...",
   LoadingSubtitle = "BY FANZ",
   ConfigurationSaving = { Enabled = false }
})

local LoginTab = Window:CreateTab("AUTH 🔒")

-- [[ SYSTEM KEY (FIRESTORE) ]] --
LoginTab:CreateInput({
   Name = "Input License Key",
   PlaceholderText = "Paste Key Here...",
   Callback = function(t) _G.Key = t end,
})

LoginTab:CreateButton({
   Name = "BYPASS LOGIN 🔓",
   Callback = function()
      local u = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.Key.."?key=AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"
      local success, result = pcall(function() return game:HttpGet(u) end)
      
      if success and not result:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Welcome Back, MEN👑. Stay Stealth!", Duration = 5})
          _G.InitMain() 
          LoginTab:Destroy()
      else
          Rayfield:Notify({Title = "ACCESS DENIED", Content = "Key Sampah atau Database Error! 💀", Duration = 5})
      end
   end,
})

-- [[ MAIN SYSTEM ]] --
_G.InitMain = function()
    local CombatTab = Window:CreateTab("COMBAT 🎯")
    local MiscTab = Window:CreateTab("MISC 👽")

    CombatTab:CreateSection("Humanized Aimbot")
    CombatTab:CreateToggle({
       Name = "Safe Aimbot (Legit Lock)",
       CurrentValue = false,
       Callback = function(v) _G.Aimbot = v end
    })
    CombatTab:CreateSlider({
       Name = "Lock Smoothness",
       Range = {0.01, 0.5},
       Increment = 0.01,
       CurrentValue = 0.05,
       Callback = function(v) _G.Smooth = v end
    })
    CombatTab:CreateSlider({
       Name = "FOV Circle Size",
       Range = {50, 500},
       Increment = 1,
       CurrentValue = 100,
       Callback = function(v) _G.FOV = v end
    })
    CombatTab:CreateToggle({
       Name = "Show FOV",
       CurrentValue = false,
       Callback = function(v) Circle.Visible = v end
    })

    MiscTab:CreateSection("Stealth Movement")
    MiscTab:CreateToggle({
       Name = "Player ESP",
       CurrentValue = false,
       Callback = function(v) _G.ESP = v end
    })
    MiscTab:CreateToggle({
       Name = "Safe Fly (Low Velocity)",
       CurrentValue = false,
       Callback = function(v) _G.Fly = v end
    })
end

-- [[ CORE ENGINE ]] --
local function GetClosest()
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
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

RunService.RenderStepped:Connect(function()
    if not _G.IsAuth then return end
    
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Radius = _G.FOV
    
    -- STEALTH AIMBOT
    if _G.Aimbot then
        local T = GetClosest()
        if T then
            -- Smooth lerping biar gak patah-patah (Fix Code 2A)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smooth)
        end
    end
    
    -- SAFE FLY (Mencegah Kick Suspicious Activity)
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1.5, 0) -- Lebih smooth, gak narik ekstrem
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    
    -- ESP LOGIC
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("BM_V2_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "BM_V2_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.Enabled = true
            end
        end
    end
end)

print("🔓BLACK-MOON V2 ACTIVE🔓 - STAY BRUTAL, FANZ")
