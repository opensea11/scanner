local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local NoClipping = false
local Speed = 60
local BodyGyro = nil
local BodyVelocity = nil
local OriginalCanCollide = {}

local MainUI -- referensi global biar bisa di-update
local MainFrame

-- FLY FUNCTIONS
local function StartFlying()
	if not BodyGyro then
		BodyGyro = Instance.new("BodyGyro")
		BodyGyro.P = 9e4
		BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		BodyGyro.CFrame = workspace.CurrentCamera.CFrame
		BodyGyro.Parent = HumanoidRootPart
	end
	if not BodyVelocity then
		BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Velocity = Vector3.zero
		BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		BodyVelocity.Parent = HumanoidRootPart
	end
end

local function StopFlying()
	if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
	if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end
end

-- NOCLIP FUNCTIONS
local function StartNoClip()
	if Character then
		for _, part in pairs(Character:GetChildren()) do
			if part:IsA("BasePart") then
				OriginalCanCollide[part] = part.CanCollide
				part.CanCollide = false
			end
		end
		NoClipping = true
	end
end

local function StopNoClip()
	if Character then
		for _, part in pairs(Character:GetChildren()) do
			if part:IsA("BasePart") and OriginalCanCollide[part] ~= nil then
				part.CanCollide = OriginalCanCollide[part]
			end
		end
		NoClipping = false
		OriginalCanCollide = {}
	end
end

-- Maintain noclip during runtime
local function MaintainNoClip()
	if NoClipping and Character then
		for _, part in pairs(Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end

-- GUI BUILDER
local function buildMainGUI()
	if MainUI then MainUI:Destroy() end

	MainUI = Instance.new("ScreenGui")
	MainUI.Name = "FlyControlUI"
	MainUI.Parent = CoreGui
	MainUI.ResetOnSpawn = false

	-- Main Frame
	MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 280, 0, 200)
	MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	MainFrame.BackgroundTransparency = 0.1
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = MainUI
	
	-- Corner rounding
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = MainFrame

	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 35)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	title.Text = "🚀 Fly & NoClip Control"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.Parent = MainFrame
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 8)
	titleCorner.Parent = title

	-- Speed Control Section
	local speedSection = Instance.new("Frame")
	speedSection.Size = UDim2.new(1, -10, 0, 80)
	speedSection.Position = UDim2.new(0, 5, 0, 40)
	speedSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	speedSection.BackgroundTransparency = 0.3
	speedSection.BorderSizePixel = 0
	speedSection.Parent = MainFrame
	
	local speedCorner = Instance.new("UICorner")
	speedCorner.CornerRadius = UDim.new(0, 6)
	speedCorner.Parent = speedSection

	-- Speed Label
	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, 0, 0, 25)
	speedLabel.Position = UDim2.new(0, 0, 0, 5)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "✈️ Speed: " .. Speed
	speedLabel.TextColor3 = Color3.new(1, 1, 1)
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextSize = 12
	speedLabel.Parent = speedSection

	-- Speed Slider Background
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, -20, 0, 20)
	sliderBg.Position = UDim2.new(0, 10, 0, 30)
	sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = speedSection
	
	local sliderBgCorner = Instance.new("UICorner")
	sliderBgCorner.CornerRadius = UDim.new(0, 10)
	sliderBgCorner.Parent = sliderBg

	-- Speed Slider
	local slider = Instance.new("Frame")
	slider.Size = UDim2.new(Speed/100, 0, 1, 0)
	slider.Position = UDim2.new(0, 0, 0, 0)
	slider.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	slider.BorderSizePixel = 0
	slider.Parent = sliderBg
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 10)
	sliderCorner.Parent = slider

	-- Speed Slider Button
	local sliderButton = Instance.new("TextButton")
	sliderButton.Size = UDim2.new(0, 20, 0, 20)
	sliderButton.Position = UDim2.new(Speed/100, -10, 0, 0)
	sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
	sliderButton.Text = ""
	sliderButton.BorderSizePixel = 0
	sliderButton.Parent = sliderBg
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(1, 0)
	buttonCorner.Parent = sliderButton

	-- Speed Values
	local minLabel = Instance.new("TextLabel")
	minLabel.Size = UDim2.new(0, 20, 0, 15)
	minLabel.Position = UDim2.new(0, 10, 0, 55)
	minLabel.BackgroundTransparency = 1
	minLabel.Text = "1"
	minLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	minLabel.Font = Enum.Font.Gotham
	minLabel.TextSize = 10
	minLabel.Parent = speedSection

	local maxLabel = Instance.new("TextLabel")
	maxLabel.Size = UDim2.new(0, 30, 0, 15)
	maxLabel.Position = UDim2.new(1, -40, 0, 55)
	maxLabel.BackgroundTransparency = 1
	maxLabel.Text = "100"
	maxLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	maxLabel.Font = Enum.Font.Gotham
	maxLabel.TextSize = 10
	maxLabel.Parent = speedSection

	-- NoClip Control Section
	local noclipSection = Instance.new("Frame")
	noclipSection.Size = UDim2.new(1, -10, 0, 70)
	noclipSection.Position = UDim2.new(0, 5, 0, 125)
	noclipSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	noclipSection.BackgroundTransparency = 0.3
	noclipSection.BorderSizePixel = 0
	noclipSection.Parent = MainFrame
	
	local noclipCorner = Instance.new("UICorner")
	noclipCorner.CornerRadius = UDim.new(0, 6)
	noclipCorner.Parent = noclipSection

	-- NoClip Toggle Button
	local noclipButton = Instance.new("TextButton")
	noclipButton.Size = UDim2.new(1, -20, 0, 35)
	noclipButton.Position = UDim2.new(0, 10, 0, 10)
	noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	noclipButton.Text = "🚫 NoClip: OFF"
	noclipButton.TextColor3 = Color3.new(1, 1, 1)
	noclipButton.Font = Enum.Font.GothamBold
	noclipButton.TextSize = 12
	noclipButton.BorderSizePixel = 0
	noclipButton.Parent = noclipSection
	
	local noclipBtnCorner = Instance.new("UICorner")
	noclipBtnCorner.CornerRadius = UDim.new(0, 6)
	noclipBtnCorner.Parent = noclipButton

	-- NoClip Status Label
	local noclipStatus = Instance.new("TextLabel")
	noclipStatus.Size = UDim2.new(1, 0, 0, 20)
	noclipStatus.Position = UDim2.new(0, 0, 0, 45)
	noclipStatus.BackgroundTransparency = 1
	noclipStatus.Text = "Press N or click button to toggle"
	noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
	noclipStatus.Font = Enum.Font.Gotham
	noclipStatus.TextSize = 10
	noclipStatus.Parent = noclipSection

	-- Slider Logic
	local dragging = false
	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouse = Players.LocalPlayer:GetMouse()
			local relativeX = mouse.X - sliderBg.AbsolutePosition.X
			local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
			
			Speed = math.floor(percentage * 99) + 1
			if Speed > 100 then Speed = 100 end
			if Speed < 1 then Speed = 1 end
			
			slider.Size = UDim2.new(percentage, 0, 1, 0)
			sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
			speedLabel.Text = "✈️ Speed: " .. Speed
		end
	end)

	-- NoClip Button Logic
	noclipButton.MouseButton1Click:Connect(function()
		NoClipping = not NoClipping
		if NoClipping then
			StartNoClip()
			noclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
			noclipButton.Text = "✅ NoClip: ON"
			noclipStatus.Text = "Walking through walls enabled"
			noclipStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
		else
			StopNoClip()
			noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			noclipButton.Text = "🚫 NoClip: OFF"
			noclipStatus.Text = "Press N or click button to toggle"
			noclipStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
		end
	end)

	-- Hover effects
	noclipButton.MouseEnter:Connect(function()
		if NoClipping then
			noclipButton.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
		else
			noclipButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
		end
	end)

	noclipButton.MouseLeave:Connect(function()
		if NoClipping then
			noclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
		else
			noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end
	end)
