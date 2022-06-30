
-- -- GLOBAL VARIABLES DECLARATION
-- ----------------------------------------------------------------------------------------------------

local tofu, flan, konjac, uiroMochi, anninTofu
local bBlip, rBlip, blBlip, yBlip, pbBlip
local pObject, tObject, fObject, kObject, uObject, aObject

local tofuModelHash = 284168200
local flanModelHash = -1865171037
local konjacModelHash = -256830146
local uiroMochiModelHash = -1107455117
local anninTofuModelHash = -830727030

local rolling = false

local NearestePed = nil
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
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
	end
end)

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

RegisterNetEvent('tofu:requestAllies')
AddEventHandler('tofu:requestAllies', function()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local ph = GetEntityHeading(ped)
    local hash = GetEntityModel(ped)
    local model = ""
    local blipName = ""
    local weapon
    
    if hash == tofuModelHash then
        spawnTofu("flan")
        spawnTofu("konjac")
        spawnTofu("uiroMochi")
        spawnTofu("anninTofu")
    elseif hash == flanModelHash then
        spawnTofu("tofu")
        spawnTofu("konjac")
        spawnTofu("uiroMochi")
        spawnTofu("anninTofu")
    elseif hash == konjacModelHash then
        spawnTofu("tofu")
        spawnTofu("flan")
        spawnTofu("uiroMochi")
        spawnTofu("anninTofu")
    elseif hash == uiroMochiModelHash then
        spawnTofu("tofu")
        spawnTofu("flan")
        spawnTofu("konjac")
        spawnTofu("anninTofu")
    elseif hash == anninTofuModelHash then
        spawnTofu("tofu")
        spawnTofu("flan")
        spawnTofu("konjac")
        spawnTofu("uiroMochi")
    end
end)

RegisterNetEvent('tofu:getIdentifier')
AddEventHandler('tofu:getIdentifier', function(val)
    local ped = PlayerPedId()
    local weapon

    if val == "steam:110000104b59124" then
        if not enableTofu then
            TriggerEvent('nic_hud:toggleHud')
            PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 0)
            changeModel()
            local ped = PlayerPedId()
            local hash = GetEntityModel(ped)
            
            if hash == tofuModelHash then
                ShowNotification("You are ~o~Tofu")
            elseif hash == flanModelHash then
                ShowNotification("You are ~o~Flan")
            elseif hash == konjacModelHash then
                ShowNotification("You are ~o~Konjac")
            elseif hash == uiroMochiModelHash then
                ShowNotification("You are ~o~Uiro Mochi")
            elseif hash == anninTofuModelHash then
                ShowNotification("You are ~o~Annin Tofu")
            end

            weapon = -1951375401

            -- GiveWeaponToPed(ped, weapon, 99, false, true)

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(ped, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(ped, 2, 1, 0, 0)
                end
            end

            SetEntityHealth(ped, 1000)
            SetPedArmour(ped, 1000)
            enableTofu = true
            Citizen.Wait(400)
            PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 0)
            TriggerEvent("tofu:requestAllies")
        else
            if DoesEntityExist(pObject) then
                DeleteObject(pObject)
            end
            if DoesEntityExist(tObject) then
                DeleteObject(tObject)
            end
            if DoesEntityExist(fObject) then
                DeleteObject(fObject)
            end
            if DoesEntityExist(kObject) then
                DeleteObject(kObject)
            end
            if DoesEntityExist(uObject) then
                DeleteObject(uObject)
            end
            if DoesEntityExist(aObject) then
                DeleteObject(aObject)
            end
            TriggerEvent('nic_hud:toggleHud')
            removeTofus()
            revert()
        end
    else
        PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
        ShowNotification("Model not ~r~Authorized")
        print(val)
    end    
end)

