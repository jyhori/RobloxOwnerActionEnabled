-- ==================================================
-- SYSTEM ROBLOX HUB V1 - ULTIMATE PRANK GUI
-- ==================================================
-- ТОЧНАЯ КОПИЯ ТВОЕГО САЙТА, НО В ROBLOX
-- ==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ==================================================
-- НАСТРОЙКИ
-- ==================================================
local CONFIG = {
    TARGET = "ilditv",  -- ЦЕЛЬ ПО УМОЛЧАНИЮ
    YOUR_ID = 10362884869,  -- ТВОЙ ID
    DEFAULT_IP = "203.0.113.45"
}

-- ==================================================
-- ФУНКЦИИ ПОИСКА
-- ==================================================
local function findPlayer(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) or 
           (p.DisplayName and p.DisplayName:lower():find(name:lower())) then
            return p
        end
    end
    return nil
end

-- ==================================================
-- ФУНКЦИИ ПРАНКА
-- ==================================================

-- LAG (СПАВН ОБЪЕКТОВ)
local function lagPlayer(target, fps, time)
    if not target or not target.Character then return end
    local intensity = (fps and tonumber(fps) or 1000) * 10
    local duration = time and tonumber(time:match("%d+")) or 10
    
    print("🔥 LAG НА " .. target.Name .. " ИНТЕНСИВНОСТЬ: " .. intensity)
    
    local parts = {}
    for i = 1, intensity do
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Size = Vector3.new(5, 5, 5)
        part.BrickColor = BrickColor.Random()
        part.Material = Enum.Material.Neon
        part.Anchored = false
        part.CanCollide = true
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            part.CFrame = target.Character.HumanoidRootPart.CFrame * 
                         CFrame.new(math.random(-200,200), math.random(0,300), math.random(-200,200))
        end
        table.insert(parts, part)
    end
    
    task.delay(duration, function()
        for _, p in ipairs(parts) do
            p:Destroy()
        end
        print("✅ ЛАГ СНЯТ")
    end)
end

-- KICK (ВЫЛЕТ)
local function kickPlayer(target, reason, delay)
    if not target then return end
    reason = reason or "Kicked by System Hub"
    delay = delay or 0
    
    print("👢 KICK " .. target.Name .. " ПРИЧИНА: " .. reason)
    
    local function doKick()
        if target and target.Character then
            target.Character:BreakJoints()
            target:Kick("👢 " .. reason)
        end
    end
    
    if delay > 0 then
        task.delay(delay, doKick)
    else
        doKick()
    end
end

-- BAN (ВРЕМЕННЫЙ БАН)
local function banPlayer(target, reason, timeDelay)
    if not target then return end
    reason = reason or "Banned by System Hub"
    
    print("🔨 BAN " .. target.Name .. " ПРИЧИНА: " .. reason)
    
    target:Kick("🔨 " .. reason .. "\n⏰ ДЛИТЕЛЬНОСТЬ: " .. (timeDelay or "FOREVER"))
end

-- BAN ACCOUNT (ПО АККАУНТУ)
local function banAccountPlayer(target, reason)
    if not target then return end
    reason = reason or "Account Banned by System Hub"
    
    print("💀 BAN ACCOUNT " .. target.Name .. " ПРИЧИНА: " .. reason)
    
    target:Kick("💀 ACCOUNT BANNED\n📝 " .. reason)
end

-- ==================================================
-- СОЗДАНИЕ GUI
-- ==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SystemRobloxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ОСНОВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

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
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "SYSTEM ROBLOX HUB V1"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

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
-- ИНФОРМАЦИЯ ОБ ИГРОКЕ
-- ==================================================
local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(0.9, 0, 0, 30)
UsernameLabel.Position = UDim2.new(0.05, 0, 0, 50)
UsernameLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
UsernameLabel.Text = "Username: " .. CONFIG.TARGET
UsernameLabel.TextColor3 = Color3.new(1, 1, 1)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextSize = 16
UsernameLabel.Parent = MainFrame

local UsernameCorner = Instance.new("UICorner")
UsernameCorner.CornerRadius = UDim.new(0, 8)
UsernameCorner.Parent = UsernameLabel

-- БЕЙДЖИ
local BadgeFrame = Instance.new("Frame")
BadgeFrame.Size = UDim2.new(0.9, 0, 0, 40)
BadgeFrame.Position = UDim2.new(0.05, 0, 0, 90)
BadgeFrame.BackgroundTransparency = 1
BadgeFrame.Parent = MainFrame

