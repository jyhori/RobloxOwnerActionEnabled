-- Functions Hub V1 (Final Ultra Edition)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local DegreeLabel = Instance.new("TextLabel")

ScreenGui.Name = "FunctionsHubV1"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 450)
MainFrame.CanvasSize = UDim2.new(0, 0, 5, 0) -- Большая прокрутка для всех функций
MainFrame.Active = true
MainFrame.Draggable = true

UIListLayout.Parent = MainFrame
UIListLayout.Padding = UDim.new(0, 5)

-- ОПРЕДЕЛЯТОР ГРАДУСА
DegreeLabel.Size = UDim2.new(1, 0, 0, 30)
DegreeLabel.Text = "Current Deg: 0°"
DegreeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DegreeLabel.TextColor3 = Color3.new(0, 1, 0)
DegreeLabel.Parent = MainFrame

-- Настройки
local s = {
    wh = false, whDeg = 45, sl = false, slSpam = false, slTick = 0.3, 
    spamGradus = 45, spamSpeed = 0.1, spamGradActive = false,
    aj = false, sj = false, jp = 50, kb = false, targetDist = 20
}

local VIM = game:GetService("VirtualInputManager")
local LP = game.Players.LocalPlayer

-- Обновление градуса
game:GetService("RunService").RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        DegreeLabel.Text = "Current Deg: " .. math.floor(LP.Character.HumanoidRootPart.Orientation.Y) .. "°"
    end
end)

-- Утилиты GUI
local function Btn(text, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Text = text
    b.Parent = MainFrame
    b.MouseButton1Click:Connect(func)
    return b
end

local function Box(ph, func)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -10, 0, 30)
    t.PlaceholderText = ph
    t.Parent = MainFrame
    t.FocusLost:Connect(function() func(t.Text) end)
    return t
end

local function Label(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = text
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1, 1, 0)
    l.Parent = MainFrame
end

-- [ WALLHOP ]
Btn("[Auto Wallhop]", function() s.wh = true while s.wh do if LP.Character then LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(s.whDeg), 0) end task.wait(0.1) end end)
Btn("[Un auto wallhop]", function() s.wh = false end)
Label("Wallhop Setting:")
Box("Wallhop gradus (45°)", function(v) s.whDeg = tonumber(v) or 45 end)

-- [ SHIFT LOCK ]
Btn("[Auto Shift Lock]", function() LP.DevEnableMouseLock = true end)
Btn("[Un auto shift lock]", function() LP.DevEnableMouseLock = false end)
Btn("[Spam Shift Lock]", function() s.slSpam = true while s.slSpam do VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) task.wait(0.05) VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) task.wait(s.slTick) end end)
Btn("[Un spam shift lock]", function() s.slSpam = false end)

Label("Shift lock setting:")
Box("Auto SL (ON/OFF)", function(v) LP.DevEnableMouseLock = (v:upper() == "ON") end)
Box("SL Tick (0.3)", function(v) s.slTick = tonumber(v) or 0.3 end)

-- [ GRADUS SPAM ]
Btn("[On Spam seted gradus]", function() s.spamGradActive = true while s.spamGradActive do if LP.Character then LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(s.spamGradus), 0) end task.wait(s.spamSpeed) end end)
Btn("[Off Spam seted gradus]", function() s.spamGradActive = false end)
Label("Gradus setting:")
Box("Spam Speed (0.1)", function(v) s.spamSpeed = tonumber(v) or 0.1 end)

-- [ JUMP SECTION ]
Btn("[Auto Jump]", function() 
    s.aj = true 
    while s.aj do 
        task.wait(0.5)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and LP.Character then
                local dist = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if dist < s.targetDist then LP.Character.Humanoid.Jump = true end
            end
        end
    end 
end)
Btn("[Un auto jump]", function() s.aj = false end)
Btn("[Spam Jump]", function() s.sj = true while s.sj do if LP.Character then LP.Character.Humanoid.Jump = true end task.wait(0.1) end end)
Btn("[Un spam jump]", function() s.sj = false end)

Label("Jump setting:")
Box("Auto Jump Target (ON/OFF)", function(v) s.aj = (v:upper() == "ON") end)
Box("Spam Jump (ON/OFF)", function(v) s.sj = (v:upper() == "ON") end)
Box("Jump Power (Limit 10M)", function(v) 
    local val = tonumber(v) or 50
    if val > 10000000 then val = 10000000 end
    s.jp = val
    if LP.Character then LP.Character.Humanoid.JumpPower = s.jp end
end)

-- [ KEYBOARD ]
Btn("[Custom Keyboard Compile]", function() s.kb = true end)
Btn("[Un compile Custom Keyboard]", function() s.kb = false end)

Label("Keyboard Keys:")
local keys = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","1","2","3","SHIFT","CTRL","ALT","SPACE"}
for _, k in pairs(keys) do
    local kbBtn = Btn("["..k.."]", function()
        if s.kb then
            local kc = Enum.KeyCode[k] or (k=="SHIFT" and Enum.KeyCode.LeftShift) or (k=="CTRL" and Enum.KeyCode.LeftControl) or (k=="ALT" and Enum.KeyCode.LeftAlt) or (k=="SPACE" and Enum.KeyCode.Space)
            VIM:SendKeyEvent(true, kc, false, game) task.wait(0.05) VIM:SendKeyEvent(false, kc, false, game)
        end
    end)
    kbBtn.Size = UDim2.new(0, 80, 0, 30) -- Компактные кнопки для клавиатуры
end
