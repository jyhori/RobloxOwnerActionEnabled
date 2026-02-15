local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 620)
Main.Position = UDim2.new(0.5, -210, 0.5, -310)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "TOOL HUB V2: OVERLORD MOD MENU"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Font = Enum.Font.GothamBold

-- [ SERVER HEALTH MONITOR ]
local SHealth = Instance.new("Frame", Main)
SHealth.Size = UDim2.new(1, -20, 0, 20)
SHealth.Position = UDim2.new(0, 10, 0, 45)
SHealth.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local SBar = Instance.new("Frame", SHealth)
SBar.Size = UDim2.new(1, 0, 1, 0)
SBar.BackgroundColor3 = Color3.new(0, 1, 0)

local SText = Instance.new("TextLabel", SHealth)
SText.Size = UDim2.new(1, 0, 1, 0)
SText.Text = "Server Integrity: 100%"
SText.TextColor3 = Color3.new(1, 1, 1)
SText.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 75)
Scroll.CanvasSize = UDim2.new(0, 0, 4, 0)
Scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)

-- [ УТИЛИТЫ ]
local function UpdateSHealth(val)
    local current = tonumber(SText.Text:match("%d+"))
    local new = math.max(0, current - val)
    SBar.Size = UDim2.new(new/100, 0, 1, 0)
    SText.Text = "Server Integrity: " .. new .. "%"
    if new < 25 then SBar.BackgroundColor3 = Color3.new(1, 0, 0) end
end

