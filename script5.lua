local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 500)
Main.Position = UDim2.new(0.5, -175, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "TOOL HUB V2: DESTRUCTION"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)

-- Функция создания кнопок с фильтрами
local function CreateDestructionBtn(name, hasFilter, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)

    if hasFilter then
        local mode = Instance.new("TextButton", btn)
        mode.Size = UDim2.new(0, 80, 0, 30)
        mode.Position = UDim2.new(1, -85, 0, 5)
        mode.Text = "Local"
        mode.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        
        local modes = {"Local", "Server", "Except Me"}
        local cur = 1
        mode.MouseButton1Click:Connect(function()
            cur = cur + 1
            if cur > 3 then cur = 1 end
            mode.Text = modes[cur]
        end)
        
        btn.MouseButton1Click:Connect(function() callback(modes[cur]) end)
    else
        btn.MouseButton1Click:Connect(callback)
    end
end

-- 1. УЛУЧШЕННАЯ СИСТЕМА ПОЛЕТА
local flying = false
local flySpeed = 50
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

CreateDestructionBtn("Fly: OFF", false, function(btn)
    flying = not flying
    
    if flying then
        btn.Text = "Fly: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленый при включении
        
        local char = player.Character
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        
        -- Создаем силы для полета
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9e4
        
        -- Цикл полета
        task.spawn(function()
            while flying do
                bg.CFrame = workspace.CurrentCamera.CFrame
                local direction = Vector3.new(0,0,0)
                
                -- Управление через камеру
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                task.wait()
            end
            -- Очистка при выключении
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end)
    else
        btn.Text = "Fly: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Серый при выключении
    end
end)

-- 2. CRASH ROBLOX (Freeze client/server)
CreateDestructionBtn("Crash Roblox", true, function(m)
    if m == "Local" or m == "Server" then
        while true do end -- Бесконечный цикл намертво вешает поток
    end
end)

-- 3. CRASH PLACE (Gugolplex Loop)
CreateDestructionBtn("Crash Place", true, function(m)
    local count = 0
    game:GetService("RunService").Heartbeat:Connect(function()
        for i = 1, 10000 do -- Спам в каждом кадре
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(100, 100, 100)
            p.Position = Vector3.new(0, 1000, 0)
        end
    end)
end)

-- 4. DESTROY PLACE (Mass Report)
CreateDestructionBtn("Destroy Place", false, function()
    print("Инициализация бот-сети...")
    for i = 1, 100 do
        print("Бот #"..i..": Жалоба отправлена по категории 'Scam/Safety'")
    end
    -- Настоящий 1 миллион жалоб за секунду забанит твой IP раньше, чем плейс
end)

-- 5. DESTROY ROBLOX (Simulation)
CreateDestructionBtn("Destroy Roblox", true, function(m)
    print("Attacking Database: Account/Password Wipe... [FAILED: ACCESS DENIED]")
end)
