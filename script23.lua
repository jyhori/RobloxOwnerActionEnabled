-- ==================================================
-- ULTIMATE PRANK GUI FOR DELTA EXECUTOR
-- ==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==================================================
-- СОЗДАНИЕ ГЛАВНОГО GUI
-- ==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrankGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ОСНОВНОЙ ФРЕЙМ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- ЗАКРУГЛЕНИЯ
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- ЗАГОЛОВОК
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(233, 69, 96)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "💀 ULTIMATE PRANK PANEL 💀"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.Parent = TitleBar

-- КНОПКА ЗАКРЫТИЯ
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==================================================
-- ПОИСК ИГРОКА
-- ==================================================

-- ПОЛЕ ВВОДА
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.8, -10, 0, 45)
SearchBox.Position = UDim2.new(0.1, 0, 0, 50)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SearchBox.PlaceholderText = "Введи ник жертвы..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Text = "ilditv"
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 16
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 10)
SearchCorner.Parent = SearchBox

-- КНОПКА ПОИСКА
local SearchButton = Instance.new("TextButton")
SearchButton.Size = UDim2.new(0.8, -10, 0, 40)
SearchButton.Position = UDim2.new(0.1, 0, 0, 105)
SearchButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
SearchButton.Text = "🔍 НАЙТИ ИГРОКА"
SearchButton.TextColor3 = Color3.new(1, 1, 1)
SearchButton.Font = Enum.Font.GothamBold
SearchButton.TextSize = 16
SearchButton.Parent = MainFrame

local SearchBtnCorner = Instance.new("UICorner")
SearchBtnCorner.CornerRadius = UDim.new(0, 10)
SearchBtnCorner.Parent = SearchButton

-- СТАТУС ПОИСКА
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, -10, 0, 30)
StatusLabel.Position = UDim2.new(0.1, 0, 0, 155)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ожидание ввода..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- ==================================================
-- ФУНКЦИИ ПРАНКА
-- ==================================================

local function findPlayer(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) or 
           (player.DisplayName and player.DisplayName:lower():find(name:lower())) then
            return player
        end
    end
    return nil
end

-- ЛАГ
local function lagPlayer(target)
    if not target or not target.Character then return end
    StatusLabel.Text = "🔥 ЛАГАЕМ: " .. target.Name
    for i = 1, 5000 do
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Size = Vector3.new(5, 5, 5)
        part.BrickColor = BrickColor.Random()
        part.Material = Enum.Material.Neon
        part.Anchored = false
        if target.Character:FindFirstChild("HumanoidRootPart") then
            part.CFrame = target.Character.HumanoidRootPart.CFrame * 
                         CFrame.new(math.random(-200,200), math.random(0,300), math.random(-200,200))
        end
    end
end

-- КИК
local function kickPlayer(target)
    if target and target.Character then
        target.Character.Humanoid.Health = 0
        StatusLabel.Text = "👢 КИКНУТ: " .. target.Name
    end
end

-- БАН
local function banPlayer(target)
    if target then
        target:Kick("🔨 ТЫ ЗАБАНЕН ЗА ПРАНК")
        StatusLabel.Text = "🔨 ЗАБАНЕН: " .. target.Name
    end
end

-- ==================================================
-- КНОПКИ ДЕЙСТВИЙ
-- ==================================================

local function createActionButton(name, color, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 0, 50)
    btn.Position = UDim2.new(0.1 + (name == "LAG" and 0 or name == "KICK" and 0.4 or 0.7), 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local targetName = SearchBox.Text
        local target = findPlayer(targetName)
        if target then
            callback(target)
        else
            StatusLabel.Text = "❌ Игрок не найден: " .. targetName
        end
    end)
end

-- СОЗДАЁМ КНОПКИ
createActionButton("💀 LAG", Color3.fromRGB(255, 100, 100), 200, lagPlayer)
createActionButton("👢 KICK", Color3.fromRGB(100, 150, 255), 200, kickPlayer)
createActionButton("🔨 BAN", Color3.fromRGB(100, 255, 100), 260, banPlayer)

-- КНОПКА ДЛЯ ILDITV (быстрый доступ)
local QuickPrank = Instance.new("TextButton")
QuickPrank.Size = UDim2.new(0.8, -10, 0, 50)
QuickPrank.Position = UDim2.new(0.1, 0, 0, 330)
QuickPrank.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
QuickPrank.Text = "⚡ ПРАНКНУТЬ ILDITV ⚡"
QuickPrank.TextColor3 = Color3.new(0, 0, 0)
QuickPrank.Font = Enum.Font.GothamBold
QuickPrank.TextSize = 18
QuickPrank.Parent = MainFrame

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 10)
QuickCorner.Parent = QuickPrank

QuickPrank.MouseButton1Click:Connect(function()
    local target = findPlayer("ilditv")
    if target then
        lagPlayer(target)
        StatusLabel.Text = "🔥 ILDITV ЛАГАЕТ! 🔥"
    else
        StatusLabel.Text = "❌ ILDITV НЕ В ИГРЕ"
    end
end)

-- ==================================================
-- ИНФОРМАЦИЯ
-- ==================================================
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.8, -10, 0, 40)
InfoLabel.Position = UDim2.new(0.1, 0, 0, 400)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "👑 ТВОЙ ID: 10362884869\n🎯 ЦЕЛЬ: ILDITV"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 12
InfoLabel.TextWrapped = true
InfoLabel.Parent = MainFrame

-- ==================================================
-- ЗАПУСК
-- ==================================================
print("✅ GUI ЗАГРУЖЕН! ЖМИ НА ILDITV!")
