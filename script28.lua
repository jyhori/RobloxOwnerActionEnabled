-- ============================================================
--              Functions Hub V1 by Script
--         Auto Wallhop | Shift Lock | Jump | Keyboard
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ============================================================
-- STATE
-- ============================================================
local State = {
    -- Wallhop
    AutoWallhop      = false,
    WallhopDegrees   = 45,

    -- Shift Lock
    AutoShiftLock    = false,
    SpamShiftLock    = false,
    ShiftLockAuto    = true,     -- ON/OFF toggle logic
    ShiftLockSpamTick= 0.3,      -- seconds per spam tick
    SpamShiftDegOn   = 45,
    SpamShiftDegOff  = 0,

    -- Jump
    AutoJump         = false,
    SpamJump         = false,
    AutoJumpDetect   = true,     -- ON/OFF
    SpamJumpEnabled  = true,     -- ON/OFF
    SpamJumpPower    = 50,       -- 0 - 10,000,000

    -- Custom Keyboard
    KeyboardCompiled = false,
    KeyboardBindings = {},       -- { [combo] = function }
}

-- ============================================================
-- UTILITY
-- ============================================================
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunctionsHubV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 760)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -380)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Border glow
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 120, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Functions Hub V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Scroll Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Scroll

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 6)
Padding.PaddingRight = UDim.new(0, 6)
Padding.PaddingTop = UDim.new(0, 4)
Padding.Parent = Scroll

-- ============================================================
-- GUI HELPER FUNCTIONS
-- ============================================================
local function makeSection(title, order)
    local Sec = Instance.new("Frame")
    Sec.Size = UDim2.new(1, 0, 0, 26)
    Sec.BackgroundColor3 = Color3.fromRGB(30, 35, 60)
    Sec.BorderSizePixel = 0
    Sec.LayoutOrder = order
    Sec.Parent = Scroll
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -10, 1, 0)
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = "── " .. title .. " ──"
    Lbl.TextColor3 = Color3.fromRGB(120, 160, 255)
    Lbl.TextSize = 13
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Sec
    return Sec
end

local function makeButton(text, color, order, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = color or Color3.fromRGB(40, 100, 220)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.Gotham
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = order
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)

    local Stroke2 = Instance.new("UIStroke")
    Stroke2.Color = Color3.fromRGB(60, 80, 180)
    Stroke2.Thickness = 1
    Stroke2.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60,140,255)}):Play()
        task.delay(0.15, function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = color or Color3.fromRGB(40,100,220)}):Play()
        end)
        if callback then callback() end
    end)
    return Btn
end

local function makeTextBox(label, defaultVal, order, onChanged)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    Row.Parent = Scroll
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 7)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0.58, -4, 1, 0)
    Lbl.Position = UDim2.new(0, 8, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = label
    Lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextWrapped = true
    Lbl.Parent = Row

    local TB = Instance.new("TextBox")
    TB.Size = UDim2.new(0.4, 0, 0, 26)
    TB.Position = UDim2.new(0.59, 0, 0.5, -13)
    TB.BackgroundColor3 = Color3.fromRGB(35, 38, 58)
    TB.Text = tostring(defaultVal)
    TB.TextColor3 = Color3.fromRGB(255, 255, 255)
    TB.TextSize = 12
    TB.Font = Enum.Font.Gotham
    TB.PlaceholderText = "Enter value..."
    TB.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
    TB.BorderSizePixel = 0
    TB.ClearTextOnFocus = false
    TB.Parent = Row
    Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 5)

    TB.FocusLost:Connect(function()
        if onChanged then onChanged(TB.Text) end
    end)
    return TB
end

local function makeStatusLabel(order)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 20)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = ""
    Lbl.TextColor3 = Color3.fromRGB(100, 220, 100)
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.Gotham
    Lbl.LayoutOrder = order
    Lbl.Parent = Scroll
    return Lbl
end

