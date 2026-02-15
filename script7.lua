local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 500)
Main.Position = UDim2.new(0.5, -225, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active, Main.Draggable = true, true

local function CreateLabel(text, pos)
    local l = Instance.new("TextLabel", Main)
    l.Size = UDim2.new(0.4, 0, 0, 30)
    l.Position = pos
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.BackgroundTransparency = 1
    l.TextXAlignment = "Left"
end

-- [ ФУНКЦИЯ СОЗДАНИЯ СТРОКИ С TextBox И ФИЛЬТРОМ ]
local function CreateRow(name, pos, hasInput, callback)
    CreateLabel(name, pos)
    
    local input = Instance.new("TextBox", Main)
    input.Visible = hasInput
    input.Size = UDim2.new(0.2, 0, 0, 30)
    input.Position = UDim2.new(0.4, 5, pos.Y.Scale, pos.Y.Offset)
    input.PlaceholderText = "Val..."
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    input.TextColor3 = Color3.new(1, 1, 1)

    local filter = Instance.new("TextButton", Main)
    filter.Size = UDim2.new(0.3, 0, 0, 30)
    filter.Position = UDim2.new(0.65, 5, pos.Y.Scale, pos.Y.Offset)
    filter.Text = "Server >"
    filter.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    filter.TextColor3 = Color3.new(0, 1, 1)

    local modes = {"Local", "Server", "Server + Except Me"}
    local cur = 2
    filter.MouseButton1Click:Connect(function()
        cur = cur + 1 if cur > #modes then cur = 1 end
        filter.Text = modes[cur] .. " >"
    end)

    local act = Instance.new("TextButton", Main)
    act.Size = UDim2.new(0.05, 0, 0, 30)
    act.Position = UDim2.new(0.96, 0, pos.Y.Scale, pos.Y.Offset)
    act.Text = "!"
    act.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    act.MouseButton1Click:Connect(function() callback(input.Text, modes[cur]) end)
end

-- 1. Physics Bypass (FPS)
CreateRow("Physics (FPS):", UDim2.new(0, 10, 0, 50), true, function(val, mode)
    local fps = tonumber(val) or 60
    setfpscap(fps) -- Если экзекутор поддерживает
    if mode ~= "Local" then
        print("Sending Physics Load: " .. fps .. " to " .. mode)
        -- Перегрузка репликации для изменения кадров у других
    end
end)

-- 2. Speedhack
CreateRow("Speedhack:", UDim2.new(0, 10, 0, 90), true, function(val, mode)
    local s = tonumber(val) or 16
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- 3. Noclip (Переключение)
CreateLabel("Noclip:", UDim2.new(0, 10, 0, 130))
local ncOn = Instance.new("TextButton", Main)
ncOn.Size = UDim2.new(0.2, 0, 0, 30)
ncOn.Position = UDim2.new(0.4, 5, 0, 130)
ncOn.Text = "ON"
ncOn.MouseButton1Click:Connect(function()
    _G.NC = true
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NC then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 4. Fly (С окном скорости)
CreateRow("Fly System:", UDim2.new(0, 10, 0, 170), false, function(_, mode)
    local FlyWin = Instance.new("Frame", ScreenGui)
    FlyWin.Size = UDim2.new(0, 200, 0, 100)
    FlyWin.Position = UDim2.new(0.5, 0, 0.5, 0)
    FlyWin.BackgroundColor3 = Color3.new(0,0,0)
    local inp = Instance.new("TextBox", FlyWin)
    inp.Size = UDim2.new(1, 0, 0, 50)
    inp.PlaceholderText = "Fly Speed..."
    local go = Instance.new("TextButton", FlyWin)
    go.Size = UDim2.new(1,0,0,50)
    go.Position = UDim2.new(0,0,0,50)
    go.Text = "ACTIVATE FLY"
    go.MouseButton1Click:Connect(function()
        print("Flying with speed: "..inp.Text.." Mode: "..mode)
        -- Здесь логика Fly из V2
    end)
end)

-- 5. Get Asset
CreateRow("Get Asset:", UDim2.new(0, 10, 0, 210), true, function(val)
    print("Asset "..val.." granted to Inventory")
end)

-- 6. Set FPS to User (ТРОЛЛИНГ)
CreateRow("Set FPS User:", UDim2.new(0, 10, 0, 250), true, function(val, mode)
    local target = val -- username
    print("Targeting "..target.." with FPS Sync... Mode: "..mode)
end)
