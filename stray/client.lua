
-- -- GLOBAL VARIABLES DECLARATION
-- ----------------------------------------------------------------------------------------------------

local strayModelHash = 1462895032

local enableStrayPowers = false
local sleeping = false
local laying = false
local sitting = false
local gScreen, bScreen, oScreen, rScreen
local carry = false
local testProp
local canCarry = false
local canExplode = false
local wType, count = 0, 0
local diplayHudTimer = 0
local displayHeadUI = false
local countName = ""
local mPhone
local explodeAbility = false

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

RegisterNetEvent('stray:getIdentifier')
AddEventHandler('stray:getIdentifier', function(val)
    local hash = GetEntityModel(PlayerPedId())
    local rnd = math.random(0, 2)
    local ped = PlayerPedId()

    if hash == strayModelHash then
        if not enableStrayPowers then
            TriggerEvent('nic_hud:toggleHud')
            PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 0)
            enableStrayPowers = true
            createMonitorGreen()
            SetPedComponentVariation(ped, 0, 1, 0, 0)
        else
            TriggerEvent('nic_hud:toggleHud')
            PlaySoundFrontend(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0)
            enableStrayPowers = false

            DeleteObject(gScreen)
            DeleteObject(bScreen)
            DeleteObject(oScreen)
            DeleteObject(rScreen)
        end
    else
        PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)
        ShowNotification("You are not a ~b~Cat")
    end
end)

RegisterCommand('stray', function()
	local _source = source
    TriggerEvent('stray:getIdentifier')
end)

-- ******************************************************************

