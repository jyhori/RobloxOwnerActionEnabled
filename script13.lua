-- СКРИПТ БАНАНО-ХАММЕРА v2.0 (Только для твоей игры!)
-- Положи это в ServerScriptService

local Players = game:GetService("Players")
local BanService = {} -- Тут мы будем хранить баны (в реальности нужно сохранять в DataStore)

-- Функция, которая выбрасывает игрока с юмором
local function funnyBan(playerToBan, adminPlayer)
	local banReason = "Тебя ударил бананом 🍌"
	
	-- Выбираем случайную причину для веселья
	local funnyReasons = {
		" за то, что не любит ананасы на пицце! 🍍",
		" за использование проводной мышки в 2026 году! 🖱️",
		" за слишком громкий смех! 😂",
		" за попытку скушать радугу! 🌈",
		" с криком 'НИЗЗЯЯЯ ТАК'! 💥"
	}
	
	local randomIndex = math.random(1, #funnyReasons)
	banReason = banReason .. funnyReasons[randomIndex]
	
	-- Кикаем игрока с сервера (в реальном бане нужно еще запрещать вход)
	playerToBan:Kick(banReason)
	
	-- Оповещаем всех в чате
	if adminPlayer then
		game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireClient(adminPlayer, "Игрок " .. playerToBan.Name .. " получил по шапке бананом!", "All")
	else
		print("Админ неопознан, но банан улетел в ", playerToBan.Name)
	end
end

-- Слушаем чат
local function onPlayerChat(player, message)
	if string.sub(message, 1, 4) == "!ban" then
		-- Проверяем, админ ли (тут нужна твоя логика, например проверка группы)
		-- Для веселья пока пропустим всех
		
		local targetName = string.sub(message, 6) -- Берем текст после "!ban "
		if targetName and targetName ~= "" then
			local targetPlayer = Players:FindFirstChild(targetName)
			if targetPlayer then
				funnyBan(targetPlayer, player)
			else
				-- Если игрок не найден
				game:GetService("ReplicatedStorage"):DefaultChatSystemChatEvents.SayMessageRequest:FireClient(player, "Игрок " .. targetName .. " не найден в матрице!", "All")
			end
		end
	end
end

-- Подключаем обработчик
for _, player in Players:GetPlayers() do
	player.Chatted:Connect(function(message) onPlayerChat(player, message) end)
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message) onPlayerChat(player, message) end)
end)

print("🍌 Банан-Хаммер активирован и ждет жертв!")
