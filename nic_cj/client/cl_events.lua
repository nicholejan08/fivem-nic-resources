
-- [EVENTS] **************************************************************

RegisterCommand('cj', function()
	local _source = source
    TriggerServerEvent('nic_cj:extractIdentifiers')
end)

RegisterNetEvent('nic_cj:recruit')
AddEventHandler('nic_cj:recruit', function(entity)
    local ped = PlayerPedId()
    local playerGroup = GetPedGroupIndex(ped)
    SetPedAsGroupMember(entity, playerGroup)
    SetPedAsGroupLeader(ped, playerGroup)
    SetPedCombatRange(entity, 2)
    local weapon = GetHashKey("weapon_pistol")
    GiveWeaponToPed(entity, weapon, 99, false, true)	
    SetPedCanSwitchWeapon(entity ,false)
    SetCurrentPedWeapon(entity, weapon, true)
    SetPedCombatAbility(entity, 2)
    SetPedCombatMovement(entity, 2)
    TaskCombatHatedTargetsAroundPed(entity, 12.0, 0)
    SetPedCombatAttributes(entity, 46, true)
    SetGroupFormation(entity, 7)
    -- SetPedConfigFlag(entity, 229, true)
    -- SetPedConfigFlag(entity, 294, true)
    -- SetPedConfigFlag(entity, 301, true)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
    PlayPedAmbientSpeechNative(entity, "GENERIC_HI", "SPEECH_PARAMS_FORCE", 1)

    local blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gang Member")
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, false)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            if enableSanAndreas then
                if IsEntityDead(entity) then
                    RemoveBlip(blip)
                end
            end
        end
    end)
end)

RegisterNUICallback('close', function()
    hideMobilePhone()
    SendNUIMessage({
        type = "HUD",
        display = false
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent('nic_cj:getIdentifier')
AddEventHandler('nic_cj:getIdentifier', function(val)
    local hash = GetEntityModel(ped)

    steamID = val

    for key, value in pairs(Config.Permissions) do
        if steamID == Config.Permissions[key] then
            permitted = true
        end
    end

    if permitted then
        if enableSanAndreas then
            deleteProps()
            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
            enableSanAndreas = false
            cancellAll()
        else
            if steamID == "steam:110000104b59124" then
                TriggerEvent('PlaySound:PlayOnOne', 'sa_startup', 0.5)
                changeModel("cj")
                local ped = PlayerPedId()
                enableSanAndreas = true
                
                SendNUIMessage({
                    type = "logo"
                })
                SetRadarZoom(10)
                DoScreenFadeOut()
                Wait(1000)
                DoScreenFadeIn(800)
            else
                cancellAll()
            end
        end
    end
end)