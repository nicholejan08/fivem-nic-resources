
-- -- GLOBAL VARIABLES DECLARATION
-- ----------------------------------------------------------------------------------------------------

local mocaptainModelHash = 500480915
local stealthModelHash = 1956691127
local nicaptainhModelHash = -1938959761
local enableCaptainAmericaPowers = false
local ragdoll = false
local shield, sBlip
local equippedCapshield = false
local equippedToBack = false
local shieldCovered = false
local equippedToHand = false
local shieldDropped = false
local charging = false
local steamID
local fallCount = 0

local thrown = false
local pedHit = false
local motorcycle = false
local fallCover = false
local rolling = false
local dropToPickup = false

local impaled = false
local impaledTarget
local NearestePed = nil
local drinking = false

ESX = nil

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["MMB"] = 348
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('nic_capshield:getIdentifier')
AddEventHandler('nic_capshield:getIdentifier', function(val)
    local hash = GetEntityModel(PlayerPedId())

    steamID = val

    -- print(steamID)

    -- if steamID == "steam:110000104b59124" then
        if hash == mocaptainModelHash or hash == stealthModelHash or hash == nicaptainhModelHash then
            if not enableCaptainAmericaPowers then
                PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 0)
                enableCaptainAmericaPowers = true
                equipShield()
            else
                removeShield()
                PlaySoundFrontend(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0)
                enableCaptainAmericaPowers = false
            end
        else
            -- print(hash)
            PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
            ShowNotification("You are not ~b~Worthy")
        end
    -- else
    --     print(steamID)
    --     print("PLAYER NOT AUTHORIZED")
    -- end
end)

RegisterCommand('capshield', function()
	local _source = source
    TriggerEvent('nic_capshield:getIdentifier')
end)

-- ******************************************************************



