local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local dragging
local dragInput
local dragStart
local startPos

local buttonHeight = 40

-- Button Creator Function
local function createButton(parent, buttonObj, order)
  local button = Instance.new("TextButton")
  button.Size = UDim2.new(0.8, 0, 0, buttonHeight)
  button.Position = UDim2.new(0.1, 0, 0, 40 + (buttonHeight + 10) * (order - 1))
  button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  button.Text = buttonObj.title .. " (Off)"
  button.TextColor3 = Color3.fromRGB(255, 255, 255)
  button.Font = Enum.Font.SourceSans
  button.TextSize = 18
  button.Parent = parent
  buttonObj.toggled = false
  button.MouseButton1Click:Connect(function()
    buttonObj.toggled = not buttonObj.toggled
    button.Text = buttonObj.title;
    if buttonObj.toggled then
      button.Text = button.Text .. " (On)"
    else
      button.Text = button.Text .. " (Off)"
    end
    buttonObj.handler(buttonObj.toggled)
  end)
  return button
end

local function update(frame, input)
  local delta = input.Position - dragStart
  frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function createMenu(buttons)

  -- Create Frame
  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(0, 200, 0, (#buttons + 2) * buttonHeight)
  frame.Position = UDim2.new(1, -210, 1, -210) -- bottom right corner
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
      update(frame, input)
    end
  end)

  -- Title Label
  local title = Instance.new("TextLabel")
  title.Size = UDim2.new(1, 0, 0, 30)
  title.BackgroundTransparency = 1
  title.Text = "Omega Hack"
  title.TextColor3 = Color3.fromRGB(255, 255, 255)
  title.Font = Enum.Font.SourceSansBold
  title.TextSize = 20
  title.Parent = frame  
  
  for i, button in ipairs(buttons) do
    createButton(frame, button, i)
  end
end

local jumpConnection
-- Functions
local function enableInfiniteJump(enable)
  local UserInputService = game:GetService("UserInputService")
  local player = game.Players.LocalPlayer
  local character = player.Character or player.CharacterAdded:Wait()
  local humanoid = character:WaitForChild("Humanoid")
  
  if enable then
    jumpConnection = UserInputService.JumpRequest:Connect(function()
      humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    
  else
    jumpConnection:Disconnect()
  end
end

local defaultWalkSpeed = 0
local function enableSpeedHack(enable)
  local player = game.Players.LocalPlayer
  local character = player.Character or player.CharacterAdded:Wait()
  local humanoid = character:WaitForChild("Humanoid")
  
  if enable then
    defaultWalkSpeed =humanoid.WalkSpeed 
    humanoid.WalkSpeed = 100 -- Adjust speed here
  else
    humanoid.WalkSpeed = defaultWalkSpeed
  end

  print("Speed Hack Activated! WalkSpeed = 100")
end
local noClipConnection
local function toggleNoclip(enable)
  local player = game.Players.LocalPlayer
  local character = player.Character or player.CharacterAdded:Wait()
  
  local RunService = game:GetService("RunService")
  
  if enable then
    noClipConnection = RunService.Stepped:Connect(function()
      for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
          part.CanCollide = false
        end
      end
    end)
  else
    noClipConnection:Disconnect()
  end
end
  
local buttons = {
  {
    title = "Infinite Jump",
    handler = enableInfiniteJump,
    isToggled = false
  },
  {
    title = "Speed Hack",
    handler = enableSpeedHack,
    isToggled = false
  },
  {
    title = "Toggle NoClip",
    handler = toggleNoclip,
    isToggled = false
  }
}

createMenu(buttons)