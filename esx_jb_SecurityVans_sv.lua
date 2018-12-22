ESX                = nil
local missionisactivated = false
local payOut = 10000
local societymoney = 10000

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--fonction qui donne argent
RegisterServerEvent('securityvans:recievemoney')
AddEventHandler('securityvans:recievemoney', function(payOut)

	local xPlayer = ESX.GetPlayerFromId(source)

	--xPlayer.addMoney(payOut)
	xPlayer.addAccountMoney('black_money', payOut)

	TriggerClientEvent('esx:showNotification', source, 'Vous avez reçu ' .. payOut)

end)
--Fin fonction qui donne argent

RegisterServerEvent('securityvans:recieveitem')
AddEventHandler('securityvans:recieveitem', function()
	print(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('bigmoneybag', 1)

	TriggerClientEvent('esx:showNotification', source, "Vous avez pris un gros sac d'argent de la brinks")

end)

RegisterServerEvent('securityvans:startmission')
AddEventHandler('securityvans:startmission', function()
	missionisactivated = true
end)

RegisterServerEvent('securityvans:sellbigmoneybag')
AddEventHandler('securityvans:sellbigmoneybag', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerItemCount = xPlayer.getInventoryItem('bigmoneybag').count
	if playerItemCount > 0 then
		xPlayer.removeInventoryItem('bigmoneybag', 1)
		xPlayer.addAccountMoney('black_money', payOut)
		TriggerClientEvent('esx:showNotification', source, "Vous avez vendu un gros sac d'argent de la brinks")
	else
		TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de gros sac d'argent sur vous")
	end
end)

RegisterServerEvent('securityvans:addsocietymoney')
AddEventHandler('securityvans:addsocietymoney', function()
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_brinks', function(account)
		societyAccount = account
	end)
	if societyAccount ~= nil then
		-- societyAccount.addMoney(societymoney)
		print('societé a reçu 10000')
	end
end)

RegisterServerEvent('securityvans:startscript')
AddEventHandler('securityvans:startscript', function()
	TriggerClientEvent('securityvans:ready', -1)
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if missionisactivated then
			Citizen.Wait(1830000)
			missionisactivated = false
		end
	end
end)


ESX.RegisterServerCallback('securityvans:checkmission', function(source, cb)
	cb(missionisactivated)
end)