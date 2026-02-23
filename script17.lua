-- Chat Configuration Hub V1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variables
local spamming = false
local spamMessage = ""
local spamSpeed = 1
local pmSpamming = {}
local pmSpamSpeed = 1
local jailed = {}
local iced = {}
local frozen = {}
local anchored = {}
local checkpoint = nil
local f3xEnabled = false
local jetpackEnabled = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatConfigHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.Text = "Chat Configuration Hub V1"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local compileBtn = Instance.new("TextButton")
compileBtn.Size = UDim2.new(0.9, 0, 0, 25)
compileBtn.Position = UDim2.new(0.05, 0, 0, 35)
compileBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
compileBtn.Text = "[ CC Compile ]"
compileBtn.TextColor3 = Color3.new(0, 1, 0)
compileBtn.Parent = mainFrame

local showCodeBtn = Instance.new("TextButton")
showCodeBtn.Size = UDim2.new(0.9, 0, 0, 25)
showCodeBtn.Position = UDim2.new(0.05, 0, 0, 65)
showCodeBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
showCodeBtn.Text = "[ Show current lua code ]"
showCodeBtn.TextColor3 = Color3.new(1, 1, 0)
showCodeBtn.Parent = mainFrame

local unshowBtn = Instance.new("TextButton")
unshowBtn.Size = UDim2.new(0.44, 0, 0, 25)
unshowBtn.Position = UDim2.new(0.05, 0, 0, 95)
unshowBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
unshowBtn.Text = "[ Un-show ]"
unshowBtn.TextColor3 = Color3.new(1, 0.5, 0)
unshowBtn.Parent = mainFrame

local deleteCacheBtn = Instance.new("TextButton")
deleteCacheBtn.Size = UDim2.new(0.44, 0, 0, 25)
deleteCacheBtn.Position = UDim2.new(0.51, 0, 0, 95)
deleteCacheBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
deleteCacheBtn.Text = "[ Delete Cache ]"
deleteCacheBtn.TextColor3 = Color3.new(1, 0, 0)
deleteCacheBtn.Parent = mainFrame

local deleteRootBtn = Instance.new("TextButton")
deleteRootBtn.Size = UDim2.new(0.9, 0, 0, 25)
deleteRootBtn.Position = UDim2.new(0.05, 0, 0, 125)
deleteRootBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
deleteRootBtn.Text = "[ Delete Root ]"
deleteRootBtn.TextColor3 = Color3.new(1, 0, 0)
deleteRootBtn.Parent = mainFrame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, 0, 0, 20)
resultLabel.Position = UDim2.new(0, 0, 1, 0)
resultLabel.BackgroundColor3 = Color3.new(0, 0, 0)
resultLabel.BackgroundTransparency = 0.5
resultLabel.Text = "Result:"
resultLabel.TextColor3 = Color3.new(1, 1, 1)
resultLabel.TextScaled = true
resultLabel.Parent = mainFrame

-- Functions
local function getTarget(targetName)
    if targetName == "me" then
        return player
    elseif targetName == "all" then
        return Players:GetPlayers()
    else
        local target = Players:FindFirstChild(targetName)
        return target
    end
end

local function showResult(text, isError)
    if isError then
        resultLabel.Text = "Result: Error. " .. text
        resultLabel.TextColor3 = Color3.new(1, 0, 0)
    else
        resultLabel.Text = "Result: " .. text
        resultLabel.TextColor3 = Color3.new(0, 1, 0)
    end
end

