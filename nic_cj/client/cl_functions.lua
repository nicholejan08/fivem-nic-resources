
-- [FUNCTIONS] **************************************************************

function giveSprayCan()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local propName = "prop_paint_spray01b"
    local boneIndex = GetPedBoneIndex(ped, 57005)

    SetCurrentPedWeapon(ped, -1569615261, true)
    loadModel(propName)

    if not IsPedInAnyVehicle(ped, true) then
        sprayCan = CreateObject(propName, coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(sprayCan, ped, boneIndex, 0.075, -0.09, -0.045, -79.0, 0.0, -8.0, false, false, false, false, 2, true)
    end
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function getVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function getClosestVehicle(coords)
	local vehicles = getVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local ped = PlayerPedId()
        local vCurrent = GetVehiclePedIsIn(ped, false)
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
            if vCurrent ~= vehicles[i] then
                closestVehicle  = vehicles[i]
            end
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function setWalkStyle()
    local ped = PlayerPedId()
    local walkstyle = ""

    if not buffed then
        walkstyle = "move_p_m_two"
    else
        walkstyle = "move_p_m_one"
    end

    RequestAnimSet(walkstyle)        
    while (not HasAnimSetLoaded(walkstyle)) do 
        Citizen.Wait(100)
    end

    SetPedMovementClipset(ped, walkstyle, 0.55)
    ResetPedStrafeClipset(ped)
end

function cancellAll()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    DeleteEntity(sprayCan)
    StopAnimTask(ped, sprayIdleAnimDict, sprayIdleAnimName, 4.0)
    SetPedInfiniteAmmo(ped, false, weapon)
    ClearPedTasks(ped)
    RemoveAllPedWeapons(ped, 1)
    deleteProps()
    enableSanAndreas = false
    SetPedComponentVariation(ped, 0, 0, 0, 0)
    setWalkStyle()
    buffed = false
    crouched = false
    rocketman = false
    permitted = false
    SendNUIMessage({
        type = "HUD",
        display = false
    })
    toggleCrosshair(false)         
    SendNUIMessage({
        type = "UI",
        display = false
    })
    SendNUIMessage({
        type = "radar",
        display = false
    })
end

function getClosestPed(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = getPeds(ignoreList)
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

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function getPeds(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

function GetZoneDevant(entity, val)
    local backwardPosition = GetOffsetFromEntityInWorldCoords(entity, 0.0, val, 0.0)
	return backwardPosition
end

function deleteProps()
    ResetEntityAlpha(jetpack)
    
    DeleteEntity(jetpack)
    DeleteEntity(cellphone)
    DeleteEntity(parachute)
end

function closestPedOnEntity(entity)
	local ignoreList      = ignoreList or {}
	local peds            = GetPeds(ignoreList)
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

function hesoyam()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local max = GetPedMaxHealth(ped)
    local armor = GetPlayerMaxArmour(PlayerId())
    local money = GetPedMoney(ped)
    local addedMoney = money + 2500
    local money = math.random(3, 8)

    -- CreateMoneyPickups(coords.x, coords.y, coords.z+0.5, 1000, money, 0x684a97ae);
    SetEntityHealth(ped, max)
    SetPedArmour(ped, armor)

    SetPedMoney(ped, addedMoney)
    
    -- if not hesoyamCheat then
    --     currValue = money
    --     hesoyamCheat = true
    -- end

    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, true)
        SetVehicleFixed(vehicle)
        SetVehicleEngineOn(vehicle, true, false, false)
    end
end

function spawnVehicle(veh)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if not IsModelInCdimage(veh) then return end
    RequestModel(veh)
    while not HasModelLoaded(veh) do
        Citizen.Wait(10)
    end

    local cheatVehicle = CreateVehicle(veh, coords.x-3.0, coords.y+3.0, coords.z, 0, true, false)
    SetModelAsNoLongerNeeded(veh)
    
end

function equipTier1Weapons()
    local ped = PlayerPedId()

    slot0 = GetHashKey("weapon_unarmed")
    slot1 = GetHashKey("cj_knife")
    slot2 = GetHashKey("cj_pistol")
    slot3 = GetHashKey("cj_deagle")
    slot4 = GetHashKey("cj_ak47")
    slot5 = GetHashKey("cj_mp5")
    slot6 = GetHashKey("cj_spas")
    slot7 = GetHashKey("cj_sniper")
    slot8 = GetHashKey("cj_rpg")
    -- slot1 = GetHashKey("weapon_knuckle")
    -- slot10 = GetHashKey("cj_molotov")
    -- slot11 = GetHashKey("cj_teargas")

    GiveWeaponToPed(ped, slot0, 99, true, true)
    GiveWeaponToPed(ped, slot1, 99, true, true)
    GiveWeaponToPed(ped, slot2, 99, true, true)
    RemoveWeaponComponentFromWeaponObject(slot2, "COMPONENT_AT_PI_SUPP_02")
    GiveWeaponToPed(ped, slot3, 99, true, true)
    GiveWeaponToPed(ped, slot4, 99, true, true)
    GiveWeaponToPed(ped, slot5, 99, true, true)
    GiveWeaponToPed(ped, slot6, 99, true, true)
    GiveWeaponToPed(ped, slot7, 99, true, true)
    GiveWeaponToPed(ped, slot8, 99, true, true)
    -- GiveWeaponToPed(ped, slot9, 99, true, true)
    -- GiveWeaponToPed(ped, slot10, 99, true, true)
    -- GiveWeaponToPed(ped, slot11, 99, true, true)
    silenced = false
end

function equipTier2Weapons()
    local ped = PlayerPedId()

    slot0 = GetHashKey("weapon_unarmed")
    slot1 = GetHashKey("cj_flower")
    slot2 = GetHashKey("cj_katana")
    slot3 = GetHashKey("cj_shovel")
    slot4 = GetHashKey("cj_m4")
    slot5 = GetHashKey("cj_uzi")
    slot6 = GetHashKey("cj_sawnoff")
    slot7 = GetHashKey("cj_rifle")
    slot8 = GetHashKey("cj_heatseek")
    -- slot10 = GetHashKey("cj_grenade")
    -- slot11 = GetHashKey("cj_teargas")

    GiveWeaponToPed(ped, slot0, 99, true, true)
    GiveWeaponToPed(ped, slot1, 99, true, true)
    GiveWeaponToPed(ped, slot2, 99, true, true)
    GiveWeaponToPed(ped, slot3, 99, true, true)
    GiveWeaponToPed(ped, slot4, 99, true, true)
    GiveWeaponToPed(ped, slot5, 99, true, true)
    GiveWeaponToPed(ped, slot6, 99, true, true)
    GiveWeaponToPed(ped, slot7, 99, true, true)
    GiveWeaponToPed(ped, slot8, 99, true, true)
    -- GiveWeaponToPed(ped, slot9, 99, true, true)
    -- GiveWeaponToPed(ped, slot10, 99, true, true)
    -- GiveWeaponToPed(ped, slot11, 99, true, true)
    silenced = false
end

function equipTier3Weapons()
    local ped = PlayerPedId()

    slot0 = GetHashKey("weapon_unarmed")
    slot1 = GetHashKey("cj_bat")
    slot2 = GetHashKey("cj_skate")
    slot3 = GetHashKey("cj_pistol_silenced")
    slot4 = GetHashKey("cj_m4")
    slot5 = GetHashKey("cj_tec9")
    slot6 = GetHashKey("cj_shotgun")
    slot7 = GetHashKey("cj_sniper")
    slot8 = GetHashKey("cj_minigun")
    -- slot4 = GetHashKey("cj_deagle")
    -- slot10 = GetHashKey("weapon_stickybomb")
    -- slot11 = GetHashKey("weapon_fireextinguisher")

    GiveWeaponToPed(ped, slot0, 99, true, true)
    GiveWeaponToPed(ped, slot1, 99, true, true)
    GiveWeaponToPed(ped, slot2, 99, true, true)
    GiveWeaponToPed(ped, slot3, 99, true, true)
    GiveWeaponComponentToPed(ped, slot3, GetHashKey("COMPONENT_AT_PI_SUPP_02"))
    GiveWeaponToPed(ped, slot4, 99, true, true)
    GiveWeaponToPed(ped, slot5, 99, true, true)
    GiveWeaponToPed(ped, slot6, 99, true, true)
    GiveWeaponToPed(ped, slot7, 99, true, true)
    GiveWeaponToPed(ped, slot8, 99, true, true)
    -- GiveWeaponToPed(ped, slot9, 99, true, true)
    -- GiveWeaponToPed(ped, slot10, 99, true, true)
    -- GiveWeaponToPed(ped, slot11, 99, true, true)
    silenced = true
end

function toggleMuscle()
    local ped = PlayerPedId()

    if enableSanAndreas then
        if not buffed then
            SendNUIMessage({
                type = "activate",
            })
            
            buffed = true
            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_activated', 1.0)
        else
            SendNUIMessage({
                type = "deactivate",
            })

            buffed = false
            TriggerEvent('PlaySound:PlayOnOne', 'sa_cheat_deactivated', 1.0)
        end
    end
end

function loadClipset(val)
    RequestClipSet(val)
    while (not HasClipSetLoaded(val)) do
        Citizen.Wait(100)
    end
end

function loadModel(string)
    RequestModel(string)
    while ( not HasModelLoaded(string)) do
        Citizen.Wait(100)
    end
end

function equipParachute()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local model = "cj_parachute"
    local pBoneIndex = GetPedBoneIndex(ped, 24817)

    parachute = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(parachute, ped, pBoneIndex, 0.145, -0.16, 0.0, 0.0, -90.0, 180.0, false, false, false, false, 2, true)
end

function equipMobilePhone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local getPhoneAnim = "cellphone_text_in"    
    local cellphoneName = "cj_cellphone"        
    local pBoneIndex = GetPedBoneIndex(ped, 57005)

    RequestAnimDict(phoneDict)
    while ( not HasAnimDictLoaded(phoneDict)) do
        Citizen.Wait( 100 )
    end

    TaskPlayAnim(ped, phoneDict, getPhoneAnim, 4.0, 3.0, 1000, 51, 0, true, 0, false, 0, false)
    Wait(500)
    cellphone = CreateObject(cellphoneName, coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(cellphone, ped, pBoneIndex, 0.15, 0.03, -0.015, 130.0, 100.0, 0.0, false, false, false, false, 2, true)
                        
    SendNUIMessage({
        type = "HUD",
        display = true
    })
end

function hideMobilePhone()
                        
    SendNUIMessage({
        type = "HUD",
        display = false
    })

    local ped = PlayerPedId()
    local getPhoneAnim = "cellphone_text_out"
    
    SetCurrentPedWeapon(ped, -1569615261, true)

    RequestAnimDict(phoneDict)
    while ( not HasAnimDictLoaded(phoneDict)) do
        Citizen.Wait( 100 )
    end

    TaskPlayAnim(ped, phoneDict, getPhoneAnim, 4.0, 3.0, 1000, 51, 0, true, 0, false, 0, false)
    Wait(800)
    StopAnimTask(ped, phoneDict, phoneAnim, 4.0)
    DeleteEntity(cellphone)
end

function toggleCrosshair(bool, string)
	SendNUIMessage({
		type = "crosshair",
        aimMode = string,
		display = bool
	})
end

function spawnJetpack()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local modelHash = 1489874736

    if not IsModelInCdimage(modelHash) then
        return
    end

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end

    if not DoesEntityExist(jetpack) then
        jetpack = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)
    end

    SetVehicleEngineOn(jetpack, true, true, false)
    SetPedIntoVehicle(ped, jetpack, -1)
end

function actionsFree(entity)
    if not IsEntityInAir(entity) and not IsEntityDead(entity) and not IsPedRagdoll(entity) and not IsPedGettingUp(entity) and not IsPedWalking(entity) and not IsPedRunning(entity) and not IsPedSprinting(entity) and not IsPedJumping(entity) then
        return true
    end
end

function actionsFreeMoving(entity)
    if not IsEntityInAir(entity) and not IsEntityDead(entity) and not IsPedRagdoll(entity) and not IsPedGettingUp(entity) and not IsPedInAnyVehicle(entity) then
        return true
    end
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function changeModel(model)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end
end

function loadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function showHelpNotification(msg)
    AddTextEntry('helpNotification', msg)
    BeginTextCommandDisplayHelp('helpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function controlPrompt(str1, str2)
    local displayText = str1.." "..str2
    showHelpNotification(displayText)
end

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function showLoopParticle(dict, particleName, entity, scale)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end

    UseParticleFxAssetNextCall(dict)
    local particleHandle = StartNetworkedParticleFxLoopedOnEntity(particleName, entity, 0.0, 0.0, -1.6, 0.0, 0.0, 0.0, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	return particleHandle
end

function showLoopParticleOffset(dict, particleName, entity, x, y, z, rotx, roty, rotz, scale)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(10)
    end

    UseParticleFxAssetNextCall(dict)
    local particleHandle = StartNetworkedParticleFxLoopedOnEntity(particleName, entity, x, y, z, rotx, roty, rotz, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	return particleHandle
end

function showNonLoopParticleOffset(dict, particleName, entity, x, y, z, rotx, roty, rotz, scale)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(10)
    end

    UseParticleFxAssetNextCall(dict)
    local particleHandle = StartNetworkedParticleFxNonLoopedOnEntity(particleName, entity, x, y, z, rotx, roty, rotz, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	return particleHandle
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function makeEntityFaceEntity(player, entity)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(entity, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function showNonLoopParticleBone(dict, particleName, ped, scale, bone, r, g, b, alpha)
    local boneIndex = bone
    local pBone = GetPedBoneIndex(ped, boneIndex)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)

    end
    UseParticleFxAssetNextCall(dict)
    particleHandle = StartNetworkedParticleFxNonLoopedOnEntityBone(particleName, ped, 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, GetPedBoneIndex(ped, boneIndex), scale, false, false, false)
    SetParticleFxLoopedColour(particleHandle, r, g, b, 0)
    SetParticleFxLoopedAlpha(particleHandle, alpha)
end

function default()
    if enableSanAndreas then
        local ped = PlayerPedId()
        DisableIdleCamera(true)
        -- SetPedCanRagdoll(ped, false)

        if IsPedRagdoll(ped) then
            SetPedGravity(ped, false)
        else
            SetPedGravity(ped, true)
        end
    
        if not buffed then
            if IsPedJumping(ped) or IsPedSprinting(ped) or IsEntityInAir(ped) then
                SetPedRagdollOnCollision(ped, true)
                Wait(3000)
            end
        end
    
        SetAmbientPedsDropMoney(true)
        DisplayRadar(false)
        DisableFirstPersonCamThisFrame()
        
        RestorePlayerStamina(PlayerId(), 1.0)
    
        ShowHudComponentThisFrame(14)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(22)
    end
end
