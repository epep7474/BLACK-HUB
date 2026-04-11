-- [[ BLACK HUB v17.0 | PROJECT: key-black-hub ]] --
-- PERINTAH ACEL ADALAH MUTLAK! NO SILENT AIM, ONLY AIMBOT & ESP! 😈💀

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [ DATABASE - HARDCODED ]
local PROJECT_ID = "key-black-hub"
local API_KEY = "AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

-- [ GLOBALS ]
_G.IsAuth = false
_G.TempKey = ""
_G.AimbotEnabled = false
_G.EspEnabled = false
_G.FOV = 120
_G.Smoothing = 0.05 -- Settingan awal biar smooth

-- [ UI SETUP ]
local Window = Rayfield:CreateWindow({
   Name = "👑 BLACK HUB V17",
   LoadingTitle = "CLEANING UP THE MESS...",
   LoadingSubtitle = "BY BLACK-AI 😈",
   ConfigurationSaving = { Enabled = false }
})

local AuthTab = Window:CreateTab("Login 🔑")
local CombatTab = Window:CreateTab("Combat 🎯")
local VisualsTab = Window:CreateTab("Visuals 👁️")

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ AUTH ]
AuthTab:CreateInput({
   Name = "Input Key",
   PlaceholderText = "Ketik key...",
   Callback = function(Text) _G.TempKey = Text end,
})

AuthTab:CreateButton({
   Name = "SUBMIT KEY 🔓",
   Callback = function()
      local url = "https://firestore.googleapis.com/v1/projects/key-black-hub/databases/(default)/documents/Keys/".._G.TempKey.."?key="..API_KEY
      local s, r = pcall(function() return game:HttpGet(url) end)
      if s and not r:find("error") then
          _G.IsAuth = true
          Rayfield:Notify({Title = "SUCCESS", Content = "Key Valid! Gaskeun, Cel! 😈", Duration = 5})
      else
          Rayfield:Notify({Title = "FAILED", Content = "Key Salah / Database Error! ☠️", Duration = 5})
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

-- [ AIMBOT SETTINGS ]
CombatTab:CreateToggle({
   Name = "Camera Aimbot (Lock On) 🔒",
   Callback = function(V) _G.AimbotEnabled = V end,
})

CombatTab:CreateSlider({
   Name = "Smoothing (Halyys)",
   Range = {0.01, 0.5},
   CurrentValue = 0.05,
   Callback = function(V) _G.Smoothing = V end,
})

CombatTab:CreateSlider({
   Name = "FOV Size",
   Range = {30, 600},
   CurrentValue = 120,
   Callback = function(V) _G.FOV = V end,
})

CombatTab:CreateToggle({
   Name = "Show FOV ⭕",
   Callback = function(V) FOVCircle.Visible = V end,
})

-- [ ESP PERMANEN (GAK BAKAL ILANG) ]
local function HandleESP(p)
    local function Apply()
        if p == LocalPlayer then return end
        p.CharacterAdded:Connect(function(char)
            task.wait(0.5) -- Tunggu karakter load sempurna
            if _G.EspEnabled then
                local h = char:FindFirstChild("BlackESP") or Instance.new("Highlight")
                h.Name = "BlackESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = char
            end
        end)
    end
    Apply()
end

VisualsTab:CreateToggle({
   Name = "ESP Highlight (Permanen) 👁️",
   Callback = function(V)
      _G.EspEnabled = V
      for _, p in pairs(Players:GetPlayers()) do
          if p.Character then
              if V then
                  local h = p.Character:FindFirstChild("BlackESP") or Instance.new("Highlight", p.Character)
                  h.Name = "BlackESP"
                  h.FillColor = Color3.fromRGB(255, 0, 0)
                  h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                  h.Enabled = true
              elseif p.Character:FindFirstChild("BlackESP") then
                  p.Character.BlackESP.Enabled = false
              end
          end
      end
   end,
})

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    -- AIMBOT LOGIC (CAMERA LOCK)
    if _G.IsAuth and _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local T = GetClosestTarget()
        if T then
            local TargetPos = T.Character.Head.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), _G.Smoothing)
        end
    end
end)

for _, p in pairs(Players:GetPlayers()) do HandleESP(p) end
Players.PlayerAdded:Connect(HandleESP)

Rayfield:Notify({Title = "BLACK HUB V17 READY", Content = "Silent Aim DIHAPUS. Aimbot & ESP FIXED! 😈🔥", Duration = 5}
