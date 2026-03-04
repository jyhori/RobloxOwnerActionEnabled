-- Set Permission Hub V1.0
-- Universal executor support (Synapse X, KRNL, Fluxus, Scriptware, etc.)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Remove existing GUI if reinjected
if LocalPlayer.PlayerGui:FindFirstChild("SetPermissionHub") then
    LocalPlayer.PlayerGui.SetPermissionHub:Destroy()
end

-- State
local autoJumpActive = false
local autoShiftLockActive = false
local autoJumpInterval = 1
local autoJumpConnection = nil
local hdAdminRoles = {}
local kohlAdminRoles = {}
local grantedPermissions = {}

-- Detect admin systems
local function detectHDAdmin()
    local roles = {"NonAdmin", "VIP", "Moderator", "Admin", "HeadAdmin", "Owner"}
    local found = {}
    local hdAdmin = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdmin")
        or workspace:FindFirstChild("HDAdmin")
        or game:GetService("ServerStorage"):FindFirstChild("HDAdmin")

    if hdAdmin then
        local rolesFolder = hdAdmin:FindFirstChild("Roles") or hdAdmin:FindFirstChild("MainModule")
        if rolesFolder then
            for _, v in pairs(rolesFolder:GetDescendants()) do
                if v:IsA("StringValue") or v:IsA("IntValue") or v.ClassName == "ModuleScript" then
                    table.insert(found, v.Name)
                end
            end
        end
    end

    if #found == 0 then
        for _, role in pairs(roles) do
            table.insert(found, role)
        end
    end
    return found
end

local function detectKohlAdmin()
    local roles = {"Banned", "NonAdmin", "Guest", "Member", "Builder", "Mod", "Admin", "SuperAdmin", "Owner"}
    local found = {}
    local kohl = game:GetService("ReplicatedStorage"):FindFirstChild("KohlsAdmin")
        or game:GetService("ReplicatedStorage"):FindFirstChild("MainModule")
        or workspace:FindFirstChild("KohlsAdmin")

    if kohl then
        local settingsModule = kohl:FindFirstChild("Settings") or kohl:FindFirstChild("Ranks")
        if settingsModule then
            for _, v in pairs(settingsModule:GetDescendants()) do
                if v:IsA("StringValue") then
                    table.insert(found, v.Value)
                end
            end
        end
    end

    if #found == 0 then
        for _, role in pairs(roles) do
            table.insert(found, role)
        end
    end
    return found
end

hdAdminRoles = detectHDAdmin()
kohlAdminRoles = detectKohlAdmin()

-- Try to set HD Admin permission
local function setHDAdminPermission(role)
    local success = false
    pcall(function()
        local hdAdmin = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdmin")
        if hdAdmin then
            local remote = hdAdmin:FindFirstChildOfClass("RemoteFunction") or hdAdmin:FindFirstChildOfClass("RemoteEvent")
            if remote then
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer("SetRank", LocalPlayer, role)
                else
                    remote:FireServer("SetRank", LocalPlayer, role)
                end
                success = true
            end
        end
        -- Fallback: try common HD Admin remotes
        local remotes = {
            game:GetService("ReplicatedStorage"):FindFirstChild("HDAdminRemote"),
            game:GetService("ReplicatedStorage"):FindFirstChild("SetRank"),
            game:GetService("ReplicatedStorage"):FindFirstChild("AdminRemote"),
        }
        for _, r in pairs(remotes) do
            if r then
                pcall(function()
                    if r:IsA("RemoteFunction") then
                        r:InvokeServer(LocalPlayer, role)
                    else
                        r:FireServer(LocalPlayer, role)
                    end
                end)
                success = true
            end
        end
    end)
    grantedPermissions["HD:" .. role] = true
    return success
end

local function setKohlAdminPermission(role)
    local success = false
    pcall(function()
        local remotes = {
            game:GetService("ReplicatedStorage"):FindFirstChild("KohlsAdminRemote"),
            game:GetService("ReplicatedStorage"):FindFirstChild("SetRank"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Rank"),
        }
        for _, r in pairs(remotes) do
            if r then
                pcall(function()
                    if r:IsA("RemoteFunction") then
                        r:InvokeServer(LocalPlayer.Name, role)
                    else
                        r:FireServer(LocalPlayer.Name, role)
                    end
                end)
                success = true
            end
        end
    end)
    grantedPermissions["Kohl:" .. role] = true
    return success
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SetPermissionHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.DisplayOrder = 999 end)