local NearestePed = nil
local NearesteObject = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    while true do
        local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
        local zone = GetZoneDevant()
        local target = ESX.Game.GetClosestPed(zone, {})
        local model = GetEntityModel(target)
		local donut = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("p_amb_bagel_01"), false)
		local donut2 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_amb_donut"), false)
		local coffee = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("p_amb_coffeecup_01"), false)
		-- local pistol = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("w_pi_pistol"), false)
		local beer1 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_amb_40oz_02"), false)
		local beer2 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_amb_beer_bottle"), false)
		local beer3 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_amb_40oz_03"), false)
		local beer4 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_cs_beer_bot_40oz"), false)
		local beer5 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_cs_beer_bot_40oz_03"), false)
		local juice1 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_food_bs_juice03"), false)
		local trash = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_rub_binbag_06"), false)
		local trash2 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_rub_binbag_05"), false)
		local trash3 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_rub_binbag_03b"), false)
		local phone1 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_amb_phone"), false)
		local bin1 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_bin_01a"), false)
		local bin2 = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_cs_bin_02"), false)
		local boxes = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_rub_boxpile_01"), false)
		local hydrant = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey("prop_fire_hydrant_1"), false)

        local mainProp
        local propName = ""

        local markerSize = 0.1        
        
        if enableStrayPowers then

            if IsControlJustReleased(0, Keys['K']) then
                if not DoesEntityExist(testProp) then
                    spawnTestProp("p_amb_bagel_01")
                else
                    DeleteEntity(testProp)
                end
            end

            if IsEntityDead(ped) then
                detachAllProps()
                TriggerEvent('nic_hud:toggleHud')
                carry = false
                enableStrayPowers = false
            end
    
            if IsPedRagdoll(ped) then
                DetachEntity(mainProp, true, true)
                carry = false
            end
    
            if IsEntityAttachedToEntity(target, ped) then
                if IsPedRagdoll(ped) or IsEntityDead(ped) then
                    uncarryAnimal(target)
                end
    
                if IsControlJustReleased(0, Keys['F']) then
                    consume(target)
                end
            end
    
            if carry and (IsEntityAttachedToEntity(donut, ped)) then
                if IsControlJustReleased(0, Keys['F']) then
                    eatDonut(donut)
                end    
            elseif carry and (IsEntityAttachedToEntity(donut2, ped)) then
                if IsControlJustReleased(0, Keys['F']) then
                    eatDonut(donut2)
                end
            end

            if DoesEntityExist(trash) then
                mainProp = trash
                canCarry = false
                propName = "Trash"
                canExplode = false
            end

            if DoesEntityExist(trash2) then
                mainProp = trash2
                canCarry = false
                propName = "Trash"
                canExplode = false
            end

            if DoesEntityExist(trash3) then
                mainProp = trash3
                canCarry = false
                propName = "Trash"
                canExplode = false
            end

            if DoesEntityExist(bin1) then
                mainProp = bin1
                canCarry = false
                propName = "Trashbin"
                canExplode = false
            end

            if DoesEntityExist(bin2) then
                mainProp = bin2
                canCarry = false
                propName = "Trashbin"
                canExplode = false
            end

            if DoesEntityExist(boxes) then
                mainProp = boxes
                canCarry = false
                propName = "Box"
                canExplode = false
            end

            if DoesEntityExist(donut) then
                mainProp = donut
                propName = "Donut"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(donut2) then
                mainProp = donut2
                propName = "Donut"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(coffee) then
                mainProp = coffee
                propName = "Coffee"
                canCarry = true
                canExplode = false
            end

            -- if DoesEntityExist(pistol) then
            --     mainProp = pistol
            --     propName = "Pistol"
            --     canCarry = true
            --     canExplode = false
            -- end

            if DoesEntityExist(beer1) then
                mainProp = beer1
                propName = "Beer"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(beer2) then
                mainProp = beer2
                propName = "Beer"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(beer3) then
                mainProp = beer3
                propName = "Beer"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(beer4) then
                mainProp = beer4
                propName = "Beer"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(beer5) then
                mainProp = beer5
                propName = "Beer"
                canCarry = true
                canExplode = false
            end

            if DoesEntityExist(hydrant) then
                mainProp = hydrant
                propName = "Hydrant"
                canCarry = false
                canExplode = true
            end

            if DoesEntityExist(mainProp) then
                local propCoords = GetOffsetFromEntityInWorldCoords(mainProp, 0.0, 0.0, 0.0)
                local distanceCheck = #(pedCoords - propCoords)
                local pCoords = GetEntityCoords(mainProp, true)

                if distanceCheck < 32.0 then
                    if not sleeping then
                        if not canCarry then
                            controlPrompt("~INPUT_TALK~", "Move ~o~"..propName)
                            local multiplier = 272.0
                            local pos = GetEntityForwardVector(target)

                            if not carry then
                                drawHoloGram(pCoords.x, pCoords.y, pCoords.z)
                            end

                            if IsControlJustReleased(0, Keys['E']) then
                                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                                showNonLoopParticleBone("core", "ent_sht_electrical_box", ped, 0.4, 24817)
                                ApplyForceToEntity(mainProp, 5, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
                                Wait(1000)
                            end
                        end
                    end
                end

                if canCarry and not carry and not canExplode then
                    drawHoloGram(pCoords.x, pCoords.y, pCoords.z)
                    if not carry and not sleeping and not IsPedRagdoll(ped) then
                        controlPrompt("~INPUT_TALK~", "Carry ~o~"..propName)
                    else
                        controlPrompt("~INPUT_TALK~", "Drop ~o~"..propName)
                    end

                elseif canExplode and not carry and not canCarry then
                    if not carry and not sleeping and not IsPedRagdoll(ped) then
                        controlPrompt("~INPUT_TALK~", "Explode ~o~"..propName)
                        if IsControlJustReleased(0, Keys['E']) then                            
                            AddExplosion(pCoords.x, pCoords.y, pCoords.z, 1, 1.0, true, false, true)
                        end
                    end
                end
                
                if IsControlJustReleased(0, Keys['E']) then
                    if not sleeping and not IsPedGettingUp(ped) and not IsPedRagdoll(ped) and not carry then

                        if canCarry then
                            makeEntityFaceEntity(ped, mainProp)
                            carryProp(mainProp, 0.1, -0.04, 0.00, -70.0, 0, 0.0)
                        end
                    else
                        uncarryProp(mainProp)
                        canCarry = false
                    end
                end
            end
        end

        if target ~= GetPlayerPed(-1) and not IsPedAPlayer(target) and not IsPedHuman(target) then
            if enableStrayPowers then
                if model == GetHashKey("a_c_rat") or model == GetHashKey("a_c_hen") or model == GetHashKey("a_c_rabbit_01") then
                    
                    local coords = GetEntityCoords(target, true)
                    local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)                    

                    if not sleeping and not carry and IsPlayerNearEntity(coords.x, coords.y, coords.z) then
                        local tVitals, tType, tGender = "", "", ""
                        local tHealth = GetEntityHealth(target)

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

                        if tHealth >= 150 then
                            tVitals = "~g~Normal"
                        elseif tHealth >= 80 then
                            tVitals = "~o~Critical"
                        elseif tHealth == 0 then
                            tVitals = "~r~Deceased"
                        end

                        if not carry then
                            drawHoloGram(coords.x, coords.y, coords.z)
                            drawText3D(coords, tVitals, tType, tGender)

                            if not IsEntityDead(target) then
                                controlPrompt("~INPUT_MAP_POI~", "Electricute")
                                                
                                if IsControlJustPressed(0, Keys['MMB']) then
                                    useAbility(target)
                                end
                            end
                        end

                        DrawMarker(21, coords.x, coords.y, coords.z+0.2, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, markerSize, markerSize, markerSize, 52, 235, 52, 255, false, true, 2, false, nil, nil, false)
                    end

                    if distance <= 0.3 then 
                        NearestePed = target
                        if not sleeping and not IsPedRagdoll(ped) and not carry then
                            if GetEntityModel(model) == "a_c_hen" then
                                controlPrompt("~INPUT_TALK~", "Carry ~b~Chicken")
                            else
                                controlPrompt("~INPUT_TALK~", "Carry ~b~Rat")
                            end
                        else
                            if GetEntityModel(model) == "a_c_hen" then
                                controlPrompt("~INPUT_ENTER~", "Eat ~b~Chicken")
                            else
                                controlPrompt("~INPUT_ENTER~", "Eat ~b~Rat")
                            end
                        end

                        if IsControlJustReleased(0, Keys['E']) then
                            if not sleeping and not IsPedRagdoll(ped) and not carry then
                                makeEntityFaceEntity(ped, target)
                                carryAnimal(target)
                            else
                                uncarryAnimal(target)
                            end
                        end
                    else
                        NearestePed = nil
                    end
                end
            end
        end
        Citizen.Wait(5)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5) 

		local ped = PlayerPedId()
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 24817))            

        if enableStrayPowers then
            if displayHeadUI then
    
                local r, g, b = 0, 0, 0
    
                if wType == 0 then
                    r = 36
                    g = 91
                    b = 209
                elseif wType == 1 then
                    r = 209
                    g = 91
                    b = 36
                elseif wType == 2 then
                    r = 91
                    g = 209
                    b = 36
                end
    
                DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.015, 0.015, 0.015, 255, 255, 255, 200, false, false, 2, true, nil, nil, false)
            
                DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.03, 0.03, 0.03,  r, g, b, 60, false, false, 2, true, nil, nil, false)
            end 
    
            if not IsEntityDead(ped) then
                if IsControlJustReleased(0, 15) then
                    if count < 2 then
                        count = count + 1
                        displayHeadUI = true
                        TriggerEvent("stray:hudTimer", 3)
                    end
                elseif IsControlJustReleased(0, 14) then
                    if count > 0 then
                        count = count - 1
                        displayHeadUI = true
                        TriggerEvent("stray:hudTimer", 3)
                    end
                end
                changeAbilityType(count)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
        local mChair
		local chair = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_table_03b_chr"), false)
		local chair2 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_chair_01b"), false)
		local chair3 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_bench_05"), false)
		local chair4 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_bench_03"), false)
		local chair5 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_bench_09"), false)
		local chair6 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_table_04_chr"), false)
		local chair7 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_bench_06"), false)
		local chair8 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_bench_10"), false)
		local chair9 = GetClosestObjectOfType(pedCoords, 0.8, GetHashKey("prop_chair_02"), false)

        local mx, my, mz, mrx, mry, mrz = 0,0, 0.0, 0.0, 0,0, 0.0, 0.0

        if enableStrayPowers then  

            if sitting then
                DisableControlAction(0, Keys['SPACE'], false)
                DisableControlAction(0, Keys['X'], false)
                DisableControlAction(0, Keys['BACKSPACE'], false)
            end

            if DoesEntityExist(chair) then
                mChair = chair
                mx = 0.0
                my = 0.0
                mz = 0.45
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair2) then
                mChair = chair2
                mx = 0.0
                my = 0.0
                mz = 0.45
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair3) then
                mChair = chair3
                mx = 0.0
                my = 0.0
                mz = 0.35
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair4) then
                mChair = chair4
                mx = 0.0
                my = 0.0
                mz = 0.35
                mrx = 0.0
                mry = 90.0
                mrz = 180.0
            elseif DoesEntityExist(chair5) then
                mChair = chair5
                mx = 0.0
                my = 0.0
                mz = 0.35
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair6) then
                mChair = chair6
                mx = 0.0
                my = 0.0
                mz = 0.50
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair7) then
                mChair = chair7
                mx = 0.0
                my = 0.0
                mz = 0.45
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair8) then
                mChair = chair8
                mx = 0.0
                my = 0.0
                mz = 0.45
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            elseif DoesEntityExist(chair9) then
                mChair = chair9
                mx = 0.0
                my = 0.0
                mz = 0.45
                mrx = 0.0
                mry = 0.0
                mrz = 180.0
            end
            
            if DoesEntityExist(mChair) then

                local mCoords = GetEntityCoords(mChair)

                if not sitting then
                    drawHoloGram(mCoords.x, mCoords.y, mCoords.z+0.5)
                end
                
                if not sitting then
                    controlPrompt("~INPUT_TALK~", "Sit")
                else
                    controlPrompt("~INPUT_TALK~", "Get Up")
                end
    
                if IsControlJustReleased(0, Keys['E']) then
                    if not sitting then
                        sitChair(mChair, mx, my, mz, mrx, mry, mrz)
                    else
                        getUpChair()
                    end
                end
            end
        end
	end
