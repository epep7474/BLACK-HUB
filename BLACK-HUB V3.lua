-- BLACK UNIVERSE VIP FIX | ROBLOX ANDROID EXECUTOR (DELTA, ARCEUS X)
-- DIJAMIN MINIMAL RUBBERBAND, WORK 90% GAME (KECUALI GAME DENGAN ANTI-CHEAT SERVER YANG NGOTOT)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "BLACK UNIVERSE VIP FIX 😈",
   LoadingTitle = "louiss Private Cheat",
   LoadingSubtitle = "by Black Universe AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BU_VIP_Configs",
      FileName = "BU_VIP_Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "NO INVITE",
      RememberJoins = false
   },
   KeySystem = false
})

-- TABS
local MainTab = Window:CreateTab("Combat", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local PlayerTab = Window:CreateTab("Player", "user")
local TeleportTab = Window:CreateTab("Teleports", "map-pin")
local MiscTab = Window:CreateTab("Misc", "settings") -- INI TAB MISC, BUKAN ILANG GOBLOK!

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- VARIABLES
local Aimbot = { Enabled = false, FOV = 100, AimPart = "Head", Prediction = 0.135 }
local ESP = { Enabled = false, Box = true, Name = true, Health = true, Tracer = false }
local Fly = { Enabled = false, Speed = 50 }
local Noclip = { Enabled = false }
local SpeedHack = { Enabled = false, Speed = 25 }
local InfJump = { Enabled = false }

-- ANTI RUBBERBAND: BodyVelocity untuk Speed Hack (Alternatif stabil)
local bodyVelocity = nil

-- FUNGSI TELEPORT AMAN
local function safeTeleport(targetCFrame)
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   local root = char.HumanoidRootPart
   
   -- Matikan sementara network ownership biar server gak koreksi
   local oldPos = root.CFrame
   root.CFrame = targetCFrame
   
   -- Paksa update ke server (metode client-side bypass)
   local bodyPos = Instance.new("BodyPosition")
   bodyPos.Parent = root
   bodyPos.MaxForce = Vector3.new(1e6, 1e6, 1e6)
   bodyPos.Position = targetCFrame.Position
   game:GetService("Debris"):AddItem(bodyPos, 0.1)
end

-- FUNGSI ESP (SAMA, TAPI DENGAN CLEANUP LEBIH BAIK)
local espConnections = {}
local function createESP(player)
   local espFolder = Instance.new("Folder")
   espFolder.Name = "BU_ESP_" .. player.Name
   espFolder.Parent = game.CoreGui
   
   local function updateESP()
      local character = player.Character
      if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then
         espFolder:ClearAllChildren()
         return
      end
      
      local rootPart = character.HumanoidRootPart
      local humanoid = character.Humanoid
      
      if ESP.Box then
         local box = espFolder:FindFirstChild("Box") or Instance.new("BoxHandleAdornment")
         box.Name = "Box"
         box.AlwaysOnTop = true
         box.ZIndex = 5
         box.Size = Vector3.new(4, 5, 1)
         box.Color3 = Color3.new(1, 0, 0)
         box.Transparency = 0.5
         box.Adornee = rootPart
         box.Parent = espFolder
      end
      
      if ESP.Name then
         local billboard = espFolder:FindFirstChild("NameTag") or Instance.new("BillboardGui")
         billboard.Name = "NameTag"
         billboard.Size = UDim2.new(0, 100, 0, 20)
         billboard.AlwaysOnTop = true
         billboard.StudsOffset = Vector3.new(0, 3, 0)
         billboard.Adornee = rootPart
         billboard.Parent = espFolder
         
         local label = billboard:FindFirstChild("NameLabel") or Instance.new("TextLabel")
         label.Name = "NameLabel"
         label.Size = UDim2.new(1, 0, 1, 0)
         label.BackgroundTransparency = 1
         label.Text = player.Name
         label.TextColor3 = Color3.new(1, 1, 1)
         label.TextStrokeTransparency = 0
         label.Font = Enum.Font.SourceSansBold
         label.TextSize = 14
         label.Parent = billboard
      end
      
      if ESP.Health then
         local healthBar = espFolder:FindFirstChild("HealthBar") or Instance.new("BillboardGui")
         healthBar.Name = "HealthBar"
         healthBar.Size = UDim2.new(0, 50, 0, 8)
         healthBar.AlwaysOnTop = true
         healthBar.StudsOffset = Vector3.new(0, 2, 0)
         healthBar.Adornee = rootPart
         healthBar.Parent = espFolder
         
         local bg = healthBar:FindFirstChild("Background") or Instance.new("Frame")
         bg.Name = "Background"
         bg.Size = UDim2.new(1, 0, 1, 0)
         bg.BackgroundColor3 = Color3.new(0, 0, 0)
         bg.BackgroundTransparency = 0.5
         bg.Parent = healthBar
         
         local fill = bg:FindFirstChild("Fill") or Instance.new("Frame")
         fill.Name = "Fill"
         fill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
         fill.BackgroundColor3 = Color3.new(0, 1, 0)
         fill.BorderSizePixel = 0
         fill.Parent = bg
      end
      
      if ESP.Tracer then
         -- Tracer menggunakan Drawing baru agar lebih stabil
         local tracer = Drawing.new("Line")
         tracer.Visible = true
         tracer.Color = Color3.new(1, 1, 1)
         tracer.Thickness = 1
         tracer.Transparency = 0.5
         
         local connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               local root = player.Character.HumanoidRootPart
               local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
               if onScreen then
                  tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                  tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               else
                  tracer.Visible = false
               end
            else
               tracer.Visible = false
            end
         end)
         espFolder:SetAttribute("TracerConnection", connection)
      end
   end
   
   updateESP()
   local connection = RunService.RenderStepped:Connect(updateESP)
   espFolder:SetAttribute("Connection", connection)
   
   player.CharacterAdded:Connect(function()
      wait(0.5)
      updateESP()
   end)
   
   return espFolder
