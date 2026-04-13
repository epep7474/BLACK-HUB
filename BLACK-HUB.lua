-- BLACK UNIVERSE MANUAL MODE | WORK 100% DI DELTA GRATISAN
-- NO RAYFIELD, NO BULLSHIT. HANYA GUI JELEK TAPI FUNGSIONAL.

local LocalPlayer = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Buat GUI Sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "BLACK UNIVERSE MANUAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 30)
TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabHolder.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.Parent = MainFrame

-- Variables
local Fly = false
local Noclip = false
local Speed = false
local Aimbot = false
local InfJump = false
local Esp = false

local FlySpeed = 50
local WalkSpeed = 25
local AimFOV = 100
local AimPart = "Head"

-- Fungsi-fungsi Murni
local function createToggle(name, parent, callback)
   local button = Instance.new("TextButton")
   button.Size = UDim2.new(1, -10, 0, 30)
   button.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35 + 5)
   button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
   button.Text = name .. ": OFF"
   button.TextColor3 = Color3.new(1, 1, 1)
   button.Font = Enum.Font.SourceSans
   button.TextSize = 14
   button.Parent = parent
   
   local state = false
   button.MouseButton1Click:Connect(function()
      state = not state
      button.Text = name .. ": " .. (state and "ON" or "OFF")
      button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
      callback(state)
   end)
end

local function createSlider(name, parent, min, max, default, callback)
   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(1, -10, 0, 20)
   label.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35 + 5)
   label.BackgroundTransparency = 1
   label.Text = name .. ": " .. default
   label.TextColor3 = Color3.new(1, 1, 1)
   label.Font = Enum.Font.SourceSans
   label.TextSize = 14
   label.Parent = parent
   
   local slider = Instance.new("TextBox")
   slider.Size = UDim2.new(1, -10, 0, 30)
   slider.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 35 + 5)
   slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
   slider.Text = tostring(default)
   slider.TextColor3 = Color3.new(1, 1, 1)
   slider.Font = Enum.Font.SourceSans
   slider.TextSize = 14
   slider.Parent = parent
   
   slider.FocusLost:Connect(function(enter)
      local num = tonumber(slider.Text)
      if num then
         num = math.clamp(num, min, max)
         slider.Text = tostring(num)
         label.Text = name .. ": " .. num
         callback(num)
      end
   end)
end

-- Tabs
local Tabs = {}
local function createTab(name)
   local tab = Instance.new("TextButton")
   tab.Size = UDim2.new(0, 70, 1, 0)
   tab.Position = UDim2.new(0, #Tabs * 70, 0, 0)
   tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
   tab.Text = name
   tab.TextColor3 = Color3.new(1, 1, 1)
   tab.Font = Enum.Font.SourceSansBold
   tab.TextSize = 14
   tab.Parent = TabHolder
   
   local frame = Instance.new("ScrollingFrame")
   frame.Size = UDim2.new(1, 0, 1, 0)
   frame.BackgroundTransparency = 1
   frame.ScrollBarThickness = 5
   frame.CanvasSize = UDim2.new(0, 0, 0, 0)
   frame.Visible = false
   frame.Parent = ContentFrame
   
   tab.MouseButton1Click:Connect(function()
      for _, f in ipairs(ContentFrame:GetChildren()) do f.Visible = false end
      frame.Visible = true
   end)
   
   Tabs[name] = frame
   return frame
end

-- Populate Tabs
local PlayerTab = createTab("Player")
local CombatTab = createTab("Combat")
local VisualsTab = createTab("Visuals")
local TeleportTab = createTab("Teleport")
local MiscTab = createTab("Misc")

-- Player Features
createToggle("Fly", PlayerTab, function(state) Fly = state end)
createSlider("Fly Speed", PlayerTab, 10, 200, 50, function(v) FlySpeed = v end)
createToggle("Noclip", PlayerTab, function(state) Noclip = state end)
createToggle("Speed Hack", PlayerTab, function(state) Speed = state end)
createSlider("Walk Speed", PlayerTab, 16, 200, 25, function(v) WalkSpeed = v end)
createToggle("Infinite Jump", PlayerTab, function(state) InfJump = state end)
createSlider("Jump Power", PlayerTab, 50, 500, 50, function(v)
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.JumpPower = v
   end
end)

-- Combat Features
createToggle("Aimbot", CombatTab, function(state) Aimbot = state end)
createSlider("Aim FOV", CombatTab, 10, 500, 100, function(v) AimFOV = v end)
local aimPartDropdown = Instance.new("TextLabel") -- nanti bisa diganti dropdown manual
aimPartDropdown.Size = UDim2.new(1, -10, 0, 30)
aimPartDropdown.Position = UDim2.new(0, 5, 0, #CombatTab:GetChildren() * 35 + 5)
aimPartDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimPartDropdown.Text = "Aim Part: Head"
aimPartDropdown.TextColor3 = Color3.new(1, 1, 1)
aimPartDropdown.Font = Enum.Font.SourceSans
aimPartDropdown.TextSize = 14
aimPartDropdown.Parent = CombatTab
aimPartDropdown.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 then
      AimPart = AimPart == "Head" and "Torso" or (AimPart == "Torso" and "HumanoidRootPart" or "Head")
      aimPartDropdown.Text = "Aim Part: " .. AimPart
   end
end)

-- Visuals Features
createToggle("ESP", VisualsTab, function(state) Esp = state end)
-- ESP implementasi sederhana dengan Highlight
local espConnections = {}
local function toggleESP(state)
   Esp = state
   for _, v in ipairs(espConnections) do v:Disconnect() end
   espConnections = {}
   if state then
      for _, plr in ipairs(game.Players:GetPlayers()) do
         if plr ~= LocalPlayer then
            local conn = plr.CharacterAdded:Connect(function(char)
               local highlight = Instance.new("Highlight")
               highlight.Parent = char
               highlight.FillColor = Color3.new(1, 0, 0)
               highlight.OutlineColor = Color3.new(1, 1, 1)
            end)
            table.insert(espConnections, conn)
            if plr.Character then
               local highlight = Instance.new("Highlight")
               highlight.Parent = plr.Character
               highlight.FillColor = Color3.new(1, 0, 0)
               highlight.OutlineColor = Color3.new(1, 1, 1)
            end
         end
      end
      table.insert(espConnections, game.Players.PlayerAdded:Connect(function(plr)
         local conn = plr.CharacterAdded:Connect(function(char)
            if Esp then
               local highlight = Instance.new("Highlight")
               highlight.Parent = char
               highlight.FillColor = Color3.new(1, 0, 0)
               highlight.OutlineColor = Color3.new(1, 1, 1)
            end
         end)
         table.insert(espConnections, conn)
      end))
   end
end
VisualsTab:FindFirstChild("ESP: OFF").MouseButton1Click:Connect(function() -- hacky, tapi manual aja
   toggleESP(not Esp)
end)

-- Teleport Features
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 0, 150)
playerList.Position = UDim2.new(0, 5, 0, 5)
playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 5
playerList.Parent = TeleportTab