end)

RegisterNetEvent('stray:hudTimer')
AddEventHandler('stray:hudTimer', function(num)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped, true)
        local hp = GetEntityHealth(ped)
        local fx = "RampageOut"

        if enableStrayPowers then
            local zone = GetZoneDevant()
            local target = ESX.Game.GetClosestPed(zone, {})
            local model = GetEntityModel(target)
            local object = ESX.Game.GetClosestObject({}, zone)
            local tHealth = GetEntityHealth(target)
            local tVitals, tType, tGender = "", "", ""

            if explodeAbility then
                wType = 2
                if IsControlJustPressed(0, Keys['MMB']) then
                    useAbility(target)
                end
            end

            if target ~= GetPlayerPed(-1) and not IsPedAPlayer(target) then
                
                local coords = GetEntityCoords(target, true)
                local oCoords = GetEntityCoords(object, true)
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)
                local oDistance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), oCoords, true), 0)

                -- if IsPlayerNearEntity(oCoords.x, oCoords.y, oCoords.z) then
                --     drawHoloGram(oCoords.x, oCoords.y, oCoords.z)
                -- end

                if IsPlayerNearEntity(coords.x, coords.y, coords.z) then
                    
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
                        if tHealth >= 150 then
                            tVitals = "~g~Normal"
                        elseif tHealth < 150 then
                            tVitals = "~o~Critical"
                        end
                    else
                        tVitals = "~r~Deceased"
                    end

                    if IsPedHuman(target) then
                        controlPrompt("~INPUT_MAP_POI~", "Electricute")
                        drawHoloGram(coords.x, coords.y, coords.z)
                        drawText3D(coords, tVitals, tType, tGender)
                                        
                        if IsControlJustPressed(0, Keys['MMB']) then
                            if not explodeAbility then
                                useAbility(target)
                            end
                        end
                    end

                end

                if distance <= 12.0 then 
                    NearestePed = target
                end

                if oDistance <= 12.0 then 
                    NearesteObject = object
                end
            end

            -- if not IsPedAPlayer(target) then
            --     if distance < 12.5 then
            --         ShowNotification("TEST")
            --         -- drawHoloGram(tCoords.x, tCoords.y, tCoords.z)
            --     end
            -- end

            if sleeping then
                if hp < 200 then
                    SetEntityHealth(ped, (hp+2))
                    Wait(500)
                end
            end
            
            if not IsEntityDead(ped) then
                
                if hp == 200 then
                    if DoesEntityExist(gScreen) then
                        DeleteObject(gScreen)
                    end
                    if DoesEntityExist(oScreen) then
                        DeleteObject(oScreen)
                    end
                    if DoesEntityExist(rScreen) then
                        DeleteObject(rScreen)
                    end
                    if not DoesEntityExist(bScreen) then
                        createMonitorBlue()
                        showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 1.0)
                    end
                else
                    if hp < 160 then
                        if DoesEntityExist(gScreen) then
                            DeleteObject(gScreen)
                        end
                        if DoesEntityExist(bScreen) then
                            DeleteObject(bScreen)
                        end
                        if DoesEntityExist(rScreen) then
                            DeleteObject(rScreen)
                        end
                        if not DoesEntityExist(oScreen) then
                            createMonitorOrange()
                        end
                    end
                    if hp < 130 then
                        if DoesEntityExist(gScreen) then
                            DeleteObject(gScreen)
                        end
                        if DoesEntityExist(bScreen) then
                            DeleteObject(bScreen)
                        end
                        if DoesEntityExist(oScreen) then
                            DeleteObject(oScreen)
                        end
                        if not DoesEntityExist(rScreen) then
                            createMonitorRed()
                        end
                        AnimpostfxPlay(fx)                        
                    end
                    if hp < 200 and hp > 160 then
                        if DoesEntityExist(rScreen) then
                            DeleteObject(rScreen)
                        end
                        if DoesEntityExist(bScreen) then
                            DeleteObject(bScreen)
                        end
                        if DoesEntityExist(oScreen) then
                            DeleteObject(oScreen)
                        end
                        if not DoesEntityExist(gScreen) then
                            createMonitorGreen()
                        end
                        AnimpostfxStop(fx)
                    end
                end
            else
                if DoesEntityExist(gScreen) then
                    DeleteObject(gScreen)
                end
                if DoesEntityExist(bScreen) then
                    DeleteObject(bScreen)
                end
                if DoesEntityExist(oScreen) then
                    DeleteObject(oScreen)
                end
                if DoesEntityExist(rScreen) then
                    DeleteObject(rScreen)
                end
                carry = false
                enableStrayPowers = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local hp = GetEntityHealth(ped)

        if enableStrayPowers then

            default()
            
            if IsControlJustPressed(0, Keys['U']) then
                stretch()
            end

            if IsEntityInAir(ped) then
                SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
            else
                if not IsPedRagdoll(ped) and not IsPedGettingUp(ped) then
                    if IsControlJustReleased(0, Keys['SPACE']) then
                        if not sleeping and not jumping then
                            jump()
                        end
                    end
                end
                SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            end

            if sleeping then

                if IsControlJustPressed(0, Keys['W']) or IsControlJustPressed(0, Keys['A']) or IsControlJustPressed(0, Keys['S']) or IsControlJustPressed(0, Keys['D']) or IsControlJustPressed(0, Keys['SPACE']) or IsControlJustPressed(0, Keys['BACKSPACE']) then
                    if not IsPedRunning(ped) or not IsPedSprinting(ped) or jumping or IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) or IsPedRagdoll(ped) or IsPedFalling(ped) then
                        exitSleep()
                    end
                end
            end

            if not carry and not sleeping and not IsPedRunning(ped) and not IsPedSprinting(ped) and not jumping and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedRagdoll(ped) and not IsPedFalling(ped) then
                if IsControlJustPressed(0, Keys['G']) then
                    sleep()
                end
            end

            -- if not sleeping and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) and not IsPedFalling(ped) then
            --     if IsControlJustPressed(0, Keys['MMB']) then
            --         if not propExplode then
            --             SetPedCanRagdoll(ped, false)
            --             local type = 70
            --             local px, py, pz = table.unpack(GetEntityCoords(ped))
            --             SetEntityInvincible(ped, true)
            --             if hp >= 200 then
            --                 showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 2.0)
            --                 AddExplosion(px, py, pz, 70, 1.0, true, false, true)
            --                 SetPedToRagdoll(ped, 1000, -1, 0, true, true, true)
            --             end
            --             Wait(2000)
            --             SetPedCanRagdoll(ped, true)
            --             SetEntityInvincible(ped, false)
            --         end
            --     end
            -- end
        end
    end
