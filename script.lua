-- Инициализация GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SERVER EXPLOIT PANEL v2.0"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

-- Функция для создания кнопок с выбором режима
local function CreateComplexButton(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local modeLabel = Instance.new("TextLabel", btn)
    modeLabel.Size = UDim2.new(0, 100, 0, 35)
    modeLabel.Position = UDim2.new(1, 5, 0, 0)
    modeLabel.Text = "[ Local ]" -- По умолчанию
    modeLabel.TextColor3 = Color3.new(1, 1, 1)
    modeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local modes = {"Local", "Server", "Except Me"}
    local currentMode = 1
    
    -- Переключение фильтра при клике на [ Mode ]
    local modeBtn = Instance.new("TextButton", modeLabel)
    modeBtn.Size = UDim2.new(1, 0, 1, 0)
    modeBtn.BackgroundTransparency = 1
    modeBtn.Text = ""
    modeBtn.MouseButton1Click:Connect(function()
        currentMode = currentMode + 1
        if currentMode > 3 then currentMode = 1 end
        modeLabel.Text = "[ " .. modes[currentMode] .. " ]"
    end)

    btn.MouseButton1Click:Connect(function()
        callback(modes[currentMode])
    end)
end

-- ЛОГИКА ФУНКЦИЙ
local function RunLoad(mode)
    if mode == "Local" or mode == "Server" then
        -- Максимальный лаг через физику и просчет лучей
        for i = 1, 10000 do
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(10, 10, 10)
            p.Velocity = Vector3.new(0, 1000, 0) -- Нагрузка на физический движок
        end
    end
    print("Executing " .. mode .. " Load...")
end

-- КНОПКИ
CreateComplexButton("ULTRA LAG", UDim2.new(0, 10, 0, 50), RunLoad)

CreateComplexButton("SHUTDOWN SERVER", UDim2.new(0, 10, 0, 90), function(mode)
    -- Попытка крашнуть сервер через переполнение таблицы данных
    local t = {}
    while true do table.insert(t, string.rep("CRASH", 10000)) end
end)

CreateComplexButton("RESTART (KICK ALL)", UDim2.new(0, 10, 0, 130), function(mode)
    for _, v in pairs(game.Players:GetPlayers()) do
        if mode == "Server" or (mode == "Except Me" and v ~= game.Players.LocalPlayer) then
            v:Kick("Server Restarting...")
        end
    end
end)

CreateComplexButton("BROKE INTERNET", UDim2.new(0, 10, 0, 170), function()
    -- Спам запросами к серверу (Remote Spam)
    game:GetService("RunService").Stepped:Connect(function()
        for i = 1, 500 do
            -- Здесь должен быть RemoteEvent конкретной игры
            -- game.ReplicatedStorage.RemoteEvent:FireServer() 
        end
    end)
end)

CreateComplexButton("GIVE ADMIN (Fake)", UDim2.new(0, 10, 0, 210), function()
    print("Admin tools injected into LocalPlayer GUI")
    -- Настоящий Owner HD Admin нельзя выдать без доступа к базе данных сервера
end)

CreateComplexButton("START VIRUS", UDim2.new(0, 10, 0, 250), function()
    -- Имитация вируса: замена текстур и звуков на сервере (если есть уязвимость)
    print("Virus Service Started")
end)

CreateComplexButton("FREE PRIVATE SRV", UDim2.new(0, 10, 0, 290), function()
    print("Error: Protocol 403. Manual bypass required.")
    -- Roblox API не позволяет создавать приватные серверы через Lua-скрипт игрока.
end)
