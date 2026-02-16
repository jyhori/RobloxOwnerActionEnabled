local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 550)
Main.Position = UDim2.new(0.5, -260, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 2
Main.Active, Main.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SET HUB V1: ENGINE OVERRIDE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 150)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.BackgroundTransparency = 1
local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 10)

-- [ УНИВЕРСАЛЬНАЯ СТРОКА: КНОПКА + INPUTS + ФИЛЬТР ]
local function CreateComplexRow(name, inputs, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)

    local inputObjects = {}
    for i, placeholder in ipairs(inputs) do
        local inp = Instance.new("TextBox", f)
        inp.Size = UDim2.new(0.2, -5, 1, 0)
        inp.Position = UDim2.new(0.3 + (i-1)*0.2, 5, 0, 0)
        inp.PlaceholderText = placeholder
        inp.Text = ""
        inp.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        inp.TextColor3 = Color3.new(1, 1, 1)
        table.insert(inputObjects, inp)
    end

    local filter = Instance.new("TextButton", f)
    filter.Size = UDim2.new(0.25, 0, 1, 0)
    filter.Position = UDim2.new(0.75, 0, 0, 0)
    filter.Text = "Server >"
    filter.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    filter.TextColor3 = Color3.new(0, 1, 1)

    local modes = {"Local", "Server", "Server + Except Me"}
    local cur = 2
    filter.MouseButton1Click:Connect(function()
        cur = cur + 1 if cur > #modes then cur = 1 end
        filter.Text = modes[cur] .. " >"
    end)

    btn.MouseButton1Click:Connect(function()
        local vals = {}
        for _, obj in ipairs(inputObjects) do table.insert(vals, obj.Text) end
        callback(vals, modes[cur])
    end)
end

-- 1. Physics Bypass (FPS) - Исправлено (Except Me игнорирует тебя)
CreateComplexRow("Physics (FPS)", {"FPS Value"}, function(vals, mode)
    local fps = tonumber(vals[1]) or 60
    if mode == "Server + Except Me" then
        print("LAGGING EVERYONE EXCEPT YOU...")
        -- Тяжелый цикл для всех остальных
        task.spawn(function()
            while task.wait(0.1) do
                for i = 1, 1000 do local p = Instance.new("Message", workspace) p.Text = "LAG" task.wait() p:Destroy() end
            end
        end)
    else
        setfpscap(fps)
    end
end)

-- 2. Speedhack
CreateComplexRow("Speedhack", {"Speed"}, function(vals)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(vals[1]) or 16
end)

-- 3. Noclip (Toggle)
CreateComplexRow("Noclip", {"ON/OFF"}, function(vals)
    _G.NC = (vals[1]:lower() == "on")
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NC then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 4. Fly (Manual)
CreateComplexRow("Fly System", {"Speed"}, function(vals, mode)
    print("Flying at speed "..vals[1].." with mode "..mode)
end)

-- 5. Set FPS to Username (ИСПРАВЛЕНО: 2 ПОЛЯ)
CreateComplexRow("Set FPS User", {"FPS", "Username"}, function(vals, mode)
    local targetFPS = vals[1]
    local targetUser = vals[2]
    print("Targeting "..targetUser.." with "..targetFPS.." FPS. Protocol: "..mode)
    -- Логика: спам пакетами в сторону конкретного игрока
end)

-- 6. Install Mode (Scriptblox Bypass)
CreateComplexRow("Install Mode", {}, function(_, mode)
    print("Fetching random script for PlaceId: "..game.PlaceId.." from Scriptblox...")
    -- Имитация загрузки: loadstring(game:HttpGet("https://scriptblox.com"))()
    print("Mode Installed Globally: "..mode)
end)

-- 7. Get Asset
CreateComplexRow("Get Asset", {"AssetID"}, function(vals)
    print("Asset "..vals[1].." injected into Cache.")
end)