end)

function changeAbilityType(num)
    if num == 0 then
        countName = "Taze"
        explodeAbility = false
    elseif num == 1 then
        countName = "Explode Head"
        explodeAbility = false
    elseif num == 2 then
        countName = "Burst Energy"
        explodeAbility = true
    end

    wType = num
end

function useAbility(entity)
	local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped))

    if wType == 0 then
        showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", entity, 1.0)
        showNonLoopParticleBone("core", "ent_sht_electrical_box", entity, 1.0, 31086)
        showNonLoopParticleBone("core", "ent_sht_electrical_box", ped, 0.4, 24817)
        SetPedToRagdoll(entity, 1000, -1, 0, true, true, true)
        if not IsEntityDead(entity) then
            SetPedDropsWeapon(entity)
            SetPedToRagdollWithFall(entity, 4000, 4000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    elseif wType == 1 then
        killTarget(entity)
    elseif wType == 2 then
        SetEntityInvincible(ped, true)
        showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 2.0)
        AddExplosion(px, py, pz, 70, 1.0, true, false, true)
        SetPedToRagdoll(ped, 1000, -1, 0, true, true, true)
    end
    Wait(2000)
end

function killTarget(ped)
    PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 0)
    showNonLoopParticle("core", "ent_sht_blood", ped, 1.0)
    showNonLoopParticleBone("core", "blood_chopper", ped, 3.0, 31086)
    showNonLoopParticleBone("core", "scrape_blood_car", ped, 2.0, 31086)
    showNonLoopParticleBone("core", "blood_entry_shotgun", ped, 1.5, 31086)
    ApplyPedDamagePack(ped, "BigRunOverByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(ped, "BigHitByVehicle", 12.0, 0.0)
    ApplyPedDamagePack(ped, "Fall", 12.0, 0.0)
    ApplyPedDamagePack(ped, "SCR_Finale_Michael", 12.0, 0.0)
    ApplyPedDamagePack(ped, "SCR_Torture", 12.0, 0.0)
    ApplyPedDamagePack(ped, "Splashback_Face_0", 12.0, 0.0)
    ApplyPedDamagePack(ped, "td_blood_shotgun", 12.0, 0.0)
    ApplyPedBlood(ped, 3, 0.0, 0.0, 0.0, "wound_sheet")
    ApplyDamageToPed(ped, 500, false)
end

function drawHoloGram(x, y, z)
	local ped = PlayerPedId()
    local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 24817))
    local markerSize = 0.1 

    DrawLine(bCoords.x, bCoords.y, bCoords.z+0.28, x, y, z, 255, 255, 255, 100)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 0.0, 45.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 0.0, -45.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    DrawMarker(25, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, markerSize, markerSize, markerSize, 229, 235, 52, 100, false, false, 2, true, nil, nil, false)

    if not displayHeadUI then
        DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.015, 0.015, 0.015, 255, 255, 255, 200, false, false, 2, true, nil, nil, false)
    
        DrawMarker(28, bCoords.x, bCoords.y, bCoords.z+0.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.03, 0.03, 0.03, 36, 91, 209, 60, false, false, 2, true, nil, nil, false)
    
        DrawMarker(28, x, y, z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.012, 0.012, 0.012, 255, 255, 255, 255, false, false, 2, false, nil, nil, false)
    end

    DrawMarker(0, bCoords.x, bCoords.y, bCoords.z+0.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize+0.07, markerSize+0.07, markerSize, 255, 255, 255, 10, false, false, 2, true, nil, nil, false)
