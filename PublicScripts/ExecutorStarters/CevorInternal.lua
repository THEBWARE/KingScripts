if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ScriptExecutor") then
    return
end

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExecutor"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.4, 0)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local tabsContainer = Instance.new("ScrollingFrame")
tabsContainer.Size = UDim2.new(1, 0, 0.1, 0)
tabsContainer.Position = UDim2.new(0, 0, 0, 0)
tabsContainer.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
tabsContainer.BorderSizePixel = 0
tabsContainer.ScrollBarThickness = 8
tabsContainer.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.3)
tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabsContainer.Parent = frame

local tabsList = Instance.new("UIListLayout")
tabsList.FillDirection = Enum.FillDirection.Horizontal
tabsList.Padding = UDim.new(0, 5)
tabsList.Parent = tabsContainer

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0.7, 0)
textBox.Position = UDim2.new(0.05, 0, 0.15, 0)
textBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Text = "Enter script here..."
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.45, 0, 0.1, 0)
executeButton.Position = UDim2.new(0.05, 0, 0.87, 0)
executeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.Text = "Execute"
executeButton.Parent = frame

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.45, 0, 0.1, 0)
clearButton.Position = UDim2.new(0.5, 0, 0.87, 0)
clearButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.Text = "Clear Text"
clearButton.Parent = frame

local addTabButton = Instance.new("TextButton")
addTabButton.Size = UDim2.new(0.1, 0, 1, 0)
addTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
addTabButton.TextColor3 = Color3.new(1, 1, 1)
addTabButton.Text = "+"
addTabButton.Parent = tabsContainer

local tabs = {}
local currentTab = nil
local tabCounter = 1

local MIN_TAB_WIDTH = 50

local function updateTabSizes()
    local totalTabs = #tabs + 1
    local containerWidth = tabsContainer.AbsoluteSize.X
    local totalPadding = tabsList.Padding.Offset * (totalTabs - 1)
    local availableWidth = containerWidth - totalPadding
    local tabWidth = math.max(MIN_TAB_WIDTH, availableWidth / totalTabs)

    for _, tab in ipairs(tabs) do
        tab.button.Size = UDim2.new(0, tabWidth, 1, 0)
        local maxTextLength = math.floor(tabWidth / 10)
        if #tab.title > maxTextLength then
            tab.label.Text = string.sub(tab.title, 1, maxTextLength) .. "..."
        else
            tab.label.Text = tab.title
        end
    end

    addTabButton.Size = UDim2.new(0, tabWidth, 1, 0)
end

local function updateTabsContainerSize()
    local totalWidth = 0
    for _, tab in ipairs(tabs) do
        totalWidth = totalWidth + tab.button.AbsoluteSize.X + tabsList.Padding.Offset
    end
    totalWidth = totalWidth + addTabButton.AbsoluteSize.X
    tabsContainer.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
end

local function createTab(title)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.2, 0, 1, 0)
    tabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.Text = ""
    tabButton.Parent = tabsContainer

    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(0.8, 0, 1, 0)
    tabLabel.Position = UDim2.new(0, 0, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.TextColor3 = Color3.new(1, 1, 1)
    tabLabel.Text = title
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabButton

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.1, 0, 1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Text = "X"
    closeButton.Parent = tabButton

    local tab = {
        title = title,
        content = "",
        button = tabButton,
        label = tabLabel,
        closeButton = closeButton
    }

    table.insert(tabs, tab)

    updateTabSizes()
    updateTabsContainerSize()

    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.content = textBox.Text
        end
        currentTab = tab
        textBox.Text = tab.content
    end)

    closeButton.MouseButton1Click:Connect(function()
        if #tabs > 1 then
            tabButton:Destroy()
            for i, v in ipairs(tabs) do
                if v == tab then
                    table.remove(tabs, i)
                    break
                end
            end
            if currentTab == tab then
                currentTab = tabs[1]
                textBox.Text = currentTab.content
            end
            updateTabSizes()
            updateTabsContainerSize()
        end
    end)
end

addTabButton.MouseButton1Click:Connect(function()
    local tabTitle = "New Tab " .. tabCounter
    createTab(tabTitle)
    tabCounter = tabCounter + 1
end)

createTab("New Tab " .. tabCounter)
tabCounter = tabCounter + 1

local function toggleGUI()
    frame.Visible = not frame.Visible
    if frame.Visible then
        textBox:CaptureFocus()
    end
end

local function executeScript()
    local scriptText = textBox.Text
    local success, errorMessage = pcall(function()
        loadstring(scriptText)()
    end)
    if not success then
        warn("Error executing script: " .. errorMessage)
    end
end

executeButton.MouseButton1Click:Connect(executeScript)

clearButton.MouseButton1Click:Connect(function()
    textBox.Text = ""
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        toggleGUI()
    end
end)

local isDragging = false
local dragStartPos = nil
local frameStartPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local dragDelta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + dragDelta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + dragDelta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)
