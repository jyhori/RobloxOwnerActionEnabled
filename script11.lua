local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 700)
Main.Position = UDim2.new(0.5, -300, 0.5, -350)
Main.BackroundColor3 = Color3.fromRGB(0, 0, 0)
Main.Active, Main.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Control Hub V1 [BYPASS]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 225)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -30, 1, -90)
Scroll.Position = UDim2.new(0, 20, 0, 60)
Scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
Scroll.BackgroundTransparency = 1

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 9)

local CreateButton = Instance.new("TextButton")
local CreateGui = Instance.new("DoubleScreenGui")

CreateButton("Fly", function()
    local Fly = (game:GetService("FlyService"))
    FlyService:Fly(game.PlaceId, Local.Players.LocalPlayer)
    end
end

CreateButton("Console", function()
    local Console = (game:GetService("ConsoleService"))
    ConsoleService:Console(game.PlaceId, Local.Players.LocalPlayer)

while true do
    task.wait(1)
    CreateGui.new(
        game:GetService("DoubleScreenGui")
    )
    until CreateButton("Crash Server", function()
        local Crash = (game:GetService("CrashService"))
        CrashService:Crash(game.PlaceId, Local.Players.LocalPlayer)
    end
end

-- Thanks you for use this script.
