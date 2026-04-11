-- [[ BLACK HUB v4.1 | PROJECT: key-black-hub ]] --
-- PERINTAH ACEL ADALAH MUTLAK 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ SETTINGS & FIREBASE ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"
local HttpService = game:GetService("HttpService")

local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V4.1",
   LoadingTitle = "CONNECTING TO FIREBASE...",
   LoadingSubtitle = "STAY BRUTAL, ACEL",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Key System 🔑", 4483362458)
local MainTab = Window:CreateTab("Combat 🎯", 4483362458)
local VisualTab = Window:CreateTab("Visuals 👁️", 4483362458)

local IsAuthenticated = false
_G.SilentAim = false
_G.HeadLock = false
_G.FOV = 150
_G.Smoothing = 0.05
_G.BoxESP = false

-- [ FIREBASE AUTH LOGIC ]
AuthTab:CreateInput({
   Name = "Enter Your Key",
   PlaceholderText = "Key From Web Dashboard...",
   Callback = function(Text)
      -- Fetch data dari Firestore REST API
      local url = "https://firestore.googleapis.com/v1/projects/"..PROJECT_ID.."/databases/(default)/documents/Keys/"..Text.."?key="..API_KEY
      local success, result = pcall(function() return game:HttpGet(url) end)

      if success then
          local data = HttpService:JSONDecode(result)
          local expiry = tonumber(data.fields.expiry.integerValue)
          
          if os.time() * 1000 < expiry then
              IsAuthenticated = true
              Rayfield:Notify({Title = "ACCESS GRANTED", Content = "Key Valid! Sikat semuanya, Cel! 😈", Duration = 5})
          else
              Rayfield:Notify({Title = "EXPIRED", Content = "Key Lu Dah Mati! 💀", Duration = 5})
          end
      else
          Rayfield:Notify({Title = "INVALID", Content = "Key Gak Terdaftar di Database! ☠️", Duration = 5})
      end
   end,
})

-- [ COMBAT & TARGETING ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local function GetClosestTarget()
    if not IsAuthenticated then return nil end
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

-- [ PROTECTED SILENT AIM (ANTI-267) ]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if not checkcaller() and _G.SilentAim and IsAuthenticated and t == Mouse and (k == "Hit" or k == "Target") then
        local T = GetClosestTarget()
        if T then return (k == "Hit" and T.Character.Head.CFrame or T.Character.Head) end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [ MAIN LOOP ]
game:GetService("RunService").RenderStepped:Connect(function()
    if IsAuthenticated and _G.HeadLock and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetClosestTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), _G.Smoothing) end
    end
end)

-- [ UI COMPONENTS ]
MainTab:CreateToggle({Name = "Silent Aim (Bullet Magnet) 🔫", Callback = function(V) _G.SilentAim = V end})
MainTab:CreateToggle({Name = "Head Lock (Camera) 🔒", Callback = function(V) _G.HeadLock = V end})
MainTab:CreateSlider({Name = "FOV Size", Range = {50, 800}, CurrentValue = 150, Callback = function(V) _G.FOV = V end})

VisualTab:CreateToggle({Name = "Box ESP 📦", Callback = function(V) _G.BoxESP = V end})

Rayfield:Notify({Title = "BLACK HUB V4.1 LIVE", Content = "Siap Digunakan! 😈🔥", Duration = 5})