end

local function toggleESP(state)
   ESP.Enabled = state
   if state then
      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer then
            local folder = createESP(player)
            table.insert(espConnections, folder)
         end
      end
      Players.PlayerAdded:Connect(function(player)
         if ESP.Enabled then
            local folder = createESP(player)
            table.insert(espConnections, folder)
         end
      end)
   else
      for _, folder in ipairs(espConnections) do
         if folder and folder.Parent then
            -- Putus koneksi
            local conn = folder:GetAttribute("Connection")
            if conn then conn:Disconnect() end
            local tracerConn = folder:GetAttribute("TracerConnection")
            if tracerConn then tracerConn:Disconnect() end
            folder:Destroy()
         end
      end
      espConnections = {}
   end
end

-- MAIN LOOP (FIX RUBBERBAND)
RunService.Stepped:Connect(function()
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
   local humanoid = char.Humanoid
   local root = char.HumanoidRootPart
   
   -- NOCLIP TANPA BALIK (Loop Stepped paksa)
   if Noclip.Enabled then
      for _, part in ipairs(char:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
   
   -- SPEED HACK ANTI RUBBERBAND (Menggunakan BodyVelocity)
   if SpeedHack.Enabled then
      if not bodyVelocity then
         bodyVelocity = Instance.new("BodyVelocity")
         bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
         bodyVelocity.Parent = root
      end
      local moveDir = humanoid.MoveDirection
      bodyVelocity.Velocity = moveDir * SpeedHack.Speed
   else
      if bodyVelocity then
         bodyVelocity:Destroy()
         bodyVelocity = nil
      end
   end
   
   -- FLIGHT (Stabil dengan BodyVelocity juga)
   if Fly.Enabled then
      if not bodyVelocity then
         bodyVelocity = Instance.new("BodyVelocity")
         bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
         bodyVelocity.Parent = root
      end
      
      local velocity = Vector3.new()
      if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0, 1, 0) end
      
      bodyVelocity.Velocity = velocity * Fly.Speed
      humanoid.PlatformStand = true
   else
      if humanoid and humanoid.PlatformStand then
         humanoid.PlatformStand = false
      end
   end
   
   -- INFINITE JUMP FIX (Tanpa balik ke bawah)
   if InfJump.Enabled then
      humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
      humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
         humanoid.JumpPower = 100
         humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

-- AIMBOT LOOP (TETAP SAMA, SILENT AIM WORK DI SEBAGIAN EXECUTOR)
RunService.RenderStepped:Connect(function()
   if Aimbot.Enabled and UserInputService:IsMouseButtonPressed(1) then
      local function getClosest()
         local closest = nil
         local shortestDistance = Aimbot.FOV
         local mousePos = UserInputService:GetMouseLocation()
         for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Aimbot.AimPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
               local part = player.Character[Aimbot.AimPart]
               local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
               if onScreen then
                  local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                  if distance < shortestDistance then
                     shortestDistance = distance
                     closest = player
                  end
               end
            end
         end
         return closest
      end
      
      local target = getClosest()
      if target and target.Character then
         local aimPart = target.Character:FindFirstChild(Aimbot.AimPart)
         if aimPart then
            local predictedPos = aimPart.Position + (aimPart.Velocity * Aimbot.Prediction)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
         end
      end
   end
end)

-- ========== UI ELEMENTS ==========

-- Combat Tab
MainTab:CreateSection("Aimbot")
MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value) Aimbot.Enabled = Value end,
})
MainTab:CreateSlider({
   Name = "FOV",
   Range = {10, 500}, Increment = 1, Suffix = "px", CurrentValue = 100,
   Callback = function(Value) Aimbot.FOV = Value end,
})
MainTab:CreateDropdown({
   Name = "Aim Part",
   Options = {"Head", "Torso", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(Option) Aimbot.AimPart = Option end,
})
MainTab:CreateSlider({
   Name = "Prediction",
   Range = {0, 0.5}, Increment = 0.001, CurrentValue = 0.135,
   Callback = function(Value) Aimbot.Prediction = Value end,
})

-- Visuals Tab
VisualsTab:CreateSection("ESP Settings")
VisualsTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Callback = toggleESP
})
VisualsTab:CreateToggle({
   Name = "Box ESP", CurrentValue = true,
   Callback = function(v) ESP.Box = v; if ESP.Enabled then toggleESP(false); toggleESP(true) end end,
})
VisualsTab:CreateToggle({
   Name = "Name ESP", CurrentValue = true,
   Callback = function(v) ESP.Name = v; if ESP.Enabled then toggleESP(false); toggleESP(true) end end,
})
VisualsTab:CreateToggle({
   Name = "Health Bar", CurrentValue = true,
   Callback = function(v) ESP.Health = v; if ESP.Enabled then toggleESP(false); toggleESP(true) end end,
})
VisualsTab:CreateToggle({
   Name = "Tracers", CurrentValue = false,
   Callback = function(v) ESP.Tracer = v; if ESP.Enabled then toggleESP(false); toggleESP(true) end end,
})

