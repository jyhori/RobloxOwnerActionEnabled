-- Global Admin Script (Template)
-- Note: Real global effect requires Server-Side access or Backdoors.

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local spamming = true
local spamMessage = ""
local spamWait = 1
local chatColor = Color3.fromRGB(255, 255, 255)

local function findTarget(name)
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name:lower():sub(1, #name) == name then
            return v
        end
    end
end

LP.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()

    -- 1. !kick <player> <reason>
    if cmd == "!kick" then
        local target = findTarget(args[2])
        local reason = table.concat(args, " ", 3) or "No reason"
        if target then target:Kick("\nGlobal Kick: " .. reason) end

    -- 2. !ban <player> <reason>
    elseif cmd == "!ban" then
        local target = findTarget(args[2])
        if target then target:Kick("BANNED PERMANENTLY: " .. (table.concat(args, " ", 3) or "Violation")) end

    -- 3. !timeban <player> <reason> <time>
    elseif cmd == "!timeban" then
        local target = findTarget(args[2])
        if target then target:Kick("Timed Ban: " .. args[4] or "1h") end

    -- 4. !kill <player>
    elseif cmd == "!kill" then
        local target = findTarget(args[2])
        if target and target.Character then target.Character:BreakJoints() end

    -- 5. !jail <player>
    elseif cmd == "!jail" then
        local target = findTarget(args[2])
        if target and target.Character then
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(8, 10, 8)
            p.CFrame = target.Character.HumanoidRootPart.CFrame
            p.Transparency = 0.5
            p.Anchored = true
        end

    -- 6. !unjail <player>
    elseif cmd == "!unjail" then
        if workspace:FindFirstChild("Part") then workspace.Part:Destroy() end

    -- 7. !ice <player>
    elseif cmd == "!ice" then
        local target = findTarget(args[2])
        if target and target.Character then
            for _, v in pairs(target.Character:GetChildren()) do
                if v:IsA("BasePart") then v.Anchored = true v.Color = Color3.new(0, 1, 1) end
            end
        end

    -- 8. !unice <player>
    elseif cmd == "!unice" then
        local target = findTarget(args[2])
        if target and target.Character then
            for _, v in pairs(target.Character:GetChildren()) do
                if v:IsA("BasePart") then v.Anchored = false end
            end
        end

    -- 9. !size <player> <scale>
    elseif cmd == "!size" then
        local target = findTarget(args[2])
        local s = tonumber(args[3]) or 1
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:FindFirstChild("BodyHeightScale").Value = s
            hum:FindFirstChild("BodyWidthScale").Value = s
            hum:FindFirstChild("HeadScale").Value = s
        end

    -- 10. !spin <player> <speed>
    elseif cmd == "!spin" then
        local target = findTarget(args[2])
        local s = tonumber(args[3]) or 50
        local root = target.Character.HumanoidRootPart
        local bg = Instance.new("BodyAngularVelocity", root)
        bg.AngularVelocity = Vector3.new(0, s, 0)
        bg.MaxTorque = Vector3.new(0, math.huge, 0)

    -- 11. !jump <player> <amount>
    elseif cmd == "!jump" then
        local target = findTarget(args[2])
        if target and target.Character then
            target.Character:FindFirstChildOfClass("Humanoid").JumpPower = tonumber(args[3]) or 50
        end

    -- 12. !day
    elseif cmd == "!day" then
        Lighting.ClockTime = 14

    -- 13. !night
    elseif cmd == "!night" then
        Lighting.ClockTime = 0

    -- 14. !spamspeed <num>
    elseif cmd == "!spamspeed" then
        spamWait = tonumber(args[2]) or 1

    -- 15. !spam <msg>
    elseif cmd == "!spam" then
        spamming = true
        spamMessage = table.concat(args, " ", 2)
        task.spawn(function()
            while spamming do
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMessage, "All")
                task.wait(spamWait)
            end
        end)

    -- 16. !unspam
    elseif cmd == "!unspam" then
        spamming = false

    -- 17. !color <R> <G> <B> (Visual/Pseudo-Global)
    elseif cmd == "!color" then
        chatColor = Color3.fromRGB(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
        print("Chat Color set to: ", chatColor)
    end
end)
