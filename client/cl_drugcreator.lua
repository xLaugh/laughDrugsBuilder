local isInZone = false
local currentAction = nil
local currentDrug = nil
local isHarvesting = false
local isProcessing = false
local lastActionTime = 0
local actionDelay = 2000 -- 2 secondes de délai entre chaque action

Citizen.CreateThread(function()
    for drugName, drugData in pairs(Config.Drugs) do
        -- Gestion des blips
        if drugData.Blip.Enabled then
            local harvestBlip = AddBlipForCoord(drugData.Harvest.Coords)
            SetBlipSprite(harvestBlip, drugData.Blip.Sprite)
            SetBlipColour(harvestBlip, drugData.Blip.Color)
            SetBlipScale(harvestBlip, drugData.Blip.Scale)
            SetBlipAsShortRange(harvestBlip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Récolte de ' .. drugName)
            EndTextCommandSetBlipName(harvestBlip)

            -- Traitement Blip
            local processingBlip = AddBlipForCoord(drugData.Processing.Coords)
            SetBlipSprite(processingBlip, drugData.Blip.Sprite)
            SetBlipColour(processingBlip, drugData.Blip.Color)
            SetBlipScale(processingBlip, drugData.Blip.Scale)
            SetBlipAsShortRange(processingBlip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Traitement de ' .. drugName)
            EndTextCommandSetBlipName(processingBlip)
        end
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        isInZone = false

        for drugName, drugData in pairs(Config.Drugs) do
            if #(coords - drugData.Harvest.Coords) < drugData.Harvest.Radius then
                isInZone = true
                currentAction = 'harvest'
                currentDrug = drugName
                if drugData.Harvest.Marker.Enabled then
                    DrawMarker(
                        drugData.Harvest.Marker.Type,
                        drugData.Harvest.Coords.x, drugData.Harvest.Coords.y, drugData.Harvest.Coords.z - 1.0,
                        0, 0, 0, 0, 0, 0,
                        drugData.Harvest.Radius * 2, drugData.Harvest.Radius * 2, 1.0,
                        drugData.Harvest.Marker.Color.r, drugData.Harvest.Marker.Color.g, drugData.Harvest.Marker.Color.b, drugData.Harvest.Marker.Color.a,
                        false, true, 2, nil, nil, false
                    )
                end

                if isHarvesting then
                    ESX.ShowHelpNotification(_('press_to_stop_harvest'))
                else
                    ESX.ShowHelpNotification(_('press_to_harvest'))
                end

                if IsControlJustReleased(0, 38) and (GetGameTimer() - lastActionTime) > actionDelay then -- Touche E avec délai anti-spam
                    lastActionTime = GetGameTimer()
                    if isHarvesting then
                        isHarvesting = false
                        ClearPedTasksImmediately(PlayerPedId()) -- Arrêter l'animation
                        ESX.ShowNotification(_('stopped_harvest'))
                    else
                        isHarvesting = true
                        Harvest(drugData)
                    end
                end
            elseif #(coords - drugData.Processing.Coords) < drugData.Processing.Radius then
                isInZone = true
                currentAction = 'process'
                currentDrug = drugName
                if drugData.Processing.Marker.Enabled then
                    DrawMarker(
                        drugData.Processing.Marker.Type,
                        drugData.Processing.Coords.x, drugData.Processing.Coords.y, drugData.Processing.Coords.z - 1.0,
                        0, 0, 0, 0, 0, 0,
                        drugData.Processing.Radius * 2, drugData.Processing.Radius * 2, 1.0,
                        drugData.Processing.Marker.Color.r, drugData.Processing.Marker.Color.g, drugData.Processing.Marker.Color.b, drugData.Processing.Marker.Color.a,
                        false, true, 2, nil, nil, false
                    )
                end

                if isProcessing then
                    ESX.ShowHelpNotification(_('press_to_stop_process'))
                else
                    ESX.ShowHelpNotification(_('press_to_process'))
                end

                if IsControlJustReleased(0, 38) and (GetGameTimer() - lastActionTime) > actionDelay then -- Touche E avec délai anti-spam
                    lastActionTime = GetGameTimer()
                    if isProcessing then
                        isProcessing = false
                        ClearPedTasksImmediately(PlayerPedId()) -- Arrêter l'animation
                        ESX.ShowNotification(_('stopped_processing'))
                    else
                        isProcessing = true
                        Process(drugData)
                    end
                end
            end
        end

        if not isInZone and (isHarvesting or isProcessing) then
            isHarvesting = false
            isProcessing = false
            ClearPedTasksImmediately(PlayerPedId())
            ESX.ShowNotification(_('stopped_harvest'))
            Citizen.Wait(500)
        end
    end
end)

function Harvest(drugData)
    ESX.TriggerServerCallback('my_drugscript:canHarvest', function(canHarvest)
        if canHarvest then
            TaskStartScenarioInPlace(PlayerPedId(), drugData.Harvest.Animation.Scenario, 0, true)

            Citizen.CreateThread(function()
                while isHarvesting do
                    Citizen.Wait(drugData.Harvest.Time * 1000)
                    if not isHarvesting then
                        ClearPedTasks(PlayerPedId())
                        break
                    end
                    ESX.TriggerServerCallback('my_drugscript:canHarvest', function(canStillHarvest)
                        if canStillHarvest then
                            TriggerServerEvent('my_drugscript:harvestItem', drugData.Harvest.Item)
                            ESX.ShowNotification(_('received_item', drugData.Harvest.Item))
                        else
                            ESX.ShowNotification(_('inventory_full'))
                            isHarvesting = false
                            ClearPedTasks(PlayerPedId())
                        end
                    end, drugData.Harvest.Item)
                end
            end)
        else
            ESX.ShowNotification(_('inventory_full'))
        end
    end, drugData.Harvest.Item)
end

function Process(drugData)
    ESX.TriggerServerCallback('my_drugscript:canProcess', function(canProcess)
        if canProcess then
            TaskStartScenarioInPlace(PlayerPedId(), drugData.Processing.Animation.Scenario, 0, true)

            Citizen.CreateThread(function()
                while isProcessing do
                    Citizen.Wait(drugData.Processing.Time * 1000)
                    if not isProcessing then
                        ClearPedTasks(PlayerPedId()) -- Arrêter l'animation doucement
                        break
                    end
                    TriggerServerEvent('my_drugscript:processItem', drugData.Processing.InputItem, drugData.Processing.OutputItem, drugData.Processing.InputAmount, drugData.Processing.OutputAmount)
                    ESX.ShowNotification(_('processed_item', drugData.Processing.InputAmount, drugData.Processing.InputItem, drugData.Processing.OutputAmount, drugData.Processing.OutputItem))
                end
            end)
        else
            ESX.ShowNotification(_('inventory_full'))
        end
    end, drugData.Processing.InputItem, drugData.Processing.InputAmount)
end

function CraftItem(recipe)
    if not Config.CraftEnabled then
        ESX.ShowNotification(_('craft_disabled'))
        return
    end

    ESX.TriggerServerCallback('my_drugscript:canCraft', function(canCraft)
        if canCraft then
            TaskStartScenarioInPlace(PlayerPedId(), Config.Craft.Animation, 0, true)
            Citizen.Wait(3000)
            TriggerServerEvent('my_drugscript:craftItem', recipe.MainItem, recipe.FinalItem)
            ClearPedTasks(PlayerPedId())
        else
            ESX.ShowNotification(_('not_enough_item'))
        end
    end, recipe.MainItem, Config.Craft.PouchItem)
end

RegisterNetEvent('my_drugscript:onUseMainItem')
AddEventHandler('my_drugscript:onUseMainItem', function(mainItem)
    for drugType, recipe in pairs(Config.Craft.Recipes) do
        if recipe.MainItem == mainItem then
            CraftItem(recipe)
        end
    end
end)