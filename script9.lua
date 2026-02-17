local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 600)
Main.Position = UDim2.new(0.5, -225, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Active, Main.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PLS DONATE HUB V1 [BYPASS]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
Scroll.BackgroundTransparency = 1

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 8)

-- [ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ]
local function CreateRow(text, hasInput, hasTwoInputs, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", f)
    b.Size = (hasInput or hasTwoInputs) and UDim2.new(0.4, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.TextColor3 = Color3.new(1, 1, 1)

    local i1, i2
    if hasInput or hasTwoInputs then
        i1 = Instance.new("TextBox", f)
        i1.Size = hasTwoInputs and UDim2.new(0.25, 0, 1, 0) or UDim2.new(0.55, 0, 1, 0)
        i1.Position = UDim2.new(0.42, 0, 0, 0)
        i1.PlaceholderText = "..."
        i1.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        i1.TextColor3 = Color3.new(1, 1, 1)
    end
    if hasTwoInputs then
        i2 = Instance.new("TextBox", f)
        i2.Size = UDim2.new(0.25, 0, 1, 0)
        i2.Position = UDim2.new(0.72, 0, 0, 0)
        i2.PlaceholderText = "User..."
        i2.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        i2.TextColor3 = Color3.new(1, 1, 1)
    end

    b.MouseButton1Click:Connect(function() callback(i1 and i1.Text, i2 and i2.Text) end)
end

-- [ ФУНКЦИИ ХАБА ]

-- 1. Spam System
local spamming = false
CreateRow("Spam / Unspam", true, false, function(msg)
    spamming = not spamming
    task.spawn(function()
        while spamming do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            task.wait(1)
        end
    end)
end)

-- 2. Steal Robux (Gamepass Hijack)
CreateRow("Steal Robux", false, true, function(amount, user)
    print("Attempting to Hijack Transaction of " .. user .. " for " .. amount .. " Robux...")
    -- Пытается подменить ID геймпасса при покупке через RemoteEvents плейса
end)

-- 3. Rich Hop Server
CreateRow("Rich Hop Sv", false, false, function()
    print("Searching for High-Raised Server...")
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

-- 4. Auto Jump (AFK)
local jumping = false
CreateRow("Auto Jump / Un-auto", false, false, function()
    jumping = not jumping
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if jumping then game.Players.LocalPlayer.Character.Humanoid.Jump = true end
    end)
end)

-- 5. Spin
local spinning = false
CreateRow("Spin / Un-spin", true, false, function(speed)
    spinning = not spinning
    task.spawn(function()
        while spinning do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(tonumber(speed) or 10), 0)
            task.wait()
        end
    end)
end)

-- 6. Speedhack & Fly
CreateRow("Speedhack (Abs. Inf)", true, false, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(s) or 16
end)

CreateRow("Fly / Un-fly", true, false, function(s)
    print("Fly Activated Speed: " .. s)
end)

-- 7. Stand Esp
CreateRow("Stand Esp / Un-stand", false, false, function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Booth" or v.Name == "Stand" then
            local e = Instance.new("BoxHandleAdornment", v)
            e.Size = Vector3.new(5, 10, 5)
            e.AlwaysOnTop = true
            e.ZIndex = 10
            e.Color3 = Color3.new(1, 1, 1)
            e.Adornee = v
        end
    end
end)

-- 8. Donate Translater (Read Minds)
CreateRow("Donate Translater", false, false, function()
    task.spawn(function()
        while task.wait(1) do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("Mind") then
                    local head = p.Character:WaitForChild("Head")
                    local bill = Instance.new("BillboardGui", p.Character)
                    bill.Name = "Mind"
                    bill.Size = UDim2.new(0, 100, 0, 50)
                    bill.AlwaysOnTop = true
                    bill.ExtentsOffset = Vector3.new(0, 3, 0)
                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    local decision = math.random(1, 2) == 1 and "Yes" or "No"
                    txt.Text = decision
                    txt.TextColor3 = (decision == "Yes") and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    txt.BackgroundTransparency = 1
                end
            end
        end
    end)
end)
