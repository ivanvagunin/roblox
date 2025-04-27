PlayersService = game:GetService("Players")

local localPlayer = game.Players.LocalPlayer

local module = {
  guiType = "checkbox",
  title = "ESP",
}

local function highlightPlayer(player, localPlayer)
  if player == localPlayer then return end -- Skip yourself

  local character = player.Character
  if not character then return end

  -- Check if already highlighted
  if character:FindFirstChild("Highlight") then return end

  local head = character:WaitForChild("Head")
  -- Create a Highlight object
  local highlight = Instance.new("Highlight")
  highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red fill
  highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
  highlight.FillTransparency = 0.5
  highlight.OutlineTransparency = 0
  highlight.Parent = character

  -- === Name BillboardGui ===
  local billboard = Instance.new("BillboardGui")
  billboard.Size = UDim2.new(0, 150, 0, 20)
  billboard.Adornee = head
  billboard.AlwaysOnTop = true
  billboard.StudsOffset = Vector3.new(0, 2, 0)
  billboard.Parent = head

  local nameLabel = Instance.new("TextLabel")
  nameLabel.Size = UDim2.new(1, 0, 1, 0)
  nameLabel.BackgroundTransparency = 1
  nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
  nameLabel.TextStrokeTransparency = 0
  nameLabel.Text = player.Name
  nameLabel.Font = Enum.Font.SourceSansBold
  nameLabel.TextScaled = true
  nameLabel.Parent = billboard
end

module.handler = function(enable)

  local allPlayers = PlayersService:GetPlayers()

  for i, player in ipairs(allPlayers) do
    highlightPlayer(player, localPlayer)
  end

end


return module