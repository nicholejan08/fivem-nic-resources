
-- -- GLOBAL VARIABLES DECLARATION
-- ----------------------------------------------------------------------------------------------------

permitted = false

enableSanAndreas, buffed, crouched, superjump, rocketman, bubblecars, respawn, hesoyamCheat, silenced, uiHidden = false, false, false, false, false, false, false, false, false, false
cheatCount, weaponCount, currValue = 1, 0, 0
cheatCode = "HESOYAM"

pAnimDict = "amb@code_human_wander_texting@male@base"
phoneDict = "cellphone@"
phoneAnim = "cellphone_text_read_base"

activatedDict = "THERMAL_VISION_GOGGLES_ON_MASTER"
activatedSound = 0

deactivatedDict = "THERMAL_VISION_GOGGLES_OFF_MASTER"
deactivatedSound = 0

spraying = false

sprayIdleAnimDict = "anim@scripted@freemode@postertag@graffiti_spray@male@"
sprayIdleAnimName = "shake_can_male"

sprayStartAnimDict = "anim@scripted@freemode@postertag@graffiti_spray@male@"
sprayStartAnimName = "spray_can_var_01_male"

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["MMB"] = 348, ["LMB"] = 24, ["RMB"] = 25, ["MWUP"] = 15, ["MWDN"] = 14
}

-- [LOGICS] **************************************************************

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         local ped = PlayerPedId()

--         if enableSanAndreas then
            
--             if not IsEntityDead(ped) then
--                 local weapon = GetSelectedPedWeapon(ped)
--                 print(weapon)
--             end
--         end
--     end

-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         local ped = PlayerPedId()

--         if enableSanAndreas then
            
--             if not IsEntityDead(ped) then
--                 local range = 3.0
--                 local zone = GetZoneDevant(ped, range)
--                 local target = getClosestPed(zone, {})