local function CreateBtn(name, filter, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", f)
    b.Size = filter and UDim2.new(0.6, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)

    if filter then
        local mBtn = Instance.new("TextButton", f)
        mBtn.Size = UDim2.new(0.35, 0, 1, 0)
        mBtn.Position = UDim2.new(0.65, 0, 0, 0)
        mBtn.Text = "Server"
        mBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        mBtn.TextColor3 = Color3.new(0.5, 0.5, 1)
        mBtn.MouseButton1Click:Connect(function()
            mBtn.Text = (mBtn.Text == "Server" and "Local" or (mBtn.Text == "Local" and "Except Me" or "Server"))
        end)
        b.MouseButton1Click:Connect(function() callback(mBtn.Text) end)
    else
        b.MouseButton1Click:Connect(callback)
    end
end

-- [ ФУНКЦИИ 8 КНОПОК ]

-- 1. Fly
CreateBtn("Fly System", false, function()
    local char = game.Players.LocalPlayer.Character
    local root = char.HumanoidRootPart
    local bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    task.spawn(function()
        while task.wait() do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100 end
    end)
end)

-- 2. Crash Roblox
CreateBtn("Crash Roblox", true, function(m)
    UpdateSHealth(10)
    while true do print(string.rep("CRASH", 10000)) end
end)

-- 3. Crash Place (Gugolplex Loop)
CreateBtn("Crash Place", true, function(m)
    UpdateSHealth(50)
    game:GetService("RunService").Heartbeat:Connect(function()
        for i = 1, 1000 do Instance.new("Part", workspace).Size = Vector3.new(500,500,500) end
    end)
end)

-- 4. Destroy Place (1M Reports)
CreateBtn("Destroy Place (Global)", false, function()
    UpdateSHealth(30)
    for i = 1, 1000000 do 
        if i % 100000 == 0 then print("BotNet: "..i.." reports sent.") end
    end
end)

-- 5. Summon Bots (Global NPC)
CreateBtn("Summon Bots", true, function(m)
    UpdateSHealth(20)
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation") and workspace:FindFirstChildOfClass("SpawnLocation").Position or Vector3.new(0,10,0)
    for i = 1, 200 do
        local p = Instance.new("Part", workspace)
        p.Name = "Unknown_Bot_"..i
        p.Position = spawn + Vector3.new(math.random(-10,10), 10, math.random(-10,10))
        p.Color = Color3.new(0,0,0)
        p.Material = "Neon"
        if p:CanSetNetworkOwnership() then p:SetNetworkOwner(game.Players.LocalPlayer) end

        -- [[ ВСТАВИТЬ ВНУТРЬ ЦИКЛА SUMMON BOTS ]]
        task.spawn(function()
            local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chatRemote then
            local sayMsg = chatRemote:FindFirstChild("SayMessageRequest")
            if sayMsg then
            -- Список страшных фраз
                local phrases = {"SYSTEM ERROR: 0x666", "SERVER BREACHED", "RUN.", "ID: Unknown_Bot_"..i.." connected", "DATABASE WIPE INITIATED"}
                while bot.Parent do
                    sayMsg:FireServer(phrases[math.random(1, #phrases)], "All")
                    task.wait(math.random(2, 5)) -- Пауза между сообщениями, чтобы не кикнуло сразу
            end
        end
    end
end)
-- [[ КОНЕЦ ВСТАВКИ ]]
            
    end
end)

-- 6. Speedhack (Time Manipulation)
CreateBtn("Speedhack (0.00001x - 10M.X)", false, function()
    local val = 0.00000001 -- Самая медленная скорость
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * val
    print("Time dilated. Movement: Ultra Slow.")
end)

-- 7. Hitbox Multiplayer Size
CreateBtn("Hitbox Multiplier", true, function()
    local char = game.Players.LocalPlayer.Character
    char.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
    char.HumanoidRootPart.Transparency = 0.5
    char.HumanoidRootPart.Color = Color3.new(1, 0, 0)
    -- Уменьшение скина (визуально для всех через Scale)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Size = v.Size * 0.1 end
    end
end)

-- 8. Connect VIP (Bypass)
CreateBtn("Connect VIP", false, function()
    print("Injecting VIP Credentials...")
    _G.VIP = true
    _G.AdminLevel = 5 -- Owner HD Admin Bypass
end)

-- [ ПОЛНЫЙ БЛОК DCM MODE: ВСТАВЛЯТЬ СЮДА ]
CreateBtn("DCM (Mega Console)", false, function()
    -- Удаляем старое окно, если оно уже открыто
    if ScreenGui:FindFirstChild("DCM_Window") then ScreenGui.DCM_Window:Destroy() end
    
    local DCM = Instance.new("Frame", ScreenGui)
    DCM.Name = "DCM_Window"
    DCM.Size = UDim2.new(0, 500, 0, 400) -- Увеличили размер для чата
    DCM.Position = UDim2.new(0.05, 0, 0.05, 0)
    DCM.BackgroundColor3 = Color3.new(0,0,0)
    DCM.BorderSizePixel = 2
    DCM.Active = true
    DCM.Draggable = true

    -- 1. СЕКЦИЯ NETWORK (ВЕРХНЯЯ ПАНЕЛЬ)
    local NetPanel = Instance.new("TextLabel", DCM)
    NetPanel.Size = UDim2.new(1, 0, 0, 50)
    NetPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NetPanel.TextColor3 = Color3.new(0, 1, 1)
    NetPanel.TextSize = 14
    NetPanel.TextXAlignment = "Left"
    
    task.spawn(function()
        while DCM.Parent do
            local ping = math.random(30, 60)
            local traffic = math.random(500, 2500)
            NetPanel.Text = string.format("  [NETWORK]\n  IP: 185.122.0.%d | Ping: %dms\n  Traffic: %d kb/s | Status: ACTIVE", math.random(1,255), ping, traffic)
            task.wait(1)
        end
    end)

    -- 2. СЕКЦИЯ OUTPUT / CONSOLE (СЕРЕДИНА)
    local LogScroll = Instance.new("ScrollingFrame", DCM)
    LogScroll.Size = UDim2.new(1, -10, 0, 180)
    LogScroll.Position = UDim2.new(0, 5, 0, 55)
    LogScroll.CanvasSize = UDim2.new(0, 0, 10, 0)
    LogScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local OutputText = Instance.new("TextLabel", LogScroll)
    OutputText.Size = UDim2.new(1, 0, 1, 0)
    OutputText.TextColor3 = Color3.new(0, 1, 0)
    OutputText.TextXAlignment = "Left"
    OutputText.TextYAlignment = "Top"
    OutputText.Text = "--- DCM MEGA MENU INITIALIZED ---\n[INPUT]: Access Granted\n[SYSTEM]: BotNet Protocol Loaded\n[CONSOLE]: Ready for Deployment..."

    -- 3. СЕКЦИЯ CUSTOM CHAT (НИЗ)
    local ChatFrame = Instance.new("ScrollingFrame", DCM)
    ChatFrame.Name = "CustomChat"
    ChatFrame.Size = UDim2.new(1, -10, 0, 150)
    ChatFrame.Position = UDim2.new(0, 5, 1, -155)
    ChatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ChatFrame.CanvasSize = UDim2.new(0, 0, 5, 0)

    local ChatList = Instance.new("UIListLayout", ChatFrame)
    ChatList.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- Логика перехвата новых игроков в кастомный чат
    game.Players.PlayerAdded:Connect(function(plr)
        local msg = Instance.new("TextLabel", ChatFrame)
        msg.Size = UDim2.new(1, 0, 0, 20)
        msg.Text = "[SYSTEM]: User " .. plr.Name .. " detected on Node."
        msg.TextColor3 = Color3.new(1, 0, 0)
        msg.BackgroundTransparency = 1
        msg.TextXAlignment = "Left"
    end)
    
    print("DCM Mode Activated: All Systems Green.")
end)
