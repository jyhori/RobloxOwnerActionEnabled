local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
game:GetService("CoreGui")

Main.Size = UDim2.new(50, 50, 50)
Main.Position = UDim2.new(0, -225, -450)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0.1
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(5, 5, 5)
Title.Position = UDim2.new(0, -300, -350)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BackgroundTransparency = 0.1
Title.BorderSizePixel = 0.1
Title.Text = "Ultimate Hub V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 1
Title.Font = Chicago
Title.Parent = Main

local Button = Instance.new("TextButton")

Button.Size = UDim2.new(10, 5, 6)
Button.Position = UDim2.new(0, -400, -450)
Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Button.BackgroundTransparency = 0.1
Button.BorderSizePixel = 0.1
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 1
Button.Parent = Title

local plr = game.Players.LocalPlayer
local plrs = game.Players
local playername = frame.PlayerName
local reason = frame.Reason

Button.new = "Kick Player" function()
    local plrKick = plrs:FindFirstChild(playername.Text)
    if plrKick then
      plrKick:Kick('Reason: \n Fake reason:'..reason.Text)
    else
      reason.Text = 'Unknown error. Player not detected.'
    end
  end
end)

local DataStore = game:GetService("DataStoreService")

Button.Size = UDim2.new(10, 5, 6)
Button.Position = UDim2.new(0, -400, -450)
Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Button.BackgroundTransparency = 0.1
Button.BorderSizePixel = 0.1
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 1
Button.Parent = Title

Button.new = "Ban player" function()
    Title.Size = UDim2.new(5, 5, 5)
    Title.Position = UDim2.new(0, -500, -550)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.BackgroundTransparency = 0.1
    Title.BorderSizePixel = 0.1
    Title.Text = "Ban for 30 sec"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 1
    Title.Font = Chicago
    Title.Parent = Main
    Title.Size = UDim2.new(5, 5, 5)
    Title.Position = UDim2.new(0, -600, -650)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.BackgroundTransparency = 0.1
    Title.BorderSizePixel = 0.1
    Title.Text = "Ban for 1 min"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 1
    Title.Font = Chicago
    Title.Parent = Main
    if Title = "Ban for 30 sec" function()
        local plrBan = plrs:FindFirstChild(playername.Text)
        if plrBan then
            Connect:DataStoreService then
                plrBan:Ban('Reason: \n Fake reason:'..reason.Text)
                if plrBan success then
                    plrBan.time(30)
    else
      reason.Text('Unknown error. Player not detected.')
      end
    end
  end
end)
    if Title = "Ban for 1 min" function()
        plrs:FindFirstChild(playername.Text)
        if plrBan then
            Connect:DataStoreService then
                plrBan:Ban('Reason: \n Fake reason:'..reason.Text)
                if plrBan success then
                    plrBan.time(60)
    else
      reason.Text('Unknown error. Player not detected.')
  end
end)
