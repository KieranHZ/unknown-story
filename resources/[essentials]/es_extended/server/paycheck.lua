ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local salary = xPlayer.job.grade_salary

			if salary > 0 then
				if Config.EnableSocietyPayouts then
					-- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
						if society ~= nil then
							-- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
								if account.money >= salary then
									-- does the society money to pay its employees?
									TriggerEvent('esx_service:isInServicePayCheck', function(isInService)

										if isInService then
											xPlayer.addAccountMoney('bank', salary)
											account.removeMoney(salary)
											TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
										end
									end, xPlayer)
								else
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
								end
							end)
						end
					end)
				end
			end
		end
		xPlayers = nil
		SetTimeout(Config.PaycheckInterval, payCheck)
	end
	SetTimeout(Config.PaycheckInterval, payCheck)
end
