ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('my_drugscript:canHarvest', function(source, cb, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local item = xPlayer.getInventoryItem(itemName)
        if item and xPlayer.canCarryItem(itemName, 1) then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('my_drugscript:canProcess', function(source, cb, itemName, itemAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local item = xPlayer.getInventoryItem(itemName)
        if item and item.count >= itemAmount and xPlayer.canCarryItem(itemName, itemAmount) then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterNetEvent('my_drugscript:harvestItem')
AddEventHandler('my_drugscript:harvestItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.canCarryItem(itemName, 1) then
            xPlayer.addInventoryItem(itemName, 1)
        else
            TriggerClientEvent('esx:showNotification', source, _U('inventory_full_item', itemName))
        end
    end
end)

RegisterNetEvent('my_drugscript:processItem')
AddEventHandler('my_drugscript:processItem', function(inputItem, outputItem, inputAmount, outputAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getInventoryItem(inputItem).count >= inputAmount and xPlayer.canCarryItem(outputItem, outputAmount) then
            xPlayer.removeInventoryItem(inputItem, inputAmount)
            xPlayer.addInventoryItem(outputItem, outputAmount)
        else
            TriggerClientEvent('esx:showNotification', source, _U('not_enough_input', inputItem))
        end
    end
end)

-- Enregistrer tous les items principaux comme utilisables
for drugType, recipe in pairs(Config.Craft.Recipes) do
    ESX.RegisterUsableItem(recipe.MainItem, function(source)
        TriggerClientEvent('my_drugscript:onUseMainItem', source, recipe.MainItem)
    end)
end

-- Callback pour vérifier si le joueur peut crafter
ESX.RegisterServerCallback('my_drugscript:canCraft', function(source, cb, mainItem, pouchItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local mainItemCount = xPlayer.getInventoryItem(mainItem).count
        local pouchItemCount = xPlayer.getInventoryItem(pouchItem).count
        if mainItemCount >= 1 and pouchItemCount >= 1 then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

-- Événement pour effectuer le crafting
RegisterNetEvent('my_drugscript:craftItem')
AddEventHandler('my_drugscript:craftItem', function(mainItem, finalItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local mainItemCount = xPlayer.getInventoryItem(mainItem).count
        local pouchItemCount = xPlayer.getInventoryItem(Config.Craft.PouchItem).count
        if mainItemCount >= 1 and pouchItemCount >= 1 then
            xPlayer.removeInventoryItem(mainItem, 1)
            xPlayer.removeInventoryItem(Config.Craft.PouchItem, 1)
            xPlayer.addInventoryItem(finalItem, 1)
            TriggerClientEvent('esx:showNotification', source, _U('processed_item', 1, mainItem, 1, finalItem))
        else
            TriggerClientEvent('esx:showNotification', source, _U('not_enough_item'))
        end
    end
end)