end

function stretch()
	local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    local inBedDicts = "creatures@cat@amb@world_cat_sleeping_ledge@base"
    
    LoadAnim(inBedDicts)
    LoadAnim("creatures@cat@amb@world_cat_sleeping_ledge@exit")

    local inBedAnims = "base"
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, px, py, pz-0.43, true, false, true, false)
    TaskPlayAnim(ped, "creatures@cat@amb@world_cat_sleeping_ledge@exit", "exit_l", 10.0, 5.0, 3000, 1, 0, false, false, false)
    Wait(3000)
    FreezeEntityPosition(ped, false)
    showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 1.0)
    StopAnimTask(ped, inBedDicts, inBedAnims, 8.0)
end

function getUpChair()
	local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    local inBedDicts = "creatures@cat@amb@world_cat_sleeping_ledge@base"
    
    LoadAnim(inBedDicts)
    LoadAnim("creatures@cat@amb@world_cat_sleeping_ledge@exit")

    local inBedAnims = "base"
    DetachEntity(ped, true, true)
    FreezeEntityPosition(ped, true)

    TaskPlayAnim(ped, "creatures@cat@amb@world_cat_sleeping_ledge@exit", "exit_l", 2.0, 1.0, 4500, 1, 0, false, false, false)
    Wait(4400)
    FreezeEntityPosition(ped, false)
    Wait(100)
    showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 1.0)
    StopAnimTask(ped, inBedDicts, inBedAnims, 8.0)
    sitting = false
