-- ESX implementation for burglary script
ESX = nil

local genders = {
	-- only 2 genders exists deal with it
	[0] = "Homme",
	[1] = "Femme"
}

-- don't ask
local skinColors = {
	[0] = "Blanc",
	[1] = "Blanc",
	[2] = "Noir",
	[3] = "Noir",
	[4] = "Blanc",
	[5] = "Légèrement teinté",
	[6] = "Blanc",
	[7] = "Blanc",
	[8] = "Noir",
	[9] = "Légèrement teinté",
	[10] = "Blanc",
	[11] = "Blanc",
	[12] = "Blanc",
	[13] = "Blanc",
	[14] = "Noir",
	[15] = "Noir",
	[16] = "Blanc",
	[17] = "Blanc",
	[18] = "Blanc",
	[19] = "Noir",
	[20] = "Blanc",
	[21] = "Blanc",
	[22] = "Blanc",
	[23] = "Noir",
	[24] = "Noir",
	[25] = "Noir",
	[26] = "Noir",
	[27] = "Blanc",
	[28] = "Blanc",
	[29] = "Noir",
	[30] = "Noir",
	[31] = "Légèrement teinté",
	[32] = "Légèrement teinté",
	[33] = "Blanc",
	[34] = "Blanc",
	[35] = "Noir",
	[36] = "Noir",
	[37] = "Légèrement teinté",
	[38] = "Blanc",
	[39] = "Blanc",
	[40] = "Blanc",
	[41] = "Légèrement teinté",
	[42] = "Blanc",
	[43] = "Blanc",
	[44] = "Blanc",
	[45] = "Blanc"
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("burglary:money", function(sum, player)
	local xPlayer = ESX.GetPlayerFromId(player)
	
	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', sum)
	else
		xPlayer.addMoney(sum)
	end
end)

AddEventHandler("burglary:failed", function(house, coords, player, street)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.getJob().name == "police" and Config.AlertPolice then
			TriggerClientEvent("esx_burglary:police", xPlayers[i], coords, Config.BlipTime)
		end
	end
	
	-- discord webhook
	if Config.DiscordWebhook then
		-- get player who did burglary
		local xBurglar = ESX.GetPlayerFromId(player)
		
		-- request burglar skin for suspect description
		MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = xBurglar.identifier
		}, function(users)
			local user = users[1]
			if user.skin ~= nil then
				skin = json.decode(user.skin)
		
				-- the message
				local message = {
					"Cambriolage lancé", street, "\n",
					"```",
					"Skin du joueur: ", skinColors[skin.skin], " ", genders[skin.sex], "\n",
					"Rue:", street, " TP au: (", 
					coords.x, " ", coords.y, " ", coords.z,
					")",
					"```"
				}
				
				local headers = {
					["Content-Type"] = "application/json"
				}
				
				-- send message
				PerformHttpRequest(Config.WebhookUrl, function(err, text, headers) 
					if err >= 400 then
						print("Erreur Webhook mod " .. err)
					end
				end, "POST", json.encode({content = table.concat(message)}), headers)
			end
		end)
	end
end)

