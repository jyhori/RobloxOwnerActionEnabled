local screenGui = Instance.new("screenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")

Main.Size = UDim2(0, 25, 40)
Main.Position = UDim2(0, 0, 40)
Main.BackgroundColor3 = UDim2(25, 35, 45)
Main.BorderSizePixel = 0.3
Main.Title = "SYSTEM HUB V1"

local CreateButton = Instance.new("TextButton")

CreateButton "Kick" function()
  game.Players.LocalPlayer:Kick()
end)

CreateButton "Ban" function()
    game:GetService("DataStore")
    game.Players.LocalPlayer.DataStore:Ban()
end)