local function refreshTPList()
   for _, v in ipairs(playerList:GetChildren()) do v:Destroy() end
   local y = 0
   for _, plr in ipairs(game.Players:GetPlayers()) do
      if plr ~= LocalPlayer then
         local btn = Instance.new("TextButton")
         btn.Size = UDim2.new(1, 0, 0, 25)
         btn.Position = UDim2.new(0, 0, 0, y)
         btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
         btn.Text = plr.Name
         btn.TextColor3 = Color3.new(1, 1, 1)
         btn.Font = Enum.Font.SourceSans
         btn.TextSize = 14
         btn.Parent = playerList
         btn.MouseButton1Click:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            end
         end)
         y = y + 30
      end
   end
   playerList.CanvasSize = UDim2.new(0, 0, 0, y)
end
refreshTPList()
createToggle("Refresh List", TeleportTab, function() refreshTPList() end) -- jadi tombol

-- Misc Features
createToggle("Rejoin", MiscTab, function()
   game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
createToggle("Server Hop", MiscTab, function()
   local Http = game:GetService("HttpService")
   local TPS = game:GetService("TeleportService")
   local req = syn and syn.request or http_request or request
   if req then
      local data = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"})
      local body = Http:JSONDecode(data.Body)
      if body and body.data then
         local servers = {}
         for _, s in ipairs(body.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
               table.insert(servers, s.id)
            end
         end
         if #servers > 0 then
            TPS:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
         end
      end
   end
end)

-- Main Loop untuk Fly, Noclip, Speed, Aimbot, InfJump
RunService.Stepped:Connect(function()
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   local root = char.HumanoidRootPart
   local humanoid = char.Humanoid
   
   -- Noclip
   if Noclip then
      for _, part in ipairs(char:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
   
   -- Speed Hack
   if Speed then
      humanoid.WalkSpeed = WalkSpeed
   else
      humanoid.WalkSpeed = 16
   end
   
   -- Fly (dengan BodyVelocity sederhana)
   if Fly then
      local vel = Vector3.new()
      if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Camera.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Camera.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0, 1, 0) end
      root.Velocity = vel * FlySpeed
      humanoid.PlatformStand = true
   else
      humanoid.PlatformStand = false
   end
   
   -- Infinite Jump
   if InfJump then
      humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
      humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
         humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
   if not Aimbot then return end
   if not UserInputService:IsMouseButtonPressed(1) then return end
   local closest = nil
   local shortest = AimFOV
   local mousePos = UserInputService:GetMouseLocation()
   for _, plr in ipairs(game.Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimPart) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
         local part = plr.Character[AimPart]
         local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
         if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < shortest then
               shortest = dist
               closest = part
            end
         end
      end
   end
   if closest then
      Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position)
   end
end)

-- Aktifkan tab pertama
ContentFrame:FindFirstChildWhichIsA("ScrollingFrame").Visible = true
