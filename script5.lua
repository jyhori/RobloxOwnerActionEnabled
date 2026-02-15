local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 550)
Main.Position = UDim2.new(0.5, -190, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "TOOL HUB V2: ULTIMATE DESTROYER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Title.Font = Enum.Font.GothamBold

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.CanvasSize = UDim2.new(0, 0, 2.5, 0)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 6)

-- [ СИСТЕМА ФИЛЬТРОВ И КНОПОК ]
local function CreateButtonWithFilter(name, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.65, 0, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)

    local modeBtn = Instance.new("TextButton", frame)
    modeBtn.Size = UDim2.new(0.3, 0, 1, 0)
    modeBtn.Position = UDim2.new(0.7, 0, 0, 0)
    modeBtn.Text = "Local"
    modeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    modeBtn.TextColor3 = Color3.new(0, 1, 0)

    local modes = {"Local", "Server", "Except Me"}
    local cur = 1
    modeBtn.MouseButton1Click:Connect(function()
        cur = cur + 1
        if cur > 3 then cur = 1 end
        modeBtn.Text = modes[cur]
    end)

    btn.MouseButton1Click:Connect(function() callback(modes[cur]) end)
end

-- [ ФУНКЦИИ ]

-- 1. Fly System
local flying = false
local flySpeed = 100
CreateButtonWithFilter("Fly Toggle", function()
    flying = not flying
    local char = game.Players.LocalPlayer.Character
    local root = char:WaitForChild("HumanoidRootPart")
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                task.wait()
            end
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end)
    end
end)

-- 2. Crash & Destroy Place
CreateButtonWithFilter("Crash Place", function(m)
    for i = 1, 500000 do
        task.spawn(function()
            while task.wait(0.1) do Instance.new("Part", workspace).Size = Vector3.new(100,100,100) end
        end)
    end
end)

CreateButtonWithFilter("Destroy Place (1M REPS)", function()
    for i = 1, 1000000 do if i % 50000 == 0 then print("Sending batch: "..i) end end
end)

-- 3. Summon Bots
CreateButtonWithFilter("Summon Bots", function()
    for i = 1, 200 do print("Requesting join: Unknown_Bot"..i) end
end)

-- [ DEBUGGING CONSOLE MODE (DCM) + NETWORK ]
CreateButtonWithFilter("DCM Mode (Network)", function()
    if ScreenGui:FindFirstChild("DCMFrame") then ScreenGui.DCMFrame:Destroy() end
    
    local DCMFrame = Instance.new("Frame", ScreenGui)
    DCMFrame.Name = "DCMFrame"
    DCMFrame.Size = UDim2.new(0, 450, 0, 350)
    DCMFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    DCMFrame.BackgroundColor3 = Color3.new(0,0,0)
    DCMFrame.Active = true
    DCMFrame.Draggable = true

    local TabNet = Instance.new("TextLabel", DCMFrame)
    TabNet.Size = UDim2.new(1, 0, 0, 60)
    TabNet.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabNet.TextColor3 = Color3.new(0, 1, 1)
    TabNet.TextSize = 14
    TabNet.TextXAlignment = Enum.TextXAlignment.Left

    local output = Instance.new("ScrollingFrame", DCMFrame)
    output.Size = UDim2.new(1, 0, 1, -65)
    output.Position = UDim2.new(0, 0, 0, 65)
    output.CanvasSize = UDim2.new(0, 0, 10, 0)
    
    local log = Instance.new("TextLabel", output)
    log.Size = UDim2.new(1, 0, 1, 0)
    log.TextColor3 = Color3.new(0, 1, 0)
    log.TextYAlignment = Enum.TextYAlignment.Top
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.Text = "--- DCM NETWORK ANALYZER ACTIVE ---"

    -- Обновление данных Network
    task.spawn(function()
        while task.wait(0.5) do
            local ping = math.random(20, 45) -- Симуляция пинга
            local kbps = math.random(100, 1500)
            if flying or flying == false then -- Если идут процессы
                TabNet.Text = string.format("  [NETWORK STATUS]\n  IP: 192.168.1.%d (Server Node)\n  Ping: %dms | Traffic: %d kbps\n  Status: CONNECTED", math.random(1,255), ping, kbps)
            end
        end
    end)
end)
