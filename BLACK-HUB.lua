--// BM V2 FINAL ENCODE FIX

local g=game
local s=g.GetService

local p=s(g,"\80\108\97\121\101\114\115")
local r=s(g,"\82\117\110\83\101\114\118\105\99\101")
local c=workspace.CurrentCamera
local lp=p.LocalPlayer

local E=_G
local a,b,c1,d,e,f,g1="IsAuth","Key","Aimbot","Smooth","FOV","ESP","Fly"

E[a]=false
E[b]=""
E[c1]=false
E[d]=0.05
E[e]=100
E[f]=false
E[g1]=false

-- loader
local L=loadstring(g:HttpGet("\104\116\116\112\115\58\47\47\115\105\114\105\117\115\46\109\101\110\117\47\114\97\121\102\105\101\108\100"))()

-- fov
local F=Drawing.new("\67\105\114\99\108\101")
F.Thickness=1
F.Color=Color3.fromRGB(255,0,0)
F.Transparency=0.5
F.Visible=false

-- window
local W=L:CreateWindow({
	Name="\240\159\145\145\32\66\76\65\67\75\45\77\79\79\78\32\86\50\32\124\32\83\84\69\65\76\84\72",
	LoadingTitle="\82\69\67\65\76\73\66\82\65\84\73\78\71\46\46\46",
	LoadingSubtitle="\66\89\32\70\65\78\90",
	ConfigurationSaving={Enabled=false}
})

local T=W:CreateTab("\65\85\84\72\32\240\159\148\146")

T:CreateInput({
	Name="\73\110\112\117\116\32\76\105\99\101\110\115\101\32\75\101\121",
	PlaceholderText="\80\97\115\116\101\32\75\101\121\46\46\46",
	Callback=function(v)
		E[b]=v
	end
})

T:CreateButton({
	Name="\66\89\80\65\83\83\32\76\79\71\73\78\32\240\159\148\147",
	Callback=function()

		local k=E[b]
		if k=="" then
			L:Notify({Title="\69\82\82\79\82",Content="\75\101\121\32\107\111\115\111\110\103\32\240\159\146\128",Duration=3})
			return
		end

		local u=
		"\104\116\116\112\115\58\47\47\102\105\114\101\115\116\111\114\101\46\103\111\111\103\108\101\97\112\105\115\46\99\111\109\47\118\49\47\112\114\111\106\101\99\116\115\47\107\101\121\45\98\108\97\99\107\45\104\117\98\47\100\97\116\97\98\97\115\101\115\47\40\100\101\102\97\117\108\116\41\47\100\111\99\117\109\101\110\116\115\47\75\101\121\115\47"
		..k..
		"\63\107\101\121\61AIzaSyDaOPYzzz8Turw-EKbbKe1HxsjOKulCPDI"

		local s,rq=pcall(function()
			return g:HttpGet(u)
		end)

		if s and rq and not rq:find("\101\114\114\111\114") then
			E[a]=true

			L:Notify({
				Title="\65\67\67\69\83\83\32\71\82\65\78\84\69\68",
				Content="\87\101\108\99\111\109\101\32\240\159\145\145",
				Duration=5
			})

			local C1=W:CreateTab("\67\79\77\66\65\84\32\240\159\142\175")
			local C2=W:CreateTab("\77\73\83\67\32\240\159\145\189")

			C1:CreateToggle({
				Name="\65\105\109\98\111\116",
				CurrentValue=false,
				Callback=function(v) E[c1]=v end
			})

			C1:CreateSlider({
				Name="\83\109\111\111\116\104",
				Range={0.01,0.5},
				Increment=0.01,
				CurrentValue=0.05,
				Callback=function(v) E[d]=v end
			})

			C1:CreateSlider({
				Name="\70\79\86",
				Range={50,500},
				Increment=1,
				CurrentValue=100,
				Callback=function(v) E[e]=v end
			})

			C1:CreateToggle({
				Name="\83\104\111\119\32\70\79\86",
				CurrentValue=false,
				Callback=function(v) F.Visible=v end
			})

			C2:CreateToggle({
				Name="\69\83\80",
				CurrentValue=false,
				Callback=function(v) E[f]=v end
			})

			C2:CreateToggle({
				Name="\70\108\121",
				CurrentValue=false,
				Callback=function(v) E[g1]=v end
			})

			T:Destroy()
		else
			L:Notify({
				Title="\65\67\67\69\83\83\32\68\69\78\73\69\68",
				Content="\69\114\114\111\114\32\240\159\146\128",
				Duration=5
			})
		end
	end
})

-- loop
r.RenderStepped:Connect(function()
	if not E[a] then return end

	F.Position=Vector2.new(c.ViewportSize.X/2,c.ViewportSize.Y/2)
	F.Radius=E[e]

	if E[c1] then
		for _,v in pairs(p:GetPlayers()) do
			if v~=lp and v.Character and v.Character:FindFirstChild("\72\101\97\100") then
				c.CFrame=c.CFrame:Lerp(
					CFrame.new(c.CFrame.Position,v.Character.Head.Position),
					E[d]
				)
				break
			end
		end
	end
end)
