-- Script Hub (Bottom-Right Menu) for JJSploit
-- Options: Infinite Jump, Speed Hack, Noclip

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(1, -210, 1, -190) -- bottom right corner
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Script Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Button Creator Function
local function createButton(text, positionY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.Position = UDim2.new(0.1, 0, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = frame
    return button
end

-- Create Buttons
local jumpButton = createButton("Infinite Jump", 0.22)
local speedButton = createButton("Speed Hack", 0.47)
local noclipButton = createButton("Noclip", 0.72)

-- Functions
local function enableInfiniteJump()
    local UserInputService = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    UserInputService.JumpRequest:Connect(function()
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)

    print("Infinite Jump Activated!")
end

local function enableSpeedHack()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 100 -- Adjust speed here

    print("Speed Hack Activated! WalkSpeed = 100")
end

local noclipEnabled = false
local function toggleNoclip()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local RunService = game:GetService("RunService")
    
    noclipEnabled = not noclipEnabled

    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    if noclipEnabled then
        print("Noclip Activated!")
    else
        print("Noclip Deactivated!")
    end
end

-- Button Events
jumpButton.MouseButton1Click:Connect(enableInfiniteJump)
speedButton.MouseButton1Click:Connect(enableSpeedHack)
noclipButton.MouseButton1Click:Connect(toggleNoclip)

print("Local Menu Loaded! Bottom right corner.")
