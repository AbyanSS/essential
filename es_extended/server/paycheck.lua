ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent("pNotify:SendNotification", xPlayer.source, { text = _U('received_salary', salary), type = "success", queue = "lmao", timeout = 10000, layout = "bottomCenter"})
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)
	
									TriggerClientEvent("pNotify:SendNotification", xPlayer.source, { text = _U('received_salary', salary), type = "success", queue = "lmao", timeout = 10000, layout = "bottomCenter"})
								else
									TriggerClientEvent("pNotify:SendNotification", xPlayer.source, { text = _U('company_nomoney'), type = "success", queue = "lmao", timeout = 10000, layout = "bottomCenter"})
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent("pNotify:SendNotification", xPlayer.source, { text = _U('received_salary', salary), type = "success", queue = "lmao", timeout = 10000, layout = "bottomCenter"})
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent("pNotify:SendNotification", xPlayer.source, { text = _U('received_salary', salary), type = "success", queue = "lmao", timeout = 10000, layout = "bottomCenter"})
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end