end

-- INPUT CONTROL
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		Flying = not Flying
		if Flying then StartFlying() else StopFlying() end
	elseif input.KeyCode == Enum.KeyCode.N then
		NoClipping = not NoClipping
		if NoClipping then
			StartNoClip()
		else
			StopNoClip()
		end
		-- Update GUI button if exists
		local noclipButton = MainFrame and MainFrame:FindFirstChild("Frame") and MainFrame.Frame:FindFirstChild("TextButton")
		if noclipButton then
			if NoClipping then
				noclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
				noclipButton.Text = "✅ NoClip: ON"
			else
				noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				noclipButton.Text = "🚫 NoClip: OFF"
			end
		end
	end
end)

-- FLY MOTION
RunService.RenderStepped:Connect(function()
	if Flying and BodyVelocity and BodyGyro then
		local cam = workspace.CurrentCamera
		local moveVec = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0, 1, 0) end

		BodyVelocity.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * Speed or Vector3.zero
		BodyGyro.CFrame = cam.CFrame
	end
	
	-- Maintain noclip
	MaintainNoClip()
end)

-- Handle character respawn
Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	Flying = false
	NoClipping = false
	OriginalCanCollide = {}
	StopFlying()
	StopNoClip()
end)

-- INIT GUI
buildMainGUI()

print("Fly & NoClip Script Loaded!")
print("Controls:")
print("F - Toggle Fly")
print("N - Toggle NoClip")
print("WASD - Movement (when flying)")
print("Space - Up, Left Ctrl - Down")
print("Drag slider to adjust fly speed (1-100)")
