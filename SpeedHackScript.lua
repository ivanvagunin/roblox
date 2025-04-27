local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local module = {
  guiType = "slider",
  guiOptions = {
    value = humanoid.WalkSpeed,
    minValue = 0,
    maxValue = 100,
  },
  title = "Speed",
}

local defaultWalkSpeed = 0
module.handler = function (enable, value)
  local player = game.Players.LocalPlayer
  local character = player.Character or player.CharacterAdded:Wait()
  local humanoid = character:WaitForChild("Humanoid")

  if enable then
    defaultWalkSpeed = humanoid.WalkSpeed 
    humanoid.WalkSpeed = value -- Adjust speed here
  else
    humanoid.WalkSpeed = defaultWalkSpeed
  end

  print("Speed Hack Activated! WalkSpeed = 100")
end


return module