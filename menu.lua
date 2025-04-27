local UserInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
-- screenGui.Parent = player.PlayerGui
screenGui.Parent = game.CoreGui

local dragging
local dragInput
local dragStart
local startPos

local menuRowHeight = 40

-- Button Creator Function
local function createButton(parent, buttonObj, order)
  local button = Instance.new("TextButton")
  button.Size = UDim2.new(0.8, 0, 0, menuRowHeight)
  button.Position = UDim2.new(0.1, 0, 0, 50 + (menuRowHeight + 10) * (order - 1))
  button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  button.Text = buttonObj.title .. " (Off)"
  button.TextColor3 = Color3.fromRGB(255, 255, 255)
  button.Font = Enum.Font.SourceSans
  button.TextSize = 18
  button.Parent = parent
  buttonObj.toggled = false
  
  local textbox
  
  if buttonObj.value then
    button.TextXAlignment = Enum.TextXAlignment.Left
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)  -- 10 pixels padding from the left
    padding.PaddingTop = UDim.new(0, 5)    -- 5 pixels from top
    padding.PaddingBottom = UDim.new(0, 5) -- 5 pixels from bottom
    padding.PaddingRight = UDim.new(0, 10) -- 10 pixels from right
    padding.Parent = button
    
    textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.4, 0, 0.8, 0) -- smaller than button
    textbox.Position = UDim2.new(0.6, 0, 0.1, 0) -- centered inside
    textbox.PlaceholderText = "Type here..."
    textbox.Text = ""
    textbox.Parent = button   
  end
  
  button.MouseButton1Click:Connect(function()
    buttonObj.toggled = not buttonObj.toggled
    button.Text = buttonObj.title;
    if buttonObj.toggled then
      button.Text = button.Text .. " (On)"
    else
      button.Text = button.Text .. " (Off)"
    end
    local userValue
    if buttonObj.value  then
      userValue=tonumber(textbox.Text)
    end
    buttonObj.handler(buttonObj.toggled, userValue)
  end)
  return button
end

-- Function to create a slider
local function createSlider(parent, script, order)
  -- Main slider frame (background bar)
  local sliderFrame = Instance.new("Frame")
  sliderFrame.Size = UDim2.new(0.8, 0, 0, menuRowHeight)
  sliderFrame.Position = UDim2.new(0.1, 0, 0, 50 + (menuRowHeight + 10) * (order - 1))
  sliderFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
  sliderFrame.BorderSizePixel = 0
  sliderFrame.Parent = parent

  -- Fill bar (shows current value)
  local fillBar = Instance.new("Frame")
  fillBar.Size = UDim2.new(0, 0, 1, 0) -- Start empty
  fillBar.Position = UDim2.new(0, 0, 0, 0)
  fillBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
  fillBar.BorderSizePixel = 0
  fillBar.ZIndex = 2
  fillBar.Parent = sliderFrame

  -- Drag button
  local dragButtonWidth = 20
  local dragButton = Instance.new("TextButton")
  dragButton.Size = UDim2.new(0, dragButtonWidth, 1, 0)
  dragButton.Position = UDim2.new(0, 0, 0, 0)
  dragButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  dragButton.Text = ""
  dragButton.ZIndex = 3
  dragButton.Parent = sliderFrame

  -- Value Label
  local valueLabel = Instance.new("TextLabel")
  valueLabel.Size = UDim2.new(0.8, 0, 0.6, 0)
  valueLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
  valueLabel.BackgroundTransparency = 1
  valueLabel.Text = script.title .. ": " .. script.guiOptions.value
  valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
  valueLabel.Font = Enum.Font.SourceSans
  valueLabel.TextScaled = true
  valueLabel.ZIndex = 10
  valueLabel.Parent = sliderFrame

  -- Dragging logic
  local dragging = false

  local function updateSlider(inputX)
    local relativeX = math.clamp(inputX - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
    local percent = relativeX / (sliderFrame.AbsoluteSize.X)
    local value = math.floor(percent * 100) -- 0 to 100
-- Update visuals
    fillBar.Size = UDim2.new(percent, 0, 1, 0)
    dragButton.Position = UDim2.new(0, relativeX - dragButton.Size.X.Offset/2, 0, 0)
    
    valueLabel.Text = script.title .. ": " .. tostring(value)
    script.handler(true, value)
  end

  dragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
    end
  end)

  dragButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = false
    end
  end)

  game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
      updateSlider(input.Position.X)
    end
  end)

  updateSlider((script.guiOptions.value / 100) * sliderFrame.AbsoluteSize.X + sliderFrame.AbsolutePosition.X)
  -- Return useful parts
  return sliderFrame, function()
    return tonumber(valueLabel.Text)
  end
end


