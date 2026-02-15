local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 480) -- Увеличил высоту
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ULTIMATE RO-HUB V5.0"
Title.TextColor3 = Color3.new(0, 1, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Вспомогательная функция для кнопок с фильтром
local function CreateComplexButton(name, pos, modes, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local modeLabel = Instance.new("TextLabel", btn)
    modeLabel.Size = UDim2.new(0, 110, 0, 35)
    modeLabel.Position = UDim2.new(1, 5, 0, 0)
    modeLabel.Text = "[ " .. modes[1] .. " ]"
    modeLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    modeLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    local currentMode = 1
    local modeBtn = Instance.new("TextButton", modeLabel)
    modeBtn.Size = UDim2.new(1, 0, 1, 0)
    modeBtn.BackgroundTransparency = 1
    modeBtn.Text = ""
    
    modeBtn.MouseButton1Click:Connect(function()
        currentMode = currentMode + 1
        if currentMode > #modes then currentMode = 1 end
        modeLabel.Text = "[ " .. modes[currentMode] .. " ]"
    end)

    btn.MouseButton1Click:Connect(function()
        callback(modes[currentMode])
    end)
end

-- 1. СИМУЛЯЦИЯ КРАЖИ (ВИЗУАЛ)
local function FakeSteal()
    spawn(function()
        for i = 1, 50 do
            local fakeNotice = Instance.new("TextLabel", ScreenGui)
            fakeNotice.Size = UDim2.new(0, 250, 0, 40)
            fakeNotice.Position = UDim2.new(0.8, 0, 0.9, -i*45)
            fakeNotice.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            fakeNotice.Text = "GIFT! Received " .. math.random(100, 5000) .. " Robux!"
            fakeNotice.TextColor3 = Color3.new(1, 1, 1)
            game:GetService("TweenService"):Create(fakeNotice, TweenInfo.new(0.5), {Position = UDim2.new(0.7, 0, fakeNotice.Position.Y.Scale, fakeNotice.Position.Y.Offset)}):Play()
            task.wait(0.2)
        end
    end)
end

-- 2. RICH SERVER HOP
local function ServerHop(amount)
    print("Searching for server with volume: " .. amount)
    local TeleportService = game:GetService("TeleportService")
    -- Логика: Просто прыгаем на случайный сервер, надеясь на удачу (как в реальных эксплойтах)
    TeleportService:Teleport(game.PlaceId)
end

-- КНОПКИ ГУИ
CreateComplexButton("ULTRA LAG", UDim2.new(0, 10, 0, 50), {"Local", "Server", "Except Me"}, function(m) print("Lagging " .. m) end)
CreateComplexButton("SHUTDOWN", UDim2.new(0, 10, 0, 95), {"Server"}, function() print("Sending Crash...") end)

-- Кнопка STEAL (Симуляция)
local StealBtn = Instance.new("TextButton", MainFrame)
StealBtn.Size = UDim2.new(0, 295, 0, 40)
StealBtn.Position = UDim2.new(0, 10, 0, 145)
StealBtn.Text = "STEAL ROBUX (SIMULATION)"
StealBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
StealBtn.TextColor3 = Color3.new(1, 1, 1)
StealBtn.MouseButton1Click:Connect(FakeSteal)

-- Кнопка RICH SERVER HOP с фильтром
CreateComplexButton("RICH HOP", UDim2.new(0, 10, 0, 200), {"10K", "100K", "1M", "10M"}, ServerHop)

-- Кнопка CLOSE
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 295, 0, 40)
CloseBtn.Position = UDim2.new(0, 10, 0, 430)
CloseBtn.Text = "CLOSE MENU"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Добавление остальных кнопок из прошлого запроса
CreateComplexButton("VIRUS SERVICE", UDim2.new(0, 10, 0, 245), {"Active"}, function() print("Virus started") end)
CreateComplexButton("GIVE ADMIN", UDim2.new(0, 10, 0, 290), {"Owner"}, function() print("Admin tools injected") end)