-- Command processing
local function processCommand(msg)
    local args = string.split(msg, " ")
    local cmd = args[1]:lower()
    
    if cmd == "!kill" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    plr.Character:BreakJoints()
                end
            else
                target.Character:BreakJoints()
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!kick" and args[2] then
        local target = getTarget(args[2])
        local reason = args[3] or "No reason"
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    plr:Kick(reason)
                end
            else
                target:Kick(reason)
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!ban" and args[2] then
        local target = getTarget(args[2])
        local reason = args[3] or "No reason"
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    plr:Ban(reason)
                end
            else
                target:Ban(reason)
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!spamspeed" and args[2] then
        spamSpeed = tonumber(args[2]) or 1
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!spam" and args[2] then
        spamMessage = table.concat(args, " ", 2)
        spamming = true
        coroutine.wrap(function()
            while spamming do
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMessage, "All")
                wait(1/spamSpeed)
            end
        end)()
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!unspam" then
        spamming = false
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!whisper" and args[2] and args[3] then
        local target = getTarget(args[2])
        local message = table.concat(args, " ", 3)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. target.Name .. " " .. message, "All")
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!pmspamspeed" and args[2] then
        pmSpamSpeed = tonumber(args[2]) or 1
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!pmspam" and args[2] and args[3] then
        local target = getTarget(args[2])
        local message = table.concat(args, " ", 3)
        if target then
            pmSpamming[target] = message
            coroutine.wrap(function()
                while pmSpamming[target] do
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. target.Name .. " " .. pmSpamming[target], "All")
                    wait(1/pmSpamSpeed)
                end
            end)()
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!unpmspam" and args[2] then
        local target = getTarget(args[2])
        if target then
            pmSpamming[target] = nil
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!jail" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    jailed[plr] = true
                end
            else
                jailed[target] = true
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!unjail" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    jailed[plr] = nil
                end
            else
                jailed[target] = nil
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!ice" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    iced[plr] = true
                end
            else
                iced[target] = true
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!unice" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    iced[plr] = nil
                end
            else
                iced[target] = nil
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!freeze" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    frozen[plr] = true
                end
            else
                frozen[target] = true
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!unfreeze" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    frozen[plr] = nil
                end
            else
                frozen[target] = nil
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!anchor" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    anchored[plr] = true
                end
            else
                anchored[target] = true
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!unanchor" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    anchored[plr] = nil
                end
            else
                anchored[target] = nil
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!day" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!night" then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.GlobalShadows = true
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!f3x" then
        if not f3xEnabled then
            local tool = Instance.new("Tool")
            tool.Name = "Building Tools"
            tool.RequiresHandle = false
            tool.Parent = player.Backpack
            
            local f3xScript = Instance.new("LocalScript")
            f3xScript.Source = [[
                -- F3X Building Tools
                local Tool = script.Parent
                local player = game.Players.LocalPlayer
                local mouse = player:GetMouse()
                
                Tool.Equipped:Connect(function()
                    print("F3X Tools Equipped")
                end)
            ]]
            f3xScript.Parent = tool
            f3xEnabled = true
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!jetpack" then
        if not jetpackEnabled then
            local jetpack = Instance.new("Tool")
            jetpack.Name = "Jetpack"
            jetpack.RequiresHandle = false
            jetpack.Parent = player.Backpack
            
            local jetpackScript = Instance.new("LocalScript")
            jetpackScript.Source = [[
                local Tool = script.Parent
                local player = game.Players.LocalPlayer
                local fuel = 100
                local maxFuel = 100
                
                Tool.Equipped:Connect(function()
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyVelocity.Parent = player.Character.HumanoidRootPart
                    
                    game:GetService("RunService").Heartbeat:Connect(function()
                        if fuel > 0 and player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                            fuel = fuel - 0.5
                        elseif fuel <= 0 then
                            bodyVelocity:Destroy()
                        end
                    end)
                    
                    while true do
                        wait(1)
                        if fuel < maxFuel then
                            fuel = fuel + 10
                        end
                    end
                end)
            ]]
            jetpackScript.Parent = jetpack
            jetpackEnabled = true
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!did" and args[2] then
        local action = table.concat(args, " ", 2)
        loadstring(action)()
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!speed" and args[2] and args[3] then
        local target = getTarget(args[2])
        local speed = tonumber(args[3]) or 16
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid.WalkSpeed = speed
                    end
                end
            else
                if target.Character and target.Character:FindFirstChild("Humanoid") then
                    target.Character.Humanoid.WalkSpeed = speed
                end
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!jumppower" and args[2] and args[3] then
        local target = getTarget(args[2])
        local power = tonumber(args[3]) or 50
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid.JumpPower = power
                    end
                end
            else
                if target.Character and target.Character:FindFirstChild("Humanoid") then
                    target.Character.Humanoid.JumpPower = power
                end
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!respawn" and args[2] then
        local target = getTarget(args[2])
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    plr:LoadCharacter()
                end
            else
                target:LoadCharacter()
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!checkpoint" then
        checkpoint = player.Character.HumanoidRootPart.Position
        player:WaitForChild("Character"):WaitForChild("Humanoid").Died:Connect(function()
            wait(1)
            player.Character:SetPrimaryPartCFrame(CFrame.new(checkpoint))
        end)
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!insert" and args[2] then
        local modelName = args[2]
        local success, model = pcall(function()
            return game:GetObjects("rbxassetid://" .. modelName)[1]
        end)
        
        if success and model then
            model.Parent = workspace
            model:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
            showResult("You compiled your chat configuration successfully!")
        else
            showResult("CC is not compiled.", true)
        end
        
    elseif cmd == "!jumpscare" and args[2] then
        local target = getTarget(args[2])
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local scareSound = Instance.new("Sound")
            scareSound.SoundId = "rbxassetid://9120386864"
            scareSound.Parent = target.Character.Head
            scareSound:Play()
            
            target.Character.Humanoid.CameraOffset = Vector3.new(0, 0, -5)
            wait(0.1)
            target.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!jump" and args[2] and args[3] then
        local target = getTarget(args[2])
        local amount = tonumber(args[3]) or 1
        if target then
            if type(target) == "table" then
                for _, plr in ipairs(target) do
                    for i = 1, amount do
                        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                            plr.Character.Humanoid.Jump = true
                            wait(0.1)
                        end
                    end
                end
            else
                for i = 1, amount do
                    if target.Character and target.Character:FindFirstChild("Humanoid") then
                        target.Character.Humanoid.Jump = true
                        wait(0.1)
                    end
                end
            end
            showResult("You compiled your chat configuration successfully!")
        end
        
    elseif cmd == "!deleteroot" or cmd == "!delroot" then
        if _G then
            _G = nil
        end
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!removeroot" or cmd == "!rmroot" then
        if shared then
            shared = nil
        end
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!sky" and args[2] then
        local bit = tonumber(args[2])
        if bit == 32 then
            Lighting.Sky = Instance.new("Sky")
            Lighting.Sky.SkyboxBk = "rbxassetid://159451345"
            Lighting.Sky.SkyboxDn = "rbxassetid://159451345"
            Lighting.Sky.SkyboxFt = "rbxassetid://159451345"
            Lighting.Sky.SkyboxLf = "rbxassetid://159451345"
            Lighting.Sky.SkyboxRt = "rbxassetid://159451345"
            Lighting.Sky.SkyboxUp = "rbxassetid://159451345"
        elseif bit == 64 then
            Lighting.Sky = Instance.new("Sky")
            Lighting.Sky.SkyboxBk = "rbxassetid://169627750"
            Lighting.Sky.SkyboxDn = "rbxassetid://169627750"
            Lighting.Sky.SkyboxFt = "rbxassetid://169627750"
            Lighting.Sky.SkyboxLf = "rbxassetid://169627750"
            Lighting.Sky.SkyboxRt = "rbxassetid://169627750"
            Lighting.Sky.SkyboxUp = "rbxassetid://169627750"
        end
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!pixel" and args[2] then
        local bit = tonumber(args[2])
        if bit == 32 then
            Lighting.ShadowSoftness = 0
            Lighting.Brightness = 0.5
            Lighting.GlobalShadows = false
        elseif bit == 64 then
            Lighting.ShadowSoftness = 0.5
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!restart" then
        TeleportService:Teleport(game.PlaceId, player)
        showResult("You compiled your chat configuration successfully!")
        
    elseif cmd == "!shutdown" then
        for _, plr in ipairs(Players:GetPlayers()) do
            plr:Kick("Server shutdown")
        end
        wait(1)
        game:Shutdown()
        showResult("You compiled your chat configuration successfully!")
    end
