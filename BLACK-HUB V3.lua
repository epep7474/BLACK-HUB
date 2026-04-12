-- BLACK UNIVERSE EXCLUSIVE | RAYFIELD UI FOR ROBLOX ANDROID
-- Load Rayfield Library dulu di executor lo, pastiin support.

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "BLACK UNIVERSE HUB 😈",
   LoadingTitle = "louiss Private Cheat",
   LoadingSubtitle = "by Black Universe AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BU_Configs",
      FileName = "BU_Settings"
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
local MiscTab = Window:CreateTab("Misc", "settings")

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

-- FUNCTIONS
local function getClosestPlayerToCursor()
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

-- AIMBOT LOOP
RunService.RenderStepped:Connect(function()
   if Aimbot.Enabled and UserInputService:IsMouseButtonPressed(1) then
      local target = getClosestPlayerToCursor()
      if target and target.Character and target.Character:FindFirstChild(Aimbot.AimPart) then
         local aimPart = target.Character[Aimbot.AimPart]
         local predictedPos = aimPart.Position + (aimPart.Velocity * Aimbot.Prediction)
         Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
      end
   end
end)

-- FLY/NOCLIP LOOP
RunService.Heartbeat:Connect(function()
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      local humanoid = LocalPlayer.Character.Humanoid
      local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      
      -- Noclip
      if Noclip.Enabled then
         for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
               part.CanCollide = false
            end
         end
      end
      
      -- Fly (Basic control via MoveDirection)
      if Fly.Enabled and rootPart then
         local moveDir = humanoid.MoveDirection
         local speed = Fly.Speed
         
         local velocity = Vector3.new()
         if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + Camera.CFrame.LookVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - Camera.CFrame.LookVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - Camera.CFrame.RightVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + Camera.CFrame.RightVector end
         if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
         if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0, 1, 0) end
         
         rootPart.Velocity = velocity * speed
         humanoid.PlatformStand = true
      else
         if humanoid and humanoid.PlatformStand then
            humanoid.PlatformStand = false
         end
      end
      
      -- Speed Hack
      if SpeedHack.Enabled then
         humanoid.WalkSpeed = SpeedHack.Speed
      else
         humanoid.WalkSpeed = 16
      end
   end
end)

-- ESP DRAWING
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
      
      -- Box
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
      
      -- Name
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
      
      -- Health Bar
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
      
      -- Tracer
      if ESP.Tracer then
         local tracer = espFolder:FindFirstChild("Tracer") or Drawing.new("Line")
         tracer.Name = "Tracer"
         tracer.Visible = true
         tracer.Color = Color3.new(1, 1, 1)
         tracer.Thickness = 1
         tracer.Transparency = 0.5
         
         local function updateTracer()
            local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
            if onScreen then
               tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
               tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            else
               tracer.Visible = false
            end
         end
         
         RunService.RenderStepped:Connect(updateTracer)
         espFolder:SetAttribute("TracerConnection", updateTracer)
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

-- ESP TOGGLE
local espConnections = {}
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
            folder:Destroy()
         end
      end
      espConnections = {}
   end
end

-- UI ELEMENTS
-- Combat Tab
MainTab:CreateSection("Aimbot")

local AimbotToggle = MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      Aimbot.Enabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "FOV",
   Range = {10, 500},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 100,
   Callback = function(Value)
      Aimbot.FOV = Value
   end,
})

MainTab:CreateDropdown({
   Name = "Aim Part",
   Options = {"Head", "Torso", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(Option)
      Aimbot.AimPart = Option
   end,
})

MainTab:CreateSlider({
   Name = "Prediction",
   Range = {0, 0.5},
   Increment = 0.001,
   Suffix = "",
   CurrentValue = 0.135,
   Callback = function(Value)
      Aimbot.Prediction = Value
   end,
})

MainTab:CreateSection("Silent Aim (Beta)")
MainTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Callback = function(Value)
      -- This requires more advanced hooking, but placeholder for now
      if Value then
         Rayfield:Notify({Title = "BU", Content = "Silent Aim enabled, but may need specific hook library", Duration = 5, Image = "crosshair"})
      end
   end,
})

-- Visuals Tab
VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Callback = function(Value)
      toggleESP(Value)
   end,
})

VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = true,
   Callback = function(Value)
      ESP.Box = Value
      -- Refresh ESP
      if ESP.Enabled then
         toggleESP(false)
         toggleESP(true)
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Name ESP",
   CurrentValue = true,
   Callback = function(Value)
      ESP.Name = Value
      if ESP.Enabled then
         toggleESP(false)
         toggleESP(true)
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = true,
   Callback = function(Value)
      ESP.Health = Value
      if ESP.Enabled then
         toggleESP(false)
         toggleESP(true)
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Tracers",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Tracer = Value
      if ESP.Enabled then
         toggleESP(false)
         toggleESP(true)
      end
   end,
})

-- Player Tab
PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      Fly.Enabled = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 1,
   Suffix = "studs/s",
   CurrentValue = 50,
   Callback = function(Value)
      Fly.Speed = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      Noclip.Enabled = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Callback = function(Value)
      SpeedHack.Enabled = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "studs/s",
   CurrentValue = 25,
   Callback = function(Value)
      SpeedHack.Speed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 10,
   Suffix = "studs",
   CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
      local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
      if humanoid then
         humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
         humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
      end
      Rayfield:Notify({Title = "BU", Content = "Infinite Jump Enabled", Duration = 3})
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

local function updatePlayerList()
   local options = {}
   for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer then
         table.insert(options, plr.Name)
      end
   end
   playerDropdown:SetOptions(options)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

TeleportTab:CreateButton({
   Name = "Teleport",
   Callback = function()
      local targetName = playerDropdown.CurrentOption
      if targetName and targetName ~= "" then
         local target = Players:FindFirstChild(targetName)
         if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
               root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            end
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
         local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = spawns.CFrame * CFrame.new(0, 5, 0)
         end
      end
   end,
})

-- Misc Tab
MiscTab:CreateSection("Settings")
MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      local ts = game:GetService("TeleportService")
      local placeId = game.PlaceId
      ts:Teleport(placeId, LocalPlayer)
   end,
})

MiscTab:CreateButton({
   Name = "Server Hop (Low Player)",
   Callback = function()
      -- Simplified server hop, may not work on all executors
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Api = "https://games.roblox.com/v1/games/"
      
      local function hop()
         local servers = {}
         local req = request({Url = Api..game.PlaceId.."/servers/Public?limit=100"})
         local body = Http:JSONDecode(req.Body)
         if body and body.data then
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
      end
      hop()
   end,
})

MiscTab:CreateLabel("Created by Black Universe AI | louiss VIP")
