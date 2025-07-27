local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Cari RemoteEvent bernama "RequestFly"
local requestFly = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name == "RequestFly" then
        requestFly = v
        break
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "FlyAutoGUI"

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.85, 0)
button.Text = "Auto Test Fly"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Draggable = true
button.Active = true

-- Status Text
local status = Instance.new("TextLabel", screenGui)
status.Size = UDim2.new(0, 300, 0, 20)
status.Position = UDim2.new(0.5, -150, 0.9, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Text = "Menunggu..."
status.TextSize = 16
status.Font = Enum.Font.SourceSans

-- Payload list
local payloads = {
 true,
 false,
 "Fly",
 "Start",
 player,
 Vector3.new(0,10,0),
 nil
}

button.MouseButton1Click:Connect(function()
 if not requestFly then
  status.Text = "❌ Remote RequestFly tidak ditemukan."
  return
 end

 status.Text = "🔍 Menguji payload..."

 for _, payload in ipairs(payloads) do
  task.wait(0.5)
  local success, err = pcall(function()
   requestFly:FireServer(payload)
  end)

  if success then
   status.Text = "✅ Sukses FireServer: " .. tostring(payload)
   button.Text = "✅ Terbang Aktif?"
   break
  else
   print("Gagal payload:", payload, err)
  end
 end
end)