-- ******************************************************************

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        
        local ped = PlayerPedId()
        local pos = GetEntityForwardVector(shield)
        local dict = "scr_minigamegolf"
        local particleName = "scr_golf_ball_trail"
        local playersInArea, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        local multiplier = 0
        local mVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local vClass = GetVehicleClass(mVehicle)
        local vModel = GetEntityModel(mVehicle)
        local attachedToBackMotorcycle = false
        local boneIndex = 24817
        local pHeading = GetEntityHeading(ped)
        local inBedDicts2 = "missheat"
        local inBedAnims2 = "binoculars_loop"
        
        -- local hash = GetEntityModel(ped)
        -- print(hash)

        if enableCaptainAmericaPowers then
    
            default()

            for key, value in pairs(Config.settings) do
                multiplier = value.pedForceDamage
            end
            
            local pedCoords = GetEntityCoords(ped)
            local closestPed, closestPedDst = getClosestPed(pedCoords)

            if IsControlJustReleased(0, Keys['G']) then
                local currHealth = GetEntityHealth(ped)

                if currHealth < 200 then
                    if not IsPedRagdoll(ped) and not IsPedFalling(ped) and not IsEntityInAir(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) then
                        drinkSerum()
                    end
                end
            end

            if IsControlJustReleased(0, Keys['MMB']) then
                if IsEntityInAir(ped) then  
                    if not fallCover then   
                        if IsPedFalling(ped) then
                            if not IsPedRagdoll(ped) then
                                if not shieldCovered and not IsPedInMeleeCombat(PlayerPedId())  then
                                    if equippedToHand and not thrown then
                                        fallCover = true
                                        headCover()
                                    end
                                else
                                    local boneIndex = 57005
                                    local ped = PlayerPedId()
                                    SetEntityRotation(ped, 0.0, 0.0, 0.0, 1, true)
                                    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
                                    equipToHand()
                                end
                            end
                        end
                    end   
                else
                    if not rolling then
                        if not IsEntityInAir(ped) and not IsPedInAnyVehicle(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedSwimming(ped) then
                            if not shieldCovered then
                                if IsPedWalking(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
                                    combatRollForce()
                                end
                            end
                        end
                    end
                end
            end

            if IsEntityDead(PlayerPedId()) then
                SetPedCanRagdoll(ped, true)
                SetPedRagdollOnCollision(PlayerPedId(), false)
                SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
                removeShield()
            end

            if fallCover then
                DisableControlAction(0, 30, false)
                DisableControlAction(0, 33, false)
                DisableControlAction(0, 34, false)

                DisableControlAction(0, 47, false)
                DisableControlAction(0, 46, false)
                
                SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
                SetPedCanRagdoll(ped, false)

                if fallCount >= -60 then
                    fallCount = fallCount - 2
                end

                SetEntityRotation(ped, 0.0, 90.0, ((-90.0)-(fallCount)), 1, true)
                SetEntityHeading(ped, pHeading)
                
                local target, distance = closestPedOnEntity(shield)

                for key, value in pairs(Config.settings) do
                    if not IsPedAPlayer(target) then
                        if distance < 1.5 then
                            -- print(distance)d
                            if value.damagePeds then
                                if not pedHit then
                                    if not IsPedInAnyVehicle(target) then
                                        SetPedToRagdoll(target, 1000, -1, 0, true, true, true)
                                        ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
            
                                        applyDamage(target)
                                        pedHit = true
                                    end
                                end
                            end
                        end
                    end
                end

                if not IsPedFalling(ped) then
                    pedHit = false
                    StopAnimTask(ped, inBedDicts2, inBedAnims2, 8.0)

                    if shieldCovered and not charging then
    
                        for key, value in pairs(Config.settings) do
                            if value.smokeEffects then
                                showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", shield, 4.0) 
                            end
                        end

                        PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
                    end
                
                    local boneIndex = 57005
                    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
                    combatRoll()
                    equipToHand()

                    shieldCovered = false
                    fallCover = false
                    fallCount = 0
                    SetPedCanRagdoll(ped, true)
                end
            end
    
            if IsEntityAttachedToEntity(shield, PlayerPedId()) then
                thrown = false
            end

            if shieldCovered then
        
                local inBedDicts = "missheat"
                local inBedAnims = "binoculars_loop"

                if IsPedJumping(ped) then
                    if not fallCover then
                        local boneIndex = 57005
                        local ped = PlayerPedId()
                        AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
                        equipToHand()
                        shieldCovered = false
                    end
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 3) then       
                        TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, -1, 49, 0, false, false, false)
                    end
                end
                
            end

            if charging then
                local target, distance = closestPedOnEntity(shield)
                
                for key, value in pairs(Config.settings) do
                    if not IsPedAPlayer(target) then
                        if distance < 1.5 then
                            if value.damagePeds then
                                if not pedHit then
                                    if not IsPedInAnyVehicle(target) then
                                        SetPedToRagdoll(target, 1000, -1, 0, true, true, true)
                                        ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
            
                                        applyDamage(target)
                
                                        PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
                                        pedHit = true
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if thrown then
                local target, distance = closestPedOnEntity(shield)
                                
                for key, value in pairs(Config.settings) do
                    if not IsPedAPlayer(target) then
                        if distance < 1.5 then
                            if value.damagePeds then
                                if target ~= PlayerPedId() then
                                    if not pedHit then
                                        if not IsPedInAnyVehicle(target) then
                                            if IsEntityInAir(shield) then
                                                SetPedToRagdoll(target, 1000, -1, 0, true, true, true)
                                                PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
                                                ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
                    
                                                if not foundPlayers then
                                                    impale(target)
                                                    impaledTarget = target
                                                    applyDamage(target)
                        
                                                    pedHit = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if distance < 1.5 then
                            if value.damagePeds then
                                if target ~= PlayerPedId() then
                                    if not pedHit then

                                        if not IsPedInAnyVehicle(target) then
                                            if IsEntityInAir(shield) then
                                                SetPedToRagdoll(target, 1000, -1, 0, true, true, true)
                                                PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
                                                ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
                    
                                                showNonLoopParticle("core", "blood_chopper", target, 3.0)
                                                showNonLoopParticle("core", "scrape_blood_car", target, 2.0)
                                                showNonLoopParticle("core", "blood_entry_shotgun", target, 1.5)
                    
                                                pedHit = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end          

            if IsPedInVehicle(PlayerPedId(), mVehicle, false) then

                if vClass ==  8 or (vModel == -1030275036 or vModel == -616331036 or vModel == -311022263) then

                    if not thrown then
                        AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.13, -0.17, 0.0, 90.0, -60.0, 10.0, 1, 1, 0, 1, 0, 1)
                        equippedToHand = false
                    end

                    motorcycle = true
                    equippedToBack = true

                else
                    equippedToBack = true
                end
            else
                motorcycle = false
            end

            if shieldCovered then
                DisableControlAction(0, 24, false)
                DisableControlAction(0, 140, false)  
            end

            if shieldCovered or equippedToHand then
    
                if DoesEntityExist(shield) then
    
                    if IsPedRagdoll(PlayerPedId()) then                        
                        DetachEntity(shield, true, true)
                        shieldDropped = true
                    end
                end
            end

            if shieldDropped and not IsEntityAttachedToEntity(shield, ped) then
                
                for key, value in pairs(Config.settings) do
                    if value.autoReturn then
                        if IsPedGettingUp(PlayerPedId()) and shieldDropped then
                            Citizen.Wait(1000)
                            equipToHand()
                            
                            for key, value in pairs(Config.settings) do
                                if value.smokeEffects then
                                    showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", shield, 2.0) 
                                end
                            end
                            
                            shieldDropped = false
                        end
                    else
                        dropToPickup = true
                    end
                end
            end
    
            if IsPedInAnyVehicle(PlayerPedId()) then
                local boneIndex = 24817
                local ped = PlayerPedId()

                if not motorcycle and IsEntityAttachedToEntity(shield, ped) then
                    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.13, -0.17, 0.0, 90.0, -60.0, 10.0, 1, 1, 0, 1, 0, 1)
                    equippedToHand = false
                end
            end

            if IsPedClimbing(PlayerPedId()) then
                
                if IsEntityAttachedToEntity(shield, ped) then
                    StopAnimTask(PlayerPedId(), "missheat", "binoculars_loop", 1.0)
                    shieldCovered = false
                    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.13, -0.17, 0.0, 90.0, -60.0, 10.0, 1, 1, 0, 1, 0, 1)
                    equippedToBack = true
                end
            end
            
            if IsPedSwimmingUnderWater(PlayerPedId()) then
                SetEnableScuba(PlayerPedId(), true)
                SetPedMaxTimeUnderwater(PlayerPedId(), 9999.99)
            end
    
            if equippedToHand then
                SetPlayerMeleeWeaponDamageModifier(PlayerId(), 12.0)
            end
        else
            SetPedCanRagdoll(ped, true)
            SetPedRagdollOnCollision(PlayerPedId(), false)
            SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
            SetAmbientPedsDropMoney(false)
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            SetPedMoveRateOverride(PlayerId(), 0.0)
        end
        
    end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)		
		local lifeOrb = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_cash_pile_01"), false)

        if enableCaptainAmericaPowers then
            
            default()

            local markerCoords = GetOffsetFromEntityInWorldCoords(lifeOrb, 0.0, 0.0, 0.0)
            local distanceCheck1 = #(pedCoords - markerCoords)
			local prevHealth = GetEntityHealth(ped)
			local health = prevHealth

            if distanceCheck1 <= 2 then
                if health ~= prevHealth then
                    SetEntityHealth(playerPed, health)
                end
            end
            
            if dropToPickup then
                local sx, sy, sz = table.unpack(GetEntityCoords(shield))
                
                if IsControlJustPressed(0, 25) then
                    if not drinking and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) then
                        reachShield()
                        shieldDropped = false
                        dropToPickup = false
                    end
                end
                
                if IsPlayerFarDroppedShield(sx, sy, sz) and not IsEntityInAir(shield) and not IsEntityAttachedToEntity(shield, ped) then
                    local coords = GetEntityCoords(ped, true)
                    local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(ped, true), coords, true), 0)
                    
                    DrawMarker(21, sx, sy, sz+0.8, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 66, 135, 245, 255, true, true, 2, true, nil, nil, false)

                    if not drinking and IsPlayerNearDroppedShield(sx, sy, sz) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) then
                        controlPrompt("~INPUT_TALK~", "Pickup ~b~Shield")
    
                        if IsControlJustReleased(0, 46) then
                            if IsBlipOnMinimap(sBlip) then
                                RemoveBlip(sBlip)
                                destroyBlips()
                            end
                            makeEntityFaceEntity(ped, shield)
                            pickupShield(coords)
                            shieldDropped = false
                            dropToPickup = false
                        end
                    end
                end
            end

            if IsEntityInAir(PlayerPedId()) then
                SetPedRagdollOnCollision(PlayerPedId(), true)
            else
                SetPedRagdollOnCollision(PlayerPedId(), false)
            end
            
            if not equippedToBack then
                
                if IsEntityAttachedToEntity(shield, ped) then
                    if IsControlJustPressed(0, 25) then
                        if not shieldCovered and not IsPedInMeleeCombat(PlayerPedId()) and not rolling then
                            if equippedToHand and not fallCover then
                                shieldCover()
                                fallCover = false
                            end
                        end
                    elseif IsControlJustReleased(0, 25) then  
                        local boneIndex = 57005
                        local inBedDicts2 = "missheat"
                        local inBedAnims2 = "binoculars_loop"
                        local ped = PlayerPedId()
    
                        AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
    
                        StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 8.0)
    
                        shieldCovered = false
                        fallCover = false
                        fallCount = 0
                    end
                end
            end

            if not IsPedRagdoll(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then

                if IsControlJustReleased(0, 46) then
                    if DoesEntityExist(shield) and not IsPedRagdoll(PlayerPedId())  then
                        if not motorcycle then
                            if not equippedToBack then
                                if not shieldCovered and not shieldDropped then
                                    throwShield()
                                else
                                    local ped = PlayerPedId()
                                    local pHeading = GetEntityHeading(ped)

                                    if not shieldDropped then
                                        if IsEntityInAir(ped) then
                                            SetEntityHeading(ped, pHeading)
                                            chargeShield()
                                        else
                                            chargeShield()
                                        end
                                    end
                                end
                            end
                        else
                            if not shieldDropped then
                                throwShieldInMotorcycle()
                            end
                        end
                    end
                end

                if equippedCapshield and not drinking then
    
                    if IsEntityAttachedToEntity(shield, ped) then
                        if IsControlJustReleased(0, 15) then
                            if DoesEntityExist(shield) then
                                if not equippedToBack then
                                    equipToBack()
                                else
                                    equipToHand()
                                end
                            end
                        elseif IsControlJustReleased(0, 14) then
                            if DoesEntityExist(shield) then
                                if not equippedToBack then
                                    equipToBack()
                                else
                                    equipToHand()
                                end
                            end
                        end
                    end

                end
            end
        end
    end
end)

