-- ╔══════════════════════════════════════════════════════════════╗
-- ║              Owner Admin Hub V1  —  by Script               ║
-- ╚══════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local StarterGui       = game:GetService("StarterGui")

local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────────────────────
--  State
-- ─────────────────────────────────────────────────────────────────
local limitFlag        = nil   -- nil = no limit
local spamActive       = {}    -- [message] = connection
local pmSpamActive     = {}    -- [username] = connection
local listNameSpamConn = nil
local listNameSpamSpeed= 1
local listNameSpamMsg  = "Hello"
local spamSpeed        = 1
local customExecLines  = {}
local customExecRunning= false
local executorConn     = nil
local dataStoreConnected = false

-- ─────────────────────────────────────────────────────────────────
--  Helpers
-- ─────────────────────────────────────────────────────────────────
local function getTargets(arg)
    local list = {}
    if arg == "all" then
        for _, p in ipairs(Players:GetPlayers()) do list[#list+1] = p end
    elseif arg == "me" then
        list[1] = LocalPlayer
    else
        local p = Players:FindFirstChild(arg)
        if p then list[1] = p end
    end
    return list
end

local function isAllowed(username)
    if limitFlag == nil then return true end
    if limitFlag == "all" then return true end
    if limitFlag == "me" and username == LocalPlayer.Name then return true end
    if limitFlag == username then return true end
    return false
end

local function notify(msg)
    StarterGui:SetCore("SendNotification", {
        Title   = "Owner Admin Hub",
        Text    = msg,
        Duration= 4,
    })
end

-- ─────────────────────────────────────────────────────────────────
--  Commands
-- ─────────────────────────────────────────────────────────────────
local function cmdFling(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(math.random(-500,500), 800, math.random(-500,500))
            end
        end
    end
end

local function cmdKill(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
end

local function cmdLag(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            for i = 1, 200 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1,1,1)
                part.Position = p.Character.HumanoidRootPart.Position
                part.Parent = workspace
                game:GetService("Debris"):AddItem(part, 5)
            end
        end
    end
end

local function cmdKick(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) then
            pcall(function() p:Kick("[Owner Admin Hub] You were kicked.") end)
        end
    end
end

local function cmdBan(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) then
            if dataStoreConnected then
                -- DataStore ban logic placeholder
                local DS = game:GetService("DataStoreService"):GetDataStore("AdminBans")
                pcall(function() DS:SetAsync(tostring(p.UserId), true) end)
            end
            pcall(function() p:Kick("[Owner Admin Hub] You are banned.") end)
        end
    end
end

local function cmdBring(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character and LocalPlayer.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHrp then hrp.CFrame = myHrp.CFrame * CFrame.new(3,0,0) end
        end
    end
end

local function cmdFire(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local fire = Instance.new("Fire")
            fire.Parent = p.Character:FindFirstChild("HumanoidRootPart") or p.Character
        end
    end
end

local function cmdDinofy(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h.RigType = Enum.HumanoidRigType.R15
                p.Character:ScaleTo(3)
            end
        end
    end
end

local function cmdDay()   Lighting.TimeOfDay = "12:00:00" end
local function cmdNight() Lighting.TimeOfDay = "00:00:00" end

local function cmdPixel(bit)
    local vals = {["1"]=1,["2"]=2,["4"]=4,["8"]=8,["16"]=16,["32"]=32,["64"]=64}
    local v = vals[bit] or 8
    -- Apply pixelation via ColorCorrectionEffect
    local cc = Lighting:FindFirstChild("PixelEffect") or Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "PixelEffect"
    cc.Contrast = v / 64
end

local function cmdJail(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local cage = Instance.new("Model", workspace)
                cage.Name = p.Name.."_Jail"
                local pos = hrp.Position
                local bars = {
                    {CFrame.new(pos+Vector3.new(4,2,0)),  Vector3.new(0.5,8,8)},
                    {CFrame.new(pos+Vector3.new(-4,2,0)), Vector3.new(0.5,8,8)},
                    {CFrame.new(pos+Vector3.new(0,2,4)),  Vector3.new(8,8,0.5)},
                    {CFrame.new(pos+Vector3.new(0,2,-4)), Vector3.new(8,8,0.5)},
                    {CFrame.new(pos+Vector3.new(0,6,0)),  Vector3.new(8,0.5,8)},
                }
                for _, b in ipairs(bars) do
                    local part = Instance.new("Part", cage)
                    part.Anchored = true
                    part.CFrame = b[1]
                    part.Size = b[2]
                    part.BrickColor = BrickColor.new("Medium grey")
                    part.Transparency = 0.3
                end
            end
        end
    end
end

local function cmdUnjail(arg)
    for _, p in ipairs(getTargets(arg)) do
        local cage = workspace:FindFirstChild(p.Name.."_Jail")
        if cage then cage:Destroy() end
    end
end

local function cmdIce(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Ice
                    part.BrickColor = BrickColor.new("Cyan")
                end
            end
        end
    end
end

local function cmdUnice(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end
end

local function cmdFreeze(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = true end
            end
        end
    end
end

local function cmdUnfreeze(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = false end
            end
        end
    end
end

local function cmdAnchor(arg)   cmdFreeze(arg) end
local function cmdUnanchor(arg) cmdUnfreeze(arg) end

local function cmdSetBodyColorRGB(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local bc = p.Character:FindFirstChildOfClass("BodyColors")
            if bc then
                local r,g,b = math.random(0,255), math.random(0,255), math.random(0,255)
                local c3 = Color3.fromRGB(r,g,b)
                bc.HeadColor3 = c3; bc.LeftArmColor3 = c3; bc.RightArmColor3 = c3
                bc.TorsoColor3 = c3; bc.LeftLegColor3 = c3; bc.RightLegColor3 = c3
            end
        end
    end
end

local function cmdUnsetBodyColorRGB(arg)
    for _, p in ipairs(getTargets(arg)) do
        if isAllowed(p.Name) and p.Character then
            local bc = p.Character:FindFirstChildOfClass("BodyColors")
            if bc then
                local c3 = Color3.fromRGB(163,162,165)
                bc.HeadColor3 = c3; bc.LeftArmColor3 = c3; bc.RightArmColor3 = c3
                bc.TorsoColor3 = c3; bc.LeftLegColor3 = c3; bc.RightLegColor3 = c3
            end
        end
    end
end

local function cmdSpam(msg)
    if spamActive[msg] then return end
    spamActive[msg] = RunService.Heartbeat:Connect(function()
        task.wait(spamSpeed)
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local fire = chat:FindFirstChild("SayMessageRequest")
            if fire then fire:FireServer(msg, "All") end
        end
    end)
end

local function cmdUnspam(msg)
    if spamActive[msg] then
        spamActive[msg]:Disconnect()
        spamActive[msg] = nil
    end
end

local function cmdWhisper(username, msg)
    local p = Players:FindFirstChild(username)
    if p then
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local fire = chat:FindFirstChild("SayMessageRequest")
            if fire then fire:FireServer("/w "..username.." "..msg, "All") end
        end
    end
end

local pmSpamSpeed = 1
local function cmdPmSpam(username, msg)
    if pmSpamActive[username] then return end
    pmSpamActive[username] = RunService.Heartbeat:Connect(function()
        task.wait(pmSpamSpeed)
        cmdWhisper(username, msg)
    end)
end

local function cmdUnpmSpam(username)
    if pmSpamActive[username] then
        pmSpamActive[username]:Disconnect()
        pmSpamActive[username] = nil
    end
end

local function cmdListNameSpam(leftMsg)
    listNameSpamMsg = leftMsg
    if listNameSpamConn then listNameSpamConn:Disconnect() end
    listNameSpamConn = RunService.Heartbeat:Connect(function()
        task.wait(listNameSpamSpeed)
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local fire = chat:FindFirstChild("SayMessageRequest")
            if fire then
                for _, p in ipairs(Players:GetPlayers()) do
                    fire:FireServer(listNameSpamMsg .. " " .. p.Name, "All")
                end
            end
        end
    end)
end

-- ─────────────────────────────────────────────────────────────────
--  GUI Builder
-- ─────────────────────────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OwnerAdminHubV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Colour palette
local C = {
    bg      = Color3.fromRGB(10,  10,  16),
    panel   = Color3.fromRGB(16,  16,  28),
    accent  = Color3.fromRGB(88,  101, 242),
    accent2 = Color3.fromRGB(255, 71,  87),
    text    = Color3.fromRGB(220, 220, 240),
    subtext = Color3.fromRGB(130, 130, 160),
    border  = Color3.fromRGB(40,  40,  70),
    btn     = Color3.fromRGB(30,  30,  55),
    btnHov  = Color3.fromRGB(50,  50,  90),
    green   = Color3.fromRGB(46,  213, 115),
}

local function makeLabel(parent, text, size, pos, color, font, halign)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = size or UDim2.new(1,0,0,20)
    lbl.Position = pos or UDim2.new(0,0,0,0)
    lbl.Text = text
    lbl.TextColor3 = color or C.text
    lbl.Font = font or Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = halign or Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function makeButton(parent, text, size, pos, bgColor, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0,140,0,30)
    btn.Position = pos or UDim2.new(0,0,0,0)
    btn.BackgroundColor3 = bgColor or C.btn
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = textColor or C.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,6)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = C.btnHov}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = bgColor or C.btn}):Play()
    end)
    return btn
end

local function makeTextBox(parent, placeholder, size, pos)
    local box = Instance.new("TextBox")
    box.Size = size or UDim2.new(1,0,0,28)
    box.Position = pos or UDim2.new(0,0,0,0)
    box.BackgroundColor3 = Color3.fromRGB(20,20,36)
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = C.subtext
    box.Text = ""
    box.TextColor3 = C.text
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)
    return box
end

local function addStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color or C.border
    s.Thickness = thickness or 1
    return s
end

-- ─────────────────────────────────────────────────────────────────
--  Main Window
-- ─────────────────────────────────────────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,460,0,520)
MainFrame.Position = UDim2.new(0.5,-230,0.5,-260)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)
addStroke(MainFrame, C.border, 1.5)

-- Gradient top bar
local topBar = Instance.new("Frame", MainFrame)
topBar.Size = UDim2.new(1,0,0,44)
topBar.BackgroundColor3 = C.panel
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,12)

local titleLabel = makeLabel(topBar, "⚙  Owner Admin Hub  V1",
    UDim2.new(1,-80,1,0), UDim2.new(0,14,0,0), C.text, Enum.Font.GothamBold)
titleLabel.TextSize = 14

local closeBtn = makeButton(topBar, "✕", UDim2.new(0,28,0,28),
    UDim2.new(1,-36,0,8), C.accent2, C.text)
closeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sub-title line
local subLine = Instance.new("Frame", MainFrame)
subLine.Size = UDim2.new(1,-28,0,1)
subLine.Position = UDim2.new(0,14,0,44)
subLine.BackgroundColor3 = C.border
subLine.BorderSizePixel = 0

-- Compile + Reset buttons
local compileBtn = makeButton(MainFrame, "▶  Compile Script",
    UDim2.new(0,180,0,36), UDim2.new(0,14,0,56), C.accent, Color3.new(1,1,1))
local resetBtn   = makeButton(MainFrame, "↺  Reset Data",
    UDim2.new(0,150,0,36), UDim2.new(0,204,0,56), C.btn, C.text)

-- Command list (hidden until compiled)
local cmdScroll = Instance.new("ScrollingFrame", MainFrame)
cmdScroll.Size = UDim2.new(1,-28,1,-110)
cmdScroll.Position = UDim2.new(0,14,0,104)
cmdScroll.BackgroundColor3 = C.panel
cmdScroll.BorderSizePixel = 0
cmdScroll.ScrollBarThickness = 4
cmdScroll.ScrollBarImageColor3 = C.accent
cmdScroll.Visible = false
Instance.new("UICorner", cmdScroll).CornerRadius = UDim.new(0,8)
addStroke(cmdScroll, C.border, 1)

local listLayout = Instance.new("UIListLayout", cmdScroll)
listLayout.Padding = UDim.new(0,2)

local listPad = Instance.new("UIPadding", cmdScroll)
listPad.PaddingTop = UDim.new(0,6)
listPad.PaddingLeft = UDim.new(0,8)
listPad.PaddingRight = UDim.new(0,8)

-- Input bar (hidden until compiled)
local inputBar = Instance.new("Frame", MainFrame)
inputBar.Size = UDim2.new(1,-28,0,36)
inputBar.Position = UDim2.new(0,14,1,-44)
inputBar.BackgroundColor3 = C.panel
inputBar.BorderSizePixel = 0
inputBar.Visible = false
Instance.new("UICorner", inputBar).CornerRadius = UDim.new(0,8)
addStroke(inputBar, C.accent, 1)

local cmdInput = makeTextBox(inputBar, "Type a command…",
    UDim2.new(1,-60,1,-8), UDim2.new(0,6,0,4))
local sendBtn = makeButton(inputBar, "⏎", UDim2.new(0,46,1,-8),
    UDim2.new(1,-52,0,4), C.accent, Color3.new(1,1,1))

-- ─────────────────────────────────────────────────────────────────
--  Command definitions (displayed list)
-- ─────────────────────────────────────────────────────────────────
local COMMANDS = {
    {"!fling",             "<username>"},
    {"!kill",              "<username>"},
    {"!lag",               "<username>"},
    {"!kick",              "<username>"},
    {"!ban",               "<username>"},
    {"!bring",             "<username>"},
    {"!fire",              "<username>"},
    {"!dinofy",            "<username>"},
    {"!setlimitflag",      "<all / %username / me>"},
    {"!unsetlimitflag",    ""},
    {"!listnamespamspeed", "<num>"},
    {"!listnamespam",      "<leftmessage>"},
    {"!day",               ""},
    {"!night",             ""},
    {"!pixel",             "<1/2/4/8/16/32/64bit>"},
    {"!customexecutor",    ""},
    {"!customlagexecutor", ""},
    {"!connectdatastore",  ""},
    {"!jail",              "<username>"},
    {"!unjail",            "<username>"},
    {"!ice",               "<username>"},
    {"!unice",             "<username>"},
    {"!freeze",            "<username>"},
    {"!unfreeze",          "<username>"},
    {"!anchor",            "<username>"},
    {"!unanchor",          "<username>"},
    {"!setbodycolorRGB",   "<username>"},
    {"!unsetbodycolorRGB", "<username>"},
    {"!spamspeed",         "<num>"},
    {"!spam",              "<message>"},
    {"!unspam",            "<message>"},
    {"!whisper",           "<username> <message>"},
    {"!pmspamspeed",       "<num>"},
    {"!pmspam",            "<username> <message>"},
    {"!unpmspam",          "<username>"},
}

local function buildCommandList()
    for _, child in ipairs(cmdScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, cmd in ipairs(COMMANDS) do
        local row = Instance.new("Frame", cmdScroll)
        row.Size = UDim2.new(1,-8,0,24)
        row.BackgroundColor3 = (i%2==0) and Color3.fromRGB(18,18,32) or Color3.fromRGB(22,22,40)
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)

        local cmdLbl = makeLabel(row, cmd[1],
            UDim2.new(0,200,1,0), UDim2.new(0,8,0,0), C.accent, Enum.Font.GothamBold)
        cmdLbl.TextSize = 12

        local argLbl = makeLabel(row, cmd[2],
            UDim2.new(1,-210,1,0), UDim2.new(0,210,0,0), C.subtext, Enum.Font.Gotham)
        argLbl.TextSize = 11
    end
    cmdScroll.CanvasSize = UDim2.new(0,0,0, #COMMANDS * 26 + 12)
end

-- ─────────────────────────────────────────────────────────────────
--  Compile button
-- ─────────────────────────────────────────────────────────────────
compileBtn.MouseButton1Click:Connect(function()
    buildCommandList()
    cmdScroll.Visible = true
    inputBar.Visible = true
    compileBtn.Visible = false
    resetBtn.Position = UDim2.new(0,14,0,56)
end)

-- ─────────────────────────────────────────────────────────────────
--  Reset button
-- ─────────────────────────────────────────────────────────────────
resetBtn.MouseButton1Click:Connect(function()
    limitFlag = nil
    spamActive = {}
    pmSpamActive = {}
    if listNameSpamConn then listNameSpamConn:Disconnect(); listNameSpamConn = nil end
    listNameSpamSpeed = 1
    spamSpeed = 1
    dataStoreConnected = false
    notify("Data reset.")
end)

-- ─────────────────────────────────────────────────────────────────
--  Custom Executor Window
-- ─────────────────────────────────────────────────────────────────
local function openCustomExecutor()
    local win = Instance.new("Frame", ScreenGui)
    win.Name = "CustomExecutor"
    win.Size = UDim2.new(0,480,0,400)
    win.Position = UDim2.new(0.5,-240,0.5,-200)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.Active = true
    win.Draggable = true
    Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)
    addStroke(win, C.accent, 1.5)

    -- title bar
    local tb = Instance.new("Frame", win)
    tb.Size = UDim2.new(1,0,0,40)
    tb.BackgroundColor3 = C.panel
    tb.BorderSizePixel = 0
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,12)
    makeLabel(tb, "⚡  Custom Executor  v1.0",
        UDim2.new(1,-50,1,0), UDim2.new(0,14,0,0), C.accent, Enum.Font.GothamBold)
    makeButton(tb, "✕", UDim2.new(0,26,0,26),
        UDim2.new(1,-32,0,7), C.accent2, C.text).MouseButton1Click:Connect(function()
        win:Destroy()
    end)

    -- line numbers + code area
    local editorFrame = Instance.new("Frame", win)
    editorFrame.Size = UDim2.new(1,-20,0,270)
    editorFrame.Position = UDim2.new(0,10,0,50)
    editorFrame.BackgroundColor3 = Color3.fromRGB(14,14,24)
    editorFrame.BorderSizePixel = 0
    Instance.new("UICorner", editorFrame).CornerRadius = UDim.new(0,8)
    addStroke(editorFrame, C.border, 1)

    local lineNumScroll = Instance.new("ScrollingFrame", editorFrame)
    lineNumScroll.Size = UDim2.new(0,32,1,0)
    lineNumScroll.BackgroundColor3 = Color3.fromRGB(18,18,32)
    lineNumScroll.BorderSizePixel = 0
    lineNumScroll.ScrollBarThickness = 0
    Instance.new("UICorner", lineNumScroll).CornerRadius = UDim.new(0,8)

    local lineNumLayout = Instance.new("UIListLayout", lineNumScroll)
    lineNumLayout.Padding = UDim.new(0,0)

    local codeBox = Instance.new("TextBox", editorFrame)
    codeBox.Size = UDim2.new(1,-40,1,-8)
    codeBox.Position = UDim2.new(0,38,0,4)
    codeBox.BackgroundTransparency = 1
    codeBox.TextColor3 = C.text
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 13
    codeBox.Text = 'print("hello, world!")'
    codeBox.MultiLine = true
    codeBox.ClearTextOnFocus = false
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.PlaceholderText = "-- write your code here"
    codeBox.PlaceholderColor3 = C.subtext

    local savedCode = codeBox.Text

    local function updateLineNumbers()
        for _, c in ipairs(lineNumScroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        local lines = 1
        for _ in codeBox.Text:gmatch("\n") do lines = lines + 1 end
        for i = 1, lines do
            local ln = Instance.new("TextLabel", lineNumScroll)
            ln.Size = UDim2.new(1,0,0,16)
            ln.BackgroundTransparency = 1
            ln.Text = tostring(i)
            ln.TextColor3 = C.subtext
            ln.Font = Enum.Font.Code
            ln.TextSize = 13
        end
        lineNumScroll.CanvasSize = UDim2.new(0,0,0, lines*16+4)
    end

    codeBox:GetPropertyChangedSignal("Text"):Connect(updateLineNumbers)
    updateLineNumbers()

    -- Buttons row
    local btnRow = Instance.new("Frame", win)
    btnRow.Size = UDim2.new(1,-20,0,36)
    btnRow.Position = UDim2.new(0,10,0,330)
    btnRow.BackgroundTransparency = 1

    local bLayout = Instance.new("UIListLayout", btnRow)
    bLayout.FillDirection = Enum.FillDirection.Horizontal
    bLayout.Padding = UDim.new(0,6)

    local deleteBtn = makeButton(btnRow, "Delete All", UDim2.new(0,100,0,32), nil, C.accent2, Color3.new(1,1,1))
    local redoBtn   = makeButton(btnRow, "Redo All",   UDim2.new(0,90,0,32),  nil, C.btn, C.text)
    local execBtn   = makeButton(btnRow, "▶ Execute",  UDim2.new(0,90,0,32),  nil, C.green, Color3.new(0,0,0))
    local stopBtn   = makeButton(btnRow, "■ Stop",     UDim2.new(0,80,0,32),  nil, C.accent2, Color3.new(1,1,1))

    deleteBtn.MouseButton1Click:Connect(function()
        savedCode = codeBox.Text
        codeBox.Text = ""
    end)
    redoBtn.MouseButton1Click:Connect(function()
        codeBox.Text = savedCode
    end)
    execBtn.MouseButton1Click:Connect(function()
        customExecRunning = true
        local ok, err = pcall(function() loadstring(codeBox.Text)() end)
        if not ok then notify("Executor error: "..tostring(err)) end
        customExecRunning = false
    end)
    stopBtn.MouseButton1Click:Connect(function()
        customExecRunning = false
        notify("Execution stopped.")
    end)
end

-- ─────────────────────────────────────────────────────────────────
--  Custom Lag Executor Window
-- ─────────────────────────────────────────────────────────────────
local function openLagExecutor()
    local win = Instance.new("Frame", ScreenGui)
    win.Name = "LagExecutor"
    win.Size = UDim2.new(0,420,0,520)
    win.Position = UDim2.new(0.5,-210,0.5,-260)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.Active = true
    win.Draggable = true
    Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)
    addStroke(win, C.accent, 1.5)

    -- title bar
    local tb = Instance.new("Frame", win)
    tb.Size = UDim2.new(1,0,0,40)
    tb.BackgroundColor3 = C.panel
    tb.BorderSizePixel = 0
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,12)
    makeLabel(tb, "🎛  Luxury sys-panel  v1.0",
        UDim2.new(1,-50,1,0), UDim2.new(0,14,0,0), C.accent, Enum.Font.GothamBold)
    makeButton(tb, "✕", UDim2.new(0,26,0,26),
        UDim2.new(1,-32,0,7), C.accent2, C.text).MouseButton1Click:Connect(function()
        win:Destroy()
    end)

    local scroll = Instance.new("ScrollingFrame", win)
    scroll.Size = UDim2.new(1,-20,1,-50)
    scroll.Position = UDim2.new(0,10,0,48)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = C.accent
    scroll.CanvasSize = UDim2.new(0,0,0,520)

    local yOff = 0
    local function lbl(text, color)
        local l = makeLabel(scroll, text, UDim2.new(1,-10,0,20),
            UDim2.new(0,0,0,yOff), color or C.subtext)
        l.TextSize = 12
        yOff = yOff + 22
        return l
    end
    local function gap(n) yOff = yOff + (n or 8) end

    lbl("Filter:", C.text)
    gap(4)

    local filterVar = "Local"
    local filterBtns = {}
    local filterLabels = {"[Local]","[Global]","[Global, but except me]"}
    local filterRow = Instance.new("Frame", scroll)
    filterRow.Size = UDim2.new(1,-10,0,30)
    filterRow.Position = UDim2.new(0,0,0,yOff)
    filterRow.BackgroundTransparency = 1
    local fLayout = Instance.new("UIListLayout", filterRow)
    fLayout.FillDirection = Enum.FillDirection.Horizontal
    fLayout.Padding = UDim.new(0,6)
    for _, lText in ipairs(filterLabels) do
        local fb = makeButton(filterRow, lText, UDim2.new(0,0,1,0), nil, C.btn, C.text)
        fb.AutomaticSize = Enum.AutomaticSize.X
        table.insert(filterBtns, fb)
        fb.MouseButton1Click:Connect(function()
            filterVar = lText:match("%[(.-)%]")
            for _, b in ipairs(filterBtns) do b.BackgroundColor3 = C.btn end
            fb.BackgroundColor3 = C.accent
        end)
    end
    filterBtns[1].BackgroundColor3 = C.accent
    yOff = yOff + 38

    gap()
    local divider = Instance.new("Frame", scroll)
    divider.Size = UDim2.new(1,-10,0,1)
    divider.Position = UDim2.new(0,0,0,yOff)
    divider.BackgroundColor3 = C.border
    divider.BorderSizePixel = 0
    yOff = yOff + 8

    lbl("/Lag Content\\", C.text)
    gap(4)

    lbl("Set fps:", C.subtext)
    local fpsBox = makeTextBox(scroll, "60", UDim2.new(1,-10,0,28), UDim2.new(0,0,0,yOff))
    yOff = yOff + 34
    local execLagBtn = makeButton(scroll, "▶ Execute Lag",
        UDim2.new(0,140,0,30), UDim2.new(0,0,0,yOff), C.accent, Color3.new(1,1,1))
    yOff = yOff + 38
    execLagBtn.MouseButton1Click:Connect(function()
        local fps = tonumber(fpsBox.Text) or 60
        RunService:Set3dRenderingEnabled(true)
        -- Simulate FPS lock
        local lagConn
        lagConn = RunService.Heartbeat:Connect(function(dt)
            local target = 1/fps
            if dt < target then
                local s = os.clock()
                while os.clock()-s < target-dt do end
            end
        end)
        game:GetService("Debris"):AddItem(Instance.new("Folder"), 10) -- placeholder to stop
        notify("Lag executor running at "..fps.." fps")
    end)

    gap()
    lbl("Filter name:", C.text)
    local filterNameState = true
    local filterNameRow = Instance.new("Frame", scroll)
    filterNameRow.Size = UDim2.new(1,-10,0,30)
    filterNameRow.Position = UDim2.new(0,0,0,yOff)
    filterNameRow.BackgroundTransparency = 1
    yOff = yOff + 36

    local fnLabel = makeLabel(filterNameRow, "YES", UDim2.new(0,40,1,0), UDim2.new(0,0,0,5), C.green)
    local toggleBtn = makeButton(filterNameRow, "Toggle",
        UDim2.new(0,70,0,26), UDim2.new(0,48,0,2), C.btn, C.text)

    local hangFrame = Instance.new("Frame", scroll)
    hangFrame.Size = UDim2.new(1,-10,0,66)
    hangFrame.Position = UDim2.new(0,0,0,yOff)
    hangFrame.BackgroundTransparency = 1
    yOff = yOff + 70

    local hangLbl = makeLabel(hangFrame, "Set time hang-out:", UDim2.new(1,0,0,18), UDim2.new(0,0,0,0), C.subtext)
    hangLbl.TextSize = 12
    local hangBox = makeTextBox(hangFrame, "seconds", UDim2.new(1,0,0,28), UDim2.new(0,0,0,20))
    local execHangBtn = makeButton(scroll, "▶ Execute Hang-out",
        UDim2.new(0,160,0,30), UDim2.new(0,0,0,yOff), C.accent, Color3.new(1,1,1))
    yOff = yOff + 38

    toggleBtn.MouseButton1Click:Connect(function()
        filterNameState = not filterNameState
        fnLabel.Text = filterNameState and "YES" or "NO"
        fnLabel.TextColor3 = filterNameState and C.green or C.accent2
        hangFrame.Visible = filterNameState
        execHangBtn.Visible = filterNameState
    end)

    execHangBtn.MouseButton1Click:Connect(function()
        local t = tonumber(hangBox.Text) or 5
        notify("Hang-out executing for "..t.."s")
        local s = os.clock()
        while os.clock()-s < t do end
    end)

    gap()
    lbl("Set Camera XYZ to:", C.subtext)
    local camUserBox = makeTextBox(scroll, "%username", UDim2.new(1,-10,0,28), UDim2.new(0,0,0,yOff))
    yOff = yOff + 34
    lbl("XYZ Set Arguments:", C.subtext)
    local xyzBox = makeTextBox(scroll, "%X,Y,Z", UDim2.new(1,-10,0,28), UDim2.new(0,0,0,yOff))
    yOff = yOff + 34
    local execXYZBtn = makeButton(scroll, "▶ Execute XYZ",
        UDim2.new(0,140,0,30), UDim2.new(0,0,0,yOff), C.green, Color3.new(0,0,0))
    yOff = yOff + 38

    execXYZBtn.MouseButton1Click:Connect(function()
        local tName = camUserBox.Text
        local p = (tName == "%username" or tName == "me") and LocalPlayer or Players:FindFirstChild(tName)
        if p and p.Character then
            local coords = xyzBox.Text:match("^(.-)$")
            local x,y,z = coords:match("([^,]+),([^,]+),([^,]+)")
            x,y,z = tonumber(x),tonumber(y),tonumber(z)
            if x and y and z then
                workspace.CurrentCamera.CFrame = CFrame.new(x,y,z)
                notify("Camera moved to "..x..","..y..","..z)
            end
        end
    end)

    scroll.CanvasSize = UDim2.new(0,0,0, yOff+20)
end

-- ─────────────────────────────────────────────────────────────────
--  Command parser
-- ─────────────────────────────────────────────────────────────────
local function parseAndRun(raw)
    local parts = {}
    for w in raw:gmatch("%S+") do parts[#parts+1] = w end
    if #parts == 0 then return end

    local cmd = parts[1]:lower()
    local a1 = parts[2] or ""
    local a2 = parts[3] or ""
    local rest = table.concat(parts, " ", 2)
    local rest2 = table.concat(parts, " ", 3)

    if cmd == "!fling"            then cmdFling(a1)
    elseif cmd == "!kill"         then cmdKill(a1)
    elseif cmd == "!lag"          then cmdLag(a1)
    elseif cmd == "!kick"         then cmdKick(a1)
    elseif cmd == "!ban"          then cmdBan(a1)
    elseif cmd == "!bring"        then cmdBring(a1)
    elseif cmd == "!fire"         then cmdFire(a1)
    elseif cmd == "!dinofy"       then cmdDinofy(a1)
    elseif cmd == "!setlimitflag" then
        limitFlag = a1
        notify("Limit flag set to: "..a1)
    elseif cmd == "!unsetlimitflag" then
        limitFlag = nil
        notify("Limit flag cleared.")
    elseif cmd == "!listnamespamspeed" then
        listNameSpamSpeed = tonumber(a1) or 1
        notify("ListNameSpam speed: "..listNameSpamSpeed)
    elseif cmd == "!listnamespam" then
        cmdListNameSpam(rest)
    elseif cmd == "!day"          then cmdDay();  notify("Day set.")
    elseif cmd == "!night"        then cmdNight();notify("Night set.")
    elseif cmd == "!pixel"        then cmdPixel(a1)
    elseif cmd == "!customexecutor" then openCustomExecutor()
    elseif cmd == "!customlagexecutor" then openLagExecutor()
    elseif cmd == "!connectdatastore" then
        dataStoreConnected = true
        notify("DataStore connected. Ban system active.")
    elseif cmd == "!jail"         then cmdJail(a1)
    elseif cmd == "!unjail"       then cmdUnjail(a1)
    elseif cmd == "!ice"          then cmdIce(a1)
    elseif cmd == "!unice"        then cmdUnice(a1)
    elseif cmd == "!freeze"       then cmdFreeze(a1)
    elseif cmd == "!unfreeze"     then cmdUnfreeze(a1)
    elseif cmd == "!anchor"       then cmdAnchor(a1)
    elseif cmd == "!unanchor"     then cmdUnanchor(a1)
    elseif cmd == "!setbodycolorrgb"   then cmdSetBodyColorRGB(a1)
    elseif cmd == "!unsetbodycolorrgb" then cmdUnsetBodyColorRGB(a1)
    elseif cmd == "!spamspeed"    then
        spamSpeed = tonumber(a1) or 1
        notify("Spam speed: "..spamSpeed)
    elseif cmd == "!spam"         then cmdSpam(rest)
    elseif cmd == "!unspam"       then cmdUnspam(rest)
    elseif cmd == "!whisper"      then cmdWhisper(a1, rest2)
    elseif cmd == "!pmspamspeed"  then
        pmSpamSpeed = tonumber(a1) or 1
        notify("PM spam speed: "..pmSpamSpeed)
    elseif cmd == "!pmspam"       then cmdPmSpam(a1, rest2)
    elseif cmd == "!unpmspam"     then cmdUnpmSpam(a1)
    else
        notify("Unknown command: "..cmd)
    end
end

sendBtn.MouseButton1Click:Connect(function()
    local text = cmdInput.Text
    if text and text ~= "" then
        parseAndRun(text)
        cmdInput.Text = ""
    end
end)

cmdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = cmdInput.Text
        if text and text ~= "" then
            parseAndRun(text)
            cmdInput.Text = ""
        end
    end
end)

-- ─────────────────────────────────────────────────────────────────
--  Toggle button (minimise)
-- ─────────────────────────────────────────────────────────────────
local toggleFrame = Instance.new("Frame", ScreenGui)
toggleFrame.Size = UDim2.new(0,140,0,34)
toggleFrame.Position = UDim2.new(0,10,0,10)
toggleFrame.BackgroundColor3 = C.panel
toggleFrame.BorderSizePixel = 0
toggleFrame.Active = true
toggleFrame.Draggable = true
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0,8)
addStroke(toggleFrame, C.accent, 1)

local toggleBtn2 = makeButton(toggleFrame, "⚙ Admin Hub",
    UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.panel, C.accent)
toggleBtn2.Font = Enum.Font.GothamBold
toggleBtn2.TextSize = 13

toggleBtn2.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ─────────────────────────────────────────────────────────────────
notify("Owner Admin Hub V1 loaded! Press ⚙ Admin Hub to open.")
