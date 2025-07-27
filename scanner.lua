local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Buat GUI utama
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "RemoteClickScanner"

local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.6, 0)
frame.CanvasSize = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 6
frame.Active = true
frame.Draggable = true  -- ✅ Ini bikin bisa di-drag

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi tambah tombol RemoteEvent
local function addRemoteButton(remote)
 local button = Instance.new("TextButton")
 button.Size = UDim2.new(1, -10, 0, 30)
 button.Text = "🔍 " .. remote:GetFullName()
 button.Font = Enum.Font.SourceSans
 button.TextSize = 14
 button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
 button.TextColor3 = Color3.new(1, 1, 1)
 button.AutoButtonColor = true
 button.Parent = frame

 button.MouseButton1Click:Connect(function()
  local success, err = pcall(function()
   remote:FireServer("scan_test_payload")
  end)

  if success then
   button.Text = "✅ Success: " .. remote.Name
   button.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
  else
   button.Text = "❌ Failed: " .. remote.Name
   button.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
  end
 end)
end

-- Scan semua RemoteEvent
for _, obj in ipairs(game:GetDescendants()) do
 if obj:IsA("RemoteEvent") then
  addRemoteButton(obj)
 end
end

-- Atur tinggi canvas otomatis
task.delay(0.2, function()
 frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