function default()
    if enableCaptainAmericaPowers then
        local ped = PlayerPedId()
        SetCurrentPedWeapon(ped, -1569615261, true)
        SetPedUsingActionMode(ped, false, 0, "motionstate_actionmode_idle")
        SetPlayerLockon(PlayerId(), false)
        ToggleStealthRadar(true)
        SetPedAsCop(ped, true)
        SetAmbientPedsDropMoney(true)
        SetFollowPedCamViewMode(2)
        SetCamViewModeForContext(2, 2)
        RestorePlayerStamina(PlayerId(), 1.0)
        AnimpostfxStopAll()
        DisableControlAction(0, 0, false) 
        HudForceWeaponWheel(false)
        ShowHudComponentThisFrame(14)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(22)

        for key, value in pairs(Config.settings) do
            if value.invincible then
                SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
            else
                SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            end
        end
        
        for key, value in pairs(Config.settings) do
            if value.superjump then
                SetSuperJumpThisFrame(PlayerId())
            end
        end

        for key, value in pairs(Config.settings) do
            if value.fastrun then
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                SetPedMoveRateOverride(PlayerId(), 10.0)
            else
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                SetPedMoveRateOverride(PlayerId(), 0.0)
            end
        end

    else
        SetAmbientPedsDropMoney(false)
        SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetPedMoveRateOverride(PlayerId(), 0.0)
    end