end

function sitChair(entity, x, y, z, rotx, roty, rotz)

	local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped))
	local cHeading = GetEntityHeading(entity)
    local boneIndex = 57005
    local duration = -1
    local flag = 1

    local inBedDicts = "creatures@cat@amb@world_cat_sleeping_ledge@base"

    LoadAnim(inBedDicts)

    local inBedAnims = "base"

    TaskTurnPedToFaceEntity(ped, entity, 1000)
	Citizen.Wait(1000)
    showNonLoopParticle("des_tv_smash", "ent_sht_electrical_box_sp", ped, 1.0)
	SetEntityHeading(ped, cHeading)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 8.0, 1.0, duration, flag, 0, false, false, false)
    AttachEntityToEntity(ped, entity, GetPedBoneIndex(ped, boneIndex), x, y, z, rotx, roty, rotz, false, false, false, false, 2, true)
	sitting = true
end

function GetEntInFrontOfPlayer(Distance, Ped)
    local Ent = nil
    local CoA = GetEntityCoords(Ped, 1)
    local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
    local RayHandle = CastRayPointToPoint(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, 10, PlayerPedId(), 0)
    local A,B,C,D,Ent = GetRaycastResult(RayHandle)
    return Ent
end

function spawnTestProp(name)
    local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    local boneIndex = 31086
    testProp = CreateObject(GetHashKey(name), px, py, pz, true,  true, true)
    AttachEntityToEntity(testProp, ped, GetPedBoneIndex(ped, boneIndex), 0.0, 0.0, 0.0, 0.0, 0, 0.0, 1, 1, 0, 1, 0, 1)  
    DetachEntity(testProp, true, true)
    ShowNotification("Spawned Test Prop")