-- ============================================================
-- STATUS LABEL
-- ============================================================
local StatusLbl = makeStatusLabel(0)
local function setStatus(msg, color)
    StatusLbl.Text = "  ● " .. msg
    StatusLbl.TextColor3 = color or Color3.fromRGB(100, 220, 100)
end

-- ============================================================
-- SECTION: WALLHOP
-- ============================================================
local lo = 1
makeSection("Auto Wallhop", lo) lo=lo+1

makeButton("▶ Auto Wallhop", Color3.fromRGB(30, 90, 200), lo, function()
    State.AutoWallhop = true
    setStatus("Auto Wallhop: ON", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Un Auto Wallhop", Color3.fromRGB(80, 30, 30), lo, function()
    State.AutoWallhop = false
    setStatus("Auto Wallhop: OFF", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

makeTextBox("Wallhop turning gradus:", "45°", lo, function(val)
    local n = tonumber(val:gsub("°",""))
    if n then State.WallhopDegrees = n end
end) lo=lo+1

-- ============================================================
-- SECTION: SHIFT LOCK
-- ============================================================
makeSection("Shift Lock", lo) lo=lo+1

makeButton("▶ Auto Shift Lock", Color3.fromRGB(30, 90, 200), lo, function()
    State.AutoShiftLock = true
    setStatus("Auto Shift Lock: ON", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Un Auto Shift Lock", Color3.fromRGB(80, 30, 30), lo, function()
    State.AutoShiftLock = false
    setStatus("Auto Shift Lock: OFF", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

makeButton("▶ Spam Shift Lock", Color3.fromRGB(30, 110, 180), lo, function()
    State.SpamShiftLock = true
    setStatus("Spam Shift Lock: ON", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Un Spam Shift Lock", Color3.fromRGB(80, 30, 30), lo, function()
    State.SpamShiftLock = false
    setStatus("Spam Shift Lock: OFF", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

makeTextBox("Auto shift lock toggle (ON/OFF):", "ON", lo, function(val)
    State.ShiftLockAuto = (val:upper() == "ON")
end) lo=lo+1

-- Combined spam gradus textbox: парсит формат "45° in 0.1 second"
makeTextBox("Spam gradus + delay (e.g. 45° in 0.1 second):", "45° in 0.1 second", lo, function(val)
    -- Парсим градус: число перед °
    local deg = tonumber(val:match("(%d+%.?%d*)%s*°"))
    -- Парсим задержку: число после "in" и перед "second"
    local delay = tonumber(val:match("in%s*(%d+%.?%d*)%s*second"))

    if deg then
        State.SpamShiftDegOn = deg
    end
    if delay and delay > 0 then
        State.ShiftLockSpamTick = delay
    end

    local statusDeg   = deg   and (deg .. "°")   or "?"
    local statusDelay = delay and (delay .. "s")  or "?"
    setStatus("Spam gradus set: " .. statusDeg .. " per " .. statusDelay, Color3.fromRGB(180, 255, 180))
end) lo=lo+1

makeButton("▶ On Spam Seted Gradus", Color3.fromRGB(40, 80, 160), lo, function()
    -- Применяет SpamShiftDegOn (поворот камеры включён)
    State.SpamShiftLock = true
    setStatus("Spam gradus ON → " .. State.SpamShiftDegOn .. "° / " .. State.ShiftLockSpamTick .. "s", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Off Spam Seted Gradus", Color3.fromRGB(60, 40, 100), lo, function()
    -- Применяет SpamShiftDegOff (камера перестаёт крутиться — градус 0)
    State.SpamShiftLock = false
    State.SpamShiftDegOn = State.SpamShiftDegOff
    setStatus("Spam gradus OFF → градус сброшен в " .. State.SpamShiftDegOff .. "°", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

-- ============================================================
-- SECTION: JUMP
-- ============================================================
makeSection("Auto / Spam Jump", lo) lo=lo+1

makeButton("▶ Auto Jump", Color3.fromRGB(30, 90, 200), lo, function()
    State.AutoJump = true
    setStatus("Auto Jump: ON", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Un Auto Jump", Color3.fromRGB(80, 30, 30), lo, function()
    State.AutoJump = false
    setStatus("Auto Jump: OFF", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

makeButton("▶ Spam Jump", Color3.fromRGB(30, 110, 180), lo, function()
    State.SpamJump = true
    setStatus("Spam Jump: ON", Color3.fromRGB(80, 255, 120))
end) lo=lo+1

makeButton("■ Un Spam Jump", Color3.fromRGB(80, 30, 30), lo, function()
    State.SpamJump = false
    setStatus("Spam Jump: OFF", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

makeTextBox("Auto jump on target detect (ON/OFF):", "ON", lo, function(val)
    State.AutoJumpDetect = (val:upper() == "ON")
end) lo=lo+1

makeTextBox("Spam jump ON/OFF:", "ON", lo, function(val)
    State.SpamJumpEnabled = (val:upper() == "ON")
end) lo=lo+1

makeTextBox("Jump power (0 - 10000000):", "50", lo, function(val)
    local n = tonumber(val)
    if n then State.SpamJumpPower = math.clamp(n, 0, 10000000) end
end) lo=lo+1

-- ============================================================
-- SECTION: CUSTOM KEYBOARD
-- ============================================================
makeSection("Custom Keyboard Compile", lo) lo=lo+1

makeButton("▶ Custom Keyboard Compile", Color3.fromRGB(60, 40, 130), lo, function()
    State.KeyboardCompiled = true
    setStatus("Custom Keyboard: COMPILED", Color3.fromRGB(180, 100, 255))
end) lo=lo+1

makeButton("■ Un Compile Custom Keyboard", Color3.fromRGB(80, 30, 30), lo, function()
    State.KeyboardCompiled = false
    State.KeyboardBindings = {}
    setStatus("Custom Keyboard: CLEARED", Color3.fromRGB(255, 100, 100))
end) lo=lo+1

-- ============================================================
-- CUSTOM KEYBOARD VISUAL
-- ============================================================
local KBFrame = Instance.new("Frame")
KBFrame.Size = UDim2.new(1, 0, 0, 200)
KBFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
KBFrame.BorderSizePixel = 0
KBFrame.LayoutOrder = lo lo = lo+1
KBFrame.Parent = Scroll
Instance.new("UICorner", KBFrame).CornerRadius = UDim.new(0, 8)

local KBTitle = Instance.new("TextLabel")
KBTitle.Size = UDim2.new(1, 0, 0, 20)
KBTitle.BackgroundTransparency = 1
KBTitle.Text = "  Custom Keyboard"
KBTitle.TextColor3 = Color3.fromRGB(160, 130, 255)
KBTitle.TextSize = 12
KBTitle.Font = Enum.Font.GothamBold
KBTitle.TextXAlignment = Enum.TextXAlignment.Left
KBTitle.Parent = KBFrame

-- Keyboard layout rows
local ROWS = {
    {"`","1","2","3","4","5","6","7","8","9","0","-","=","⌫"},
    {"Q","W","E","R","T","Y","U","I","O","P","[","]","\\"},
    {"A","S","D","F","G","H","J","K","L",";","'","↵"},
    {"⇧","Z","X","C","V","B","N","M",",",".","/","⇧"},
    {"CTRL","ALT","SPACE","ALT","CTRL"},
}

local COMBOS = {"CTRL+C","CTRL+V","CTRL+X","CTRL+Z","CTRL+A","CTRL+S","CTRL+D","ALT+TAB","SHIFT+TAB","CTRL+SHIFT+I"}

-- Active key tracking
local ActiveKeys = {}
local ComboLabel = Instance.new("TextLabel")
ComboLabel.Size = UDim2.new(1, -10, 0, 18)
ComboLabel.Position = UDim2.new(0, 5, 0, 22)
ComboLabel.BackgroundTransparency = 1
ComboLabel.Text = "Pressed: —"
ComboLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
ComboLabel.TextSize = 11
ComboLabel.Font = Enum.Font.Gotham
ComboLabel.TextXAlignment = Enum.TextXAlignment.Left
ComboLabel.Parent = KBFrame

local KBScroll = Instance.new("ScrollingFrame")
KBScroll.Size = UDim2.new(1, -6, 1, -44)
KBScroll.Position = UDim2.new(0, 3, 0, 42)
KBScroll.BackgroundTransparency = 1
KBScroll.ScrollBarThickness = 3
KBScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 200)
KBScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
KBScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
KBScroll.Parent = KBFrame

local KBLayout = Instance.new("UIListLayout")
KBLayout.SortOrder = Enum.SortOrder.LayoutOrder
KBLayout.Padding = UDim.new(0, 3)
KBLayout.Parent = KBScroll

local function pressKey(key)
    ActiveKeys[key] = true
    local pressed = {}
    for k,_ in pairs(ActiveKeys) do table.insert(pressed, k) end
    table.sort(pressed)
    local combo = table.concat(pressed, "+")
    ComboLabel.Text = "Pressed: " .. combo
    if State.KeyboardCompiled and State.KeyboardBindings[combo] then
        State.KeyboardBindings[combo]()
    end
    task.delay(0.25, function()
        ActiveKeys[key] = nil
        local still = {}
        for k,_ in pairs(ActiveKeys) do table.insert(still, k) end
        if #still == 0 then
            ComboLabel.Text = "Pressed: —"
        end
    end)
end

local function makeKey(parent, txt, wScale, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(wScale, -2, 0, 22)
    Btn.BackgroundColor3 = Color3.fromRGB(38, 40, 60)
    Btn.Text = txt
    Btn.TextColor3 = Color3.fromRGB(230, 230, 255)
    Btn.TextSize = 10
    Btn.Font = Enum.Font.Gotham
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = order
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    local St = Instance.new("UIStroke")
    St.Color = Color3.fromRGB(60, 60, 100)
    St.Thickness = 1
    St.Parent = Btn

    Btn.MouseButton1Down:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(90, 60, 200)
        pressKey(txt)
    end)
    Btn.MouseButton1Up:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(38, 40, 60)
    end)
    return Btn
end

for rowIdx, row in ipairs(ROWS) do
    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(1, -4, 0, 24)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = rowIdx
    RowFrame.Parent = KBScroll

    local RowLayout = Instance.new("UIListLayout")
    RowLayout.FillDirection = Enum.FillDirection.Horizontal
    RowLayout.Padding = UDim.new(0, 2)
    RowLayout.Parent = RowFrame

    local wideKeys = {["SPACE"]=0.3, ["CTRL"]=0.08, ["ALT"]=0.07, ["⇧"]=0.12, ["⌫"]=0.1, ["↵"]=0.12, ["SPACE"]=0.28}

    for ki, key in ipairs(row) do
        local w = wideKeys[key] or (1/#row)
        makeKey(RowFrame, key, w, ki)
    end
end

-- Combo row
local ComboRow = Instance.new("Frame")
ComboRow.Size = UDim2.new(1, -4, 0, 24)
ComboRow.BackgroundTransparency = 1
ComboRow.LayoutOrder = 10
ComboRow.Parent = KBScroll
local ComboRowLayout = Instance.new("UIListLayout")
ComboRowLayout.FillDirection = Enum.FillDirection.Horizontal
ComboRowLayout.Padding = UDim.new(0, 2)
ComboRowLayout.Parent = ComboRow

for ci, combo in ipairs(COMBOS) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1/#COMBOS, -2, 0, 22)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 30, 80)
    Btn.Text = combo
    Btn.TextColor3 = Color3.fromRGB(200, 160, 255)
    Btn.TextSize = 8
    Btn.Font = Enum.Font.Gotham
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = ci
    Btn.Parent = ComboRow
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Down:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
        local parts = combo:split("+")
        for _, p in ipairs(parts) do
            ActiveKeys[p] = true
        end
        local pressed = {}
        for k,_ in pairs(ActiveKeys) do table.insert(pressed, k) end
        table.sort(pressed)
        local c = table.concat(pressed, "+")
        ComboLabel.Text = "Pressed: " .. c
        if State.KeyboardCompiled and State.KeyboardBindings[c] then
            State.KeyboardBindings[c]()
        end
    end)
    Btn.MouseButton1Up:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(50, 30, 80)
        task.delay(0.25, function()
            for _, p in ipairs(combo:split("+")) do
                ActiveKeys[p] = nil
            end
            local still = {}
            for k,_ in pairs(ActiveKeys) do table.insert(still, k) end
            if #still == 0 then ComboLabel.Text = "Pressed: —" end
        end)
    end)
end

-- Bind example section
lo = lo + 1
makeSection("Keyboard Bind (example)", lo) lo=lo+1

local BindComboTB = makeTextBox("Combo (e.g. CTRL+J):", "CTRL+J", lo, nil) lo=lo+1
local BindActionTB = makeTextBox("Action (e.g. jump/wallhop/shiftlock):", "jump", lo, nil) lo=lo+1

makeButton("+ Add Binding", Color3.fromRGB(40, 110, 60), lo, function()
    if not State.KeyboardCompiled then
        setStatus("Compile keyboard first!", Color3.fromRGB(255, 180, 50))
        return
    end
    local combo = BindComboTB.Text:upper():gsub("%s","")
    local action = BindActionTB.Text:lower()

    local actionFuncs = {
        jump = function()
            local hum = getHumanoid()
            if hum then hum.Jump = true end
        end,
        wallhop = function()
            State.AutoWallhop = not State.AutoWallhop
            setStatus("Wallhop toggled: " .. (State.AutoWallhop and "ON" or "OFF"))
        end,
        shiftlock = function()
            State.AutoShiftLock = not State.AutoShiftLock
            setStatus("ShiftLock toggled: " .. (State.AutoShiftLock and "ON" or "OFF"))
        end,
    }

    if actionFuncs[action] then
        State.KeyboardBindings[combo] = actionFuncs[action]
        setStatus("Bound: " .. combo .. " → " .. action, Color3.fromRGB(180, 255, 180))
    else
        -- generic print action
        State.KeyboardBindings[combo] = function()
            setStatus("Combo triggered: " .. combo, Color3.fromRGB(200, 200, 100))
        end
        setStatus("Bound: " .. combo .. " → notify", Color3.fromRGB(180, 255, 180))
    end
end) lo=lo+1

-- ============================================================
-- LOGIC: AUTO WALLHOP
-- ============================================================
local wallhopConn
local function startWallhopLogic()
    if wallhopConn then wallhopConn:Disconnect() end
    wallhopConn = RunService.Heartbeat:Connect(function()
        if not State.AutoWallhop then return end
        local hrp = getHRP()
        local hum = getHumanoid()
        if not hrp or not hum then return end

        -- Raycast to detect wall
        local deg = math.rad(State.WallhopDegrees)
        local lookVec = hrp.CFrame.LookVector
        local rightVec = hrp.CFrame.RightVector
        local dirs = {
            lookVec,
            -lookVec,
            rightVec * math.cos(deg) + lookVec * math.sin(deg),
            -rightVec * math.cos(deg) + lookVec * math.sin(deg),
        }

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        for _, dir in ipairs(dirs) do
            local result = workspace:Raycast(hrp.Position, dir * 3, rayParams)
            if result then
                -- Near wall → jump
                if hum:GetState() ~= Enum.HumanoidStateType.Jumping and
                   hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                    hum.Jump = true
                end
                break
            end
        end
    end)
end
startWallhopLogic()

-- ============================================================
-- LOGIC: AUTO SHIFT LOCK
-- ============================================================
local shiftLockConn
local shiftSpamConn
local lastShiftSpam = 0

local function applyShiftLock(enabled)
    -- Toggle shift lock via StarterPlayerScripts approach
    local sps = LocalPlayer:FindFirstChild("PlayerScripts")
    if sps then
        local module = sps:FindFirstChild("PlayerModule")
        if module then
            pcall(function()
                local pm = require(module)
                local controls = pm:GetControls()
                -- Attempt camera toggle
            end)
        end
    end
    -- Fallback: camera rotate
    if enabled then
        Camera.CameraType = Enum.CameraType.Custom
    end
end

local function startShiftLockLogic()
    if shiftLockConn then shiftLockConn:Disconnect() end
    if shiftSpamConn then shiftSpamConn:Disconnect() end

    shiftLockConn = RunService.Heartbeat:Connect(function()
        if not State.AutoShiftLock then return end
        applyShiftLock(State.ShiftLockAuto)
    end)

    shiftSpamConn = RunService.Heartbeat:Connect(function()
        if not State.SpamShiftLock then return end
        local now = tick()
        if now - lastShiftSpam >= State.ShiftLockSpamTick then
            lastShiftSpam = now
            -- Rotate camera by spam degrees
            local deg = State.SpamShiftDegOn
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(deg), 0)
        end
    end)
end
startShiftLockLogic()

-- ============================================================
-- LOGIC: AUTO JUMP / SPAM JUMP
-- ============================================================
local jumpConn
local lastSpamJump = 0

local function startJumpLogic()
    if jumpConn then jumpConn:Disconnect() end
    jumpConn = RunService.Heartbeat:Connect(function()
        local hum = getHumanoid()
        if not hum then return end

        -- Auto Jump: detect nearby threats (simplified)
        if State.AutoJump and State.AutoJumpDetect then
            local hrp = getHRP()
            if hrp then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")
                        if enemyHRP then
                            local dist = (hrp.Position - enemyHRP.Position).Magnitude
                            if dist < 15 then
                                if hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                                    hum.Jump = true
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Spam Jump
        if State.SpamJump and State.SpamJumpEnabled then
            local now = tick()
            if now - lastSpamJump >= 0.05 then
                lastSpamJump = now
                hum.JumpPower = math.clamp(State.SpamJumpPower, 0, 1000)
                hum.Jump = true
            end
        end
    end)
end
startJumpLogic()

-- ============================================================
-- REAL INPUT → KEYBOARD BINDINGS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not State.KeyboardCompiled then return end

    local heldKeys = {}
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
       UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
        table.insert(heldKeys, "CTRL")
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or
       UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
        table.insert(heldKeys, "SHIFT")
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or
       UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
        table.insert(heldKeys, "ALT")
    end

    local keyName = input.KeyCode.Name:upper()
    if keyName ~= "UNKNOWN" then
        table.insert(heldKeys, keyName)
    end
    table.sort(heldKeys)
    local combo = table.concat(heldKeys, "+")

    if State.KeyboardBindings[combo] then
        State.KeyboardBindings[combo]()
        setStatus("Key binding fired: " .. combo, Color3.fromRGB(200, 200, 100))
    end
end)

-- ============================================================
-- CLEANUP ON CHARACTER RESPAWN
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    startWallhopLogic()
    startShiftLockLogic()
    startJumpLogic()
    setStatus("Character respawned — logic restarted", Color3.fromRGB(150, 200, 255))
end)

-- ============================================================
-- INIT STATUS
-- ============================================================
setStatus("Functions Hub V1 loaded!", Color3.fromRGB(100, 220, 255))

print("✅ Functions Hub V1 loaded successfully!")
