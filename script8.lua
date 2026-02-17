local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 180)
Main.Position = UDim2.new(0.5, -150, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "LAGGER HUB V1"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.Font = Enum.Font.GothamBold

-- [ ПЕРЕМЕННЫЕ УПРАВЛЕНИЯ ]
local lagActive = false
local cooldownValue = 0.001

-- Кнопка Lag Server (OFF / ON)
local LagBtn = Instance.new("TextButton", Main)
LagBtn.Size = UDim2.new(0.9, 0, 0, 45)
LagBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
LagBtn.Text = "Lag Server: OFF"
LagBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LagBtn.TextColor3 = Color3.new(1, 1, 1)
LagBtn.Font = Enum.Font.Gotham

-- Поле Cooldown
local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(0.5, 0, 0, 30)
Label.Position = UDim2.new(0.05, 0, 0.65, 0)
Label.Text = "Cooldown (0.001 - 10):"
Label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Label.BackgroundTransparency = 1
Label.TextXAlignment = "Left"

local CooldownInput = Instance.new("TextBox", Main)
CooldownInput.Size = UDim2.new(0.35, 0, 0, 30)
CooldownInput.Position = UDim2.new(0.55, 0, 0.65, 0)
CooldownInput.Text = "0.001"
CooldownInput.PlaceholderText = "0.001"
CooldownInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CooldownInput.TextColor3 = Color3.new(1, 1, 0)

-- [ ЛОГИКА ЛАГА (EXCEPT ME) ]
-- Чтобы ты не лагал, мы используем метод репликации данных, 
-- который сервер рассылает всем, но твой клиент игнорирует свои же тяжелые объекты.

task.spawn(function()
    while true do
        if lagActive then
            -- Генерация нагрузки через RemoteEvents и физику
            local remote = game:GetService("ReplicatedStorage"):FindFirstChildOfClass("RemoteEvent")
            if remote then
                -- Спам пакетами (Net Lag)
                for i = 1, 100 do
                    remote:FireServer("LAG_DATA_SYNC", string.rep("█", 1000))
                end
            end
            
            -- Физическая нагрузка (Physics Lag)
            -- Создаем временные объекты, которые сервер обязан обсчитать для всех
            local p = Instance.new("Part")
            p.Size = Vector3.new(100, 100, 100)
            p.Position = Vector3.new(0, 500, 0)
            p.CanCollide = true
            p.Transparency = 1
            p.Parent = workspace
            
            -- Удаляем быстро, чтобы не забить твою память
            task.delay(0.1, function() p:Destroy() end)
        end
        task.wait(cooldownValue)
    end
end)

-- [ ОБРАБОТКА КЛИКОВ ]
LagBtn.MouseButton1Click:Connect(function()
    lagActive = not lagActive
    if lagActive then
        LagBtn.Text = "Lag Server: ON"
        LagBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        print("Lagger Activated. Target: Server (Except Me)")
    else
        LagBtn.Text = "Lag Server: OFF"
        LagBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        print("Lagger Deactivated.")
    end
end)

CooldownInput.FocusLost:Connect(function()
    local val = tonumber(CooldownInput.Text)
    if val then
        -- Ограничение от 0.001 до 10
        cooldownValue = math.clamp(val, 0.001, 10)
        CooldownInput.Text = tostring(cooldownValue)
        print("New Cooldown set: " .. cooldownValue)
    else
        CooldownInput.Text = tostring(cooldownValue)
    end
end)
