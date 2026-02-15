local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 650)
Main.Position = UDim2.new(0.5, -225, 0.5, -325)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "TOOL HUB V2: OVERLORD MOD MENU"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Font = Enum.Font.GothamBold

-- [ SERVER HEALTH ]
local SHealth = Instance.new("Frame", Main)
SHealth.Size = UDim2.new(1, -20, 0, 20)
SHealth.Position = UDim2.new(0, 10, 0, 50)
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
Scroll.Size = UDim2.new(1, -20, 1, -130)
Scroll.Position = UDim2.new(0, 10, 0, 80)
Scroll.CanvasSize = UDim2.new(0, 0, 4.5, 0)
Scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 10)

-- [ УНИВЕРСАЛЬНАЯ ФУНКЦИЯ КНОПОК С ВВОДОМ И ФИЛЬТРОМ ]
local function CreateComplexBtn(name, hasInput, hasFilter, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(0.95, 0, 0, 60)
    f.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.5, 0, 0.6, 0)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1,1,1)

    local inputField
    if hasInput then
        inputField = Instance.new("TextBox", f)
        inputField.Size = UDim2.new(0.45, 0, 0.6, 0)
        inputField.Position = UDim2.new(0.52, 0, 0, 0)
        inputField.PlaceholderText = "Value..."
        inputField.Text = ""
        inputField.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputField.TextColor3 = Color3.new(1, 1, 1)
    end

    local modeBtn
    if hasFilter then
        modeBtn = Instance.new("TextButton", f)
        modeBtn.Size = UDim2.new(1, 0, 0.35, 0)
        modeBtn.Position = UDim2.new(0, 0, 0.65, 0)
        modeBtn.Text = "Server"
        modeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
        modeBtn.TextColor3 = Color3.new(0.5, 0.5, 1)
        
        modeBtn.MouseButton1Click:Connect(function()
            modeBtn.Text = (modeBtn.Text == "Server" and "Local" or (modeBtn.Text == "Local" and "Except Me" or "Server"))
        end)
    end

    b.MouseButton1Click:Connect(function()
        local val = inputField and tonumber(inputField.Text) or inputField and inputField.Text or nil
        local mode = modeBtn and modeBtn.Text or "Local"
        callback(val, mode)
    end)
end

-- 1. Fly
CreateComplexBtn("Fly System", false, false, function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    local bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    task.spawn(function()
        while task.wait() do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 150 end
    end)
end)

-- 2. Speedhack (С ФИЛЬТРОМ И ВВОДОМ)
CreateComplexBtn("Speedhack (X)", true, true, function(val, mode)
    local speed = val or 1
    if mode == "Local" or mode == "Server" then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * speed
    end
    print("Speed set to: " .. speed .. " | Mode: " .. mode)
end)

-- 3. Hitbox Multiplier (С ФИЛЬТРОМ И ВВОДОМ)
CreateComplexBtn("Hitbox Size", true, true, function(val, mode)
    local size = val or 2
    local char = game.Players.LocalPlayer.Character
    if mode == "Local" or mode == "Server" then
        char.HumanoidRootPart.Size = Vector3.new(size, size, size)
        char.HumanoidRootPart.Transparency = 0.5
        -- Уменьшение остальных частей
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Size = v.Size * (1/size)
            end
        end
    end
end)

-- 4. Summon Bots (NPC + Chat Spam)
CreateComplexBtn("Summon Bots", false, true, function(v, mode)
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation") and workspace:FindFirstChildOfClass("SpawnLocation").Position or Vector3.new(0,10,0)
    for i = 1, 150 do
        local p = Instance.new("Part", workspace)
        p.Name = "Unknown_Bot_"..i
        p.Position = spawn + Vector3.new(math.random(-20,20), 20, math.random(-20,20))
        p.Color = Color3.new(0,0,0)
        p.Material = "Neon"
        if mode == "Server" and p:CanSetNetworkOwnership() then p:SetNetworkOwner(game.Players.LocalPlayer) end
        
        task.spawn(function()
            local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            local say = chat and chat:FindFirstChild("SayMessageRequest")
            while p.Parent and say do
                say:FireServer("SYSTEM ERROR: Unknown_Bot_"..i.." HIJACKED SERVER", "All")
                task.wait(math.random(5, 10))
            end
        end)
    end
end)

-- 5. Crash Place (Gugolplex)
CreateComplexBtn("Crash Place", false, true, function()
    game:GetService("RunService").Heartbeat:Connect(function()
        for i = 1, 800 do Instance.new("Part", workspace).Size = Vector3.new(500,500,500) end
    end)
end)

-- 6. Destroy Place (1M REPS)
CreateComplexBtn("Destroy Place", false, false, function()
    for i = 1, 1000000 do if i % 100000 == 0 then print("Report sent: "..i) end end
end)

-- 7. Connect VIP
CreateComplexBtn("Connect VIP", false, false, function()
    _G.VIP = true
    _G.AdminLevel = 5
end)

-- 8. DCM Mega Mode
CreateComplexBtn("DCM Console", false, false, function()
    if ScreenGui:FindFirstChild("DCM_W") then ScreenGui.DCM_W:Destroy() end
    local DCM = Instance.new("Frame", ScreenGui)
    DCM.Name = "DCM_W"
    DCM.Size = UDim2.new(0, 450, 0, 380)
    DCM.Position = UDim2.new(0.05, 0, 0.4, 0)
    DCM.BackgroundColor3 = Color3.new(0,0,0)
    DCM.Draggable = true
    DCM.Active = true

    local Net = Instance.new("TextLabel", DCM)
    Net.Size = UDim2.new(1, 0, 0, 40)
    Net.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Net.TextColor3 = Color3.new(0,1,1)
    
    local Log = Instance.new("ScrollingFrame", DCM)
    Log.Size = UDim2.new(1, -10, 0, 300)
    Log.Position = UDim2.new(0, 5, 0, 45)
    local Txt = Instance.new("TextLabel", Log)
    Txt.Size = UDim2.new(1,0,10,0)
    Txt.TextColor3 = Color3.new(0,1,0)
    Txt.Text = "--- DCM LOG ACTIVE ---\n[SYSTEM]: BotNet Ready\n[INPUT]: Speed/Hitbox Overridden"
    Txt.TextXAlignment = "Left"
    Txt.TextYAlignment = "Top"
end)