end

function drinkSerum()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local dic = "amb@code_human_wander_mobile@male@enter"
    local anim = "enter"
    local dic2 = "mini@sprunk"
    local anim2 = "plyr_buy_drink_pt2"
    local anim3 = "plyr_buy_drink_pt3"
    local flag = 48
    local propName = "prop_cs_spray_can"
    local boneIndex = 57005
    
    SetCurrentPedWeapon(ped, -1569615261, true)

    if IsEntityAttachedToEntity(shield, ped) then
        equipToBack()
    end

    if not drinking then
        drinking = true
        LoadAnim(dic)
        TaskPlayAnim(ped, dic, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    
        Wait(1500)
        canteen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
        AttachEntityToEntity(canteen, ped, GetPedBoneIndex(ped, boneIndex), 0.15, -0.01, -0.03, -80.0, -100.0, 0, 1, 1, 0, 1, 0, 1)
        Wait(500)
        showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
        Wait(500)
        LoadAnim(dic2)
        TaskPlayAnim(ped, dic2, anim2, 2.0, 2.0, -1, flag, 0, false, false, false)
        Wait(1200)
        TaskPlayAnim(ped, dic2, anim3, 2.0, 2.0, 1000, flag, 0, false, false, false)
        SetEntityHealth(ped, 200)
        Wait(880)
        DetachEntity(canteen, true, true)
        Wait(1000)
        showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
        Wait(200)
        DeleteObject(canteen)
        drinking = false
    end
end

function renderShieldBlip()
    ClearGpsMultiRoute()
    sBlip = AddBlipForEntity(shield)
    SetBlipSprite(sBlip, 1)
    SetBlipColour(sBlip, 38)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Shield")
    EndTextCommandSetBlipName(sBlip)
    SetBlipAsShortRange(sBlip, true)
end

function destroyBlips()
    RemoveBlip(sBlip)
    ClearGpsMultiRoute()
    StartGpsMultiRoute(18, false, false)
    SetGpsMultiRouteRender(false)
end

function controlPrompt(str1, str2)
    local displayText = str1.." "..str2
    ESX.ShowHelpNotification(displayText)
end

function impale(ped)
    local boneIndex = 24817
    local impaleChance = 0

    for key, value in pairs(Config.settings) do

        impaleChance = math.random(0, value.impaleChance)

        if value.impaleChance > 5 then
            value.impaleChance = 5
        end
        
        if impaleChance > 2 then
            impaled = true
            AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, 1, 1, 0, 1, 0, 1)
        end
    end
