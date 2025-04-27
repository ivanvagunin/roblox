local module = {
    guiType = "checkbox",
    title = "Infinte jump",
  }
  
  local jumpConnection
  -- Functions
  module.handler = function(enable)
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
  
  return module