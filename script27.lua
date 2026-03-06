local ScreenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Button = Instance.new("TextButton")

mainFrame.Size = UDim2(50, 50, 50)
mainFrame.Position = UDim2(0, -225, -450)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
mainFrame.BorderSizePixel = 0.1
mainFrame.Title = "My Hub V1"
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

Button "Kick" function()
  game.Players.LocalPlayer:Kick()
end)