local ok, err = pcall(function()
    ScreenGui.Parent = LocalPlayer.PlayerGui
end)
if not ok then
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Colors
local BG_COLOR = Color3.fromRGB(15, 15, 20)
local PANEL_COLOR = Color3.fromRGB(22, 22, 30)
local ACCENT = Color3.fromRGB(80, 120, 255)
local ACCENT2 = Color3.fromRGB(130, 60, 240)
local TEXT_COLOR = Color3.fromRGB(220, 220, 240)
local MUTED = Color3.fromRGB(110, 110, 140)
local DANGER = Color3.fromRGB(220, 60, 80)
local SUCCESS = Color3.fromRGB(60, 200, 120)
local BORDER = Color3.fromRGB(40, 40, 60)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 580)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = ACCENT
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Gradient overlay
local GradBG = Instance.new("Frame")
GradBG.Size = UDim2.new(1, 0, 0, 60)
GradBG.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
GradBG.BorderSizePixel = 0
GradBG.ZIndex = 0
GradBG.Parent = MainFrame

local GradCorner = Instance.new("UICorner")
GradCorner.CornerRadius = UDim.new(0, 12)
GradCorner.Parent = GradBG

local UIGrad = Instance.new("UIGradient")
UIGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(1, ACCENT2)
})
UIGrad.Rotation = 90
UIGrad.Parent = GradBG

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 0, 36)
TitleLabel.Position = UDim2.new(0, 14, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ Set Permission Hub V1.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2
TitleLabel.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.BackgroundColor3 = DANGER
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 3
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -70, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 3
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local contentFrame = MainFrame:FindFirstChild("ContentFrame")
    if contentFrame then
        contentFrame.Visible = not minimized
    end
    MainFrame.Size = minimized and UDim2.new(0, 420, 0, 52) or UDim2.new(0, 420, 0, 580)
end)

-- Note bar
local NoteBar = Instance.new("Frame")
NoteBar.Size = UDim2.new(1, -20, 0, 32)
NoteBar.Position = UDim2.new(0, 10, 0, 52)
NoteBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
NoteBar.BorderSizePixel = 0
NoteBar.Parent = MainFrame

local NoteCorner = Instance.new("UICorner")
NoteCorner.CornerRadius = UDim.new(0, 6)
NoteCorner.Parent = NoteBar

local NoteLabel = Instance.new("TextLabel")
NoteLabel.Size = UDim2.new(1, -10, 1, 0)
NoteLabel.Position = UDim2.new(0, 8, 0, 0)
NoteLabel.BackgroundTransparency = 1
NoteLabel.Text = "⚠  Permission set only for you! Valid in current place only."
NoteLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
NoteLabel.TextSize = 11
NoteLabel.Font = Enum.Font.Gotham
NoteLabel.TextXAlignment = Enum.TextXAlignment.Left
NoteLabel.Parent = NoteBar

-- Scrollable Content
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -10, 1, -92)
ContentFrame.Position = UDim2.new(0, 5, 0, 88)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = ACCENT
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 6)
ListLayout.Parent = ContentFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingLeft = UDim.new(0, 6)
ContentPad.PaddingRight = UDim.new(0, 6)
ContentPad.PaddingTop = UDim.new(0, 4)
ContentPad.Parent = ContentFrame

-- Helper: create section label
local function SectionLabel(text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = MUTED
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.Parent = ContentFrame
    return lbl
end

-- Helper: create role button
local function RoleButton(labelText, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = PANEL_COLOR
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.LayoutOrder = order
    btn.Parent = ContentFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = BORDER
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 10, 0.5, -4)
    dot.BackgroundColor3 = color or ACCENT
    dot.BorderSizePixel = 0
    dot.Parent = btn
    local dotC = Instance.new("UICorner")
    dotC.CornerRadius = UDim.new(1, 0)
    dotC.Parent = dot

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 26, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 60, 1, 0)
    statusLbl.Position = UDim2.new(1, -68, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = ""
    statusLbl.TextColor3 = SUCCESS
    statusLbl.TextSize = 11
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextXAlignment = Enum.TextXAlignment.Right
    statusLbl.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback(btn, statusLbl) end
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
        task.delay(0.2, function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = PANEL_COLOR}):Play()
        end)
    end)

    btn.MouseEnter:Connect(function()
        btnStroke.Color = color or ACCENT
        btnStroke.Transparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btnStroke.Color = BORDER
        btnStroke.Transparency = 0
    end)

    return btn, statusLbl