-- Function to create a checkbox
local function createCheckbox(parent, script, order)
  -- Main checkbox frame
  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(0.8, 0, 0, menuRowHeight)
  frame.Position = UDim2.new(0.1, 0, 0, 50 + (menuRowHeight + 10) * (order - 1))
  frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
  frame.Parent = parent

  local hiddenButton = Instance.new("TextButton")
  hiddenButton.Size = UDim2.new(0.8, 0, 0, menuRowHeight)
  hiddenButton.Position = UDim2.new(0.1, 0, 0, 40 + (menuRowHeight + 10) * (order - 1))
  hiddenButton.Parent = parent
  hiddenButton.BackgroundTransparency = 1
  hiddenButton.TextTransparency = 1
  hiddenButton.ZIndex = 10
  
  -- Checkbox button
  local checkbox = Instance.new("TextButton")
  checkbox.Size = UDim2.new(0, 20, 0, 20)
  checkbox.Position = UDim2.new(0, 10, 0.5, -10) -- center vertically
  checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  checkbox.Text = ""
  checkbox.Parent = frame

  -- Label next to checkbox
  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(1, -40, 0.6, 0)
  label.Position = UDim2.new(0, 40, 0.2, 0)
  label.BackgroundTransparency = 1
  label.Text = script.title
  label.TextColor3 = Color3.fromRGB(255, 255, 255)
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Font = Enum.Font.SourceSans
  label.TextScaled = true
  label.Parent = frame

  -- Checked indicator
  local checkMark = Instance.new("TextLabel")
  checkMark.Size = UDim2.new(1, 0, 1, 0)
  checkMark.BackgroundTransparency = 1
  checkMark.Text = "✔️"
  checkMark.TextColor3 = Color3.fromRGB(0, 255, 0)
  checkMark.TextScaled = true
  checkMark.Visible = false -- Start unchecked
  checkMark.Parent = checkbox

  -- Toggle checked state
  local isChecked = false

  hiddenButton.MouseButton1Click:Connect(function()
    isChecked = not isChecked
    checkMark.Visible = isChecked
    script.handler(isChecked)
  end)
end

local function createScriptUi(parent, script, order)
  if script.guiType == "checkbox" then
    createCheckbox(parent, script, order)
  elseif script.guiType == "slider" then
    createSlider(parent, script, order)
  else
    createButton(parent, script, order)
  end

end


local function updateFramePosition(frame, input)
  local delta = input.Position - dragStart
  frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local minimized = false

local function hideAllChildren(frame, visible)
  for _, child in pairs(frame:GetChildren()) do
    -- Check if the child is a GUI object (TextButton, TextLabel, etc.)
    if child:IsA("GuiObject") then
      child.Visible = visible
    end
  end
end
local function createMainGui(scripts)
  -- Create Frame
  local frame = Instance.new("Frame")
  local height = (#scripts + 2) * menuRowHeight + 10
  frame.Size = UDim2.new(0, 250, 0, height)
  frame.Position = UDim2.new(1, -260, 1, -height -10
  ) -- bottom right corner
  frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
  frame.BorderSizePixel = 0
  frame.Parent = screenGui
  frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
      dragStart = input.Position
      startPos = frame.Position

      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)
  frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
      dragInput = input
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
      updateFramePosition(frame, input)
    end
  end)

  -- Title Label
  local title = Instance.new("TextLabel")
  title.Size = UDim2.new(1, 0, 0, 40)
  title.BackgroundTransparency = 1
  title.Text = "Chicken Hub"
  title.TextColor3 = Color3.fromRGB(255, 255, 255)
  title.Font = Enum.Font.SourceSansBold
  title.TextSize = 20
  title.Parent = frame  

  for i, script in ipairs(scripts) do
    createScriptUi(frame, script, i)
  end
  
  local icon = Instance.new("ImageLabel")
  icon.Size = UDim2.new(0, 40, 0, 40) -- Slight padding inside
  icon.Position = UDim2.new(0, 0, 0, 0)
  icon.BackgroundTransparency = 1
  icon.Image = "rbxassetid://93333926094882"
  icon.Parent = frame
  icon.ZIndex = 9
  
  
  -- Create the Minimize Button
  local minimizeButton = Instance.new("TextButton")
  minimizeButton.Size = UDim2.new(0, 20, 0, 20)
  minimizeButton.Position = UDim2.new(1, -30, 0, 5) -- top-right corner, 10px down
  minimizeButton.Text = "—"
  minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
  minimizeButton.BackgroundTransparency = 0.5
  minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  minimizeButton.Font = Enum.Font.SourceSansBold
  minimizeButton.TextScaled = true
  minimizeButton.Parent = frame -- Add it inside the menu
  minimizeButton.ZIndex = 10
  minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
      -- Expand menu
      frame.Size = UDim2.new(0, 250, 0, -height -10)
      minimized = false
      minimizeButton.Text = "—"
      hideAllChildren(frame, true)
    else
      -- Minimize menu
      frame.Size = UDim2.new(0, 40, 0, 40)
      minimized = true
      minimizeButton.Text = "+"
      hideAllChildren(frame, false)
      minimizeButton.Visible = true
      icon.Visible = true
    end
  end)
  
end


local noClip = require(game.StarterPlayer.StarterPlayerScripts.NoClipScript)
local speedHack = require(game.StarterPlayer.StarterPlayerScripts.SpeedHackScript)
local infiniteJump = require(game.StarterPlayer.StarterPlayerScripts.InfiniteJumpScript)
local esp = require(game.StarterPlayer.StarterPlayerScripts.EspScript)

local scripts = {
  noClip,
  speedHack,
  infiniteJump,
  esp,
}

createMainGui(scripts)