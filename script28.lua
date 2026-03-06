local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Functions Hub V1",
   LoadingTitle = "Loading Hub...",
   ConfigurationSaving = { Enabled = false }
})

-- Вкладка Информации
local InfoTab = Window:CreateTab("Status", 4483362458)
local DegreeLabel = InfoTab:CreateLabel("Current Rotation: 0°")

-- Переменные настроек
local settings = {
    wallhop = false,
    whGradus = 45,
    autoSL = false,
    spamSL = false,
    slTick = 0.3,
    spamGradus = 45,
    kbCompiled = false
}

-- Обновление градуса в реальном времени
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local yRotation = math.floor(LocalPlayer.Character.HumanoidRootPart.Orientation.Y)
        DegreeLabel:Set("Current Rotation: " .. tostring(yRotation) .. "°")
    end
end)

local MainTab = Window:CreateTab("Main Functions", 4483362458)

-- [WALLHOP SECTION]
MainTab:CreateSection("Wallhop")
MainTab:CreateButton({
    Name = "Auto Wallhop",
    Callback = function() 
        settings.wallhop = true 
        task.spawn(function()
            while settings.wallhop do
                -- Логика поворота персонажа на заданный градус при прыжке
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(settings.whGradus), 0)
                end
                task.wait(0.2)
            end
        end)
    end
})
MainTab:CreateButton({ Name = "Un auto wallhop", Callback = function() settings.wallhop = false end })
MainTab:CreateInput({
    Name = "Wallhop turning gradus",
    PlaceholderText = "45",
    Callback = function(val) settings.whGradus = tonumber(val) or 45 end
})

-- [SHIFT LOCK SECTION]
MainTab:CreateSection("Shift Lock")
MainTab:CreateButton({ Name = "Auto Shift Lock", Callback = function() LocalPlayer.DevEnableMouseLock = true end })
MainTab:CreateButton({ Name = "Un auto shift lock", Callback = function() LocalPlayer.DevEnableMouseLock = false end })

MainTab:CreateButton({
    Name = "Spam Shift Lock",
    Callback = function()
        settings.spamSL = true
        task.spawn(function()
            while settings.spamSL do
                VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                task.wait(settings.slTick)
            end
        end)
    end
})
MainTab:CreateButton({ Name = "Un spam shift lock", Callback = function() settings.spamSL = false end })

MainTab:CreateInput({
    Name = "Auto shift lock toggle (ON/OFF)",
    PlaceholderText = "ON",
    Callback = function(val) LocalPlayer.DevEnableMouseLock = (string.upper(val) == "ON") end
})

MainTab:CreateInput({
    Name = "Shift lock turning toggle spam in tick",
    PlaceholderText = "0.3",
    Callback = function(val) settings.slTick = tonumber(val) or 0.3 end
})

-- [GRADUS SECTION]
MainTab:CreateSection("Gradus Settings")
MainTab:CreateButton({
    Name = "On Spam seted gradus",
    Callback = function()
        settings.spamActive = true
        task.spawn(function()
            while settings.spamActive do
                if LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(settings.spamGradus), 0)
                end
                task.wait(0.1) -- Базовая скорость из ТЗ
            end
        end)
    end
})
MainTab:CreateButton({ Name = "Off Spam seted gradus", Callback = function() settings.spamActive = false end })

MainTab:CreateInput({
    Name = "Spamming speed tick (Gradus/Sec)",
    PlaceholderText = "45",
    Callback = function(val) settings.spamGradus = tonumber(val) or 45 end
})

-- [KEYBOARD SECTION]
local KBTab = Window:CreateTab("Custom Keyboard", 4483362458)
KBTab:CreateButton({ Name = "Custom Keyboard Compile", Callback = function() settings.kbCompiled = true end })
KBTab:CreateButton({ Name = "Un compile Custom Keyboard", Callback = function() settings.kbCompiled = false end })

local keys = {
    "Q","W","E","R","T","Y","U","I","O","P",
    "A","S","D","F","G","H","J","K","L",
    "Z","X","C","V","B","N","M",
    "1","2","3","4","5","SHIFT","ALT","CTRL","SPACE"
}

for _, key in ipairs(keys) do
    KBTab:CreateButton({
        Name = "[" .. key .. "]",
        Callback = function()
            if settings.kbCompiled then
                local code = Enum.KeyCode[key] or (key == "SHIFT" and Enum.KeyCode.LeftShift) or (key == "CTRL" and Enum.KeyCode.LeftControl) or (key == "ALT" and Enum.KeyCode.LeftAlt) or (key == "SPACE" and Enum.KeyCode.Space)
                if code then
                    VIM:SendKeyEvent(true, code, false, game)
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, code, false, game)
                end
            end
        end
    })
end