end

-- Helper: action button (wider, colored)
local function ActionButton(text, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or ACCENT
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = ContentFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback(btn) end
        local orig = btn.BackgroundColor3
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        task.delay(0.15, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = orig}):Play()
        end)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color:lerp(Color3.fromRGB(255,255,255), 0.15)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    end)

    return btn
end

-- Helper: toggle button row
local function ToggleRow(labelText, order, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = PANEL_COLOR
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = ContentFrame

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = BORDER
    rowStroke.Thickness = 1
    rowStroke.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = TEXT_COLOR
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 52, 0, 24)
    toggleBtn.Position = UDim2.new(1, -62, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = MUTED
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = row

    local tglCorner = Instance.new("UICorner")
    tglCorner.CornerRadius = UDim.new(0, 12)
    tglCorner.Parent = toggleBtn

    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            toggleBtn.BackgroundColor3 = SUCCESS
            toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            toggleBtn.TextColor3 = MUTED
            toggleBtn.Text = "OFF"
        end
        if onToggle then onToggle(toggled) end
    end)

    return row, toggleBtn
end

-- Helper: divider
local function Divider(order)
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, 0, 0, 1)
    div.BackgroundColor3 = BORDER
    div.BorderSizePixel = 0
    div.LayoutOrder = order
    div.Parent = ContentFrame
    return div
end

-- ===== SECTION: HD Admin Roles =====
local order = 1
SectionLabel("  HD ADMIN — SET PERMISSION BY ROLE", order) order = order + 1

local hdRoleColors = {
    NonAdmin = Color3.fromRGB(120, 120, 120),
    VIP      = Color3.fromRGB(80, 200, 255),
    Moderator= Color3.fromRGB(80, 200, 120),
    Admin    = Color3.fromRGB(80, 120, 255),
    HeadAdmin= Color3.fromRGB(200, 80, 255),
    Owner    = Color3.fromRGB(255, 180, 0),
}

for _, role in ipairs(hdAdminRoles) do
    local col = hdRoleColors[role] or ACCENT
    local displayText = "Set Permission to HD Admin by: " .. role
    if role == "Owner" then
        displayText = "👑 " .. displayText .. "  [Full Access: Kick/Ban/All]"
    end
    RoleButton(displayText, col, order, function(btn, statusLbl)
        local ok2 = setHDAdminPermission(role)
        statusLbl.Text = ok2 and "✓ Set" or "✓ Local"
        statusLbl.TextColor3 = SUCCESS
        task.delay(2.5, function() statusLbl.Text = "" end)
    end)
    order = order + 1
end

Divider(order) order = order + 1

-- ===== SECTION: Kohl's Admin Roles =====
SectionLabel("  KOHL'S ADMIN — SET PERMISSION BY ROLE", order) order = order + 1

local kohlRoleColors = {
    Banned     = DANGER,
    NonAdmin   = Color3.fromRGB(120, 120, 120),
    Guest      = Color3.fromRGB(160, 160, 180),
    Member     = Color3.fromRGB(80, 200, 255),
    Builder    = Color3.fromRGB(255, 160, 50),
    Mod        = Color3.fromRGB(80, 200, 120),
    Admin      = Color3.fromRGB(80, 120, 255),
    SuperAdmin = Color3.fromRGB(200, 80, 255),
    Owner      = Color3.fromRGB(255, 180, 0),
}

for _, role in ipairs(kohlAdminRoles) do
    local col = kohlRoleColors[role] or ACCENT2
    local displayText = "Set Permission to Kohl's Admin by: " .. role
    if role == "Owner" then
        displayText = "👑 " .. displayText .. "  [Full Access]"
    end
    RoleButton(displayText, col, order, function(btn, statusLbl)
        local ok2 = setKohlAdminPermission(role)
        statusLbl.Text = ok2 and "✓ Set" or "✓ Local"
        statusLbl.TextColor3 = SUCCESS
        task.delay(2.5, function() statusLbl.Text = "" end)
    end)
    order = order + 1
end

Divider(order) order = order + 1

-- ===== SECTION: Actions =====
SectionLabel("  ACTIONS", order) order = order + 1