end

function eatDonut(entity)
    local ped = PlayerPedId()
    showNonLoopParticle("core", "bang_mud", entity, 0.5)
    Wait(200)
    DeleteEntity(entity)
    SetEntityHealth(ped, 200)
    carry = false
    ShowNotification("Consumed ~o~Donut")
end

function consume(entity)
    local ped = PlayerPedId()
    showNonLoopParticle("core", "blood_entry_shotgun", entity, 0.8)
    Wait(200)
    DeleteEntity(entity)
    SetEntityHealth(ped, 200)
    carry = false
end

function uncarryAnimal(entity)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity, 0))
    SetEntityCoords(entity, ex, ey, ez+1.0, true, false, true, false)
    DetachEntity(entity, true, true)
    ResurrectPed(entity)
    SetPedToRagdoll(entity, 1000, -1, 0, true, true, true)
    carry = false
end

function carryAnimal(entity)
    local ped = PlayerPedId()
    local ex, ey, ez = table.unpack(GetEntityCoords(entity, 0))
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local boneIndex = 31086
    uncarryAnimal(entity)
    SetEntityCoords(entity, ex, ey, ez, true, false, true, false)
    SetEntityRotation(entity, 0.0, 0.0, 0.0, 1, true)
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, boneIndex), -0.01, -0.02, 0.03, -70.0, 0, 0.0, 1, 1, 0, 1, 0, 1)  
    carry = true
end

function carryProp(entity, x, y, z, rotx, roty, rotz)
    local ped = PlayerPedId()
    local boneIndex = 31086
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, boneIndex), x, y, z, rotx, roty, rotz, 1, 1, 0, 1, 0, 1)  
    carry = true
end

function uncarryProp(entity)
    DetachEntity(entity, true, true)
    carry = false
end

function detachAllProps(entity)
    local ped = PlayerPedId()
    local attachedObject = GetEntityAttachedTo(ped)
    DetachEntity(attachedObject, true, true)
    DetachEntity(ped, true, true)
end

function createMonitorGreen()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propName = "stray_emv_green"
    local boneIndex = 24817

    gScreen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(gScreen, ped, GetPedBoneIndex(ped, boneIndex), 0.01, 0.07, 0.0, -95.0, 90.0, 0.0, 1, 1, 0, 1, 0, 1)    
end

function createMonitorBlue()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propName = "stray_emv_blue"
    local boneIndex = 24817

    bScreen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(bScreen, ped, GetPedBoneIndex(ped, boneIndex), 0.01, 0.07, 0.0, -95.0, 90.0, 0.0, 1, 1, 0, 1, 0, 1)    
end

function createMonitorOrange()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propName = "stray_emv_orange"
    local boneIndex = 24817

    oScreen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(oScreen, ped, GetPedBoneIndex(ped, boneIndex), 0.01, 0.07, 0.0, -95.0, 90.0, 0.0, 1, 1, 0, 1, 0, 1)    
end

function createMonitorRed()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propName = "stray_emv_red"
    local boneIndex = 24817

    rScreen = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(rScreen, ped, GetPedBoneIndex(ped, boneIndex), 0.01, 0.07, 0.0, -95.0, 90.0, 0.0, 1, 1, 0, 1, 0, 1)
end

function lay()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local duration = -1
    local flag = 1
    inBedDicts = "amb@lo_res_idles@"
    LoadAnim(inBedDicts)
    inBedAnims = "creatures_world_cat_ground_sleep_lo_res_base"
    SetEntityCoords(ped, x, y, z-0.4, true, false, true, false)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 2.0, 1.0, duration, flag, 0, false, false, false)
end

