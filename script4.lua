local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "TOOL HUB V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ScrollingFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 8)

-- Функция создания кнопок
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", ScrollingFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(callback)
end

-- 1. Kick Yourself
CreateButton("Kick Yourself", function()
    game.Players.LocalPlayer:Kick("Успешный самокик.")
end)

-- 2. Connect Hacker (Interface)
CreateButton("Connect Hacker", function()
    print("Hacker Service Initialized. Scanning players...")
end)

-- 3. Connect You As Hacker
CreateButton("Connect You As Hacker", function()
    local HackWin = Instance.new("Frame", ScreenGui)
    HackWin.Size = UDim2.new(0, 250, 0, 250)
    HackWin.Position = UDim2.new(0.7, 0, 0.5, -125)
    HackWin.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
    
    local l = Instance.new("TextLabel", HackWin)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = "Hacker Console"
    l.BackgroundColor3 = Color3.new(0,0,0)
    l.TextColor3 = Color3.new(0,1,0)

    local btns = {"Username: ...", "Password [Connect]", "Email [Connect]", "Email Code [Connect]", "Phone [Connect]"}
    for i, v in ipairs(btns) do
        local b = Instance.new("TextButton", HackWin)
        b.Size = UDim2.new(0.9, 0, 0, 30)
        b.Position = UDim2.new(0.05, 0, 0, 40 + (i-1)*35)
        b.Text = v
    end
end)

-- 4. Robux Generator (Internal bypass attempt)
CreateButton("Connect Robux Generator", function()
    print("Marketplace Bypass Active. Attempting free purchases...")
end)

-- 5. Speed Boost
CreateButton("Connect Speed Boost", function()
    local SpeedWin = Instance.new("Frame", ScreenGui)
    SpeedWin.Size = UDim2.new(0, 200, 0, 100)
    SpeedWin.Position = UDim2.new(0.2, 0, 0.5, -50)
    SpeedWin.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local input = Instance.new("TextBox", SpeedWin)
    input.Size = UDim2.new(0.8, 0, 0, 30)
    input.Position = UDim2.new(0.1, 0, 0.1, 0)
    input.PlaceholderText = "Введите скорость"
    
    local set = Instance.new("TextButton", SpeedWin)
    set.Size = UDim2.new(0.8, 0, 0, 30)
    set.Position = UDim2.new(0.1, 0, 0.5, 10)
    set.Text = "Set Speed"
    
    set.MouseButton1Click:Connect(function()
        local s = tonumber(input.Text) or 16
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end)
end)

-- 6. Custom Executor
CreateButton("Connect Custom Executor", function()
    local ExecWin = Instance.new("Frame", ScreenGui)
    ExecWin.Size = UDim2.new(0, 300, 0, 200)
    ExecWin.Position = UDim2.new(0.5, -150, 0.1, 0)
    ExecWin.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    local box = Instance.new("TextBox", ExecWin)
    box.Size = UDim2.new(0.9, 0, 0.7, 0)
    box.Position = UDim2.new(0.05, 0, 0.05, 0)
    box.ClearTextOnFocus = false
    box.MultiLine = true
    box.Text = "print('Hello')"
    
    local ex = Instance.new("TextButton", ExecWin)
    ex.Size = UDim2.new(0.9, 0, 0.2, 0)
    ex.Position = UDim2.new(0.05, 0, 0.75, 5)
    ex.Text = "Execute Script"
    ex.MouseButton1Click:Connect(function()
        loadstring(box.Text)()
    end)
end)

-- 7. New Script
CreateButton("Connect New Script", function()
    print("Scripting environment ready. Injecting to Workspace...")
end)

-- 8. Connect Explorer
CreateButton("Connect Explorer", function()
    local Dex = Instance.new("Frame", ScreenGui)
    Dex.Size = UDim2.new(0, 250, 0, 350)
    Dex.Position = UDim2.new(0, 50, 0.5, -175)
    Dex.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    local scrolly = Instance.new("ScrollingFrame", Dex)
    scrolly.Size = UDim2.new(1, 0, 1, -30)
    scrolly.Position = UDim2.new(0, 0, 0, 30)
    
    local list = Instance.new("UIListLayout", scrolly)
    
    local function Scan(obj, parent)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 25)
        b.Text = " > " .. obj.Name
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.MouseButton1Click:Connect(function()
            for _, child in pairs(obj:GetChildren()) do
                print("Found: " .. child.Name .. " (" .. child.ClassName .. ")")
            end
        end)
    end
    
    Scan(game.Workspace, scrolly)
    Scan(game.ReplicatedStorage, scrolly)
    Scan(game.Players, scrolly)
end)