end

function applyDamage(ped)
    showNonLoopParticle("core", "blood_chopper", ped, 3.0)
    showNonLoopParticle("core", "scrape_blood_car", ped, 2.0)
    showNonLoopParticle("core", "blood_entry_shotgun", ped, 1.5)
    ApplyPedDamagePack(ped, "BigRunOverByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(ped, "BigHitByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(ped, "Fall", 12.0, 0.0)
    ApplyPedDamagePack(ped, "SCR_Finale_Michael", 12.0, 0.0)
    ApplyPedDamagePack(ped, "SCR_Torture", 12.0, 0.0)
    ApplyPedDamagePack(ped, "Splashback_Face_0", 12.0, 0.0)
    ApplyPedDamagePack(ped, "td_blood_shotgun", 12.0, 0.0)
    ApplyPedBlood(ped, 3, 0.0, 0.0, 0.0, "wound_sheet")
    ExplodePedHead(ped, GetSelectedPedWeapon(PlayerPedId()))
    SetEntityHealth(ped, 0, 0)
    ApplyDamageToPed(ped, 90000, false)
end

function getClosestPed(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

function closestPedOnEntity(entity)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

    local sCoords = GetEntityCoords(entity)

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, sCoords.x, sCoords.y, sCoords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function headCover()
    local ped = PlayerPedId()
    local boneIndex = 24817
    local inBedDicts = "missheat"
    local inBedAnims = "binoculars_loop"

    LoadAnim(inBedDicts)

    shieldCovered = true

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 49, 0, false, false, false)
    -- Citizen.Wait( 300 )
    -- PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
    Citizen.Wait( 200 )
    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.61, 0.12, 0.0, -90.0, -150.0, -90.0, 1, 1, 0, 1, 0, 1)
end

function combatRoll()
    local ped = PlayerPedId()
    local inBedDicts = "move_strafe@roll_fps"
    local inBedAnims = "combatroll_fwd_p1_00"

    local pos = GetEntityForwardVector(ped)
    local multiplier = 0
    
    LoadAnim(inBedDicts)

    for key, value in pairs(Config.settings) do
        multiplier = (value.shieldThrowForceMultiplier)/15
    end

    if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 3) then
        TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 4.0, 3.0, 1000, 0, 0, false, false, false)
    end
    
    rolling = true
    Wait(500)
    rolling = false
end


function combatRollForce()
    local ped = PlayerPedId()
    local inBedDicts = "move_strafe@roll_fps"
    local inBedAnims = "combatroll_fwd_p1_00"
    local inBedDicts2 = "move_climb"
    local inBedAnims2 = "clamberpose_to_dive"

    local pos = GetEntityForwardVector(ped)
    local multiplier = 0
    
    LoadAnim(inBedDicts)
    LoadAnim(inBedDicts2)

    for key, value in pairs(Config.settings) do
        multiplier = (value.shieldThrowForceMultiplier)/15
    end
    
    PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 0)


    if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts2, inBedAnims2, 3) then
        TaskPlayAnim(PlayerPedId(), inBedDicts2, inBedAnims2, 4.0, 8.0, 800, 0, 0, false, false, false)
        Wait(400)    
        rolling = true
        ApplyForceToEntity(ped, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
        Wait(300)
        if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 3) then
            TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 3.0, 4.0, 1000, 0, 0, false, false, false)
        end
    end
    Wait(500)
    rolling = false