function exitSleep()
    local ped = PlayerPedId()
    local duration = 3000
    local flag = 1
    inBedDicts = "creatures@cat@amb@world_cat_sleeping_ground@exit"
    LoadAnim(inBedDicts)
    inBedAnims = "exit"
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 2.0, 1.0, duration, flag, 0, false, false, false)
    sleeping = false
end

function sleep()
    local ped = PlayerPedId()
    local duration = 2000
    local flag = 1
    inBedDicts = "creatures@cat@amb@world_cat_sleeping_ground@enter"
    LoadAnim(inBedDicts)
    inBedAnims = "enter"
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 2.0, 1.0, duration, flag, 0, false, false, false)
    Wait(duration)
    sleeping = true
    TaskPlayAnim(ped, "amb@lo_res_idles@", "creatures_world_cat_ground_sleep_lo_res_base", 2.0, 1.0, -1, flag, 0, false, false, false)
end

function jump()
    local ped = PlayerPedId()
    local pos = GetEntityForwardVector(ped)
    local multiplier = 12.0
    local flag = 0

    inBedDicts = "creatures@cat@amb@world_cat_sleeping_ground@exit"
    LoadAnim(inBedDicts)
    inBedAnims = "exit_panic"
    duration = 1000
    local heading = GetEntityHeading(ped)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 2.0, 1.0, duration, flag, 0, false, false, false)
    Wait(300)
    SetEntityRotation(ped, 0.00, 10.00, 0.00, 1, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    -- showNonLoopParticle("core", "ent_dst_rubbish", ped, 0.5)
    showNonLoopParticle("core", "bul_rubber_dust", ped, 2.5)
    ApplyForceToEntity(ped, 1, pos.x*multiplier, pos.y*multiplier, pos.z*-multiplier+17.0, 0,0,0, 1, false, true, true, true, true)
    Wait(1000)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function default()
    if enableStrayPowers then
        local ped = PlayerPedId()        

        SetCurrentPedWeapon(ped, -1569615261, true)
        SetPedUsingActionMode(ped, false, 0, "motionstate_actionmode_idle")
        SetPlayerLockon(PlayerId(), false)
        ToggleStealthRadar(true)
        -- SetAmbientPedsDropMoney(true)
        SetFollowPedCamViewMode(2)
        SetCamViewModeForContext(2, 2)
        RestorePlayerStamina(PlayerId(), 1.0)
        AnimpostfxStopAll()
        DisableControlAction(0, Keys['V'], false)
        HudForceWeaponWheel(false)
        ShowHudComponentThisFrame(14)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(22)
    else
        SetAmbientPedsDropMoney(false)
        SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetPedMoveRateOverride(PlayerId(), 0.0)
    end
end

function IsPlayerNearEntity(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 18.0 then
        return true
    end
end

function controlPrompt(str1, str2)
    local displayText = str1.." "..str2
    ESX.ShowHelpNotification(displayText)
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

function GetZoneDevant()
    local backwardPosition = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 2.0, 0.0)
	return backwardPosition
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

function makeEntityFaceEntity(player, entity)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(entity, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
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

function showNonLoopParticleBone(dict, particleName, ped, scale, bone)
    local boneIndex = bone
    local pBone = GetPedBoneIndex(ped, boneIndex)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(particleHandle, 0, 255, 0 ,0)
    return StartNetworkedParticleFxNonLoopedOnEntityBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(ped, boneIndex), scale, false, false, false)
end


function showNonLoopedAtCoord(dict, particleName, x, y, z, scale)

    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(particleHandle, 0, 255, 0 ,0)
    return StartNetworkedParticleFxNonLoopedAtCoord(particleName, x, y, z, 0.00, 0.00, 0.00, scale, false, false, false)
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
    DrawText(_x, _y)

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString("Type: "..text2)
    DrawText(_x, _y+0.015)

    SetTextScale(fontSize, fontSize)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextColour(255, 255, 255, 200)

    AddTextComponentString("Gender: "..text3)
    DrawText(_x, _y+0.03)

    if not HasStreamedTextureDictLoaded("CommonMenu") then
        RequestStreamedTextureDict("CommonMenu", false)
    else
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.03, _y-0.022, 0.072, 0.02, 0.1, 209, 133, 33, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.03, _y+0.025, 0.072, 0.076, 0.1, 0, 0, 0, 155)

        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.05, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.055, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.06, _y-0.022, 0.003, 0.006, 0.1, 255, 255, 255, 200)
        -- DrawSprite("CommonMenu", "MPWeaponsCommon", _x+0.056, _y+0.07, 0.01, 0.004, 0.1, 255, 255, 255, 200)
    end
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