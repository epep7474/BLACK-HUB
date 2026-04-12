-- TARGET SYSTEM
local function getTarget()
	local best = nil
	local bestScore = math.huge
	local Camera = workspace.CurrentCamera

	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= game.Players.LocalPlayer and v.Character then
			local h = v.Character:FindFirstChild("Humanoid")
			local head = v.Character:FindFirstChild("Head")

			if h and head and h.Health > 0 then
				local pos,vis = Camera:WorldToViewportPoint(head.Position)

				if vis then
					local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(
						Camera.ViewportSize.X/2,
						Camera.ViewportSize.Y/2
					)).Magnitude

					local score = dist + (h.Health * 2)

					if score < bestScore then
						bestScore = score
						best = v
					end
				end
			end
		end
	end

	return best
end

-- MAIN LOOP
local currentTarget = nil
local lastSwitch = 0

game:GetService("RunService").RenderStepped:Connect(function()

	if not _G.IsAuth then return end

	local Camera = workspace.CurrentCamera

	-- FOV CIRCLE UPDATE
	FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	FOVCircle.Radius = _G.FOV

	-- SWITCH TARGET DELAY
	if tick() - lastSwitch > 0.3 then
		currentTarget = getTarget()
		lastSwitch = tick()
	end

	-- AIMBOT
	if _G.Aimbot and currentTarget and currentTarget.Character then
		local head = currentTarget.Character:FindFirstChild("Head")

		if head then
			local dist = (head.Position - Camera.CFrame.Position).Magnitude

			-- FOV DINAMIS
			_G.FOV = math.clamp(200 - dist, 60, 200)

			-- SMOOTH AIM
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, head.Position),
				math.clamp(_G.Smooth, 0.05, 0.2)
			)
		end
	end

	-- ESP
	if _G.ESP then
		for _,p in pairs(game.Players:GetPlayers()) do
			if p ~= game.Players.LocalPlayer and p.Character then
				
				local h = p.Character:FindFirstChild("BM_ESP")

				if not h then
					h = Instance.new("Highlight")
					h.Name = "BM_ESP"
					h.FillColor = Color3.fromRGB(255,0,0)
					h.Parent = p.Character
				end

				h.Enabled = true
			end
		end
	else
		for _,p in pairs(game.Players:GetPlayers()) do
			if p.Character then
				local h = p.Character:FindFirstChild("BM_ESP")
				if h then h:Destroy() end
			end
		end
	end

end)
