-- GUI Carry Remote Scanner
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 280, 0, 300)
Frame.Position = UDim2.new(0.5, -140, 0.7, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔍 Remote Carry Scanner"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Keyword yang dicari
local keywords = {"carry", "grab", "attach", "pickup", "hold"}

-- Cek semua RemoteEvent
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        for _, word in ipairs(keywords) do
            if obj.Name:lower():find(word) then
                local btn = Instance.new("TextButton", Frame)
                btn.Size = UDim2.new(1, -10, 0, 25)
                btn.Text = "🔘 " .. obj.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 14
                btn.AutoButtonColor = true
                btn.MouseButton1Click:Connect(function()
                    local success, err = pcall(function()
                        obj:FireServer("test_payload")
                    end)
                    if success then
                        btn.Text = "✅ Sent: " .. obj.Name
                        btn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
                    else
                        btn.Text = "❌ Failed: " .. obj.Name
                        btn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
                    end
                end)
            end
        end
    end
end