local AvatarBadge = Instance.new("TextButton")
AvatarBadge.Size = UDim2.new(0, 50, 0, 40)
AvatarBadge.Position = UDim2.new(0, 0, 0, 0)
AvatarBadge.BackgroundColor3 = Color3.fromRGB(233, 69, 96)
AvatarBadge.Text = "🖼️"
AvatarBadge.TextColor3 = Color3.new(1, 1, 1)
AvatarBadge.Font = Enum.Font.Gotham
AvatarBadge.TextSize = 20
AvatarBadge.Parent = BadgeFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 10)
AvatarCorner.Parent = AvatarBadge

local UserBadge = Instance.new("TextButton")
UserBadge.Size = UDim2.new(0, 50, 0, 40)
UserBadge.Position = UDim2.new(0, 60, 0, 0)
UserBadge.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
UserBadge.Text = "USER"
UserBadge.TextColor3 = Color3.new(1, 1, 1)
UserBadge.Font = Enum.Font.GothamBold
UserBadge.TextSize = 14
UserBadge.Parent = BadgeFrame

local UserCorner = Instance.new("UICorner")
UserCorner.CornerRadius = UDim.new(0, 10)
UserCorner.Parent = UserBadge

-- СТАТУС
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0.9, 0, 0, 80)
StatusFrame.Position = UDim2.new(0.05, 0, 0, 140)
StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatusFrame.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 10)
StatusCorner.Parent = StatusFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 0, 20)
StatusText.Position = UDim2.new(0, 5, 0, 5)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: ONLINE / ONLINE"
StatusText.TextColor3 = Color3.fromRGB(200, 255, 200)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusFrame

local PlayingText = Instance.new("TextLabel")
PlayingText.Size = UDim2.new(1, -10, 0, 20)
PlayingText.Position = UDim2.new(0, 5, 0, 30)
PlayingText.BackgroundTransparency = 1
PlayingText.Text = "Playing: Yes / Brookhaven 🏡"
PlayingText.TextColor3 = Color3.fromRGB(255, 255, 200)
PlayingText.Font = Enum.Font.Gotham
PlayingText.TextSize = 14
PlayingText.TextXAlignment = Enum.TextXAlignment.Left
PlayingText.Parent = StatusFrame

local IDText = Instance.new("TextLabel")
IDText.Size = UDim2.new(1, -10, 0, 20)
IDText.Position = UDim2.new(0, 5, 0, 55)
IDText.BackgroundTransparency = 1
IDText.Text = "ID Player: " .. CONFIG.YOUR_ID
IDText.TextColor3 = Color3.fromRGB(200, 200, 255)
IDText.Font = Enum.Font.Gotham
IDText.TextSize = 14
IDText.TextXAlignment = Enum.TextXAlignment.Left
IDText.Parent = StatusFrame

-- ==================================================
-- ПОЛЕ ВВОДА НИКА
-- ==================================================
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(0.9, 0, 0, 40)
TargetBox.Position = UDim2.new(0.05, 0, 0, 230)
TargetBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetBox.PlaceholderText = "Введи ник жертвы..."
TargetBox.Text = CONFIG.TARGET
TargetBox.TextColor3 = Color3.new(1, 1, 1)
TargetBox.Font = Enum.Font.Gotham
TargetBox.TextSize = 16
TargetBox.Parent = MainFrame

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 10)
TargetCorner.Parent = TargetBox

-- ==================================================
-- КНОПКИ ДЕЙСТВИЙ
-- ==================================================
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(0.9, 0, 0, 50)
ActionFrame.Position = UDim2.new(0.05, 0, 0, 280)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = MainFrame

local function createActionButton(name, color, xPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.23, 0, 0, 40)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ActionFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local targetName = TargetBox.Text
        local target = findPlayer(targetName)
        if target then
            callback(target)
        else
            StatusText.Text = "❌ Игрок не найден: " .. targetName
        end
    end)
end

createActionButton("LAG", Color3.fromRGB(255, 100, 100), 0, 
    function(t) lagPlayer(t, 1000, "10 SEC") end)
createActionButton("KICK", Color3.fromRGB(100, 150, 255), 0.26, 
    function(t) kickPlayer(t, "Kicked by Hub", 0) end)
createActionButton("BAN", Color3.fromRGB(100, 200, 100), 0.52, 
    function(t) banPlayer(t, "Banned by Hub", "FOREVER") end)
