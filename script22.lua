local plr = game.Players.LocalPlayer
local plrs = game.Players
local frame = script.Parent.Parent
local playername = frame.PlayerName
local reason = frame.Reason

script.Parent.MouseButton1Down:connect(function()
    local plrKick = plrs:FindFirstChild(playername.Text)
    if plrKick then
        plrKick:Kick('Reason: '..reason.Text)
    else
        reason.Text = "Failed to kick player. Try again."
    end
end)