end


function shieldCover()
    local ped = PlayerPedId()
    local boneIndex = 24817
    local inBedDicts = "missheat"
    local inBedAnims = "binoculars_loop"

    LoadAnim(inBedDicts)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 49, 0, false, false, false)
    -- Citizen.Wait( 300 )
    -- PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)
    Citizen.Wait(100)
    shieldCovered = true
    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.36, 0.32, 0.0, -90.0, -90.0, -10.0, 1, 1, 0, 1, 0, 1)
end

function pickupShield(coords)
    local ped = PlayerPedId()
    local boneIndex = 57005

    local inBedDicts = "anim@mp_snowball"
    local inBedAnims = "pickup_snowball"

    LoadAnim(inBedDicts)

    local inBedDicts2 = "missheat"
    local inBedAnims2 = "binoculars_loop"

    audioHitPlay = false
    shieldCovered = false
    StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 8.0)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 3.0, 8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(500)
    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)

    if impaled then

        showNonLoopParticle("core", "ent_sht_blood", impaledTarget, 3.0)
        showNonLoopParticle("core", "blood_chopper", impaledTarget, 3.0)
        showNonLoopParticle("core", "scrape_blood_car", impaledTarget, 2.0)
        SetPedToRagdoll(impaledTarget, 1000, -1, 0, true, true, true)
        PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)

    end

    Citizen.Wait(500)
    StopAnimTask(PlayerPedId(), inBedDicts, inBedAnims, 8.0)

    equippedToHand = true
    equippedToBack = false
    shieldCovered = false
    impaled = false
end

function equipToHand()
    local ped = PlayerPedId()
    local boneIndex = 57005

    local inBedDicts = "weapons@unarmed"
    local inBedAnims = "holster"

    LoadAnim(inBedDicts)

    local inBedDicts2 = "missheat"
    local inBedAnims2 = "binoculars_loop"

    audioHitPlay = false
    shieldCovered = false
    StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 8.0)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 3.0, 8.0, -1, 48, 0, false, false, false)
    Citizen.Wait(500)

    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
    equippedToHand = true
    equippedToBack = false
    shieldCovered = false
end

