ESX  = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

players = {}

RegisterServerEvent("esx_zombiesystem:newplayer")
AddEventHandler("esx_zombiesystem:newplayer", function(id)
    players[source] = id
    TriggerClientEvent("esx_zombiesystem:playerupdate", -1, players)
end)

AddEventHandler("playerDropped", function(reason)
    players[source] = nil
    TriggerClientEvent("esx_zombiesystem:clear", source)
    TriggerClientEvent("esx_zombiesystem:playerupdate", -1, players)
end)

AddEventHandler("onResourceStop", function()
	 TriggerClientEvent("esx_zombiesystem:clear", -1)
end)

RegisterServerEvent('esx_zombiesystem:moneyloot')
AddEventHandler('esx_zombiesystem:moneyloot', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local random = math.random(1, 20)
    xPlayer.addMoney(random)
    TriggerClientEvent("esx:showNotification", xPlayer.source, ('You found ~g~$' .. random .. ' dolars'))
end)

RegisterServerEvent('esx_zombiesystem:itemloot')
AddEventHandler('esx_zombiesystem:itemloot', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
	local random = math.random(1, 3)
    if xPlayer.canCarryItem(item, random) then
        xPlayer.addInventoryItem(item, random)
        TriggerClientEvent("esx:showNotification", xPlayer.source, ('You found ~y~' .. random .. 'x ~b~' .. item))
    else
        xPlayer.showNotification('You cannot pickup that because your inventory is full!')
    end
end)

entitys = {}

RegisterServerEvent("RegisterNewZombie")
AddEventHandler("RegisterNewZombie", function(entity)
	TriggerClientEvent("ZombieSync", -1, entity)
	table.insert(entitys, entity)
end)

ESX.RegisterCommand('giveammo', 'admin', function(xPlayer, args, showError)
    local playerPed = GetPlayerPed(args.playerId)

    currentWeapon = GetCurrentPedWeapon(playerPed, true)
 
    if currentWeapon ~= nil then
        local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon)
        local newAmmo = currentAmmo + args.count
        local maxAmmo = GetMaxAmmo(playerPed, currentWeapon)
        if newAmmo < maxAmmo then
            TaskReloadWeapon(playerPed)
            SetPedAmmo(playerPed, currentWeapon, newAmmo)
            
        else
            showError("Weapon player is holding already has max ammo.")
        end
    
    else
        showError("Player isn't holding a weapon.")
    end

end, true, {help = 'Give ammo to weapon player is holding in hands', validate = true, arguments = {
	{name = 'playerId', help = 'commandgeneric_playerid', type = 'player'},
	{name = 'count', help = 'command_giveitem_count', type = 'number'}
}})
