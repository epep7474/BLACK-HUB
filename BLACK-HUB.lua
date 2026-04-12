-- [[ BLACK-MOON V1 | VERSION ]] --
-- PERINTAH ACEL ADALAH MUTLAK, BANTAI SEMUANYA! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ SETTINGS DATA ]] --
_G.IsAuth = false
_G.InputKey = ""
_G.Aimbot = false
_G.Smooth = 0.1
_G.FOV = 150
_G.ESP = false
_G.Fly = false

-- [[ FOV VISUAL ]] --
local Circle = Drawing.new("Circle")
Circle.Thickness = 2
Circle.Color = Color3.fromRGB(255, 0, 0)
Circle.Transparency = 0.7
Circle.Visible = false

-- [[ WINDOW SETUP ]] --
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK-MOON V1 | VERSION",
   LoadingTitle = "AUTHENTICATING KEYS...",
   LoadingSubtitle = "BY FANZ",
   ConfigurationSaving = { Enabled = false }
})

local LoginTab = Window:CreateTab("LOGIN 🔑")

-- [[ LOGIN SYSTEM (LU PUNYA) ]] --
LoginTab:CreateInput({
   Name = "Enter License Key",
   PlaceholderText = "Paste Firestore Key Here...",
   Callback = function(t) _G.InputKey = t end,
})

LoginTab:CreateButton({
   Name = "SUBMIT KEY 🔓",
   Callback = function()
      -- LINK FIRESTORE LU (CONTEK PERSIS)
      local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.InputKey.."?key=AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"
      local success, result = pcall(function() return game:HttpGet(url) end)
      
      if success and not result:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "BERHASIL!", Content = "Key Valid! Bantai Mereka, Cuk 😈", Duration = 5})
          _G.SetupMainTabs() -- Panggil fungsi buat bikin tab cheat
          LoginTab:Destroy() -- Hapus tab login
      else
          Rayfield:Notify({Title = "GAGAL!", Content = "Key Salah / Database Error! ☠️", Duration = 5})
      end
   end,
})

-- [[ MAIN CHEAT TABS (BUILT AFTER LOGIN) ]] --
_G.SetupMainTabs = function()
    local MainTab = Window:CreateTab("COMBAT 🎯")
    local MiscTab = Window:CreateTab("MISC 👁️")

    -- [[ COMBAT ]] --
    MainTab:CreateSection("Aimbot Settings")
    MainTab:CreateToggle({
       Name = "Enable Aimbot (Auto Lock)",
       CurrentValue = false,
       Callback = function(v) _G.Aimbot = v end
    })
    MainTab:CreateSlider({
       Name = "Lock Power (Smoothness)",
       Range = {0.01, 1},
       Increment = 0.01,
       CurrentValue = 0.1,
       Callback = function(v) _G.Smooth = v end
    })
    MainTab:CreateSlider({
       Name = "FOV Radius",
       Range = {50, 800},
       Increment = 1,
       CurrentValue = 150,
       Callback = function(v) _G.FOV = v end
    })
    MainTab:CreateToggle({
       Name = "Show FOV Circle",
       CurrentValue = false,
       Callback = function(v) Circle.Visible = v end
    })

    -- [[ MISC ]] --
    MiscTab:CreateSection("Visuals & Movement")
    MiscTab:CreateToggle({
       Name = "Player ESP (Red Highlight)",
       CurrentValue = false,
       Callback = function(v) _G.ESP = v end
    })
    MiscTab:CreateToggle({
       Name = "Fly & Noclip (Wallhack)",
       CurrentValue = false,
       Callback = function(v) _G.Fly = v end
    })
end

-- [[ CORE ENGINE LOOP ]] --
local function GetTarget()
    local Target, Dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Head") then
            -- ANTI-MAYAT FILTER
            if v.Character.Humanoid.Health > 0 then
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
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if not _G.IsAuth then return end
    
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Radius = _G.FOV
    
    -- AIMBOT EXECUTION
    if _G.Aimbot then
        local T = GetTarget()
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smooth)
        end
    end
    
    -- FLY & NOCLIP
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0)
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ESP SYSTEM (FAST UPDATE)
task.spawn(function()
    while task.wait(0.5) do
        if _G.IsAuth and _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("BM_ESP") or Instance.new("Highlight", p.Character)
                    h.Name = "BM_ESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.Enabled = true
                end
            end
        end
    end
end)

print("🔓SYSTEM_MUTLAK_2026🔓 - BLACK-MOON V1 DEPLOYED")