RegisterCommand('tofu', function()
	local _source = source
    TriggerServerEvent('tofu:extractIdentifiers', _source)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if enableTofu then
            default()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local boneIndex = 39317

        if enableTofu then
            
            if IsControlJustPressed(0, Keys['MMB']) then
                if not rolling then
                    if not IsEntityInAir(ped) and not IsPedInAnyVehicle(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedSwimming(ped) then
                        if IsPedWalking(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
                            tofuDive()
                        end
                    end
                end
            end
            
            if IsControlJustPressed(0, Keys['G']) then
                if not DoesEntityExist(pObject) then
                    pObject = CreateObject(GetHashKey("c_flashlight"), pedCoords.x, pedCoords.y, pedCoords.z,  true,  true, true)
                    AttachEntityToEntity(pObject, ped, GetPedBoneIndex(ped, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                else
                    DeleteObject(pObject)
                    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                end
            end

            if IsEntityDead(ped) then
                revert()
                removeTofus()
                enableTofu = false
                visor = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableTofu then
            for key, value in pairs(Config.settings) do
                if value.spawnAlliesNearPlayer then
    
                    if DoesEntityExist(tofu) then
                        local pCoords = GetEntityCoords(tofu)
                        if IsEntityDead(tofu) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) and not IsPedRagdoll(ped) and not IsEntityInAir(ped) and not IsPedFalling(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) and not IsPedFalling(tofu) and not IsEntityInAir(tofu) then
                            respawnTofu(tofu, tBlip, tObject)
                        end
                    end
        
                    if DoesEntityExist(flan) then
                        local pCoords = GetEntityCoords(flan)
                        if IsEntityDead(flan) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) and not IsPedRagdoll(ped) and not IsEntityInAir(ped) and not IsPedFalling(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) and not IsPedFalling(flan) and not IsEntityInAir(flan) then
                            respawnTofu(flan, fBlip, fObject)
                        end
                    end
        
                    if DoesEntityExist(konjac) then
                        local pCoords = GetEntityCoords(konjac)
                        if IsEntityDead(konjac) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) and not IsPedRagdoll(ped) and not IsEntityInAir(ped) and not IsPedFalling(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) and not IsPedFalling(konjac) and not IsEntityInAir(konjac) then
                            respawnTofu(konjac, kBlip, kObject)
                        end
                    end
        
                    if DoesEntityExist(uiroMochi) then
                        local pCoords = GetEntityCoords(uiroMochi)
                        if IsEntityDead(uiroMochi) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) and not IsPedRagdoll(ped) and not IsEntityInAir(ped) and not IsPedFalling(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) and not IsPedFalling(uiroMochi) and not IsEntityInAir(uiroMochi) then
                            respawnTofu(uiroMochi, uBlip, uObject)
                        end
                    end
        
                    if DoesEntityExist(anninTofu) then
                        local pCoords = GetEntityCoords(anninTofu)
                        if IsEntityDead(anninTofu) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) and not IsPedRagdoll(ped) and not IsEntityInAir(ped) and not IsPedFalling(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) and not IsPedInAnyVehicle(ped) and not IsPedFalling(anninTofu) and not IsEntityInAir(anninTofu) then
                            respawnTofu(anninTofu, aBlip, aObject)
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

        if enableTofu then
            if rolling then
                SetPedRagdollOnCollision(ped, true)
            end

            for key, value in pairs(Config.settings) do
                if value.clumsyTofus then
                    if IsPedJumping(ped) or IsPedSprinting(ped) or IsEntityInAir(ped) then
                        SetPedRagdollOnCollision(ped, true)
                        Wait(1000)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local hours = GetClockHours()
        local interval = math.random(5000, 20000)
        local boneIndex = 39317
        
        if enableTofu then
            if hours > 21 or hours < 5 then
                if DoesEntityExist(tofu) then
                    local coords = GetEntityCoords(tofu)
                    if not DoesEntityExist(tObject) then
                        tObject = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                        AttachEntityToEntity(tObject, tofu, GetPedBoneIndex(tofu, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                        DeleteObject(tObject)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                    else
                        DeleteObject(tObject)
                    end
                else
                    DeleteObject(tObject)
                end
            else
                DeleteObject(tObject)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local hours = GetClockHours()
        local interval = math.random(5000, 20000)
        local boneIndex = 39317
        
        if enableTofu then
            if hours > 21 or hours < 5 then
                if DoesEntityExist(flan) then
                    local coords = GetEntityCoords(flan)
                    if not DoesEntityExist(fObject) then
                        fObject = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                        AttachEntityToEntity(fObject, flan, GetPedBoneIndex(flan, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                        DeleteObject(fObject)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                    else
                        DeleteObject(fObject)
                    end
                else
                    DeleteObject(fObject)
                end
            else
                DeleteObject(fObject)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local hours = GetClockHours()
        local interval = math.random(5000, 20000)
        local boneIndex = 39317
        
        if enableTofu then
            if hours > 21 or hours < 5 then
                if DoesEntityExist(konjac) then
                    local coords = GetEntityCoords(konjac)
                    if not DoesEntityExist(kObject) then
                        kObject = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                        AttachEntityToEntity(kObject, konjac, GetPedBoneIndex(konjac, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                        DeleteObject(kObject)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                    else
                        DeleteObject(kObject)
                    end
                else
                    DeleteObject(kObject)
                end
            else
                DeleteObject(kObject)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local hours = GetClockHours()
        local interval = math.random(5000, 20000)
        local boneIndex = 39317
        
        if enableTofu then
            if hours > 21 or hours < 5 then
                if DoesEntityExist(uiroMochi) then
                    local coords = GetEntityCoords(uiroMochi)
                    if not DoesEntityExist(uObject) then
                        uObject = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                        AttachEntityToEntity(uObject, uiroMochi, GetPedBoneIndex(uiroMochi, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                        DeleteObject(uObject)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                    else
                        DeleteObject(uObject)
                    end
                else
                    DeleteObject(uObject)
                end
            else
                DeleteObject(uObject)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local hours = GetClockHours()
        local interval = math.random(5000, 20000)
        local boneIndex = 39317
        
        if enableTofu then
            if hours > 21 or hours < 5 then
                if DoesEntityExist(anninTofu) then
                    local coords = GetEntityCoords(anninTofu)
                    if not DoesEntityExist(aObject) then
                        aObject = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                        AttachEntityToEntity(aObject, anninTofu, GetPedBoneIndex(anninTofu, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                        DeleteObject(aObject)
                        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                        Wait(interval)
                    else
                        DeleteObject(aObject)
                    end
                else
                    DeleteObject(aObject)
                end
            else
                DeleteObject(aObject)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if enableTofu then
            if DoesEntityExist(tofu) then

                for key, value in pairs(Config.settings) do
                    if value.invincible then
                        SetPlayerInvincibleKeepRagdollEnabled(tofu, true)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.superjump then
                        SetSuperJumpThisFrame(tofu)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.fastrun then
                        SetRunSprintMultiplierForPlayer(tofu, 1.0)
                        SetPedMoveRateOverride(tofu, 2.0)
                    else
                        SetRunSprintMultiplierForPlayer(tofu, 1.0)
                        SetPedMoveRateOverride(tofu, 2.0)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.clumsyTofus then
                        if IsPedRunning(tofu) or IsPedJumping(tofu) or IsPedSprinting(tofu) or IsEntityInAir(tofu) then
                            SetPedRagdollOnCollision(tofu, true)
                            Wait(1000)
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

        if enableTofu then
            if DoesEntityExist(flan) then

                for key, value in pairs(Config.settings) do
                    if value.invincible then
                        SetPlayerInvincibleKeepRagdollEnabled(flan, true)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.superjump then
                        SetSuperJumpThisFrame(flan)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.fastrun then
                        SetRunSprintMultiplierForPlayer(flan, 1.0)
                        SetPedMoveRateOverride(flan, 2.0)
                    else
                        SetRunSprintMultiplierForPlayer(flan, 1.0)
                        SetPedMoveRateOverride(flan, 2.0)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.clumsyTofus then
                        if IsPedRunning(flan) or IsPedJumping(flan) or IsPedSprinting(flan) or IsEntityInAir(flan) then
                            SetPedRagdollOnCollision(flan, true)
                            Wait(1000)
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

        if enableTofu then

            if DoesEntityExist(konjac) then

                for key, value in pairs(Config.settings) do
                    if value.invincible then
                        SetPlayerInvincibleKeepRagdollEnabled(konjac, true)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.superjump then
                        SetSuperJumpThisFrame(konjac)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.fastrun then
                        SetRunSprintMultiplierForPlayer(konjac, 1.0)
                        SetPedMoveRateOverride(konjac, 2.0)
                    else
                        SetRunSprintMultiplierForPlayer(konjac, 1.0)
                        SetPedMoveRateOverride(konjac, 2.0)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.clumsyTofus then
                        if IsPedRunning(konjac) or IsPedJumping(konjac) or IsPedSprinting(konjac) or IsEntityInAir(konjac) then
                            SetPedRagdollOnCollision(konjac, true)
                            Wait(1000)
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

        if enableTofu then

            if DoesEntityExist(uiroMochi) then

                for key, value in pairs(Config.settings) do
                    if value.invincible then
                        SetPlayerInvincibleKeepRagdollEnabled(uiroMochi, true)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.superjump then
                        SetSuperJumpThisFrame(uiroMochi)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.fastrun then
                        SetRunSprintMultiplierForPlayer(uiroMochi, 1.0)
                        SetPedMoveRateOverride(uiroMochi, 2.0)
                    else
                        SetRunSprintMultiplierForPlayer(uiroMochi, 1.0)
                        SetPedMoveRateOverride(uiroMochi, 2.0)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.clumsyTofus then
                        if IsPedRunning(uiroMochi) or IsPedJumping(uiroMochi) or IsPedSprinting(uiroMochi) or IsEntityInAir(uiroMochi) then
                            SetPedRagdollOnCollision(uiroMochi, true)
                            Wait(1000)
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

        if enableTofu then
            if DoesEntityExist(anninTofu) then

                for key, value in pairs(Config.settings) do
                    if value.invincible then
                        SetPlayerInvincibleKeepRagdollEnabled(anninTofu, true)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.superjump then
                        SetSuperJumpThisFrame(anninTofu)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.fastrun then
                        SetRunSprintMultiplierForPlayer(anninTofu, 1.0)
                        SetPedMoveRateOverride(anninTofu, 2.0)
                    else
                        SetRunSprintMultiplierForPlayer(anninTofu, 1.0)
                        SetPedMoveRateOverride(anninTofu, 2.0)
                    end
                end

                for key, value in pairs(Config.settings) do
                    if value.clumsyTofus then
                        if IsPedRunning(anninTofu) or IsPedJumping(anninTofu) or IsPedSprinting(anninTofu) or IsEntityInAir(anninTofu) then
                            SetPedRagdollOnCollision(anninTofu, true)
                            Wait(1000)
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
		local pedCoords = GetEntityCoords(ped)
        local radius = 2.0
        local zone = GetZoneDevant(radius)
        local target = ESX.Game.GetClosestPed(zone, {})
		local tCoords = GetEntityCoords(target)
        local bCoords = GetWorldPositionOfEntityBone(target, GetPedBoneIndex(target, 24817))
        
        if enableTofu then
            if DoesEntityExist(target) and not IsPedInAnyVehicle(target) and not IsPedAPlayer(target) and not IsPedGroupMember(target, GetPedGroupIndex(ped)) then
                local distanceCheck = #(pedCoords - tCoords)
    
                if IsPlayerNearEntity(pedCoords.x, pedCoords.y, pedCoords.z, 8.0) then
                    drawNear3D(bCoords)
                    if distanceCheck < 2.0 then
                        if IsPedRagdoll(target) then
                            drawControl3D(bCoords, "E", "Eat")
                        else
                            drawControl3D(bCoords, "E", "Bite")
                        end
                            
                        if IsControlJustReleased(0, Keys['E']) then
                            makeEntityFaceEntity(ped, target)
                            if IsPedRagdoll(target) then
                                consume(target)
                            else
                                bite(target)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function revert()
    local ped = PlayerPedId()
    SetCurrentPedWeapon(ped, -1569615261, true)
    RemoveAllPedWeapons(ped, true)
    PlaySoundFrontend(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0)
    ShowNotification("Powers ~r~disabled")
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetPedMoveRateOverride(PlayerId(), 0.0)  
    ShowHudComponentThisFrame(14)
    ShowHudComponentThisFrame(19)
    ShowHudComponentThisFrame(20)
    ShowHudComponentThisFrame(21)
    ShowHudComponentThisFrame(22)
    SetMobileRadioEnabledDuringGameplay(false)
    enableTofu = false
end

function respawnTofu(entity, blip, object)
    RemoveBlip(blip)
    DeleteEntity(entity)
    if DoesEntityExist(object) then
        DeleteObject(object)
    end
    Wait(1000)
    TriggerEvent("tofu:requestAllies")
end

function toggleFlashlight(entity, object)
    local hours = GetClockHours()
    local interval = math.random(5000, 20000)
    local boneIndex = 39317
    local flashlight
    
    if hours > 21 or hours < 5 then
        if DoesEntityExist(entity) then
            local coords = GetEntityCoords(tofu)
            if not DoesEntityExist(object) then
                flashlight = CreateObject(GetHashKey("c_flashlight"), coords.x, coords.y, coords.z,  true,  true, true)
                object = flashlight
                AttachEntityToEntity(object, entity, GetPedBoneIndex(entity, boneIndex), 0.20, 0.34, 0.20, 180.0, 0.0, -20.0, 1, 1, 0, 1, 0, 1)
                PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                Wait(interval)
                DeleteObject(object)
                PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                Wait(interval)
            else
                DeleteObject(object)
            end
        else
            DeleteObject(object)
        end
    else
        DeleteObject(object)
    end
end

function attachEntity(entity)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity, 0))
    ApplyDamageToPed(entity, 500, false)
    ResurrectPed(entity)
end

function bite(entity)
    local ped = PlayerPedId()
    local inBedDicts = "melee@unarmed@streamed_core_fps"
    local inBedAnims = "plyr_takedown_front_headbutt"
    local boneIndex = 31086
    local hurtDuration = math.random(1000, 10000)
    local pos = GetEntityForwardVector(ped)
    local multiplier = 28.0
    local bCoords = GetWorldPositionOfEntityBone(entity, GetPedBoneIndex(entity, 24817))
    LoadAnim(inBedDicts)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 10.0, 5.0, 2000, 1, 0, false, false, false)
    Wait(400)
    PlaySoundFrontend(-1, "Enemy_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset", 0)
    -- ApplyForceToEntity(entity, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
    -- attachEntity(entity)
    -- AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, boneIndex), -0.01, -0.02, 0.03, -70.0, 0, 0.0, 1, 1, 0, 1, 0, 1)
    showNonLoopParticleBone("core", "blood_chopper", entity, 3.0, 0)
    showNonLoopParticleBone("core", "scrape_blood_car", entity, 2.0, 0)
    showNonLoopParticleBone("core", "blood_entry_shotgun", entity, 1.5, 0)
    showNonLoopParticleBone("core", "ent_sht_blood", entity, 1.0, 0)
    ApplyPedDamagePack(entity, "BigRunOverByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(entity, "BigHitByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(entity, "Fall", 12.0, 0.0)
    ApplyPedDamagePack(entity, "SCR_Finale_Michael", 12.0, 0.0)
    ApplyPedDamagePack(entity, "SCR_Torture", 12.0, 0.0)
    ApplyPedDamagePack(entity, "Splashback_Face_0", 12.0, 0.0)
    ApplyPedDamagePack(entity, "td_blood_shotgun", 12.0, 0.0)
    ApplyPedBlood(entity, 3, 0.0, 0.0, 0.0, "wound_sheet")
    -- SetPedToRagdollWithFall(entity, -1, -1, 1, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    SetPedToRagdollWithFall(entity, -1, -1, 1, -GetEntityForwardVector(entity), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    -- Wait(hurtDuration)
    -- ApplyDamageToPed(entity, 500, false)
    -- DeleteEntity(entity)
end

function consume(entity)
    local ped = PlayerPedId()
    local inBedDicts = "melee@unarmed@streamed_core_fps"
    local inBedAnims = "plyr_takedown_front_headbutt"
    local boneIndex = 31086
    local bCoords = GetWorldPositionOfEntityBone(entity, GetPedBoneIndex(entity, 24817))
    LoadAnim(inBedDicts)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 10.0, 5.0, 2000, 1, 0, false, false, false)
    Wait(400)
    -- attachEntity(entity)
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, boneIndex), 0.0, 0.0, 0.0, 90.0, 0, 0.0, 1, 1, 0, 1, 0, 1)
    showNonLoopParticleBone("core", "blood_chopper", entity, 3.0, 0)
    showNonLoopParticleBone("core", "scrape_blood_car", entity, 2.0, 0)
    showNonLoopParticleBone("core", "blood_entry_shotgun", entity, 1.5, 0)
    showNonLoopParticleBone("core", "ent_sht_blood", entity, 1.0, 0)
    ApplyPedDamagePack(entity, "BigRunOverByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(entity, "BigHitByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(entity, "Fall", 12.0, 0.0)
    ApplyPedDamagePack(entity, "SCR_Finale_Michael", 12.0, 0.0)
    ApplyPedDamagePack(entity, "SCR_Torture", 12.0, 0.0)
    ApplyPedDamagePack(entity, "Splashback_Face_0", 12.0, 0.0)
    ApplyPedDamagePack(entity, "td_blood_shotgun", 12.0, 0.0)
    ApplyPedBlood(entity, 3, 0.0, 0.0, 0.0, "wound_sheet")
    Wait(400)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
    ApplyDamageToPed(entity, 500, false)
    DeleteEntity(entity)
    SetEntityHealth(ped, 200)
end

function spawnTofu(string)
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local ph = GetEntityHeading(ped)
    local hash = GetEntityModel(ped)
    local model = ""
    local blipName = ""
    local weapon
    local initalHealth = 1000
    local initalArmor = 0
    local particleDict = "core"
    local particleName = "bul_rubber_dust"
    local distanceToPlayer = 0
    local spawnRnd = math.random(0, 20)

    if spawnRnd >= 10 then
        distanceToPlayer = 1.0
    else
        distanceToPlayer = -1.0
    end
    
    if string == "tofu" then
        if not DoesEntityExist(tofu) then
            model = "tofu"
            textShow = "~b~Tofu"
            blipName = "Tofu"
            weapon = -1768145561
            blipColor = 62
            
            if not DoesEntityExist(tofu) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            tofu = CreatePed(4, model, x+distanceToPlayer, y+distanceToPlayer, z-1.0, ph, true, true)
            bBlip = AddBlipForEntity(tofu)
        
            SetEntityHealth(tofu, initalHealth)
            SetPedArmour(tofu, initalArmor)
            SetBlipSprite(bBlip, 1)
            SetBlipColour(bBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(bBlip)
            SetBlipAsShortRange(bBlip, false)            

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(tofu, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(tofu, 2, 1, 0, 0)
                end
            end

            SetPedComponentVariation(tofu, 3, 0, 0, 0)
            -- GiveWeaponToPed(tofu, weapon, 99, false, true)
        
            showNonLoopParticle(particleDict, particleName, tofu, 12.0)
            SetBlockingOfNonTemporaryEvents(tofu, false)
            SetEntityInvincible(tofu, false)
            SetPedCanBeTargettedByPlayer(tofu, ped, true)
            SetEntityAsMissionEntity(tofu, false, false)
            SetPedAsGroupMember(tofu, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
            SetPedToRagdollWithFall(tofu, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    elseif string == "flan" then
        if not DoesEntityExist(flan) then
            model = "flan"
            textShow = "~b~Flan"
            blipName = "Flan"
            weapon = -1355376991
            blipColor = 28
            
            if not DoesEntityExist(flan) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            flan = CreatePed(4, model, x+distanceToPlayer, y+distanceToPlayer, z-1.0, ph, true, true)
            rBlip = AddBlipForEntity(flan)
        
            SetEntityHealth(flan, initalHealth)
            SetPedArmour(flan, initalArmor)
            SetBlipSprite(rBlip, 1)
            SetBlipColour(rBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(rBlip)
            SetBlipAsShortRange(rBlip, false)           

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(flan, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(flan, 2, 1, 0, 0)
                end
            end
            
            SetPedComponentVariation(flan, 3, 0, 0, 0)
            -- GiveWeaponToPed(flan, weapon, 99, false, true)
        
            showNonLoopParticle(particleDict, particleName, flan, 12.0)
            SetBlockingOfNonTemporaryEvents(flan, false)
            SetEntityInvincible(flan, false)
            SetPedCanBeTargettedByPlayer(flan, ped, true)
            SetEntityAsMissionEntity(flan, false, false)
            SetPedAsGroupMember(flan, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
            SetPedToRagdollWithFall(flan, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    elseif string == "konjac" then
        if not DoesEntityExist(konjac) then
            model = "konjac"
            textShow = "~b~Konjac"
            blipName = "Konjac"
            weapon = 1198256469
            blipColor = 40
            
            if not DoesEntityExist(konjac) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            konjac = CreatePed(4, model, x+distanceToPlayer, y+distanceToPlayer, z-1.0, ph, true, true)
            bBlip = AddBlipForEntity(konjac)
        
            SetEntityHealth(konjac, initalHealth)
            SetPedArmour(konjac, initalArmor)
            SetBlipSprite(bBlip, 1)
            SetBlipColour(bBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(bBlip)
            SetBlipAsShortRange(bBlip, false)           

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(konjac, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(konjac, 2, 1, 0, 0)
                end
            end
            
            SetPedComponentVariation(konjac, 3, 0, 0, 0)
            -- GiveWeaponToPed(konjac, weapon, 99, false, true)
        
            showNonLoopParticle(particleDict, particleName, konjac, 12.0)
            SetBlockingOfNonTemporaryEvents(konjac, false)
            SetPedCanBeTargettedByPlayer(konjac, ped, true)
            SetEntityAsMissionEntity(konjac, false, false)
            SetPedAsGroupMember(konjac, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
            SetPedToRagdollWithFall(konjac, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    elseif string == "uiroMochi" then        
        if not DoesEntityExist(uiroMochi) then
            model = "uiro-mochi"
            textShow = "~b~Uiro Mochi"
            blipName = "Uiro Mochi"
            weapon = -1238556825
            blipColor = 52
            
            if not DoesEntityExist(uiroMochi) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            uiroMochi = CreatePed(4, model, x+distanceToPlayer, y+distanceToPlayer, z-1.0, ph, true, true)
            yBlip = AddBlipForEntity(uiroMochi)
        
            SetEntityHealth(uiroMochi, initalHealth)
            SetPedArmour(uiroMochi, initalArmor)
            SetBlipSprite(yBlip, 1)
            SetBlipColour(yBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(yBlip)
            SetBlipAsShortRange(yBlip, false)           

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(uiroMochi, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(uiroMochi, 2, 1, 0, 0)
                end
            end
            
            SetPedComponentVariation(uiroMochi, 3, 0, 0, 0)
            -- GiveWeaponToPed(uiroMochi, weapon, 99, false, true)
        
            showNonLoopParticle(particleDict, particleName, uiroMochi, 12.0)
            SetBlockingOfNonTemporaryEvents(uiroMochi, false)
            SetPedCanBeTargettedByPlayer(uiroMochi, ped, true)
            SetEntityAsMissionEntity(uiroMochi, false, false)
            SetPedAsGroupMember(uiroMochi, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
            SetPedToRagdollWithFall(uiroMochi, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    elseif string == "anninTofu" then
        if not DoesEntityExist(anninTofu) then
            model = "annin-tofu"
            textShow = "~b~Annin Tofu"
            blipName = "Annin Tofu"
            weapon = 2138347493
            blipColor = 0
            
            if not DoesEntityExist(anninTofu) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            anninTofu = CreatePed(4, model, x+distanceToPlayer, y+distanceToPlayer, z-1.0, ph, true, true)
            pBlip = AddBlipForEntity(anninTofu)
        
            SetEntityHealth(anninTofu, initalHealth)
            SetPedArmour(anninTofu, initalArmor)
            SetBlipSprite(pBlip, 1)
            SetBlipColour(pBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(pBlip)
            SetBlipAsShortRange(pBlip, false)           

            for key, value in pairs(Config.settings) do
                if value.wearHat then
                    SetPedComponentVariation(anninTofu, 2, 0, 0, 0)
                else
                    SetPedComponentVariation(anninTofu, 2, 1, 0, 0)
                end
            end
            
            SetPedComponentVariation(anninTofu, 3, 0, 0, 0)
            -- GiveWeaponToPed(anninTofu, weapon, 99, false, true)
        
            showNonLoopParticle(particleDict, particleName, anninTofu, 12.0)
            SetBlockingOfNonTemporaryEvents(anninTofu, false)
            SetPedCanBeTargettedByPlayer(anninTofu, ped, true)
            SetEntityAsMissionEntity(anninTofu, false, false)
            SetPedAsGroupMember(anninTofu, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
            SetPedToRagdollWithFall(anninTofu, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    end    
    PlaySoundFrontend(-1, "QUIT_WHOOSH", "HUD_MINI_GAME_SOUNDSET", 0)
end

function removeTofus()

    if DoesEntityExist(tofu) then
        DeleteEntity(tofu)
        RemoveBlip(bBlip)
    end
    
    if DoesEntityExist(flan) then
        DeleteEntity(flan)
        RemoveBlip(rBlip)
    end
    
    if DoesEntityExist(konjac) then
        DeleteEntity(konjac)
        RemoveBlip(blBlip)
    end
    
    if DoesEntityExist(uiroMochi) then
        DeleteEntity(uiroMochi)
        RemoveBlip(yBlip)
    end
    
    if DoesEntityExist(anninTofu) then
        DeleteEntity(anninTofu)
        RemoveBlip(pBlip)
    end
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

function GetZoneDevant(radius)
    local backwardPosition = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, radius, 0.0)
	return backwardPosition
end

function default()
    local ped = PlayerPedId()
    SetPlayerLockon(PlayerId(), false)
    ToggleStealthRadar(true)
    SetFollowPedCamViewMode(2)
    HudForceWeaponWheel(false)
    RestorePlayerStamina(PlayerId(), 1.0)
    DisableControlAction(0, Keys['V'], true)
    DisableControlAction(0, Keys['TAB'], true)
    -- RemoveAllPedWeapons(ped, true)
    SetPedArmour(ped, 100)
    SetMobileRadioEnabledDuringGameplay(true)
    SetPlayerCanUseCover(PlayerId(), false)
    SetFlashLightKeepOnWhileMoving(true)
    
    if IsPedSwimmingUnderWater(ped) then
        SetEnableScuba(ped, true)
        SetPedMaxTimeUnderwater(ped, 9999.99)
    end

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

    ShowHudComponentThisFrame(14)
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(20)
    HideHudComponentThisFrame(21)
    HideHudComponentThisFrame(22)
end

local Models = {
	"tofu",
	"flan",
	"konjac",
	"uiro-mochi",
	"annin-tofu"
}

function changeModel()
    EntityModel = Models[math.random(1, #Models)]
    EntityModel = string.upper(EntityModel)
    SetMonModel(EntityModel)
end

function SetMonModel(name)
    local model = name
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end
end

function toggleUI(display, battery)
    SendNUIMessage({
        type = "ui",
        display = display,
        battery = battery
    })
end

function drawText3D(coords, text, text2, text3)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local fontSize = 0.25

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString("Vital Signs: "..text)
    DrawText(_x+0.04, _y)

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString("Type: "..text2)
    DrawText(_x+0.04, _y+0.015)

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString("Gender: "..text3)
    DrawText(_x+0.04, _y+0.03)

    if not HasStreamedTextureDictLoaded("CommonMenu") then
        RequestStreamedTextureDict("CommonMenu", false)
    else
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.07, _y-0.022, 0.072, 0.02, 0.1, 209, 133, 33, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.07, _y+0.025, 0.072, 0.076, 0.1, 0, 0, 0, 155)

        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.09, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.095, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.1, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        -- DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.056, _y+0.07, 0.01, 0.004, 0.1, 255, 255, 255, 200)
    end
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function controlPrompt(str1, str2)
    local displayText = str1.." "..str2
    ESX.ShowHelpNotification(displayText)
end

function makeEntityFaceEntity(player, entity)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(entity, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function ShowNotification(text)
    for key, value in pairs(Config.settings) do
        if value.notifications then    
            SetNotificationTextEntry("STRING")
            AddTextComponentString(text)
            DrawNotification(false, false)
        end
    end
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function tofuDive()
    local ped = PlayerPedId()
    local inBedDicts = "move_strafe@roll_fps"
    local inBedAnims = "combatroll_fwd_p1_00"
    local inBedDicts2 = "move_climb"
    local inBedAnims2 = "clamberpose_to_dive"

    local pos = GetEntityForwardVector(ped)
    local multiplier = 12.0
    
    LoadAnim(inBedDicts)
    LoadAnim(inBedDicts2)
    
    PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 0)


    if not IsEntityPlayingAnim(ped, inBedDicts2, inBedAnims2, 3) then
        TaskPlayAnim(ped, inBedDicts2, inBedAnims2, 4.0, 8.0, 800, 0, 0, false, false, false)
        Wait(400)    
        rolling = true
        ApplyForceToEntity(ped, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
        Wait(300)
        -- SetPedToRagdoll(ped, 1000, 1000, 0, true, true, true)
        SetPedToRagdollWithFall(ped, 1000, 1000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        -- if not IsEntityPlayingAnim(ped, inBedDicts, inBedAnims, 3) then
        --     TaskPlayAnim(ped, inBedDicts, inBedAnims, 3.0, 4.0, 1000, 0, 0, false, false, false)
        -- end
    end
    Wait(500)
    rolling = false
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.2, 0.2)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)

		
		if not HasStreamedTextureDictLoaded("commonmenu") or not HasStreamedTextureDictLoaded("mpawards1") then
			RequestStreamedTextureDict("commonmenu", false)
			RequestStreamedTextureDict("mpawards1", false)
		else
			DrawSprite("commonmenu", "gradient_bgd", _x, _y-0.001, 0.031, 0.04, 0.1, 0, 0, 0, 255, 0)
			DrawSprite("mpawards1", "blowupenemiesusingcarbombs", _x, _y-0.008, 0.01, 0.017, 0.1, 255, 255, 255, 200, 0)
		end
	end
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

function IsPlayerNearEntity(x, y, z, radius)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < radius then
        return true
    end
end

function showNonLoopParticle(dict, particleName, ped, scale)
    local boneIndex = 24818
    local pBone = GetPedBoneIndex(ped, boneIndex)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(particleHandle, 0, 255, 0 ,0)
    return StartNetworkedParticleFxNonLoopedOnEntityBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, pBone, scale, false, false, false)
end

function showNonLoopAtCoords(dict, particleName, x, y, z, rotx, roty, rotz, scale)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(particleName, 0, 255, 0 ,0)
    return StartNetworkedParticleFxNonLoopedAtCoord(particleName, x, y, z, rotx, roty, rotz, scale, false, false, false)
end

function showNonLoopParticleBone(dict, particleName, ped, scale, bone)
    local pBone = bone

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    return StartNetworkedParticleFxNonLoopedOnEntityBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(ped, pBone), scale, false, false, false)
end

function drawControl3D(coords, str1, str2)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local fontSize = 0.35

    SetTextScale(0.3, 0.3)
    SetTextFont(2)
    SetTextProportional(1)
    SetTextCentre(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString(str1)
    DrawText(_x, _y-0.0105)

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    AddTextComponentString(str2)
    DrawText(_x+0.01, _y-0.012)

    local tDict = "mpinventory"

    if not HasStreamedTextureDictLoaded(tDict) then
        RequestStreamedTextureDict(tDict, false)
    else
        DrawSprite(tDict, "in_world_circle", _x, _y, 0.018, 0.031, 0.1, 255, 255, 255, 50)
        DrawSprite(tDict, "in_world_circle", _x, _y, 0.016, 0.027, 0.1, 0, 0, 0, 255)
    end
end

function drawNear3D(coords)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local fontSize = 0.35
    
    local tDict = "mpinventory"

    if not HasStreamedTextureDictLoaded(tDict) then
        RequestStreamedTextureDict(tDict, false)
    else
        DrawSprite(tDict, "in_world_circle", _x, _y, 0.009, 0.017, 0.1, 255, 255, 255, 50)
        DrawSprite(tDict, "in_world_circle", _x, _y, 0.007, 0.013, 0.1, 0, 0, 0, 255)
    end
end
