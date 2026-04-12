--// [[ BLACK-MOON V6 | THE FINAL RECKONING ]] //-- 
--// HARDCODED UI | NO CLIP | PLAYER & MOB SLAYER 😈💀 //-- 

--// SERVICES
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Camera      = workspace.CurrentCamera

local LP = Players.LocalPlayer

--// CORE SETTINGS
_G.Aimbot      = false
_G.TargetMobs  = false
_G.Smooth      = 0.07
_G.FOV         = 150
_G.ESP         = false

--// GUI SETUP
local GUI = Instance.new("ScreenGui")
GUI.Name = "BlackMoon_V6"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
GUI.Parent = game:GetService("CoreGui")

--// MAIN FRAME
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = GUI
Main.Size = UDim2.new(0, 210, 0, 260)
Main.Position = UDim2.new(0.5, -105, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(12,12,12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(150,0,0)
Main.Active = true
Main.Draggable = true
Main.ZIndex = 10

--// HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,35)
Header.BackgroundColor3 = Color3.fromRGB(60,0,0)
Header.BorderSizePixel = 0
Header.ZIndex = 11

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1,-65,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "BLACK-MOON V6 🌑"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.ZIndex = 12

--// BUTTONS (CLOSE & MINIMIZE)
local function createHeaderButton(text, posX, color)
	local btn = Instance.new("TextButton", Header)
	btn.Size = UDim2.new(0,25,0,25)
	btn.Position = UDim2.new(1, posX, 0, 5)
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.ZIndex = 13
	return btn
end

local CloseBtn = createHeaderButton("X", -30, Color3.fromRGB(100,0,0))
local MinBtn   = createHeaderButton("-", -60, Color3.fromRGB(30,30,30))

--// CONTAINER
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1,0,1,-40)
Container.Position = UDim2.new(0,0,0,40)
Container.BackgroundTransparency = 1
Container.ZIndex = 11

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0,4)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// TOGGLE CREATOR
local function MakeToggle(name, callback)
	local btn = Instance.new("TextButton", Container)
	btn.Size = UDim2.new(0.9,0,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
	btn.Text = name .. " [OFF]"
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 11
	btn.ZIndex = 15
	
	local state = false
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		
		btn.Text = name .. (state and " [ON]" or " [OFF]")
		btn.BackgroundColor3 = state and Color3.fromRGB(150,0,0) or Color3.fromRGB(20,20,20)
		btn.TextColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(200,200,200)
		
		callback(state)
	end)
end

--// FEATURES
MakeToggle("AIMBOT PLAYERS", function(v)
	_G.Aimbot = v
end)

MakeToggle("TARGET MOBS (NPC)", function(v)
	_G.TargetMobs = v
end)

MakeToggle("ESP PLAYER", function(v)
	_G.ESP = v
end)

MakeToggle("SPEED HACK", function(v)
	if LP.Character and LP.Character:FindFirstChild("Humanoid") then
		LP.Character.Humanoid.WalkSpeed = v and 50 or 16
	end
end)

--// UI LOGIC
local isMin = false

MinBtn.MouseButton1Click:Connect(function()
	isMin = not isMin
	
	Container.Visible = not isMin
	Main:TweenSize(
		isMin and UDim2.new(0,210,0,35) or UDim2.new(0,210,0,260),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true
	)
	
	MinBtn.Text = isMin and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

--// TARGET SYSTEM
local function GetTarget()
	local target = nil
	local dist = _G.FOV
	local candidates = {}

	-- players
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local hum = plr.Character:FindFirstChild("Humanoid")
			local head = plr.Character:FindFirstChild("Head")
			
			if hum and head and hum.Health > 0 then
				table.insert(candidates, plr.Character)
			end
		end
	end

	-- mobs
	if _G.TargetMobs then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
				if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
					table.insert(candidates, v)
				end
			end
		end
	end

	-- find closest
	for _, char in pairs(candidates) do
		local pos, visible = Camera:WorldToViewportPoint(char.Head.Position)
		
		if visible then
			local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
			local magnitude = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
			
			if magnitude < dist then
				target = char
				dist = magnitude
			end
		end
	end

	return target
end

--// RENDER LOOP
RunService.RenderStepped:Connect(function()
	-- AIMBOT
	if _G.Aimbot then
		local target = GetTarget()
		if target then
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, target.Head.Position),
				_G.Smooth
			)
		end
	end

	-- ESP
	if _G.ESP then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local h = plr.Character:FindFirstChild("BM_ESP") 
					or Instance.new("Highlight", plr.Character)
				
				h.Name = "BM_ESP"
				h.FillColor = Color3.fromRGB(255,0,0)
				h.Enabled = true
			end
		end
	end
end)