--                 if DoesEntityExist(target) and target ~= ped then
--                     if HasEntityBeenDamagedByEntity(target, ped, 1) then
--                         local pos = GetEntityForwardVector(ped)
--                         local multiplier = 112.0
--                         ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
--                         Wait(500)
--                         ClearEntityLastDamageEntity(target)
--                     end
--                 end
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then

            SwitchTrainTrack(0, true) -- Setting the Main train track(s) around LS and towards Sandy Shores active
            SwitchTrainTrack(3, true) -- Setting the Metro tracks active
            SetTrainTrackSpawnFrequency(0, 120000) -- The Train spawn frequency set for the game engine
            SetTrainTrackSpawnFrequency(3, 120000) -- The Metro spawn frequency set for the game engine
            SetRandomTrains(true)

        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
        if enableSanAndreas then
            if IsBigmapActive() or IsRadarHidden() then
                if not uiHidden then
                    SendNUIMessage({
                        action = "hideUI"
                    })
                    uiHidden = true
                end
            elseif uiHidden then
                SendNUIMessage({
                    action = "displayUI"
                })
                uiHidden = false
            end
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(800)
        local ped = PlayerPedId()
        local ped = PlayerPedId()
        local hr = GetClockHours()
        local min = GetClockMinutes()
        local maxHp = GetPedMaxHealth(ped)
        local hp = GetEntityHealth(ped)
        local maxArmor = GetPlayerMaxArmour(PlayerId())
        local armor = GetPedArmour(ped)
        local money = GetPedMoney(ped)
        local weapon = GetSelectedPedWeapon(ped)
        local ammoTotal = GetAmmoInPedWeapon(ped, weapon)
        local bool, clip = GetAmmoInClip(ped, weapon)
        local maxClip = GetMaxAmmoInClip(ped, weapon, 1)
        local ammo = math.floor(ammoTotal - clip)

        if enableSanAndreas then
            if IsEntityDead(ped) then
                SendNUIMessage({
                    type = "UI",
                    minimap = true,
                    display = true,
                    silenced = silenced,
                    weapon = weapon,
                    hr = hr,
                    min = min,
                    maxHp = maxHp,
                    hp = hp,
                    maxArmor = maxArmor,
                    armor = armor,
                    money = money,
                    clip = clip,
                    maxClip = maxClip,
                    ammo = ammo,
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local hr = GetClockHours()
        local min = GetClockMinutes()
        local maxHp = GetPedMaxHealth(ped)
        local hp = GetEntityHealth(ped)
        local maxArmor = GetPlayerMaxArmour(PlayerId())
        local armor = GetPedArmour(ped)
        local money = GetPedMoney(ped)
        local weapon = GetSelectedPedWeapon(ped)
        local ammoTotal = GetAmmoInPedWeapon(ped, weapon)
        local bool, clip = GetAmmoInClip(ped, weapon)
        local maxClip = GetMaxAmmoInClip(ped, weapon, 1)
        local ammo = math.floor(ammoTotal - clip)

        if enableSanAndreas then

            if ammoTotal <= 1 then
                SetPedAmmo(ped, weapon, 99)
            end

            if ammo >= 99 then
                SetPedAmmo(ped, weapon, 99)
            end

            if hp > maxHp then
                hp = maxHp
            end

            if not IsPauseMenuActive() then

                if DoesEntityExist(sprayCan) then
                    weapon = "spray"
                end

                if not IsEntityDead(ped) then
                    SendNUIMessage({
                        type = "UI",
                        minimap = true,
                        display = true,
                        silenced = silenced,
                        weapon = weapon,
                        hr = hr,
                        min = min,
                        maxHp = maxHp,
                        hp = hp,
                        maxArmor = maxArmor,
                        armor = armor,
                        money = money,
                        clip = clip,
                        maxClip = maxClip,
                        ammo = ammo,
                    })
                end
            else
                SendNUIMessage({
                    type = "UI",
                    display = false
                })
            end
        else
            SendNUIMessage({
                type = "UI",
                display = false
            })

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then

            for key, value in pairs(Config.settings) do
                if value.enableRagdoll then
                    SetPedCanRagdoll(ped, true)
                else
                    SetPedCanRagdoll(ped, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if enableSanAndreas then
            SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
            DisableControlAction(0, Keys['TAB'], false)
            HudForceWeaponWheel(false)
            DisplayAmmoThisFrame(false)
            HideHudComponentThisFrame(19)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if enableSanAndreas then
            default()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then

            if not IsPedSwimming(ped) and not IsPedInCover(ped) and not IsEntityInAir(ped) and not IsPedRagdoll(ped) then
                if not DoesEntityExist(cellphone) then

                    if weaponCount ~= 1 then
                        DeleteEntity(sprayCan)
                        StopAnimTask(ped, sprayIdleAnimDict, sprayIdleAnimName, 4.0)
                    end

                    if weaponCount == 0 then
                        SetCurrentPedWeapon(ped, slot0, true)
                    elseif weaponCount == 1 then
                        if not DoesEntityExist(sprayCan) then
                            giveSprayCan()
                        end
                    elseif weaponCount == 2 then
                        SetCurrentPedWeapon(ped, slot1, true)
                    elseif weaponCount == 3 then
                        SetCurrentPedWeapon(ped, slot2, true)
                    elseif weaponCount == 4 then
                        SetCurrentPedWeapon(ped, slot3, true)
                    elseif weaponCount == 5 then
                        SetCurrentPedWeapon(ped, slot4, true)
                    elseif weaponCount == 6 then
                        SetCurrentPedWeapon(ped, slot5, true)
                    elseif weaponCount == 7 then
                        SetCurrentPedWeapon(ped, slot6, true)
                    elseif weaponCount == 8 then
                        SetCurrentPedWeapon(ped, slot7, true)
                    elseif weaponCount == 9 then
                        SetCurrentPedWeapon(ped, slot8, true)
                    elseif weaponCount == 10 then
                        SetCurrentPedWeapon(ped, slot9, true)
                    elseif weaponCount == 11 then
                        SetCurrentPedWeapon(ped, slot10, true)
                    elseif weaponCount == 12 then
                        SetCurrentPedWeapon(ped, slot11, true)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then

            loadAnim(sprayIdleAnimDict)
            loadAnim(sprayStartAnimDict)
            
            if DoesEntityExist(sprayCan) then
                if IsEntityAttachedToEntity(sprayCan, ped) then

                    if IsPedInAnyVehicle(ped, true) then
                        StopAnimTask(ped, sprayIdleAnimDict, sprayIdleAnimName, 4.0)
                        DeleteEntity(sprayCan)
                    end

                    if not IsPedRagdoll(ped) and not IsPedRunning(ped) and not IsPedSprinting(ped) and not IsPedFalling(ped) and not IsPedSwimming(ped) and not IsPedClimbing(ped) then
    
                        DisableControlAction(0, Keys["RMB"], true) 
                        DisablePlayerFiring(true)
    
                        if not spraying then
                            if not IsEntityPlayingAnim(ped, sprayIdleAnimDict, sprayIdleAnimName, 3) then
                                TaskPlayAnim(ped, sprayIdleAnimDict, sprayIdleAnimName, 2.0, 1.0, -1, 51, 0, true, 0, false, 0, false)
                            end
                        end
    
                        if IsControlJustPressed(0, Keys['E']) then
    
                            local rndR = math.random(0, 10)
                            local rndG = math.random(0, 10)
                            local rndB = math.random(0, 10)
    
                            sR = (rndR * 0.1)
                            sG = (rndG * 0.1)
                            sB = (rndB * 0.1)
    
                            spraying = true
                        end
                        
                        if IsControlJustReleased(0, Keys["E"]) then
                            DeleteEntity(sprayCan)
                            giveSprayCan()
                            spraying = false
                        end
                    else
                        DeleteEntity(sprayCan)
                        giveSprayCan()
                        spraying = false
                    end

                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local spraySize = 0.1
        local alpha = 1.0

        if enableSanAndreas then
            if spraying then
                showNonLoopParticleBone("core", "veh_respray_smoke", sprayCan, spraySize, 0, 0.0, 0.9, 0.0, alpha)
                Wait(200)
            else
                StopAnimTask(ped, sprayStartAnimDict, sprayStartAnimName, 4.0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then
            if spraying then

                if not IsEntityPlayingAnim(ped, sprayStartAnimDict, sprayStartAnimName, 3) then
                    TaskPlayAnim(ped, sprayStartAnimDict, sprayStartAnimName, 2.0, 1.0, -1, 51, 0, true, 0, false, 0, false)
                end
            else
                StopAnimTask(ped, sprayStartAnimDict, sprayStartAnimName, 4.0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if IsControlJustPressed(0, Keys['Z']) then
            if not DoesEntityExist(sprayCan) then
                giveSprayCan()
            else
                DisablePlayerFiring(false)
                StopAnimTask(ped, sprayIdleAnimDict, sprayIdleAnimName, 4.0)
                StopAnimTask(ped, sprayStartAnimDict, sprayStartAnimName, 4.0)
                DeleteEntity(sprayCan)
            end
            Wait(100)
        end

        if enableSanAndreas then

            if IsControlJustPressed(0, Keys['V']) then
                TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                Wait(500)
            end

            if IsPedSwimming(ped) then
                SetCurrentPedWeapon(ped, -1569615261, true)
            end

            if actionsFreeMoving(ped) then

                if IsControlJustPressed(0, Keys['MMB']) then
                    SetCurrentPedWeapon(ped, -1569615261, true)
                    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
                    if not DoesEntityExist(cellphone) then
                        equipMobilePhone()
                    else
                        hideMobilePhone()
                    end
                end
            end

            if DoesEntityExist(cellphone) then
                DeleteEntity(sprayCan)
                StopAnimTask(ped, sprayIdleAnimDict, sprayIdleAnimName, 4.0)
                SetCurrentPedWeapon(ped, -1569615261, true)

                if IsControlJustPressed(0, Keys['RMB']) then
                    hideMobilePhone()
                end

                if IsControlJustPressed(0, Keys["E"]) then

                    if cheatCount == 1 then
                        cheatCode = "HESOYAM"
        
                        SendNUIMessage({
                            type = "activate",
                        })
                        hesoyam()
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
        
                    elseif cheatCount == 2 then
                        cheatCode = "BUFFMEUP"
        
                        toggleMuscle()
                    elseif cheatCount == 3 then
                        cheatCode = "KANGAROO"
        
                        if not superjump then
                            SendNUIMessage({
                                type = "activate",
                            })
                            superjump = true
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        else
                            SendNUIMessage({
                                type = "deactivate",
                            })
                            superjump = false
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
                        end

                    elseif cheatCount == 4 then
                        cheatCode = "AIYPWZQP"
        
                        if not DoesEntityExist(parachute) then
                            SendNUIMessage({
                                type = "activate",
                            })
                            equipParachute()
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        else
                            SendNUIMessage({
                                type = "deactivate",
                            })
                            DeleteEntity(parachute)
                            RemoveWeaponFromPed(ped, GetHashKey("gadget_parachute"))
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
                        end
                    elseif cheatCount == 5 then
                        cheatCode = "ROCKETMAN"
        
                        if not DoesEntityExist(jetpack) then
                            SendNUIMessage({
                                type = "activate",
                            })
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                            rocketman = true
                            spawnJetpack()
                        else
                            rocketman = false
                            SendNUIMessage({
                                type = "deactivate",
                            })
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
                            DeleteEntity(jetpack)
                        end
                    elseif cheatCount == 6 then
                        cheatCode = "LXGIWYL"
        
                        SendNUIMessage({
                            type = "activate",
                        })
                        
                        RemoveAllPedWeapons(ped, 1)
                        equipTier1Weapons()
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 7 then
                        cheatCode = "PROFESSIONALSKIT "
        
                        SendNUIMessage({
                            type = "activate",
                        })
                        
                        RemoveAllPedWeapons(ped, 1)
                        equipTier2Weapons()
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 8 then
                        cheatCode = "UZUMYMW"
        
                        SendNUIMessage({
                            type = "activate",
                        })
                        
                        RemoveAllPedWeapons(ped, 1)
                        equipTier3Weapons()
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 9 then
                        cheatCode = "OHDUDE"
        
                        spawnVehicle(-42959138)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 10 then
                        cheatCode = "AIWPRTON"
        
                        spawnVehicle(782665360)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 11 then
                        cheatCode = "JUMPJET"
        
                        spawnVehicle(970385471)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 12 then
                        cheatCode = "MONSTERMASH"
        
                        spawnVehicle(-845961253)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 13 then
                        cheatCode = "FOURWHEELFUN"
        
                        spawnVehicle(-2128233223)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 14 then
                        cheatCode = "CELEBRITYSTATUS"
        
                        spawnVehicle(-1961627517)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 15 then
                        cheatCode = "VROCKPOKEY"
        
                        spawnVehicle(-915704871)
                        TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        
                    elseif cheatCount == 16 then
                        cheatCode = "BUBBLECARS"
        
                        if not bubblecars then
                            bubblecars = true
                            SendNUIMessage({
                                type = "activate",
                            })
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                        else
                            bubblecars = false
                            SendNUIMessage({
                                type = "deactivate",
                            })
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
                        end
                    end
                    hideMobilePhone()
                end
            end
            
            if not IsEntityPlayingAnim(ped, phoneDict, phoneAnim, 3) and DoesEntityExist(cellphone) then
                TaskPlayAnim(ped, phoneDict, phoneAnim, 2.0, 1.0, -1, 51, 0, true, 0, false, 0, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if enableSanAndreas then
            exports.spawnmanager:setAutoSpawn(false)

            if IsEntityDead(ped) or IsPedRagdoll(ped) then
                SendNUIMessage({
                    type = "HUD",
                    display = false
                })
                toggleCrosshair(false, nil)
            end
            if IsEntityDead(ped) then
                DeleteEntity(sprayCan)
                DeleteEntity(jetpack)
                if IsControlJustPressed(0, Keys['E']) then
                    local coords = GetEntityCoords(ped)
                    exports.spawnmanager:setAutoSpawn(true)
                    exports.spawnmanager:forceRespawn()
                end
            end 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

        if enableSanAndreas then
            if bubblecars then

                if IsPedInAnyVehicle(ped, false) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local vTarget = getClosestVehicle(coords)
                    local vCoords = GetEntityCoords(vTarget)

                    if HasEntityCollidedWithAnything(vehicle) then
                        if DoesEntityExist(vTarget) then
                            if IsEntityTouchingEntity(vehicle, vTarget) then
                                SetVehicleGravity(vTarget, false)
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then
            
            if not IsEntityDead(ped) then

                if IsPedRagdoll(ped) then
                    DeleteEntity(cellphone)
                        
                    SendNUIMessage({
                        type = "HUD",
                        display = false
                    })
                end

                if DoesEntityExist(parachute) then
                    local pBoneIndex = GetPedBoneIndex(ped, 24817)

                    if IsEntityAttachedToEntity(parachute, ped) then
                        GiveWeaponToPed(ped, GetHashKey("gadget_parachute"), 1, 0, 0)
                    else
                        AttachEntityToEntity(parachute, ped, pBoneIndex, 0.145, -0.16, 0.0, 0.0, -90.0, 180.0, false, false, false, false, 2, true)
                    end
                end

                if DoesEntityExist(cellphone) then
                    DisablePlayerFiring(PlayerId(), true)

                    if IsControlJustPressed(0, Keys['MWUP']) then
                        if cheatCount > 1 then
                            cheatCount = cheatCount - 1
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_nav_up', 1.0)
                        end
                        
                    elseif IsControlJustPressed(0, Keys['MWDN']) then
                        if cheatCount < 16 then
                            cheatCount = cheatCount + 1
                            TriggerEvent('PlaySound:PlayOnOne', 'sa_nav_down', 1.0)
                        end
                    end

                    if cheatCount == 1 then
                        cheatCode = "HESOYAM"
                    elseif cheatCount == 2 then
                        cheatCode = "BUFFMEUP"
                    elseif cheatCount == 3 then
                        cheatCode = "KANGAROO"
                    elseif cheatCount == 4 then
                        cheatCode = "AIYPWZQP"
                    elseif cheatCount == 5 then
                        cheatCode = "ROCKETMAN"
                    elseif cheatCount == 6 then
                        cheatCode = "LXGIWYL"
                    elseif cheatCount == 7 then
                        cheatCode = "PROFESSIONALSKIT"
                    elseif cheatCount == 8 then
                        cheatCode = "UZUMYMW"
                    elseif cheatCount == 9 then
                        cheatCode = "OHDUDE"
                    elseif cheatCount == 10 then
                        cheatCode = "AIWPRTON"
                    elseif cheatCount == 11 then
                        cheatCode = "JUMPJET"
                    elseif cheatCount == 12 then
                        cheatCode = "MONSTERMASH"
                    elseif cheatCount == 13 then
                        cheatCode = "FOURWHEELFUN"
                    elseif cheatCount == 14 then
                        cheatCode = "CELEBRITYSTATUS"
                    elseif cheatCount == 15 then
                        cheatCode = "VROCKPOKEY"
                    elseif cheatCount == 16 then
                        cheatCode = "BUBBLECARS"
                    end
                    
                    SendNUIMessage({
                        type = "cheat",
                        cheat = cheatCode
                    })
                    
                else
                    if not IsPlayerFreeAiming(PlayerId()) then
                        if IsControlJustPressed(0, Keys['MWUP']) then
                            if weaponCount > 0 then
                                weaponCount = weaponCount - 1
                            end
                            
                        elseif IsControlJustPressed(0, Keys['MWDN']) then
                            if weaponCount < 9 then
                                weaponCount = weaponCount + 1
                            end
                        end
                    end
                end

                if DoesEntityExist(jetpack) then
                    local jHealth = GetVehicleEngineHealth(jetpack)

                    if not IsPedInVehicle(ped, jetpack, false) then

                        if jHealth >= 1000 then
                            local jCoords = GetEntityCoords(jetpack)
                            DrawMarker(0, jCoords.x-0.2, jCoords.y, jCoords.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 177, 224, 4, 250, true, true, 2, false, nil, nil, false)
        
                            if IsEntityNearEntity(ped, jetpack, 0.5) and not IsPedRagdoll(ped) and actionsFreeMoving(ped) then
                                local heading = GetEntityHeading(ped)
    
                                spawnJetpack()
                                SetEntityHeading(ped, heading)
                            end
                        else
                            DeleteEntity(jetpack)
                        end
                    end
                end

                if DoesEntityExist(jetpack) then
                    
                    if not IsPedInVehicle(ped, jetpack, false) then
                        local coords = GetEntityCoords(ped)
                        local jCoords = GetEntityCoords(jetpack)
                        
                        SetEntityCoords(jetpack, jCoords.x, jCoords.y, coords.z)
                        PlaceObjectOnGroundProperly(jetpack)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableSanAndreas then
            
            if not IsEntityDead(ped) then

                if IsPlayerFreeAiming() or IsPlayerFreeAiming(PlayerId()) then
                    local weapon = GetSelectedPedWeapon(ped)
                    local weaponType = GetWeapontypeGroup(weapon)

                    if not IsPedInMeleeCombat(ped) and not IsPedRagdoll(ped) and not IsEntityDead(ped) and not IsPedInCover(ped, true) and not IsPedGoingIntoCover(ped) and not IsPedGettingUp(ped) and IsPedArmed(ped, 4 | 2) then
                        if weapon ~= 100416529 then
                            if weapon == -896051817 or weapon == -543458394 then
                                toggleCrosshair(true, "heavy")
                            elseif weapon == -2005140789 or weapon == 121503875 then
                                toggleCrosshair(true, "scope")
                            else
                                toggleCrosshair(true, "normal")
                            end
                        end
                    end
                else
                    toggleCrosshair(false, nil)
                end

                if not buffed then
                    SetPedComponentVariation(ped, 0, 0, 0, 0)
                    if not crouched then
                        setWalkStyle()
                    else
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                        SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                    end
                else
                    SetPedComponentVariation(ped, 0, 1, 0, 0)
                    if not crouched then
                        setWalkStyle()
                    else
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                        SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                    end
                end

                if superjump then
                    SetSuperJumpThisFrame(PlayerId())
                end

                ClearFocus()
                DetachCam(deathCam)
                RenderScriptCams(false, false, 0, 1, 0)
                DestroyCam(deathCam, false)

                DisableControlAction(0, Keys["LEFTCTRL"], true) 

                if (not IsPauseMenuActive()) then 
                    if IsDisabledControlJustPressed(0, Keys["LEFTCTRL"])  then 
                        RequestAnimSet("move_ped_crouched")
                        
                        while (not HasAnimSetLoaded("move_ped_crouched")) do 
                            Citizen.Wait(100)
                        end 
                        if crouched then
                            if not buffed then
                                setWalkStyle()
                            end
                            crouched = false
                        elseif not crouched then
                            SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                            SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                            crouched = true 
                        end
                    end
                end

                SendNUIMessage({
                    type = "wasted",
                    display = false
                })

            else
                SetCurrentPedWeapon(ped, -1569615261, true)

                if not IsCamRendering(deathCam) then

                    SendNUIMessage({
                        type = "wasted",
                        display = true
                    })

                    local coords = GetEntityCoords(ped)
                    deathCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0.0, 0.0, 0.0, 25.00, false, 0) 
                    AttachCamToPedBone(deathCam, ped, 0, 2.0, 2.0, 15.0, 0)
                    SetCamActive(deathCam, true)
                    PointCamAtEntity(deathCam, ped, 1, 1, 0, 1)
                    RenderScriptCams(true, false, 1, true, true)
                end

                deleteProps()
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if enableSanAndreas then
            local ped = PlayerPedId()
            local group = GetPedGroupIndex(ped)
            local coords = GetEntityCoords(ped)
            local range = 12.0
            local zone = GetZoneDevant(ped, range)
            local target = getClosestPed(zone, {})

            if not IsPedRagdoll(ped) and not IsEntityDead(ped) and not IsPedRagdoll(target) and not IsEntityDead(target) then
                if not IsPedAPlayer(target) then
                    local model = GetEntityModel(target)
                    if model == GetHashKey("g_m_y_ballaeast_01") or model == GetHashKey("g_m_y_ballaorig_01") or model == GetHashKey("g_m_y_ballasout_01") then
                        if GetPedGroupIndex(target) ~= group then
                            local tCoords = GetEntityCoords(target)

                            if IsEntityNearEntity(ped, target, 10.0) then
                                if IsPlayerFreeAimingAtEntity(PlayerId(), target) then
                                    if IsAimCamActive() then
                                        DrawMarker(0, tCoords.x, tCoords.y, tCoords.z+1.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 177, 224, 4, 250, true, true, 2, false, nil, nil, false)
                                        SendNUIMessage({
                                            type = "recruit",
                                            display = true
                                        })
                                        if IsControlJustPressed(0, Keys['E']) then
                                            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
                                            SendNUIMessage({
                                                type = "recruit",
                                                display = false
                                            })
                                            TriggerEvent("nic_cj:recruit", target)
                                        end
                                    else
                                        SendNUIMessage({
                                            type = "recruit",
                                            display = false
                                        })
                                    end
                                else
                                    SendNUIMessage({
                                        type = "recruit",
                                        display = false
                                    })
                                end
                            else
                                SendNUIMessage({
                                    type = "recruit",
                                    display = false
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end)