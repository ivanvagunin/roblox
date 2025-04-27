local module = {
    guiType = "checkbox",
    title = "No clip",
  }
  
  local noClipConnection
  
  local noClipParts = {}
  
  module.handler = function(enable)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
  
    local RunService = game:GetService("RunService")
  
    if enable then
      noClipConnection = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
          if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
            table.insert(noClipParts, part)
          end
        end
      end)
    else
      for i, part in ipairs(noClipParts) do
        part.CanCollide = true
      end
      noClipParts = {}
      noClipConnection:Disconnect()
    end
  end
  
  
  return module