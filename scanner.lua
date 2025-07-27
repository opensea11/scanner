local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local remote = ReplicatedStorage:FindFirstChild("RequestFly")

local payloads = {
    {Fly = true},
    {action = "start"},
    {Action = "Fly"},
    {state = "flying"},
    {player = player},
    {character = character},
    {Fly = true, player = player},
    {Fly = true, character = character},
    {Fly = true, Position = Vector3.new(0,50,0)},
    {Fly = true, Velocity = Vector3.new(0,50,0)},
    {Request = "Fly", Character = character},
    {RequestFly = true},
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "FlyPayloadTester"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.8, -100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🧪 Fly Payload Tester"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Scrolling = Instance.new("ScrollingFrame", Frame)
Scrolling.Size = UDim2.new(1, 0, 1, -30)
Scrolling.Position = UDim2.new(0, 0, 0, 30)
Scrolling.CanvasSize = UDim2.new(0, 0, 0, #payloads * 30)
Scrolling.ScrollBarThickness = 4
Scrolling.BackgroundTransparency = 0.3
Scrolling.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function isFlying()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    return hrp and math.abs(hrp.AssemblyLinearVelocity.Y) > 5
end

for i, payload in ipairs(payloads) do
    task.delay(i * 1.2, function()
        local resultText = Instance.new("TextButton", Scrolling)
        resultText.Size = UDim2.new(1, -10, 0, 25)
        resultText.Position = UDim2.new(0, 5, 0, (i - 1) * 30)
        resultText.Text = "Payload #" .. i .. ": Testing..."
        resultText.TextColor3 = Color3.fromRGB(200, 200, 200)
        resultText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        resultText.Font = Enum.Font.SourceSans
        resultText.TextSize = 14
        resultText.TextXAlignment = Enum.TextXAlignment.Left

        -- Try payload
        local success = pcall(function()
            remote:FireServer(payload)
        end)

        task.wait(0.6)

        if isFlying() then
            resultText.Text = "✅ Payload #" .. i .. " - SUCCESS"
            resultText.TextColor3 = Color3.fromRGB(0, 255, 0)
            resultText.MouseButton1Click:Connect(function()
                setclipboard(game.HttpService:JSONEncode(payload))
                StarterGui:SetCore("SendNotification", {
                    Title = "Payload Copied!";
                    Text = "Berhasil disalin ke clipboard";
                    Duration = 3;
                })
            end)
        else
            resultText.Text = "❌ Payload #" .. i .. " - Failed"
        end
    end)
end