createActionButton("ACC", Color3.fromRGB(200, 100, 255), 0.78, 
    function(t) banAccountPlayer(t, "Account Banned") end)

-- ==================================================
-- КНОПКА ILDITV
-- ==================================================
local IlditvButton = Instance.new("TextButton")
IlditvButton.Size = UDim2.new(0.9, 0, 0, 50)
IlditvButton.Position = UDim2.new(0.05, 0, 0, 340)
IlditvButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
IlditvButton.Text = "⚡ ПРАНКНУТЬ ILDITV ⚡"
IlditvButton.TextColor3 = Color3.new(0, 0, 0)
IlditvButton.Font = Enum.Font.GothamBold
IlditvButton.TextSize = 18
IlditvButton.Parent = MainFrame

local IlditvCorner = Instance.new("UICorner")
IlditvCorner.CornerRadius = UDim.new(0, 10)
IlditvCorner.Parent = IlditvButton

IlditvButton.MouseButton1Click:Connect(function()
    local target = findPlayer("ilditv")
    if target then
        lagPlayer(target, 5000, "30 SEC")
        StatusText.Text = "🔥 ILDITV ЛАГАЕТ! 🔥"
    else
        StatusText.Text = "❌ ILDITV НЕ В ИГРЕ"
    end
end)

-- ==================================================
-- ИСТОРИЯ ПЛЕЙСОВ
-- ==================================================
local HistoryFrame = Instance.new("Frame")
HistoryFrame.Size = UDim2.new(0.9, 0, 0, 130)
HistoryFrame.Position = UDim2.new(0.05, 0, 0, 400)
HistoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
HistoryFrame.Parent = MainFrame

local HistoryCorner = Instance.new("UICorner")
HistoryCorner.CornerRadius = UDim.new(0, 10)
HistoryCorner.Parent = HistoryFrame

local HistoryTitle = Instance.new("TextLabel")
HistoryTitle.Size = UDim2.new(1, -10, 0, 20)
HistoryTitle.Position = UDim2.new(0, 5, 0, 5)
HistoryTitle.BackgroundTransparency = 1
HistoryTitle.Text = "History of time spent in places:"
HistoryTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
HistoryTitle.Font = Enum.Font.GothamBold
HistoryTitle.TextSize = 12
HistoryTitle.TextXAlignment = Enum.TextXAlignment.Left
HistoryTitle.Parent = HistoryFrame

local places = {
    {icon = "🏘️", name = "Brookhaven", time = "2 YEAR 3 MONTH 10 DAY 5 HOUR 30 MIN"},
    {icon = "🗼", name = "Tower of Hell", time = "1 YEAR 1 MONTH 20 DAY 15 HOUR 45 MIN"},
    {icon = "🐶", name = "Adopt Me!", time = "8 MONTH 12 DAY 2 HOUR 10 MIN"}
}

for i, place in ipairs(places) do
    local placeLabel = Instance.new("TextLabel")
    placeLabel.Size = UDim2.new(1, -10, 0, 20)
    placeLabel.Position = UDim2.new(0, 5, 0, 25 + (i-1) * 25)
    placeLabel.BackgroundTransparency = 1
    placeLabel.Text = i .. ". " .. place.icon .. " " .. place.name .. " [" .. place.time .. "]"
    placeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    placeLabel.Font = Enum.Font.Gotham
    placeLabel.TextSize = 10
    placeLabel.TextXAlignment = Enum.TextXAlignment.Left
    placeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    placeLabel.Parent = HistoryFrame
end

-- ==================================================
-- СТАТУСНАЯ СТРОКА
-- ==================================================
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(0.9, 0, 0, 25)
StatusBar.Position = UDim2.new(0.05, 0, 0, 540)
StatusBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusBar.Text = "✅ Готов к работе | Цель: " .. CONFIG.TARGET
StatusBar.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusBar.Font = Enum.Font.Gotham
StatusBar.TextSize = 12
StatusBar.Parent = MainFrame

local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 8)
StatusBarCorner.Parent = StatusBar

-- ==================================================
-- ЗАПУСК
-- ==================================================
print("🔥 SYSTEM ROBLOX HUB V1 ЗАГРУЖЕН")
print("👑 ТВОЙ ID: " .. CONFIG.YOUR_ID)
print("🎯 ЦЕЛЬ ПО УМОЛЧАНИЮ: " .. CONFIG.TARGET)