function equipToBack()
    local ped = PlayerPedId()
    local boneIndex = 24817

    local inBedDicts = "weapons@unarmed"
    local inBedAnims = "unholster"

    local inBedDicts2 = "missheat"
    local inBedAnims2 = "binoculars_loop"

    shieldCovered = false
    StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 1.0)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, -1, 48, 0, false, false, false)
    Citizen.Wait(500)

    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.13, -0.17, 0.0, 90.0, -60.0, 10.0, 1, 1, 0, 1, 0, 1)
    equippedToBack = true
    equippedToHand = false
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function chargeShield()
    local ped = PlayerPedId()
    local sitDict = "nm@stunt_jump"
    local sitAnim = "jump_intro"
    local pos = GetEntityForwardVector(ped)
    local boneIndex = 57005
    local multiplier = 0

    charging = true

    for key, value in pairs(Config.settings) do
        multiplier = (value.shieldThrowForceMultiplier)/5
    end

    LoadAnim(sitDict)

    PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 0)
    if not IsEntityInAir(ped) then
        ApplyForceToEntity(ped, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
    else
        ApplyForceToEntity(ped, 1, 0, 0, (multiplier*-1), 0,0,0, 1, false, true, true, true, true)
        SetEntityRotation(ped, 0.0, 90.0, -142, 1, true)
    end

    if not IsEntityPlayingAnim(ped, sitDict, sitAnim, 8) then
        TaskPlayAnim(ped, sitDict, sitAnim, 7.0, 1.0, 1000, 8, 0, false, false, false)
        Wait(1500)
    end
                
    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
    equipToHand()

    pedHit = false
    shieldCovered = false
    fallCover = false
    charging = false
end

function makeEntityFaceEntity(player, entity)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(entity, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end


function throwShield()
    local ped = PlayerPedId()
    local boneIndex = 57005
    local random = math.random(0, 6)
    local inBedDicts = ""
    local inBedAnims = ""
    local multiplier = 0

    for key, value in pairs(Config.settings) do
        multiplier = value.shieldThrowForceMultiplier
    end

    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)

    local inBedDicts2 = "missheat"
    local inBedAnims2 = "binoculars_loop"

    local duration = 0
    local flag = 0    

    StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 1.0)

    if random == 0 then
        inBedDicts = "weapons@projectile@grenade_str"
        LoadAnim(inBedDicts)
        inBedAnims = "throw_h_fb_forward"
        duration = 300
    elseif random == 1 then
        inBedDicts = "weapons@projectile@grenade_str"
        LoadAnim(inBedDicts)
        inBedAnims = "throw_h_fb_backward"
        duration = 300
    elseif random == 2 then
        inBedDicts = "melee@unarmed@streamed_variations"
        LoadAnim(inBedDicts)
        inBedAnims = "plyr_stealth_kill_unarmed_hook_r"
        duration = 700
    elseif random == 3 then
        inBedDicts = "melee@unarmed@streamed_variations"
        LoadAnim(inBedDicts)
        inBedAnims = "plyr_takedown_front_backslap"
        duration = 500
    elseif random == 4 then
        inBedDicts = "melee@unarmed@streamed_core"
        LoadAnim(inBedDicts)
        inBedAnims = "plyr_takedown_front_elbow"
        duration = 500
    elseif random == 5 then
        inBedDicts = "melee@small_wpn@streamed_core_fps"
        LoadAnim(inBedDicts)
        inBedAnims = "small_melee_wpn_short_range_0"
        duration = 500
    elseif random == 6 then
        inBedDicts = "melee@knife@streamed_core"
        LoadAnim(inBedDicts)
        inBedAnims = "plyr_knife_front_takedown"
        duration = 600
    end

    if IsPedRunning(ped) or IsPedSprinting(ped) or IsPedWalking(ped) then
        flag = 48

        TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, duration, flag, 0, false, false, false)
        Citizen.Wait(duration)
    else
        flag = 1

        TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 1.0, duration, flag, 0, false, false, false)
        Citizen.Wait(duration)
    end
    
    for key, value in pairs(Config.settings) do
        if value.smokeEffects then
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", shield, 4.0) 
        end
    end
    
    shieldCovered = false
    DetachEntity(shield, true, true)
    local pos = GetEntityForwardVector(ped)
    PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 0)
    ApplyForceToEntity(shield, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
    thrown = true
    shieldDropped = true
    equippedToHand = false
    attachedToBackMotorcycle = false
    
    for key, value in pairs(Config.settings) do
        if value.autoReturn then
            Citizen.Wait(3000)
            shieldDropped = false
            reachShield()
        else
            dropToPickup = true
            shieldDropped = true
        end
    end
    pedHit = false
end


function throwShieldInMotorcycle()
    local ped = PlayerPedId()
    local boneIndex = 57005
    local inBedDicts = "weapons@projectile@grenade_str"
    local inBedAnims = "throw_h_fb_backward"
    local duration = 300

    local multiplier = 0
    
    for key, value in pairs(Config.settings) do
        multiplier = value.shieldThrowForceMultiplier
    end

    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)


    StopAnimTask(PlayerPedId(), inBedDicts2, inBedAnims2, 1.0)

    LoadAnim(inBedDicts)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, duration, 48, 0, false, false, false)
    Citizen.Wait(duration)
    
    for key, value in pairs(Config.settings) do
        if value.smokeEffects then
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", shield, 4.0) 
        end
    end

    shieldCovered = false
    DetachEntity(shield, true, true)

    local coords = GetEntityCoords(ped, 0)
    local mVehicle = GetVehiclePedIsIn(ped, false)
    local vModel = GetEntityModel(mVehicle)

    if vModel == -1030275036 or vModel == -616331036 or vModel == -311022263 then
        SetEntityCoords(shield, coords.x, coords.y, coords.z+2.0, true, false, true, false)
    else
        SetEntityCoords(shield, coords.x, coords.y, coords.z+1.0, true, false, true, false)
    end

    SetEntityRotation(shield, 0.00, 0.00, 0.00, 1, true)
    local pos = GetEntityForwardVector(ped)
    PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 0)
    ApplyForceToEntity(shield, 1, pos.x*multiplier, pos.y*multiplier, (pos.z-0.1)*multiplier, 0,0,0, 1, false, true, true, true, true)
    thrown = true
    shieldDropped = true
    equippedToHand = false
    attachedToBackMotorcycle = false

    for key, value in pairs(Config.settings) do
        if value.autoReturn then
            Citizen.Wait(3000)
            shieldDropped = false
            reachShield()
        else
            dropToPickup = true
            shieldDropped = true
        end
    end
    
    pedHit = false
