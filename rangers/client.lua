
-- -- GLOBAL VARIABLES DECLARATION
-- ----------------------------------------------------------------------------------------------------

local canteen
local bRanger, rRanger, blRanger, yRanger, pRanger
local bBlip, rBlip, blBlip, yBlip, pbBlip

local bRangerModelHash = -1314526475
local rRangerModelHash = -1512385136
local blRangerModelHash = -560807755
local yRangerModelHash = 1866519084
local pRangerModelHash = 1891202321

local drinking = false
local thermal = false
local diplayHudTimer = 0

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

local Weather = {
	"FOGGY",
	"RAIN",
	-- "THUNDER",
}

local Time = {
	19.00,
	23.00
}

RegisterNetEvent('rangers:requestAllies')
AddEventHandler('rangers:requestAllies', function()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local ph = GetEntityHeading(ped)
    local hash = GetEntityModel(ped)
    local model = ""
    local blipName = ""
    local weapon
    
    if hash == bRangerModelHash then
        spawnRanger("red")
        spawnRanger("black")
        spawnRanger("yellow")
        spawnRanger("pink")
    elseif hash == rRangerModelHash then
        spawnRanger("blue")
        spawnRanger("black")
        spawnRanger("yellow")
        spawnRanger("pink")
    elseif hash == blRangerModelHash then
        spawnRanger("blue")
        spawnRanger("red")
        spawnRanger("yellow")
        spawnRanger("pink")
    elseif hash == yRangerModelHash then
        spawnRanger("blue")
        spawnRanger("red")
        spawnRanger("black")
        spawnRanger("pink")
    elseif hash == pRangerModelHash then
        spawnRanger("blue")
        spawnRanger("red")
        spawnRanger("black")
        spawnRanger("yellow")
    end
end)

