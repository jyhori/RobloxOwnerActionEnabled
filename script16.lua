local function runAction(filterType, actionType)
    local players = game:GetService("Players")
    local me = players.LocalPlayer

    for _, plr in pairs(players:GetPlayers()) do
        local isTarget = false
        
        -- Логика фильтра
        if filterType == "Local" and plr == me then
            isTarget = true
        elseif filterType == "Global" then
            isTarget = true
        elseif filterType == "Except Me" and plr ~= me then
            isTarget = true
        end

        -- Выполнение действия
        if isTarget then
            if actionType == "Kick" then
                plr:Kick("Вы были исключены из сервера.")
            elseif actionType == "Kill" and plr.Character then
                plr.Character:BreakJoints() -- Убивает игрока
            end
        end
    end
end
