local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local tweenService = game:GetService("TweenService")

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Center the frame
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true -- Allow dragging
frame.Draggable = true -- Make the frame draggable
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Teleport Settings"
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Max Distance Slider
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(1, 0, 0, 20)
distanceLabel.Position = UDim2.new(0, 0, 0, 25)
distanceLabel.Text = "Max Distance: 100"
distanceLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
distanceLabel.TextColor3 = Color3.new(1, 1, 1)
distanceLabel.Parent = frame

local distanceSlider = Instance.new("TextBox")
distanceSlider.Size = UDim2.new(0.8, 0, 0, 20)
distanceSlider.Position = UDim2.new(0.1, 0, 0, 50)
distanceSlider.Text = "100"
distanceSlider.BackgroundColor3 = Color3.new(1, 1, 1)
distanceSlider.TextColor3 = Color3.new(0, 0, 0)
distanceSlider.Parent = frame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 30)
toggleButton.Position = UDim2.new(0.1, 0, 0, 80)
toggleButton.Text = "Toggle Teleport (OFF)"
toggleButton.BackgroundColor3 = Color3.new(1, 0, 0) -- Red when OFF
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = frame

-- Variables
local teleportMode = false
local maxTeleportDistance = 100

-- Update Max Distance
distanceSlider.FocusLost:Connect(function()
    local newDistance = tonumber(distanceSlider.Text)
    if newDistance and newDistance > 0 then
        maxTeleportDistance = newDistance
        distanceLabel.Text = "Max Distance: " .. maxTeleportDistance
    else
        distanceSlider.Text = maxTeleportDistance -- Reset to previous value
    end
end)

-- Toggle Teleport Mode
toggleButton.MouseButton1Click:Connect(function()
    teleportMode = not teleportMode
    if teleportMode then
        toggleButton.Text = "Toggle Teleport (ON)"
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0) -- Green when ON
    else
        toggleButton.Text = "Toggle Teleport (OFF)"
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0) -- Red when OFF
    end
end)

-- Function to tween the player to a position
local function tweenToPosition(position)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = character.HumanoidRootPart
    local direction = (position - humanoidRootPart.Position).Unit
    local distance = (humanoidRootPart.Position - position).Magnitude

    -- If the target is beyond the max distance, move as far as possible
    local targetPosition = humanoidRootPart.Position + direction * math.min(distance, maxTeleportDistance)

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
end

-- Handle mouse click
mouse.Button1Down:Connect(function()
    if teleportMode then
        local targetPosition = mouse.Hit.Position
        tweenToPosition(targetPosition)
    end
end)
