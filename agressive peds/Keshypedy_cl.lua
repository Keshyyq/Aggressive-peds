Citizen.CreateThread(function()
    AddRelationshipGroup("terminator")
    local peds = {}
    AddStateBagChangeHandler("terminator", nil, function(name, _, weapon)
        Citizen.Wait(1000)
        local entity = GetEntityFromStateBagName(name)
        if entity == 0 then return end
        peds[name] = true
        while not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Citizen.Wait(10)
        end
        SetPedCombatAttributes(entity, 0, true)
        SetPedCombatAttributes(entity, 5, true) 
        SetPedCombatAttributes(entity, 46, true)
        SetPedFleeAttributes(entity, 0, true)
        SetPedRelationshipGroupHash(entity, `terminator`)
        SetRelationshipBetweenGroups(5, `terminator`, `player`)
        TaskCombatHatedTargetsAroundPed(entity, 100.0, 0)
        ClearPedTasks(entity)
        -- local has, wep = GetCurrentPedWeapon(entity)
        -- print(has, wep, weapon)
        -- if not has or wep~=weapon then
        --     GiveWeaponToPed(entity, weapon, 9999, false, true)
        --     Citizen.Wait(10)
        --     SetCurrentPedWeapon(entity, weapon, true)
        -- end
    end)

    AddEventHandler("gameEventTriggered", function(event, data)
        if event ~= "CEventNetworkEntityDamage"then
            return
        end
        local netId = NetworkGetNetworkIdFromEntity(data[1])
        if peds["entity:"..netId] and data[6]==1 then
            TriggerServerEvent("BabiczTerminator:killed", netId)
        end
    end)

    RegisterNetEvent("BabiczTerminator:stash", function(netId, id)
        if id then
            exports["ox_target"]:addEntity(netId, {
                {
                    label = "Zbadaj",
                    name = "terminator_inspect",
                    distance = 2,
                    onSelect = function()
                        exports["ox_inventory"]:openInventory("stash", id)
                    end
                }
            })
        else
            exports["ox_target"]:removeEntity(netId, "terminator_inspect")
        end
    end)
end)