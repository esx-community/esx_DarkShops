ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Load item labels
Citizen.CreateThread(function()
	Citizen.Wait(5000)
	
	MySQL.Async.fetchAll(
	'SELECT * FROM items',
	{},
	function(result)
		for i=1, #result, 1 do
			ItemsLabels[result[i].name] = result[i].label
		end
	end)
end)

ESX.RegisterServerCallback('esx_dark:requestDBItems', function(source, cb)

	MySQL.Async.fetchAll(
	'SELECT * FROM darkshops',
	{},
	function(result)
		local darkItems  = {}
		for i=1, #result, 1 do
			if darkItems[result[i].name] == nil then
				darkItems[result[i].name] = {}
			end
			
			table.insert(darkItems[result[i].name], {
				name  = result[i].item,
				price = result[i].price,
				label = ItemsLabels[result[i].item]
			})
		end
		cb(darkItems)
	end)
end)

RegisterServerEvent('esx_dark:buyItem')
AddEventHandler('esx_dark:buyItem', function(itemName, price)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')

	if sourceItem.limit ~= -1 and (sourceItem.count + 1) > sourceItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
	
		if account.money >= price then
			xPlayer.removeAccountMoney('black_money', price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
		end
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
	end
end)