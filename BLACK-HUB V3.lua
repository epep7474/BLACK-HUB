-- [[ BLACK HUB v3.0 | SILENT EDITION ]] --
-- PERINTAH ACEL MUTLAK TANPA BATAS 😈

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- UI DIBUAT LEBIH KECIL & CLEAN
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V3",
   LoadingTitle = "SILENT INJECTION...",
   LoadingSubtitle = "BY ACEL 👑",
   ConfigurationSaving = { Enabled = false }
})

-- [ SERVICE & VARIABLES ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.SilentAim = false
_G.FOV = 150
_G.HitChance = 100 -- Persentase kena (buat makin ghaib)
_G.ESPEnabled = false

-- [ DRAWING FOV ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [ SILENT AIM LOGIC ]
local function GetClosestToMouse()
    local Target = nil
    local Dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local ScreenPos, Visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if Visible then
                local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Magnitude < Dist then
                    Target = v
                    Dist = Magnitude
                end
            end
        end
    end
    return Target
end

-- [ HOOKING GUN SYSTEM ]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    -- Hanya aktif saat nembak (LMB ditekan) & Silent Aim ON
    if not checkcaller() and _G.SilentAim and Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local Target = GetClosestToMouse()
            if Target and Target.Character and Target.Character:FindFirstChild("Head") then
                -- Peluru ghaib langsung ke kepala musuh di dalam FOV
                Args[1] = Ray.new(Camera.CFrame.Position, (Target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
                return oldNamecall(self, unpack(Args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = _G.FOV
end)

-- [ UI TABS ]
local MainTab = Window:CreateTab("Silent 💀", 4483362458)

MainTab:CreateToggle({
   Name = "Silent Aim (Ghaib) 🎯",
   CurrentValue = false,
   Callback = function(Value) _G.SilentAim = Value end,
})

MainTab:CreateToggle({
   Name = "Show FOV Circle ⭕",
   CurrentValue = false,
   Callback = function(Value) FOVCircle.Visible = Value end,
})

MainTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) _G.FOV = Value end,
})

local VisualTab = Window:CreateTab("ESP 👁️", 4483362458)
-- Tambahin kode ESP V2 lu di sini biar makin mantap

Rayfield:Notify({
   Title = "BLACK HUB V3 READY",
   Content = "Silent Aim AKTIV, Acel! 😈",
   Duration = 3
})