ActionButton("🔄  Reset All Permissions", Color3.fromRGB(180, 50, 60), order, function()
    grantedPermissions = {}
    -- Attempt to reset server-side
    pcall(function()
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                pcall(function()
                    if r:IsA("RemoteEvent") then
                        r:FireServer("RemoveRank", LocalPlayer)
                    end
                end)
            end
        end
    end)
end)
order = order + 1

ActionButton("⚡  Compile All Permissions", ACCENT, order, function()
    -- Fire all detected remotes with highest role
    pcall(function()
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") then
                pcall(function() r:FireServer("SetRank", LocalPlayer, "Owner") end)
                pcall(function() r:FireServer(LocalPlayer.Name, "Owner") end)
                pcall(function() r:FireServer(LocalPlayer, "Owner") end)
            end
        end
    end)
    setHDAdminPermission("Owner")
    setKohlAdminPermission("Owner")
end)
order = order + 1

Divider(order) order = order + 1

-- ===== SECTION: Auto Jump =====
SectionLabel("  MOVEMENT TOOLS", order) order = order + 1

local jumpRow = Instance.new("Frame")
jumpRow.Size = UDim2.new(1, 0, 0, 36)
jumpRow.BackgroundColor3 = PANEL_COLOR
jumpRow.BorderSizePixel = 0
jumpRow.LayoutOrder = order
jumpRow.Parent = ContentFrame
order = order + 1

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 8)
jumpCorner.Parent = jumpRow

local jumpStroke = Instance.new("UIStroke")
jumpStroke.Color = BORDER
jumpStroke.Thickness = 1
jumpStroke.Parent = jumpRow

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 110, 1, 0)
jumpLabel.Position = UDim2.new(0, 10, 0, 0)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "🦘 Auto Jump"
jumpLabel.TextColor3 = TEXT_COLOR
jumpLabel.TextSize = 13
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = jumpRow

local jumpIntervalBox = Instance.new("TextBox")
jumpIntervalBox.Size = UDim2.new(0, 56, 0, 24)
jumpIntervalBox.Position = UDim2.new(0, 126, 0.5, -12)
jumpIntervalBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
jumpIntervalBox.BorderSizePixel = 0
jumpIntervalBox.Text = "1"
jumpIntervalBox.TextColor3 = TEXT_COLOR
jumpIntervalBox.TextSize = 12
jumpIntervalBox.Font = Enum.Font.GothamBold
jumpIntervalBox.PlaceholderText = "sec"
jumpIntervalBox.Parent = jumpRow

local jiCorner = Instance.new("UICorner")
jiCorner.CornerRadius = UDim.new(0, 6)
jiCorner.Parent = jumpIntervalBox

local jiStroke = Instance.new("UIStroke")
jiStroke.Color = ACCENT
jiStroke.Thickness = 1
jiStroke.Parent = jumpIntervalBox

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 52, 0, 24)
jumpToggle.Position = UDim2.new(1, -62, 0.5, -12)
jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
jumpToggle.BorderSizePixel = 0
jumpToggle.Text = "OFF"
jumpToggle.TextColor3 = MUTED
jumpToggle.TextSize = 11
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.Parent = jumpRow

local jtCorner = Instance.new("UICorner")
jtCorner.CornerRadius = UDim.new(0, 12)
jtCorner.Parent = jumpToggle

jumpToggle.MouseButton1Click:Connect(function()
    autoJumpActive = not autoJumpActive
    autoJumpInterval = tonumber(jumpIntervalBox.Text) or 1
    if autoJumpInterval <= 0 then autoJumpInterval = 0.05 end

    if autoJumpActive then
        jumpToggle.BackgroundColor3 = SUCCESS
        jumpToggle.TextColor3 = Color3.fromRGB(255,255,255)
        jumpToggle.Text = "ON"
        if autoJumpConnection then autoJumpConnection:Disconnect() end
        autoJumpConnection = task.spawn(function()
            while autoJumpActive do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                            hum.Jump = true
                        end
                    end
                end)
                task.wait(autoJumpInterval)
            end
        end)
    else
        jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        jumpToggle.TextColor3 = MUTED
        jumpToggle.Text = "OFF"
        autoJumpConnection = nil
    end
end)

-- Auto Shift Lock
local shiftRow, shiftToggle = ToggleRow("🔒 Auto Shift Lock (toggles ShiftLock rapidly)", order, function(on)
    autoShiftLockActive = on
    if on then
        task.spawn(function()
            while autoShiftLockActive do
                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam then
                        -- Try toggling shift lock mode
                        local success = pcall(function()
                            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        end)
                        task.wait(0.05)
                        pcall(function()
                            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        end)
                    end
                end)
                task.wait(0.05)
            end
        end)
    end