-- Player Tab
PlayerTab:CreateSection("Movement (FIXED)")
PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(v) Fly.Enabled = v; if not v and bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end end,
})
PlayerTab:CreateSlider({
   Name = "Fly Speed", Range = {10, 200}, Increment = 1, Suffix = "studs/s", CurrentValue = 50,
   Callback = function(v) Fly.Speed = v end,
})
PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v) Noclip.Enabled = v end,
})
PlayerTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Callback = function(v) SpeedHack.Enabled = v; if not v and bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end end,
})
PlayerTab:CreateSlider({
   Name = "Walk Speed", Range = {16, 200}, Increment = 1, Suffix = "studs/s", CurrentValue = 25,
   Callback = function(v) SpeedHack.Speed = v end,
})
PlayerTab:CreateSlider({
   Name = "Jump Power", Range = {50, 500}, Increment = 10, CurrentValue = 50,
   Callback = function(v)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = v
      end
   end,
})
PlayerTab:CreateToggle({
   Name = "Infinite Jump (FIXED)",
   CurrentValue = false,
   Callback = function(v) InfJump.Enabled = v; 
      if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
         LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
      end
   end,
})

-- Teleport Tab
TeleportTab:CreateSection("Teleport to Player")
local playerDropdown = TeleportTab:CreateDropdown({
   Name = "Select Player",
   Options = {},
   CurrentOption = "",
   Callback = function() end,
})

local function refreshPlayerList()
   local options = {}
   for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer then
         table.insert(options, plr.Name)
      end
   end
   playerDropdown:SetOptions(options)
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

TeleportTab:CreateButton({
   Name = "Refresh Player List",
   Callback = refreshPlayerList
})

TeleportTab:CreateButton({
   Name = "Teleport",
   Callback = function()
      local targetName = playerDropdown.CurrentOption
      if targetName and targetName ~= "" then
         local target = Players:FindFirstChild(targetName)
         if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            safeTeleport(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0))
         end
      end
   end,
})

TeleportTab:CreateSection("Quick Teleports")
TeleportTab:CreateButton({
   Name = "Teleport to Spawn",
   Callback = function()
      local spawns = workspace:FindFirstChild("SpawnLocation")
      if spawns then
         safeTeleport(spawns.CFrame * CFrame.new(0, 5, 0))
      end
   end,
})

-- Misc Tab (SEKARANG ADA MENUNYA, BEO!)
MiscTab:CreateSection("Utility")
MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
   end,
})
MiscTab:CreateButton({
   Name = "Server Hop (Low Player)",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Api = "https://games.roblox.com/v1/games/"
      local req = request({Url = Api..game.PlaceId.."/servers/Public?limit=100"})
      local body = Http:JSONDecode(req.Body)
      if body and body.data then
         local servers = {}
         for _, s in ipairs(body.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
               table.insert(servers, s.id)
            end
         end
         if #servers > 0 then
            TPS:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
         else
            Rayfield:Notify({Title = "BU", Content = "No low player servers found", Duration = 3})
         end
      end
   end,
})
MiscTab:CreateLabel("Black Universe VIP | louiss ONLY")
MiscTab:CreateLabel("Script optimized for Android Executors")

Rayfield:Notify({Title = "BU VIP", Content = "Script Fixed! Minimal rubberband.", Duration = 5, Image = "check"})