RegisterNetEvent('rangers:getIdentifier')
AddEventHandler('rangers:getIdentifier', function(val)
    local ped = PlayerPedId()
    local weapon
    local weather = Weather[math.random(1, #Weather)]
    local time = Time[math.random(1, #Time)]

    if val == "steam:110000104b59124" then
        if not enableRangerPowers then
            SetOverrideWeather(weather)
            SetClockTime(19, 0, 0)
            PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 0)
            changeModel()
            local ped = PlayerPedId()
            local hash = GetEntityModel(ped)
            SetPedDefaultComponentVariation(ped)
            
            if hash == bRangerModelHash then
                weapon = -1768145561
                SetPedComponentVariation(ped, 9, 1, 0, 0)
                GiveWeaponToPed(ped, weapon, 99, false, true)
            elseif hash == rRangerModelHash then
                weapon = -1355376991
                SetPedComponentVariation(ped, 9, 1, 0, 0)
                GiveWeaponToPed(ped, weapon, 99, false, true)
            elseif hash == blRangerModelHash then
                weapon = 1198256469
                SetPedComponentVariation(ped, 9, 0, 0, 0)
                GiveWeaponToPed(ped, weapon, 99, false, true)
            elseif hash == yRangerModelHash then
                weapon = -1238556825
                SetPedComponentVariation(ped, 9, 0, 0, 0)
                GiveWeaponToPed(ped, weapon, 99, false, true)
            elseif hash == pRangerModelHash then
                weapon = 2138347493
                SetPedComponentVariation(ped, 9, 1, 0, 0)
                GiveWeaponToPed(ped, weapon, 99, false, true)
            end

            SetEntityHealth(ped, 1000)
            SetPedArmour(ped, 1000)
            enableRangerPowers = true
            Citizen.Wait(400)
            PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 0)
            TriggerEvent("rangers:requestAllies")
            -- TriggerEvent("zombie:trigger", true)
            visor = true            
        else
            removeRangers()
            revert()
        end
    else
        PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
        ShowNotification("Model not ~b~Authorized")
        print(val)
    end    
end)

RegisterCommand('rangers', function()
	local _source = source
    TriggerServerEvent('rangers:extractIdentifiers', _source)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local radius = 12.0
        local zone = GetZoneDevant(radius)
        local target = ESX.Game.GetClosestPed(zone, {})
        local tCoords = GetWorldPositionOfEntityBone(target, GetPedBoneIndex(target, 24817))
        local tVitals, tType, tGender = "", "", ""

        if enableRangerPowers then 
            local boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 24817))   
            
            if HasEntityBeenDamagedByWeapon(ped, 453432689, GetWeapontypeModel(453432689)) then
                SetPedToRagdollWithFall(ped, 2000, 2000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                ShowNotification("You have been shot")
            end
                    
            if not IsPedHuman(target) then
                tType = "~g~Animal"
            else
                tType = "~o~Human"
            end

            if not IsPedMale(target) then
                tGender = "~o~Female"
            else
                tGender = "~b~Male"
            end

            if not IsEntityDead(target) then
                local tHealth = GetEntityHealth(target)
                local hPercent = tHealth/10
                if tHealth >= 150 then
                    tVitals = "~g~Normal: "..hPercent.."%"
                elseif tHealth < 150 then
                    tVitals = "~o~Critical: "..hPercent.."%"
                end
            else
                tVitals = "~r~Deceased"
            end

            if IsPlayerNearEntity(tCoords.x, tCoords.y, tCoords.z, 5.0) then

                if not IsPedAPlayer(target) then
                    drawHoloGram(tCoords.x, tCoords.y, tCoords.z)
                    drawText3D(boneCoords, tVitals, tType, tGender)
                end
            end

            if DoesEntityExist(bRanger) then
                -- if not IsEntityDead(target) and not IsPedGroupMember(target) then
                --     TaskCombatPed(bRanger, target, 1, 1)
                -- end
                local pCoords = GetEntityCoords(bRanger)
                if IsEntityDead(bRanger) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) then
                    RemoveBlip(bBlip)
                    DeleteEntity(bRanger)
                    Wait(1000)
                    TriggerEvent("rangers:requestAllies")
                end
            end

            if DoesEntityExist(rRanger) then
                -- if not IsEntityDead(target) and not IsPedGroupMember(target) then
                --     TaskCombatPed(rRanger, target, 1, 1)
                -- end
                local pCoords = GetEntityCoords(rRanger)
                if IsEntityDead(rRanger) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) then
                    RemoveBlip(rBlip)
                    DeleteEntity(rRanger)
                    Wait(1000)
                    TriggerEvent("rangers:requestAllies")
                end
            end

            if DoesEntityExist(blRanger) then
                -- if not IsEntityDead(target) and not IsPedGroupMember(target) then
                --     TaskCombatPed(blRanger, target, 1, 1)
                -- end
                local pCoords = GetEntityCoords(blRanger)
                if IsEntityDead(blRanger) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) then
                    RemoveBlip(blBlip)
                    DeleteEntity(blRanger)
                    Wait(1000)
                    TriggerEvent("rangers:requestAllies")
                end
            end

            if DoesEntityExist(yRanger) then
                -- if not IsEntityDead(target) and not IsPedGroupMember(target) then
                --     TaskCombatPed(yRanger, target, 1, 1)
                -- end
                local pCoords = GetEntityCoords(yRanger)
                if IsEntityDead(yRanger) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) then
                    RemoveBlip(yBlip)
                    DeleteEntity(yRanger)
                    Wait(1000)
                    TriggerEvent("rangers:requestAllies")
                end
            end

            if DoesEntityExist(pRanger) then
                -- if not IsEntityDead(target) and not IsPedGroupMember(target) then
                --     TaskCombatPed(pRanger, target, 1, 1)
                -- end
                local pCoords = GetEntityCoords(pRanger)
                if IsEntityDead(pRanger) or not IsPlayerNearEntity(pCoords.x, pCoords.y, pCoords.z, 32.0) then
                    RemoveBlip(pBlip)
                    DeleteEntity(pRanger)
                    Wait(1000)
                    TriggerEvent("rangers:requestAllies")
                end
            end

            if IsEntityDead(ped) then
                revert()
                removeRangers()
                enableRangerPowers = false
                visor = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enableRangerPowers then

            default()

            if IsPedFalling(ped) or IsEntityInAir(ped) then
                SetPedRagdollOnCollision(ped, true)
            end

            if IsPedRagdoll(ped) then
                if not visor then
                    SetPedComponentVariation(ped, 6, 0, 0, 0)
                    visor = true
                    showNonLoopParticleBone("core", "ent_dst_elec_fire_sp", ped, 1.0, 31086) 
                    PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 0)
                end
            end
            
            if visor then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        if enableRangerPowers then
            
            if DoesEntityExist(bRanger) and not IsPedInjured(bRanger) and not IsPedRagdoll(bRanger) and not IsPedClimbing(bRanger) and not IsPedGettingUp(bRanger) then
                local bHealth = GetEntityHealth(bRanger)
                local minHealth = 800

                if bHealth < minHealth then
                    toggleVisorManual(bRanger, false)
                    drinkSerum(bRanger)
                    toggleVisorManual(bRanger, true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        if enableRangerPowers then

            if DoesEntityExist(rRanger) and not IsPedInjured(rRanger) and not IsPedRagdoll(rRanger) and not IsPedClimbing(rRanger) and not IsPedGettingUp(rRanger) then
                local rHealth = GetEntityHealth(rRanger)  
                local minHealth = 800

                if rHealth < minHealth then
                    toggleVisorManual(rRanger, false)
                    drinkSerum(rRanger)
                    toggleVisorManual(rRanger, true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        if enableRangerPowers then
            
            if DoesEntityExist(blRanger) and not IsPedInjured(blRanger) and not IsPedRagdoll(blRanger) and not IsPedClimbing(blRanger) and not IsPedGettingUp(blRanger) then
                local blHealth = GetEntityHealth(blRanger)
                local minHealth = 800
            
                if blHealth < minHealth then
                    toggleVisorManual(blRanger, false)
                    drinkSerum(blRanger)
                    toggleVisorManual(blRanger, true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        if enableRangerPowers then
            
            if DoesEntityExist(yRanger) and not IsPedInjured(yRanger) and not IsPedRagdoll(yRanger) and not IsPedClimbing(yRanger) and not IsPedGettingUp(yRanger) then
                local yHealth = GetEntityHealth(yRanger)
                local minHealth = 800
            
                if yHealth < minHealth then
                    toggleVisorManual(yRanger, false)
                    drinkSerum(yRanger)
                    toggleVisorManual(yRanger, true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        if enableRangerPowers then
            
            if DoesEntityExist(pRanger) and not IsPedInjured(pRanger) and not IsPedRagdoll(pRanger) and not IsPedClimbing(pRanger) and not IsPedGettingUp(pRanger) then
                local pHealth = GetEntityHealth(pRanger)
                local minHealth = 800
            
                if pHealth < minHealth then
                    toggleVisorManual(pRanger, false)
                    drinkSerum(pRanger)
                    toggleVisorManual(pRanger, true)
                end
            end
        end
    end
end)

local prevHealth = GetEntityHealth(PlayerPedId())

Citizen.CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        
        if enableRangerPowers then
            local hasBeenDamagedByWeapon = HasPedBeenDamagedByWeapon(ped, 0, 2)

            if hasBeenDamagedByWeapon then
                SetPedToRagdollWithFall(ped, 1300, 1300, 3, false, false, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
        local hash = GetEntityModel(ped)

        if enableRangerPowers then
            if IsControlJustReleased(0, Keys['G']) and not IsPedRagdoll(ped) and not IsEntityDead(ped) then
                if not IsPedInVehicle(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) and not IsPedSwimmingUnderWater(ped) then
                    if not visor then
                        toggleVisorManual(ped, true)
                    else
                        toggleVisorManual(ped, false)
                    end
                end
            end

            if IsControlJustReleased(0, Keys['H']) and not IsPedRagdoll(ped) then
                if visor and not drinking and not IsPedGettingUp(ped) then
                    if not thermal then
                        toggleThermal()
                        SetSeethrough(true)
                        thermal = true
                    else
                        toggleThermal()
                        SetSeethrough(false)
                        thermal = false
                    end
                end
            end

            if IsControlJustReleased(0, Keys['U']) then
                local currHealth = GetEntityHealth(ped)

                if currHealth < 200 then
                    if not IsPedRagdoll(ped) and not IsPedFalling(ped) and not IsEntityInAir(ped) and not IsPedClimbing(ped) and not IsPedGettingUp(ped) then
                        if not visor then
                            drinkSerum(ped)
                        else
                            ShowNotification("Take off your Visor first")
                        end
                    end
                end
            end

        end        
	end
end)

RegisterNetEvent('rangers:proximityTimer')
AddEventHandler('rangers:proximityTimer', function(num)
    diplayHudTimer = num

	Citizen.CreateThread(function()
        if displayHeadUI and diplayHudTimer > 0 then -- round timer start 
            while diplayHudTimer > 0 and not IsEntityDead(PlayerPedId()) do
                Citizen.Wait(1000)
                diplayHudTimer = diplayHudTimer - 1
            end
    
            if diplayHudTimer == 0 then
                displayHeadUI = false
            end
        else
            return
        end
	end)
end)

function revert()
    local ped = PlayerPedId()
    TriggerEvent("zombie:trigger", false)
    SetOverrideWeather("EXTRASUNNY")
    SetClockTime(13, 0, 0)
    SetCurrentPedWeapon(ped, -1569615261, true)
    RemoveAllPedWeapons(ped, true)
    SetPedComponentVariation(ped, 6, 1, 0, 0)
    PlaySoundFrontend(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0)
    ShowNotification("Powers ~b~disabled")
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetPedMoveRateOverride(PlayerId(), 0.0)    
    ShowHudComponentThisFrame(14)
    ShowHudComponentThisFrame(19)
    ShowHudComponentThisFrame(20)
    ShowHudComponentThisFrame(21)
    ShowHudComponentThisFrame(22)
    enableRangerPowers = false
    thermal = false
    visor = false
end


function drinkSerum(entity)
    local ped = PlayerPedId()
    local hash = GetEntityModel(entity)
    local x, y, z = table.unpack(GetEntityCoords(entity))
    local dic = "amb@code_human_wander_mobile@male@enter"
    local anim = "enter"
    local dic2 = "mini@sprunk"
    local anim2 = "plyr_buy_drink_pt2"
    local anim3 = "plyr_buy_drink_pt3"
    local flag = 48
    local propName = "prop_cs_spray_can"
    local boneIndex = 57005
    local fullHealth = 1000
    local weapon

    if hash == bRangerModelHash then
        weapon = -1768145561
    elseif hash == rRangerModelHash then
        weapon = -1355376991
    elseif hash == blRangerModelHash then
        weapon = 1198256469
    elseif hash == yRangerModelHash then
        weapon = -1238556825
    elseif hash == pRangerModelHash then
        weapon = 2138347493
    end

    if not IsPedAPlayer(entity) then
        LoadAnim(dic)
        TaskPlayAnim(entity, dic, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
        RemoveWeaponFromPed(entity, weapon)
        Wait(1500)
        canteen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
        AttachEntityToEntity(canteen, entity, GetPedBoneIndex(entity, boneIndex), 0.15, -0.01, -0.03, -80.0, -100.0, 0, 1, 1, 0, 1, 0, 1)
        Wait(500)
        showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
        Wait(500)
        LoadAnim(dic2)
        TaskPlayAnim(entity, dic2, anim2, 2.0, 2.0, -1, flag, 0, false, false, false)
        Wait(1200)
        TaskPlayAnim(entity, dic2, anim3, 2.0, 2.0, 1000, flag, 0, false, false, false)
        SetEntityHealth(entity, fullHealth)
        Wait(880)
        DetachEntity(canteen, true, true)
        Wait(1000)
        showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
        Wait(200)
        DeleteObject(canteen)
        GiveWeaponToPed(entity, weapon, 99, false, true)
    else
        if not drinking then
            drinking = true
            LoadAnim(dic)
            SetCurrentPedWeapon(entity, -1569615261, true)
            TaskPlayAnim(entity, dic, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
        
            Wait(1500)
            canteen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
            AttachEntityToEntity(canteen, entity, GetPedBoneIndex(entity, boneIndex), 0.15, -0.01, -0.03, -80.0, -100.0, 0, 1, 1, 0, 1, 0, 1)
            Wait(500)
            showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
            Wait(500)
            LoadAnim(dic2)
            TaskPlayAnim(entity, dic2, anim2, 2.0, 2.0, -1, flag, 0, false, false, false)
            Wait(1200)
            TaskPlayAnim(entity, dic2, anim3, 2.0, 2.0, 1000, flag, 0, false, false, false)
            SetEntityHealth(entity, fullHealth)
            Wait(880)
            DetachEntity(canteen, true, true)
            Wait(1000)
            showNonLoopParticle("core", "ent_sht_electrical_box", canteen, 0.5)
            Wait(200)
            DeleteObject(canteen)
            drinking = false
            SetCurrentPedWeapon(entity, weapon, true)
        end
    end
end

function toggleThermal()
    local ped = PlayerPedId()
    local inBedDicts = "random@arrests"
    local inBedAnims = "generic_radio_chatter"
    LoadAnim(inBedDicts)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 8.0, 8.0, -1, 48, 1, false, false, false)
    Citizen.Wait(400)
    ClearPedTasks(ped)
end

function spawnRanger(string)
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local ph = GetEntityHeading(ped)
    local hash = GetEntityModel(ped)
    local model = ""
    local blipName = ""
    local weapon
    local initalHealth = 1000
    local initalArmor = 0
    
    if string == "blue" then
        if not DoesEntityExist(bRanger) then
            model = "tofu"
            textShow = "~b~Blue Ranger"
            blipName = "Blue Ranger"
            weapon = -1768145561
            blipColor = 38
            
            if not DoesEntityExist(bRanger) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            bRanger = CreatePed(4, model, x+3.0, y+3.0, z-1.0, ph, true, true)
            bBlip = AddBlipForEntity(bRanger)
            SetPedComponentVariation(bRanger, 9, 1, 0, 0)
        
            SetEntityHealth(bRanger, initalHealth)
            SetPedArmour(bRanger, initalArmor)
            SetBlipSprite(bBlip, 1)
            SetBlipColour(bBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(bBlip)
            SetBlipAsShortRange(bBlip, false)
            SetPedComponentVariation(bRanger, 6, 0, 0, 0)
            GiveWeaponToPed(bRanger, weapon, 99, false, true)
        
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", bRanger, 12.0)
            SetBlockingOfNonTemporaryEvents(bRanger, false)
            SetEntityInvincible(bRanger, false)
            SetPedCanBeTargettedByPlayer(bRanger, ped, true)
            SetEntityAsMissionEntity(bRanger, false, false)
            SetPedAsGroupMember(bRanger, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
        end
    elseif string == "red" then
        if not DoesEntityExist(rRanger) then
            model = "red-ranger"
            textShow = "~b~Red Ranger"
            blipName = "Red Ranger"
            weapon = -1355376991
            blipColor = 6
            
            if not DoesEntityExist(rRanger) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            rRanger = CreatePed(4, model, x+3.0, y+3.0, z-1.0, ph, true, true)
            rBlip = AddBlipForEntity(rRanger)
            SetPedComponentVariation(rRanger, 9, 1, 0, 0)
        
            SetEntityHealth(rRanger, initalHealth)
            SetPedArmour(rRanger, initalArmor)
            SetBlipSprite(rBlip, 1)
            SetBlipColour(rBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(rBlip)
            SetBlipAsShortRange(rBlip, false)
            SetPedComponentVariation(rRanger, 6, 0, 0, 0)
            GiveWeaponToPed(rRanger, weapon, 99, false, true)
        
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", rRanger, 12.0)
            SetBlockingOfNonTemporaryEvents(rRanger, false)
            SetEntityInvincible(rRanger, false)
            SetPedCanBeTargettedByPlayer(rRanger, ped, true)
            SetEntityAsMissionEntity(rRanger, false, false)
            SetPedAsGroupMember(rRanger, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
        end
    elseif string == "black" then
        if not DoesEntityExist(blRanger) then
            model = "black-ranger"
            textShow = "~b~Black Ranger"
            blipName = "Black Ranger"
            weapon = 1198256469
            blipColor = 72
            
            if not DoesEntityExist(blRanger) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            blRanger = CreatePed(4, model, x+3.0, y+3.0, z-1.0, ph, true, true)
            bBlip = AddBlipForEntity(blRanger)
            SetPedComponentVariation(blRanger, 9, 0, 0, 0)
        
            SetEntityHealth(blRanger, initalHealth)
            SetPedArmour(blRanger, initalArmor)
            SetBlipSprite(bBlip, 1)
            SetBlipColour(bBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(bBlip)
            SetBlipAsShortRange(bBlip, false)
            SetPedComponentVariation(blRanger, 6, 0, 0, 0)
            GiveWeaponToPed(blRanger, weapon, 99, false, true)
        
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", blRanger, 12.0)
            SetBlockingOfNonTemporaryEvents(blRanger, false)
            SetEntityInvincible(blRanger, false)
            SetPedCanBeTargettedByPlayer(blRanger, ped, true)
            SetEntityAsMissionEntity(blRanger, false, false)
            SetPedAsGroupMember(blRanger, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
        end
    elseif string == "yellow" then        
        if not DoesEntityExist(yRanger) then
            model = "yellow-ranger"
            textShow = "~b~Yellow Ranger"
            blipName = "Yellow Ranger"
            weapon = -1238556825
            blipColor = 5
            
            if not DoesEntityExist(yRanger) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            yRanger = CreatePed(4, model, x+3.0, y+3.0, z-1.0, ph, true, true)
            yBlip = AddBlipForEntity(yRanger)
            SetPedComponentVariation(yRanger, 9, 0, 0, 0)
        
            SetEntityHealth(yRanger, initalHealth)
            SetPedArmour(yRanger, initalArmor)
            SetBlipSprite(yBlip, 1)
            SetBlipColour(yBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(yBlip)
            SetBlipAsShortRange(yBlip, false)
            SetPedComponentVariation(yRanger, 6, 0, 0, 0)
            GiveWeaponToPed(yRanger, weapon, 99, false, true)
        
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", yRanger, 12.0)
            SetBlockingOfNonTemporaryEvents(yRanger, false)
            SetEntityInvincible(yRanger, false)
            SetPedCanBeTargettedByPlayer(yRanger, ped, true)
            SetEntityAsMissionEntity(yRanger, false, false)
            SetPedAsGroupMember(yRanger, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
        end
    elseif string == "pink" then
        if not DoesEntityExist(pRanger) then
            model = "pink-ranger"
            textShow = "~b~Pink Ranger"
            blipName = "Pink Ranger"
            weapon = 2138347493
            blipColor = 8
            
            if not DoesEntityExist(pRanger) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do
                    Wait(100)
                end
            end
            
            pRanger = CreatePed(4, model, x+3.0, y+3.0, z-1.0, ph, true, true)
            pBlip = AddBlipForEntity(pRanger)
            SetPedComponentVariation(pRanger, 9, 1, 0, 0)
        
            SetEntityHealth(pRanger, initalHealth)
            SetPedArmour(pRanger, initalArmor)
            SetBlipSprite(pBlip, 1)
            SetBlipColour(pBlip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(pBlip)
            SetBlipAsShortRange(pBlip, false)
            SetPedComponentVariation(pRanger, 6, 0, 0, 0)
            GiveWeaponToPed(pRanger, weapon, 99, false, true)
        
            showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", pRanger, 12.0)
            SetBlockingOfNonTemporaryEvents(pRanger, false)
            SetEntityInvincible(pRanger, false)
            SetPedCanBeTargettedByPlayer(pRanger, ped, true)
            SetEntityAsMissionEntity(pRanger, false, false)
            SetPedAsGroupMember(pRanger, GetPedGroupIndex(ped))
            ShowNotification("Spawned "..textShow)
        end
    end
end

function removeRangers()

    if DoesEntityExist(bRanger) then
        DeleteEntity(bRanger)
        RemoveBlip(bBlip)
    end
    
    if DoesEntityExist(rRanger) then
        DeleteEntity(rRanger)
        RemoveBlip(rBlip)
    end
    
    if DoesEntityExist(blRanger) then
        DeleteEntity(blRanger)
        RemoveBlip(blBlip)
    end
    
    if DoesEntityExist(yRanger) then
        DeleteEntity(yRanger)
        RemoveBlip(yBlip)
    end
    
    if DoesEntityExist(pRanger) then
        DeleteEntity(pRanger)
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
    local weapon

    if enableRangerPowers then
        local ped = PlayerPedId()
        local hash = GetEntityModel(ped)
        
        SetPedUsingActionMode(ped, false, 0, "motionstate_actionmode_idle")
        SetPlayerLockon(PlayerId(), false)
        ToggleStealthRadar(true)
        SetFollowPedCamViewMode(2)
        -- SetCamViewModeForContext(2, 2)
        HudForceWeaponWheel(false)
        RestorePlayerStamina(PlayerId(), 1.0)
        SetFollowPedCamViewMode(2)
        DisableControlAction(0, 0, false)
        DisableControlAction(0, Keys['TAB'], false) 
        
        if hash == yRangerModelHash then
            weapon = -1238556825
            SetSuperJumpThisFrame(PlayerId())
            SetPedComponentVariation(ped, 9, 0, 0, 0)
            SetPedInfiniteAmmo(ped, true, weapon)
        elseif hash == bRangerModelHash then
            weapon = -1768145561
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
            SetPedMoveRateOverride(PlayerId(), 10.0)
            SetPedInfiniteAmmo(ped, true, weapon)
            SetPedInfiniteAmmo(ped, true, weapon)
        elseif hash == pRangerModelHash then
            weapon = 2138347493
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
            SetPedMoveRateOverride(PlayerId(), 10.0)
            SetPedInfiniteAmmo(ped, true, weapon)
        end

        if DoesEntityExist(bRanger) then
            SetRunSprintMultiplierForPlayer(bRanger, 1.0)
            SetPedMoveRateOverride(bRanger, 2.0)
        end

        if DoesEntityExist(pRanger) then
            SetRunSprintMultiplierForPlayer(pRanger, 1.0)
            SetPedMoveRateOverride(pRanger, 2.0)
        end

        ShowHudComponentThisFrame(14)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(22)
    end
end

local Models = {
	-- "blue-ranger",
	"red-ranger",
	-- "black-ranger",
	-- "yellow-ranger",
	-- "pink-ranger"
}

function drawHoloGram(x, y, z)
	local ped = PlayerPedId()
    local zHeight = 1.0
    local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 24817))
    local markerSize = 0.1 

    DrawLine(bCoords.x, bCoords.y, bCoords.z, x, y, z, 255, 255, 255, 100)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 0.0, 45.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 0.0, -45.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    if not displayHeadUI then
        DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.015, 0.015, 0.015, 255, 255, 255, 200, false, false, 2, true, nil, nil, false)
    
        DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+zHeight, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.03, 0.03, 0.03, 36, 91, 209, 60, false, false, 2, true, nil, nil, false)
    
        DrawMarker(28, x, y, z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.012, 0.012, 0.012, 255, 255, 255, 255, false, false, 2, false, nil, nil, false)
    end

    DrawMarker(0, bCoords.x, bCoords.y, bCoords.z+0.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize+0.07, markerSize+0.07, markerSize, 255, 255, 255, 10, false, false, 2, true, nil, nil, false)
end

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

function toggleVisorManual(entity, bool)
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    local inBedDicts = "random@arrests"
    local inBedAnims = "generic_radio_chatter"
    LoadAnim(inBedDicts)
    TaskPlayAnim(entity, inBedDicts, inBedAnims, 12.0, 12.0, -1, 48, 1, false, false, false)

    if not IsPedAPlayer(entity) then
        if bool then
            Citizen.Wait(400)
            SetPedComponentVariation(entity, 6, 0, 0, 0)
        else
            Citizen.Wait(400)
            SetPedComponentVariation(entity, 6, 1, 0, 0)
        end
    else
        if bool then
            Citizen.Wait(400)
            SetPedComponentVariation(entity, 6, 0, 0, 0) 
            visor = true
        else
            Citizen.Wait(400)
            SetPedComponentVariation(entity, 6, 1, 0, 0)  
            visor = false
        end
    end
    showNonLoopParticleBone("core", "ent_dst_elec_fire_sp", entity, 1.0, 31086) 
    PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 0)
    StopAnimTask(entity, inBedDicts, inBedAnims, 8.0)
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
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function combatRollForce()
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
        if not IsEntityPlayingAnim(ped, inBedDicts, inBedAnims, 3) then
            TaskPlayAnim(ped, inBedDicts, inBedAnims, 3.0, 4.0, 1000, 0, 0, false, false, false)
        end
    end
    Wait(500)
    rolling = false
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

function toggleThermal()
    local ped = PlayerPedId()
    local inBedDicts = "random@arrests"
    local inBedAnims = "generic_radio_chatter"
    LoadAnim(inBedDicts)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 8.0, 8.0, -1, 48, 1, false, false, false)
    Citizen.Wait(400)
    ClearPedTasks(ped)
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