end)
order = order + 1

Divider(order) order = order + 1

-- ===== SECTION: Custom Keyboard =====
SectionLabel("  COMPILE CUSTOM KEYBOARD", order) order = order + 1

ActionButton("⌨️  Compile Custom Keyboard", ACCENT2, order, function()
    -- Create a draggable custom keyboard overlay
    if ScreenGui:FindFirstChild("KeyboardFrame") then
        ScreenGui.KeyboardFrame:Destroy()
        return
    end

    local KeyboardFrame = Instance.new("Frame")
    KeyboardFrame.Name = "KeyboardFrame"
    KeyboardFrame.Size = UDim2.new(0, 380, 0, 160)
    KeyboardFrame.Position = UDim2.new(0.5, -190, 1, -180)
    KeyboardFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    KeyboardFrame.BorderSizePixel = 0
    KeyboardFrame.Active = true
    KeyboardFrame.Draggable = true
    KeyboardFrame.ZIndex = 10
    KeyboardFrame.Parent = ScreenGui

    local kbCorner = Instance.new("UICorner")
    kbCorner.CornerRadius = UDim.new(0, 10)
    kbCorner.Parent = KeyboardFrame

    local kbStroke = Instance.new("UIStroke")
    kbStroke.Color = ACCENT2
    kbStroke.Thickness = 1.5
    kbStroke.Parent = KeyboardFrame

    local kbTitle = Instance.new("TextLabel")
    kbTitle.Size = UDim2.new(1, -30, 0, 24)
    kbTitle.Position = UDim2.new(0, 8, 0, 4)
    kbTitle.BackgroundTransparency = 1
    kbTitle.Text = "⌨  Custom Keyboard  (drag to move | click again to close)"
    kbTitle.TextColor3 = MUTED
    kbTitle.TextSize = 10
    kbTitle.Font = Enum.Font.Gotham
    kbTitle.TextXAlignment = Enum.TextXAlignment.Left
    kbTitle.ZIndex = 11
    kbTitle.Parent = KeyboardFrame

    local keys = {
        {"Q","W","E","R","T","Y","U","I","O","P"},
        {"A","S","D","F","G","H","J","K","L"},
        {"Z","X","C","V","B","N","M","Space"},
    }
    local keyActions = {
        Space = function()
            pcall(function()
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Jump = true end
            end)
        end
    }

    for rowIdx, row in ipairs(keys) do
        for colIdx, key in ipairs(row) do
            local kBtn = Instance.new("TextButton")
            local isSpace = key == "Space"
            kBtn.Size = isSpace and UDim2.new(0, 60, 0, 26) or UDim2.new(0, 30, 0, 26)
            kBtn.Position = UDim2.new(0, 8 + (colIdx - 1) * (isSpace and 34 or 32) + (rowIdx - 1) * 8, 0, 28 + (rowIdx - 1) * 32)
            kBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            kBtn.BorderSizePixel = 0
            kBtn.Text = key
            kBtn.TextColor3 = TEXT_COLOR
            kBtn.TextSize = 11
            kBtn.Font = Enum.Font.GothamBold
            kBtn.ZIndex = 11
            kBtn.Parent = KeyboardFrame

            local kCorner = Instance.new("UICorner")
            kCorner.CornerRadius = UDim.new(0, 5)
            kCorner.Parent = kBtn

            kBtn.MouseButton1Click:Connect(function()
                TweenService:Create(kBtn, TweenInfo.new(0.08), {BackgroundColor3 = ACCENT2}):Play()
                task.delay(0.12, function()
                    TweenService:Create(kBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35,35,55)}):Play()
                end)
                if keyActions[key] then
                    keyActions[key]()
                else
                    -- Simulate keypress via VirtualInputManager (executor feature)
                    pcall(function()
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, key, false, game)
                    end)
                end
            end)
        end
    end
end)
order = order + 1

-- Status bar at bottom
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 22)
StatusBar.Position = UDim2.new(0, 0, 1, -22)
StatusBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 12)
sbCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 8, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready  •  " .. LocalPlayer.Name .. "  •  " .. game.PlaceId
StatusLabel.TextColor3 = MUTED
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- Animate in
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()

print("[Set Permission Hub V1.0] Loaded for: " .. LocalPlayer.Name)
