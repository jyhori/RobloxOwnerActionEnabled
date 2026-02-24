local screenGui = Instance.new("screenGui")
local Main = Instance.new("Frame")

-- gui
Main.Size = UDim2.new(0, 200, 100)
Main.Position = UDim2.new(0, -225, -450)
Main.BackgroundColor3 = UDim2.new(0, 25, 40)
Main.BackgrondTransparency = 0.3
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.new(1, 1, 1)
Main.Parent = screenGui

local CreateButton = Instance.new("TextButton")

CreateButton = "Jail forever" function()
  local Jail = Instance.new("Model")
  game:GetService("JailService")
  JailService:Jail(game.PlaceId, game.Players.LocalPlayer)
end)
