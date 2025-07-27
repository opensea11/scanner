local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 280, 0, 130)
Frame.Position = UDim2.new(0.5, -140, 0.75, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local ScanButton = Instance.new("TextButton", Frame)
ScanButton.Size = UDim2.new(1, -20, 0, 40)
ScanButton.Position = UDim2.new(0, 10, 0, 10)
ScanButton.Text = "Scan + Test Fly Remotes"
ScanButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ScanButton.TextColor3 = Color3.new(1,1,1)
ScanButton.Font = Enum.Font.SourceSans
ScanButton.TextSize = 20

local ResultLabel = Instance.new("TextLabel", Frame)
ResultLabel.Size = UDim2.new(1, -20, 0, 30)
ResultLabel.Position = UDim2.new(0, 10, 0, 60)
ResultLabel.BackgroundTransparency = 1
ResultLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
ResultLabel.Font = Enum.Font.SourceSansBold
ResultLabel.TextSize = 16
ResultLabel.Text = "Status: Waiting..."

local SubLabel = Instance.new("TextLabel", Frame)
SubLabel.Size = UDim2.new(1, -20, 0, 20)
SubLabel.Position = UDim2.new(0, 10, 0, 90)
SubLabel.BackgroundTransparency = 1
SubLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
SubLabel.Font = Enum.Font.SourceSansItalic
SubLabel.TextSize = 14
SubLabel.Text = "Payload test will auto-run..."

-- Common test payloads
local payloads = {
 "Fly", true, false, 1, 0, {}, {true}, {false}, nil, "RequestFly", {mode = "fly"},
 player.Character,
}

ScanButton.MouseButton1Click:Connect(function()
 local found = false
 for _, v in pairs(ReplicatedStorage:GetDescendants()) do
  if v:IsA("RemoteEvent") and v.Name:lower():find("fly") then
   found = true
   ResultLabel.Text = "🛫 Found: "..v.Name.." (Testing...)"
   print("🛫 Found remote:", v.Name)

   for i, p in ipairs(payloads) do
    task.delay(i * 0.5, function()
     local success, err = pcall(function()
      v:FireServer(p)
     end)
     if success then
      print("✅ Payload Success:", typeof(p), p)
      SubLabel.Text = "✅ Success: "..(typeof(p) == "table" and "table" or tostring(p))
     else
      print("❌ Payload Failed:", p, "Error:", err)
     end
    end)
   end

   -- Track response (optional)
   local char = player.Character or player.CharacterAdded:Wait()
   local hrp = char:WaitForChild("HumanoidRootPart")
   local humanoid = char:WaitForChild("Humanoid")

   local startPos = hrp.Position
   local startState = humanoid:GetState()

   task.delay(#payloads * 0.6 + 1, function()
    local distMoved = (hrp.Position - startPos).Magnitude
    local newState = humanoid:GetState()
    if distMoved > 5 then
     print("✅ Character moved after payload.")
     ResultLabel.Text = "✅ Server Response: Position Changed"
    elseif newState ~= startState then
     print("✅ Humanoid state changed:", newState)
     ResultLabel.Text = "✅ State Change: "..tostring(newState)
    else
     ResultLabel.Text = "❌ No movement/state change"
    end
   end)
   break
  end
 end
 if not found then
  ResultLabel.Text = "❌ No RemoteEvent with 'fly' found"
 end
end)