end

function reachShield()
    local ped = PlayerPedId()

    local inBedDicts = "veh@driveby@first_person@passenger_right_handed@throw"
    local inBedAnims = "throw_225l"
    local boneIndex = 57005

    LoadAnim(inBedDicts)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, 1000, 48, 0, false, false, false)
    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
    Citizen.Wait(500)
    PlaySoundFrontend(-1, "Hit_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)

	DetachEntity(shield, true, true)

    if impaled then

        local multiplier = 0  
        local pos = GetEntityForwardVector(shield)  
        for key, value in pairs(Config.settings) do
            multiplier = value.pedForceDamage
        end

        showNonLoopParticle("core", "ent_sht_blood", impaledTarget, 3.0)
        showNonLoopParticle("core", "blood_chopper", impaledTarget, 3.0)
        showNonLoopParticle("core", "scrape_blood_car", impaledTarget, 2.0)
        SetPedToRagdoll(impaledTarget, 1000, -1, 0, true, true, true)
        PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 0)

        ApplyForceToEntity(impaledTarget, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
        
        if impaled then
            SetEntityHealth(impaledTarget, 0, 0)
            ApplyDamageToPed(impaledTarget, 90000, false)
        end

		impaled = false

    end

    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)
    
    for key, value in pairs(Config.settings) do
        if value.smokeEffects then
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", shield, 4.0) 
        end
    end

    Citizen.Wait(500)

    if not motorcycle then
        equippedToHand = true
    end
    
end

function equipShield()
    local ped = PlayerPedId()
    local propName = ""
    local hash = GetEntityModel(PlayerPedId())
    -- local propName = "prop_stockade_wheel"

    local x, y, z = table.unpack(GetEntityCoords(ped))
    local boneIndex = 57005

    local inBedDicts = "weapons@unarmed"
    local inBedAnims = "holster"
    
    if hash == mocaptainModelHash then
        propName = "capshield"
    elseif hash == stealthModelHash then
        propName = "capshield_s"
    elseif hash == nicaptainhModelHash then
        propName = "capshield_n"
    else
        propName = "capshield"
    end

    print(propName)

    LoadAnim(inBedDicts)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, -1, 48, 0, false, false, false)
    Citizen.Wait(500)
    PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", 0)

    RequestModel(propName)
    while ( not HasModelLoaded(propName)) do
        Citizen.Wait( 100 )
    end

    shield = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    -- SetEntityAsMissionEntity(shield, true, true)
    
    AttachEntityToEntity(shield, ped, GetPedBoneIndex(ped, boneIndex), 0.0, -0.07, 0.00, 36.0, -0.0, -0.80, 1, 1, 0, 1, 0, 1)

    equippedCapshield = true
    equippedToHand = true
end

function IsPlayerFarDroppedShield(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 16.0 then
        return true
    end
end

function IsPlayerNearDroppedShield(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 1.5 then
        return true
    end
end

function removeShield()

    local inBedDicts = "weapons@unarmed"
    local inBedAnims = "unholster"

    LoadAnim(inBedDicts)

    TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 2.0, 2.0, -1, 48, 0, false, false, false)
    Citizen.Wait(500)
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)

    DeleteObject(shield)
    
    local inBedDicts = "missheat"
    local inBedAnims = "binoculars_loop"

    StopAnimTask(PlayerPedId(), inBedDicts, inBedAnims, 1.0)
    DeleteObject(canteen)

    enableCaptainAmericaPowers = false
    shieldCovered = false
    fallCover = false
    ragdoll = false
    equippedCapshield = false
    equippedToBack = false
    shieldCovered = false
    equippedToHand = false
    shieldDropped = false
    charging = false
    thrown = false
    pedHit = false
    motorcycle = false
    fallCover = false
    rolling = false    
    impaled = false
    shieldDropped = false
    dropToPickup = false
    drinking = false
end

function showNonLoopParticle(dict, particleName, ped, scale)
    local boneIndex = 23553
    local pBone = GetPedBoneIndex(ped, boneIndex)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(particleHandle, 0, 255, 0 ,0)
    return StartNetworkedParticleFxNonLoopedOnEntityBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, pBone, scale, false, false, false)
end

function showLoopParticle(dict, particleName, entity, scale)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    local particleHandle = StartNetworkedParticleFxLoopedOnEntity(particleName, entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	return particleHandle
end
