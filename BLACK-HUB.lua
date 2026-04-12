--// BM V2 FULL HIDE HYBRID

local _0x0=game
local _0x1=_0x0.GetService

local _0x2=_0x1(_0x0,"\80\108\97\121\101\114\115")
local _0x3=_0x1(_0x0,"\82\117\110\83\101\114\118\105\99\101")
local _0x4=workspace.CurrentCamera
local _0x5=_0x2.LocalPlayer

local _0xE=_G

local a,b,c,d,e,f,g="IsAuth","Key","Aimbot","Smooth","FOV","ESP","Fly"

_0xE[a]=false
_0xE[b]=""
_0xE[c]=false
_0xE[d]=0.05
_0xE[e]=100
_0xE[f]=false
_0xE[g]=false

-- junk layer
local function _0xJ()
	local r=0
	for i=1,5 do
		r=r+math.random(1,9)
	end
	return r==99999
end

task.spawn(function()
	while false do _0xJ() end
end)

-- loader
local _0x6=loadstring(_0x0:HttpGet("\104\116\116\112\115\58\47\47\115\105\114\105\117\115\46\109\101\110\117\47\114\97\121\102\105\101\108\100"))()

-- fov
local _0x7=Drawing.new("\67\105\114\99\108\101")
_0x7.Thickness=1
_0x7.Color=Color3.fromRGB(255,0,0)
_0x7.Transparency=0.5
_0x7.Visible=false

-- window (FULL ENCODED)
local _0x8=_0x6:CreateWindow({
	Name="\240\159\145\145\32\66\76\65\67\75\45\77\79\79\78\32\86\50\32\124\32\83\84\69\65\76\84\72",
	LoadingTitle="\82\69\67\65\76\73\66\82\65\84\73\78\71\32\78\69\85\82\65\76\32\66\89\80\65\83\83\46\46\46",
	LoadingSubtitle="\66\89\32\70\65\78\90",
	ConfigurationSaving={Enabled=false}
})

local _0x9=_0x8:CreateTab("\65\85\84\72\32\240\159\148\146")

_0x9:CreateInput({
	Name="\73\110\112\117\116\32\76\105\99\101\110\115\101\32\75\101\121",
	PlaceholderText="\80\97\115\116\101\32\75\101\121\32\72\101\114\101\46\46\46",
	Callback=function(t)
		_0xE[b]=t
	end
})

_0x9:CreateButton({
	Name="\66\89\80\65\83\83\32\76\79\71\73\78\32\240\159\148\147",
	Callback=function()

		local _0xU="\104\116\116\112\115\58\47\47\102\105\114\101\115\116\111\114\101\46\103\111\111\103\108\101\97\112\105\115\46\99\111\109"
		local s,r=pcall(function() return _0x0:HttpGet(_0xU) end)

		if s and not (r and r:find("\101\114\114\111\114")) then
			_0xE[a]=true

			_0x6:Notify({
				Title="\65\67\67\69\83\83\32\71\82\65\78\84\69\68",
				Content="\87\101\108\99\111\109\101\32\66\97\99\107\32\240\159\145\145",
				Duration=5
			})

			_0xE["_0xM"]()
			_0x9:Destroy()
		else
			_0x6:Notify({
				Title="\65\67\67\69\83\83\32\68\69\78\73\69\68",
				Content="\69\114\114\111\114\32\240\159\146\128",
				Duration=5
			})
		end
	end
})

-- main
_0xE["_0xM"]=function()

	local _A=_0x8:CreateTab("\67\79\77\66\65\84\32\240\159\142\175")
	local _B=_0x8:CreateTab("\77\73\83\67\32\240\159\145\189")

	_A:CreateSection("\72\117\109\97\110\105\122\101\100\32\65\105\109\98\111\116")

	_A:CreateToggle({
		Name="\83\97\102\101\32\65\105\109\98\111\116",
		CurrentValue=false,
		Callback=function(v)
			_0xE[c]=v
		end
	})

	_A:CreateSlider({
		Name="\83\109\111\111\116\104",
		Range={0.01,0.5},
		Increment=0.01,
		CurrentValue=0.05,
		Callback=function(v)
			_0xE[d]=v
		end
	})

	_A:CreateSlider({
		Name="\70\79\86",
		Range={50,500},
		Increment=1,
		CurrentValue=100,
		Callback=function(v)
			_0xE[e]=v
		end
	})

	_A:CreateToggle({
		Name="\83\104\111\119\32\70\79\86",
		CurrentValue=false,
		Callback=function(v)
			_0x7.Visible=v
		end
	})

	_B:CreateSection("\83\116\101\97\108\116\104")

	_B:CreateToggle({
		Name="\69\83\80",
		CurrentValue=false,
		Callback=function(v)
			_0xE[f]=v
		end
	})

	_B:CreateToggle({
		Name="\70\108\121",
		CurrentValue=false,
		Callback=function(v)
			_0xE[g]=v
		end
	})
end

-- target
local function _0xT()
	local t=nil
	local d=_0xE[e]

	for _,v in pairs(_0x2:GetPlayers()) do
		if v~=_0x5 and v.Character then
			local h=v.Character:FindFirstChild("\72\117\109\97\110\111\105\100")
			local hd=v.Character:FindFirstChild("\72\101\97\100")

			if h and hd and h.Health>0 then
				local p,vis=_0x4:WorldToViewportPoint(hd.Position)
				if vis then
					local m=(Vector2.new(p.X,p.Y)-Vector2.new(_0x4.ViewportSize.X/2,_0x4.ViewportSize.Y/2)).Magnitude
					if m<d then
						t=v
						d=m
					end
				end
			end
		end
	end

	return t
end

-- loop
_0x3.RenderStepped:Connect(function()

	if not _0xE[a] then return end

	_0x7.Position=Vector2.new(_0x4.ViewportSize.X/2,_0x4.ViewportSize.Y/2)
	_0x7.Radius=_0xE[e]

	if _0xE[c] then
		local t=_0xT()
		if t then
			_0x4.CFrame=_0x4.CFrame:Lerp(
				CFrame.new(_0x4.CFrame.Position,t.Character.Head.Position),
				_0xE[d]
			)
		end
	end

	if _0xE[g] and _0x5.Character and _0x5.Character:FindFirstChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116") then
		_0x5.Character.HumanoidRootPart.Velocity=Vector3.new(0,1.5,0)
		for _,p in pairs(_0x5.Character:GetDescendants()) do
			if p:IsA("\66\97\115\101\80\97\114\116") then
				p.CanCollide=false
			end
		end
	end

	if _0xE[f] then
		for _,p in pairs(_0x2:GetPlayers()) do
			if p~=_0x5 and p.Character then
				local h=p.Character:FindFirstChild("\66\77\95\86\50\95\69\83\80") or Instance.new("\72\105\103\104\108\105\103\104\116",p.Character)
				h.Name="\66\77\95\86\50\95\69\83\80"
				h.FillColor=Color3.fromRGB(255,0,0)
				h.Enabled=true
			end
		end
	end

end)

print("\66\77\32\86\50\32\65\67\84\73\86\69")
