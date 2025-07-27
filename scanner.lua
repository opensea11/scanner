local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local Speed = 60
local BodyGyro = nil
local BodyVelocity = nil
local LookingAtPlayer = nil
local LookTween = nil

local MainUI -- referensi global biar bisa di-update
local MainFrame
local SpeedFrame
local PlayerListFrame

-- FLY
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

-- LOOKUP FUNCTION
local function lookAtPlayer(targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetRoot = targetPlayer.Character.HumanoidRootPart
		local camera = workspace.CurrentCamera
		
		-- Stop previous tween
		if LookTween then
			LookTween:Cancel()
		end
		
		-- Calculate look direction
		local lookDirection = (targetRoot.Position - camera.CFrame.Position).Unit
		local newCFrame = CFrame.lookAt(camera.CFrame.Position, targetRoot.Position)
		
		-- Smooth camera transition
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		LookTween = TweenService:Create(camera, tweenInfo, {CFrame = newCFrame})
		LookTween:Play()
		
		LookingAtPlayer = targetPlayer
	end
end

local function lookAtNearestPlayer()
	local closestDistance = math.huge
	local closestPlayer = nil
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				closestPlayer = otherPlayer
			end
		end
	end
	if closestPlayer then
		lookAtPlayer(closestPlayer)
	end
end

-- GUI BUILDER
local function buildMainGUI()
	if MainUI then MainUI:Destroy() end

	MainUI = Instance.new("ScreenGui")
	MainUI.Name = "FlyLookupUI"
	MainUI.Parent = CoreGui
	MainUI.ResetOnSpawn = false

	-- Main Frame
	MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 250, 0, 400)
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
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	title.Text = "Fly & Lookup Control"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.Parent = MainFrame
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 8)
	titleCorner.Parent = title

	-- Speed Control Frame
	SpeedFrame = Instance.new("Frame")
	SpeedFrame.Size = UDim2.new(1, -10, 0, 80)
	SpeedFrame.Position = UDim2.new(0, 5, 0, 35)
	SpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	SpeedFrame.BackgroundTransparency = 0.3
	SpeedFrame.BorderSizePixel = 0
	SpeedFrame.Parent = MainFrame
	
	local speedCorner = Instance.new("UICorner")
	speedCorner.CornerRadius = UDim.new(0, 6)
	speedCorner.Parent = SpeedFrame

	-- Speed Label
	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, 0, 0, 25)
	speedLabel.Position = UDim2.new(0, 0, 0, 5)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Speed: " .. Speed
	speedLabel.TextColor3 = Color3.new(1, 1, 1)
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextSize = 12
	speedLabel.Parent = SpeedFrame

	-- Speed Slider Background
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, -20, 0, 20)
	sliderBg.Position = UDim2.new(0, 10, 0, 30)
	sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = SpeedFrame
	
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
			
			Speed = math.floor(percentage * 100) + 1
			if Speed > 100 then Speed = 100 end
			if Speed < 1 then Speed = 1 end
			
			slider.Size = UDim2.new(percentage, 0, 1, 0)
			sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
			speedLabel.Text = "Speed: " .. Speed
		end
	end)

	-- Player List Frame
	PlayerListFrame = Instance.new("ScrollingFrame")
	PlayerListFrame.Size = UDim2.new(1, -10, 1, -125)
	PlayerListFrame.Position = UDim2.new(0, 5, 0, 120)
	PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	PlayerListFrame.BackgroundTransparency = 0.3
	PlayerListFrame.BorderSizePixel = 0
	PlayerListFrame.ScrollBarThickness = 6
	PlayerListFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	PlayerListFrame.Parent = MainFrame
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 6)
	listCorner.Parent = PlayerListFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = PlayerListFrame
end

local function refreshPlayerList()
	if not PlayerListFrame then return end
	for _, child in pairs(PlayerListFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local playerCount = 0
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= Player then
			playerCount = playerCount + 1
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Text = "👁️ " .. p.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 12
			btn.BorderSizePixel = 0
			btn.Parent = PlayerListFrame

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 4)
			btnCorner.Parent = btn

			-- Hover effect
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			end)

			btn.MouseButton1Click:Connect(function()
				lookAtPlayer(p)
				btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
				wait(0.1)
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			end)
		end
	end
	
	-- Update canvas size
	PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerCount * 32)
end

-- AUTO REFRESH GUI
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- INPUT CONTROL
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		Flying = not Flying
		if Flying then StartFlying() else StopFlying() end
	elseif input.KeyCode == Enum.KeyCode.R then
		lookAtNearestPlayer()
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
end)

-- INIT GUI
buildMainGUI()
refreshPlayerList()

print("Fly & Lookup Script Loaded!")
print("Controls:")
print("F - Toggle Fly")
print("R - Look at nearest player")
print("Click player name to look at them")
print("Drag speed slider to adjust fly speed")
