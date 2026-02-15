local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 600)
Main.Position = UDim2.new(0.5, -225, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ADMIN OWNER ROBLOX GOD HUB V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
Title.Font = Enum.Font.GothamBold

local CategoryFrame = Instance.new("Frame", Main)
CategoryFrame.Size = UDim2.new(1, 0, 0, 40)
CategoryFrame.Position = UDim2.new(0, 0, 0, 45)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -95)
Content.Position = UDim2.new(0, 10, 0, 85)
Content.CanvasSize = UDim2.new(0, 0, 5, 0)
Content.BackgroundTransparency = 1
local List = Instance.new("UIListLayout", Content)
List.Padding = UDim.new(0, 10)

-- [ СИСТЕМА ПЕРЕКЛЮЧЕНИЯ КАТЕГОРИЙ ]
local function ClearContent()
    for _, v in pairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

local function CreateBtn(parent, name, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function CreateInput(parent, placeholder)
    local i = Instance.new("TextBox", parent)
    i.Size = UDim2.new(1, 0, 0, 30)
    i.PlaceholderText = placeholder
    i.Text = ""
    i.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    i.TextColor3 = Color3.new(1, 1, 1)
    return i
end

-- [ КАТЕГОРИЯ: ADMIN ]
local function OpenAdmin()
    ClearContent()
    local msgInput = CreateInput(Content, "Spam message...")
    CreateBtn(Content, "Spam", function() 
        _G.Spamming = true 
        task.spawn(function() while _G.Spamming do print(msgInput.Text) task.wait(0.5) end end)
    end)
    CreateBtn(Content, "Unspam", function() _G.Spamming = false end)
    
    local flyInput = CreateInput(Content, "Fly Speed...")
    CreateBtn(Content, "Fly", function() print("Flying at "..flyInput.Text) end)
    CreateBtn(Content, "Unfly", function() print("Unfly") end)
    CreateBtn(Content, "Show Hitboxes", function() end)
    CreateBtn(Content, "Hide Hitboxes", function() end)
end

-- [ КАТЕГОРИЯ: OWNER ]
local function OpenOwner()
    ClearContent()
    local user = CreateInput(Content, "Username...")
    local reason = CreateInput(Content, "Reason...")
    CreateBtn(Content, "Kill", function() end)
    CreateBtn(Content, "Kick", function() end)
    CreateBtn(Content, "Ban", function() end)
    CreateBtn(Content, "Set Time (Ban Duration)", function() print("Ban Window Opened") end)
    
    CreateBtn(Content, "Kill Server (Filter)", function() end)
    CreateBtn(Content, "Summon Bots To Server", function() end)
    CreateBtn(Content, "Clear Chat", function() end)
end

-- [ КАТЕГОРИЯ: ROBLOX ]
local function OpenRoblox()
    ClearContent()
    CreateBtn(Content, "BAN ALL ROBLOX ACCOUNTS (ACTIVE: 0)", function() 
        print("DATABASE HIJACK: Global Ban Wave Initiated...")
    end)
    CreateBtn(Content, "Make Yourself Verified (PERMANENT)", function()
        print("Injecting Verified Tag to API...")
    end)
    CreateBtn(Content, "Reply to Support Ticket", function() end)
end

-- [ КАТЕГОРИЯ: GOD ]
local function OpenGod()
    ClearContent()
    CreateBtn(Content, "Slowdown Roblox (VPN Req)", function() end)
    
    local country = Instance.new("TextButton", Content)
    country.Size = UDim2.new(1, 0, 0, 40)
    country.Text = "BAN ROBLOX IN COUNTRY: [Russia]"
    country.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    
    CreateBtn(Content, "BAN ROBLOX SERVICE (GLOBAL DELETE)", function()
        print("Wiping Roblox from Google Play/AppStore...")
    end)
end

-- Кнопки категорий
local b1 = CreateBtn(CategoryFrame, "Admin", OpenAdmin)
b1.Size = UDim2.new(0.25, 0, 1, 0)
local b2 = CreateBtn(CategoryFrame, "Owner", OpenOwner)
b2.Size = UDim2.new(0.25, 0, 1, 0) b2.Position = UDim2.new(0.25, 0, 0, 0)
local b3 = CreateBtn(CategoryFrame, "Roblox", OpenRoblox)
b3.Size = UDim2.new(0.25, 0, 1, 0) b3.Position = UDim2.new(0.5, 0, 0, 0)
local b4 = CreateBtn(CategoryFrame, "God", OpenGod)
b4.Size = UDim2.new(0.25, 0, 1, 0) b4.Position = UDim2.new(0.75, 0, 0, 0)

OpenAdmin() -- По умолчанию
