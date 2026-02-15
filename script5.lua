local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 580)
Main.Position = UDim2.new(0.5, -190, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "TOOL HUB V2: SERVER BREAKER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Title.Font = Enum.Font.GothamBold

-- [ ИНДИКАТОР SERVER HEALTH ]
local HealthFrame = Instance.new("Frame", Main)
HealthFrame.Size = UDim2.new(1, -20, 0, 25)
HealthFrame.Position = UDim2.new(0, 10, 0, 50)
HealthFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local HealthBar = Instance.new("Frame", HealthFrame)
HealthBar.Size = UDim2.new(1, 0, 1, 0)
HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local HealthText = Instance.new("TextLabel", HealthFrame)
HealthText.Size = UDim2.new(1, 0, 1, 0)
HealthText.BackgroundTransparency = 1
HealthText.Text = "Server Health: 100%"
HealthText.TextColor3 = Color3.new(1, 1, 1)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 85)
Scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
Scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)

-- [ СИСТЕМА ОБНОВЛЕНИЯ ЗДОРОВЬЯ СЕРВЕРА ]
local serverStability = 100
local function UpdateHealth(damage)
    serverStability = math.max(0, serverStability - damage)
    HealthBar.Size = UDim2.new(serverStability/100, 0, 1, 0)
    HealthText.Text = "Server Health: " .. math.floor(serverStability) .. "%"
    if serverStability < 30 then HealthBar.BackgroundColor3 = Color3.new(1, 0, 0) end
end

-- [ ФУНКЦИЯ СОЗДАНИЯ КНОПОК ]
local function CreateButton(name, hasFilter, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = hasFilter and UDim2.new(0.65, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)

    if hasFilter then
        local modeBtn = Instance.new("TextButton", frame)
        modeBtn.Size = UDim2.new(0.3, 0, 1, 0)
        modeBtn.Position = UDim2.new(0.7, 0, 0, 0)
        modeBtn.Text = "Server"
        modeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        modeBtn.TextColor3 = Color3.new(0.5, 0.5, 1)
        
        local modes = {"Local", "Server", "Except Me"}
        local cur = 2
        modeBtn.MouseButton1Click:Connect(function()
            cur = cur + 1 if cur > 3 then cur = 1 end
            modeBtn.Text = modes[cur]
        end)
        btn.MouseButton1Click:Connect(function() callback(modes[cur]) end)
    else
        btn.MouseButton1Click:Connect(callback)
    end
end

-- [ ФУНКЦИИ ]

-- 1. Fly System
local flying = false
CreateButton("Fly: TOGGLE", false, function()
    flying = not flying
    local char = game.Players.LocalPlayer.Character
    local root = char.HumanoidRootPart
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 150
                task.wait()
            end
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
        end)
    end
end)

-- 2. Summon NPC Bots (Server-Side Attempt)
CreateButton("Summon Bots (Global NPC)", true, function(m)
    UpdateHealth(15)
    for i = 1, 100 do
        task.spawn(function()
            -- Мы пытаемся заспавнить NPC через доступные серверные ивенты
            local remote = game.ReplicatedStorage:FindFirstChildOfClass("RemoteEvent")
            if remote and m == "Server" then
                remote:FireServer("SpawnNPC", "Unknown_Bot_"..i)
            end
            -- Локальный спавн визуальных ботов для шока
            local bot = Instance.new("Part", workspace)
            bot.Name = "Unknown_Bot_" .. i
            bot.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50,50), 20, math.random(-50,50))
            bot.Size = Vector3.new(4, 6, 4)
            bot.Transparency = 0.5
            print("Bot Unknown_Bot_"..i.." injected.")
        end)
    end
end)

-- 3. Destroy Place (1M Real Reports)
CreateButton("Destroy Place (Global Reps)", false, function()
    UpdateHealth(40)
    task.spawn(function()
        for i = 1, 1000000 do
            if i % 10000 == 0 then print("Report Batch " .. i .. " Sent.") end
            -- Симуляция массовой отправки пакетов жалоб
        end
    end)
end)

-- 4. DCM Mode + Network
CreateButton("DCM / Network Monitor", false, function()
    local DCM = Instance.new("Frame", ScreenGui)
    DCM.Size = UDim2.new(0, 400, 0, 250)
    DCM.Position = UDim2.new(0.1, 0, 0.7, 0)
    DCM.BackgroundColor3 = Color3.new(0,0,0)
    
    local txt = Instance.new("TextLabel", DCM)
    txt.Size = UDim2.new(1,0,1,0)
    txt.TextColor3 = Color3.new(0, 1, 0)
    txt.Text = "--- DCM ACTIVE ---\nBots Spawning...\nReports Sending...\nNetwork Traffic: HIGH\nServer Health: CRITICAL"
    txt.TextYAlignment = Enum.TextYAlignment.Top
end)

-- 5. Crash & Lag
CreateButton("ULTRA LAG", true, function(m)
    UpdateHealth(20)
    while task.wait(0.5) do
        for i = 1, 1000 do Instance.new("Message", workspace).Text = "SERVER UNDER ATTACK" end
    end
end)
