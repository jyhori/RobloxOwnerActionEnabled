local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 700)
Main.Position = UDim2.new(0.5, -275, 0.5, -350)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.BorderSizePixel = 2
Main.Active, Main.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ADMIN OWNER ROBLOX GOD HUB V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
Title.Font = Enum.Font.GothamBold

local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(1, 0, 0, 40)
Nav.Position = UDim2.new(0, 0, 0, 45)
Nav.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -100)
Content.Position = UDim2.new(0, 10, 0, 95)
Content.CanvasSize = UDim2.new(0, 0, 10, 0)
Content.BackgroundTransparency = 1
local List = Instance.new("UIListLayout", Content)
List.Padding = UDim.new(0, 8)

local function Clear()
    for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
end

-- [ ГЕНЕРАТОР КНОПОК С ФУНКЦИОНАЛОМ ФИЛЬТРОВ ]
local function Action(name, hasInput, callback)
    local f = Instance.new("Frame", Content)
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", f)
    btn.Size = hasInput and UDim2.new(0.3, -5, 1, 0) or UDim2.new(0.5, -5, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)

    local inp
    if hasInput then
        inp = Instance.new("TextBox", f)
        inp.Size = UDim2.new(0.2, -5, 1, 0)
        inp.Position = UDim2.new(0.3, 0, 0, 0)
        inp.PlaceholderText = "..."
        inp.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        inp.TextColor3 = Color3.new(1, 1, 1)
    end

    local filter = Instance.new("TextButton", f)
    filter.Size = UDim2.new(0.5, 0, 1, 0)
    filter.Position = UDim2.new(0.5, 0, 0, 0)
    filter.Text = "Server >"
    filter.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    filter.TextColor3 = Color3.new(0, 1, 1)

    local modes = {"Local", "Last", "Server", "Except Me", "Global", "Global Roblox", "Global Roblox Service"}
    local cur = 3
    filter.MouseButton1Click:Connect(function()
        cur = cur + 1 if cur > #modes then cur = 1 end
        filter.Text = modes[cur] .. " >"
    end)

    btn.MouseButton1Click:Connect(function() callback(inp and inp.Text or nil, modes[cur]) end)
end

-- [ КАТЕГОРИИ ]
local function Admin()
    Clear()
    Action("Spam", true, function(v, m) _G.S = true while _G.S do print(v) task.wait(0.5) end end)
    Action("Unspam", false, function() _G.S = false end)
    Action("Show Hitboxes", false, function() end)
    Action("Fly", true, function(v) end)
    Action("Request Reference", false, function() end)
end

local function Owner()
    Clear()
    Action("Username", true, function() end)
    Action("Kill", false, function(v, m) end)
    Action("Ban + Set Time", false, function() end)
    Action("Set Time (Morning/Night)", false, function() end)
    Action("Clear Chat", false, function() end)
    Action("Kill Server", false, function() end)
    Action("Summon Hackers", false, function() end)
end

local function Roblox()
    Clear()
    Action("BAN ACCOUNT (ACTIVE: 0)", false, function() end)
    Action("Make Yourself Verified", false, function() end)
    Action("Ticket Support Reply", true, function() end)
end

local function God()
    Clear()
    Action("Slowdown Roblox", false, function() end)
    Action("Limit Roblox", false, function() end)
    Action("Ban Roblox Service", false, function() end)
    
    local countries = {"Russia", "USA", "UK", "Finland", "India", "Germany", "Brazil", "Spain"}
    for _, c in pairs(countries) do
        Action("Ban In " .. c, false, function() end)
    end
end

-- [ НАВИГАЦИЯ ]
local function Tab(n, p, f)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(0.25, 0, 1, 0)
    b.Position = UDim2.new(p, 0, 0, 0)
    b.Text = n
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(f)
end

Tab("Admin", 0, Admin)
Tab("Owner", 0.25, Owner)
Tab("Roblox", 0.5, Roblox)
Tab("God", 0.75, God)

Admin()
