Citizen.CreateThread(function()
    local peds, killed = {}, {}
    local Spawn = function(index)
        local l = Config.Locations[index]
        Citizen.CreateThread(function()
            local ped = CreatePed(4, l.model, l.coords, true, true)
            while not DoesEntityExist(ped) do
                Citizen.Wait(10)
            end
            GiveWeaponToPed(ped, l.weapon, 9999, false, true)
            SetCurrentPedWeapon(ped, l.weapon, true)
            local state = Entity(ped)?.state
            if state then
                state:set("terminator", l.weapon, true)
            end
            local netId = NetworkGetNetworkIdFromEntity(ped)
            peds[netId] = index
        end)
    end
    for i=1, #Config.Locations, 1 do
        Spawn(i)
    end

    local ESX = exports["es_extended"]:getSharedObject()
    RegisterServerEvent("KeshyTerminator:killed", function(netId)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return end
        local index = netId and not killed[netId] and peds[netId]
        if not index then return end
        killed[netId] = true
        local l = Config.Locations[index]
        if l.priceForKill then
            xPlayer.addMoney(l.priceForKill)
        end
        if l.items then
            local items = {}
            for i=1, #l.items, 1 do
                items[i] = {l.items[i].name, math.random(l.items[i].min or 0, l.items[i].max or 0)}
            end
            local id = exports["ox_inventory"]:CreateTemporaryStash({
                label = "Trup",
                slots = 20,
                maxWeight = 20000,
                items = items
            })
            TriggerClientEvent("KeshyTerminator:stash", -1, netId, id)
        end
        Citizen.Wait(l.respawnTime or Config.defaultRespawnTime)
        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity ~= 0 then DeleteEntity(entity) end
        TriggerClientEvent("KeshyTerminator:stash", -1, netId)
        killed[netId], peds[netId] = nil, nil
        Spawn(index)
        collectgarbage()
    end)
end)