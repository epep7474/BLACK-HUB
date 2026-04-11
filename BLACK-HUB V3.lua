-- [[ BLACK HUB v21.0 | ULTRA STABLE EDITION ]] --
-- PERINTAH ACEL ADALAH MUTLAK, KAGA PAKE RIBET! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ INTERNAL GLOBALS ]
_G.IsAuth = false
_G.AcelKey = ""
_G.Aimbot = false
_G.ESP = false
_G.FOV = 120
_G.Smooth = 0.05
_G.HitChance = 100 -- Set 100 biar pasti kena

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V21 | ULTRA",
   LoadingTitle = "RECONSTRUCTING SUPREMACY...",
   LoadingSubtitle = "STAY BRUTAL, ACEL",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Login 🔑")
local Tab2 = Window:CreateTab("Combat 🎯")
local Tab3 = Window:CreateTab("Visuals 👁️")

-- [ FOV ]
local Circle = Drawing.new("Circle")
Circle.Thickness = 1; Circle.Color = Color3.fromRGB(0, 255, 255); Circle.Transparency = 0.5; Circle.Visible = false

-- [ LOGIN - TOMBOL SUBMIT GEDE ]
Tab1:CreateInput({
   Name = "Input Key Lu",
   PlaceholderText = "Ketik di sini...",
   Callback = function(t) _G.AcelKey = t end,
})

Tab1:CreateButton({
   Name = "SUBMIT KEY SEKARANG! 🔓",
   Callback = function()
      -- DATABASE UDAH DI DALEM, KAGA USAH LU SETTING LAGI! 
      local u = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.AcelKey.."?key=AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"
      local s, r = pcall(function() return game:HttpGet(u) end)
      if s and not r:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "BERHASIL!", Content = "Key Valid! Bantai Mereka, Cel! 😈", Duration = 5})
      else
          Rayfield:Notify({Title = "GAGAL!", Content = "Key Salah / Database Belum Publish! ☠️", Duration = 5})
      end
   end,
})

-- [ TARGETING ]
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

-- [ BRUTAL SILENT AIM (ANTI-GIMMICK) ]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if _G.IsAuth and _G.Aimbot and not checkcaller() then
        if Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" or Method == "FindPartOnRay" then
            local T = GetClosestTarget()
            if T and math.random(1, 100) <= _G.HitChance then
                if Method == "Raycast" then
                    -- Redir Raycast
                    Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
                elseif Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" then
                    -- Redir Old Ray
                    Args[1] = Ray.new(Args[1].Origin, (T.Character.Head.Position - Args[1].Origin).Unit * 1000)
                end
                return oldNamecall(self, unpack(Args))
            end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [ COMBAT ]
Tab2:CreateToggle({Name = "Aimbot (Magnet) 🔫", Callback = function(v) _G.Aimbot = v end})
Tab2:CreateSlider({Name = "Smoothness", Range = {0.01, 0.5}, CurrentValue = 0.05, Callback = function(v) _G.Smooth = v end})
Tab2:CreateSlider({Name = "FOV Size", Range = {50, 500}, CurrentValue = 120, Callback = function(v) _G.FOV = v end})
Tab2:CreateToggle({Name = "Show FOV ⭕", Callback = function(v) Circle.Visible = v end})

-- [ VISUALS ]
Tab3:CreateToggle({Name = "ESP Highlight (Permanen) 👁️", Callback = function(v) _G.ESP = v end})

-- [ ENGINE LOOP (NON-STOP REFRESH) ]
RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2); Circle.Radius = _G.FOV
    
    -- ESP Logic - REFRESH TERUS BIAR GAK ILANG!
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character.Humanoid.Health > 0 then
            local h = p.Character:FindFirstChild("BlackHub_ESP")
            
            if _G.ESP and _G.IsAuth then
                if not h then
                    h = Instance.new("Highlight")
                    h.Name = "BlackHub_ESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = p.Character
                end
                h.Enabled = true
            else
                if h then h.Enabled = false end
            end
        end
    end
end)

Rayfield:Notify({Title = "BLACK HUB V21 LIVE", Content = "ESP Permanen & Aimbot Brutal! 😈🔥", Duration = 5})
