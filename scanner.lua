local flyKeywords = {"fly", "hover", "ascend", "levitate", "float", "air"}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FlyRemoteScanner"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.4, 0, 0.6, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Fly Remote Scanner"
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 4)

local function createButton(remote)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Text = "🔍 " .. remote.Name
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = ScrollingFrame

    button.MouseButton1Click:Connect(function()
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer()
                button.Text = "✅ Sent: " .. remote.Name
                button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer()
                button.Text = "✅ Invoked: " .. remote.Name
                button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            end
        end)
    end)
end

for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        for _, keyword in pairs(flyKeywords) do
            if remote.Name:lower():find(keyword) then
                createButton(remote)
            end
        end
    end
end

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