end

-- Chat connection
player.Chatted:Connect(function(msg)
    if msg:sub(1,1) == "!" then
        processCommand(msg)
    end
end)

-- Button functions
compileBtn.MouseButton1Click:Connect(function()
    showResult("You compiled your chat configuration successfully!")
end)

showCodeBtn.MouseButton1Click:Connect(function()
    local codeFrame = Instance.new("Frame")
    codeFrame.Size = UDim2.new(1, 0, 0.8, 0)
    codeFrame.Position = UDim2.new(0, 0, 0, 0)
    codeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    codeFrame.BackgroundTransparency = 0.5
    codeFrame.Parent = screenGui
    
    local codeText = Instance.new("TextLabel")
    codeText.Size = UDim2.new(1, 0, 1, 0)
    codeText.BackgroundTransparency = 1
    codeText.Text = script.Source
    codeText.TextColor3 = Color3.new(0, 1, 0)
    codeText.TextScaled = true
    codeText.TextWrapped = true
    codeText.Parent = codeFrame
end)

unshowBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(screenGui:GetChildren()) do
        if v:IsA("Frame") and v ~= mainFrame then
            v:Destroy()
        end
    end
end)

deleteCacheBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Cache") then
            v:Destroy()
        end
    end
    showResult("Cache deleted!")
end)

deleteRootBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "Root" then
            v:Destroy()
        end
    end
    showResult("Root deleted!")
end)

-- Main loop
game:GetService("RunService").Heartbeat:Connect(function()
    -- Jail effect
    for plr, _ in pairs(jailed) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end
    
    -- Ice effect
    for plr, _ in pairs(iced) do
        if plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Ice
                    part.BrickColor = BrickColor.new("Cyan")
                end
            end
        end
    end
    
    -- Freeze effect
    for plr, _ in pairs(frozen) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Anchored = true
        end
    end
    
    -- Unfreeze effect
    for plr, _ in pairs(frozen) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Anchored = false
        end
    end
    
    -- Anchor effect
    for plr, _ in pairs(anchored) do
        if plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end
    end
    
    -- Unanchor effect
    for plr, _ in pairs(anchored) do
        if plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end
    end
end)
