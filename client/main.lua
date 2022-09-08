-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local route = 1
local max = #Config.NPCLocations.Locations
local busBlip = nil
local lvl8 = false
local lvl7 = false
local lvl6 = false
local lvl5 = false
local lvl4 = false
local lvl3 = false
local lvl2 = false
local lvl1 = false
local lvl0 = false

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180
}

local BusData = {
    Active = false,
}

-- Functions
local function resetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

local function updateBlip()
    if PlayerData.job.name == "bus" then
        busBlip = AddBlipForCoord(Config.Location)
        SetBlipSprite(busBlip, 513)
        SetBlipDisplay(busBlip, 4)
        SetBlipScale(busBlip, 0.6)
        SetBlipAsShortRange(busBlip, true)
        SetBlipColour(busBlip, 49)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Lang:t('info.bus_depot'))
        EndTextCommandSetBlipName(busBlip)
    elseif busBlip ~= nil then
        RemoveBlip(busBlip)
    end
end

local function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false
    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    if veh == GetHashKey("dynasty") then
        retval = true
    end
    return retval
end

local function nextStop()
    if route <= (max - 1) then
        route = route + 1
    else
        route = 1
    end
end

local function GetDeliveryLocation()
    nextStop()
    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = route
    local inRange = false
    local PolyZone = CircleZone:Create(vector3(Config.NPCLocations.Locations[route].x,
        Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z), 5, {
        name = "busjobdeliver",
        useZ = true,
        -- debugPoly=true
    })
    PolyZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inRange = true
            exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'rgb(220, 20, 60)')
            CreateThread(function()
                repeat
                    Wait(0)
                    if IsControlJustPressed(0, 38) then
                        local ped = PlayerPedId()
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Config.NPCLocations.Locations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify(Lang:t('success.dropped_off'), 'success')
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("PASSANGER DROPPED OFF", Lang:t('success.dropped_off'), 3500, "success")
                        end 
                        if Config.mzskills then 
                            local BetterXP = math.random(Config.DriverXPlow, Config.DriverXPhigh)
                            local xpmultiple = math.random(1, 4)
                            if xpmultiple >= 3 then
                                chance = BetterXP
                            elseif xpmultiple < 3 then
                                chance = Config.DriverXPlow
                            end
                            exports["mz-skills"]:UpdateSkill("Driving", chance) 
                            Wait(1000)
                            if Config.BonusChance >= math.random(1, 100) then
                                exports["mz-skills"]:CheckSkill("Driving", 12800, function(hasskill)
                                    if hasskill then
                                        lvl8 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 6400, function(hasskill)
                                    if hasskill then
                                        lvl7 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 3200, function(hasskill)
                                    if hasskill then
                                        lvl6 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 1600, function(hasskill)
                                    if hasskill then
                                        lvl5 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 800, function(hasskill)
                                    if hasskill then
                                        lvl4 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 400, function(hasskill)
                                    if hasskill then
                                        lvl3 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 200, function(hasskill)
                                    if hasskill then
                                        lvl2 = true
                                    end
                                end)
                                exports["mz-skills"]:CheckSkill("Driving", 0, function(hasskill)
                                    if hasskill then
                                        lvl1 = true
                                    end
                                end)
                                if lvl8 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel8')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Best service I have had, take my money!', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", "Best service I have had, take my money!", 3500, "info")
                                    end 
                                    lvl8 = false
                                elseif lvl7 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel7')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('You could get away from law enforcement all day with driving like that!', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'You could get away from law enforcement all day with driving like that!', 3500, "info")
                                    end 
                                    lvl7 = false
                                elseif lvl6 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel6')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Hey, can I grab your number? You got me here quick smart!', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Hey, can I grab your number? You got me here quick smart!', 3500, "info")
                                    end 
                                    lvl6 = false
                                elseif lvl5 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel5')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Hey, can I grab your number? You got me here quick smart!', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Hey, can I grab your number? You got me here quick smart!', 3500, "info")
                                    end 
                                    lvl5 = false
                                elseif lvl4 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel4')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Hey I appreciate that, thank you! Take something extra please...', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Hey I appreciate that, thank you! Take something extra please...', 3500, "info")
                                    end 
                                    lvl4 = false
                                elseif lvl3 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel3')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Hey I appreciate that, thank you! Take something extra please...', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Hey I appreciate that, thank you! Take something extra please...', 3500, "info")
                                    end 
                                    lvl3 = false
                                elseif lvl2 == true then
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel2')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Nice driving, thank you! Here is a small tip...', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Nice driving, thank you! Here is a small tip...', 3500, "info")
                                    end 
                                    lvl2 = false
                                elseif lvl1 == true then 
                                    TriggerServerEvent('qb-busjob:server:NPCBonusLevel1')
                                    Wait(1500)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Nice driving, thank you! Here is a small tip...', "info", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("TIP", 'Nice driving, thank you! Here is a small tip...', 3500, "info")
                                    end 
                                    lvl1 = false
                                end
                                Wait(1000)
                            end
                        end
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(pped)
                            SetTimeout(60000, function()
                                DeletePed(pped)
                            end)
                        end
                        RemovePed(NpcData.Npc)
                        resetNpcTask()
                        nextStop()
                        TriggerEvent('qb-busjob:client:DoBusNpc')
                        exports["qb-core"]:HideText()
                        PolyZone:destroy()
                        break
                    end
                until not inRange
            end)
        else
            exports["qb-core"]:HideText()
            inRange = false
        end
    end)
end

local function closeMenuFull()
    exports['qb-menu']:closeMenu()
end

-- Old Menu Code (being removed)
local function busGarage()
    local vehicleMenu = {
        {
            header = Lang:t('menu.bus_header'),
            isMenuHeader = true
        }
    }
    for _, v in pairs(Config.AllowedVehicles) do
        vehicleMenu[#vehicleMenu + 1] = {
            header = v.label,
            params = {
                event = "qb-busjob:client:TakeVehicle",
                args = {
                    model = v.model
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu + 1] = {
        header = Lang:t('menu.bus_close'),
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

RegisterNetEvent("qb-busjob:client:TakeVehicle", function(data)
    local coords = Config.Location
    if (BusData.Active) then
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.one_bus_active'), 'error')
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("ONE BUS", Lang:t('error.one_bus_active'), 3500, "error")
        end 
        return
    else
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            local veh = NetToVeh(netId)
            SetVehicleNumberPlateText(veh, Lang:t('info.bus_plate') .. tostring(math.random(1000, 9999)))
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, data.model, coords, true)
        Wait(1000)
        TriggerEvent('qb-busjob:client:DoBusNpc')
    end
end)

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    -- handles script restarts
    if GetCurrentResourceName() == resourceName then
        updateBlip()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    updateBlip()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    updateBlip()

end)

RegisterNetEvent('qb-busjob:client:DoBusNpc', function()
    if whitelistedVehicle() then
        if not NpcData.Active then
            local Gender = math.random(1, #Config.NpcSkins)
            local PedSkin = math.random(1, #Config.NpcSkins[Gender])
            local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            NpcData.Npc = CreatePed(3, model, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z - 0.98, Config.NPCLocations.Locations[route].w, false, true)
            PlaceObjectOnGroundProperly(NpcData.Npc)
            FreezeEntityPosition(NpcData.Npc, true)
            if NpcData.NpcBlip ~= nil then
                RemoveBlip(NpcData.NpcBlip)
            end
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.goto_busstop'), 'primary')
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("GO TO BUS STOP", Lang:t('info.goto_busstop'), 3500, "info")
            end 
            NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
            SetBlipColour(NpcData.NpcBlip, 3)
            SetBlipRoute(NpcData.NpcBlip, true)
            SetBlipRouteColour(NpcData.NpcBlip, 3)
            NpcData.LastNpc = route
            NpcData.Active = true
            local inRange = false
            local PolyZone = CircleZone:Create(vector3(Config.NPCLocations.Locations[route].x,
                Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z), 5, {
                name = "busjobdeliver",
                useZ = true,
                -- debugPoly=true
            })
            PolyZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    inRange = true
                    exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'rgb(220, 20, 60)')
                    CreateThread(function()
                        repeat
                            Wait(5)
                            if IsControlJustPressed(0, 38) then
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, 0)
                                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)
                                for i = maxSeats - 1, 0, -1 do
                                    if IsVehicleSeatFree(veh, i) then
                                        freeSeat = i
                                        break
                                    end
                                end
                                ClearPedTasksImmediately(NpcData.Npc)
                                FreezeEntityPosition(NpcData.Npc, false)
                                TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify(Lang:t('info.drive_passanger'), 'primary')
                                elseif Config.NotifyType == "okok" then
                                    exports['okokNotify']:Alert("DRIVE PASSENGER", Lang:t('info.drive_passanger'), 3500, "info")
                                end 
                                if NpcData.NpcBlip ~= nil then
                                    RemoveBlip(NpcData.NpcBlip)
                                end
                                GetDeliveryLocation()
                                NpcData.NpcTaken = true
                                TriggerServerEvent('qb-busjob:server:NpcPay')
                                exports["qb-core"]:HideText()
                                PolyZone:destroy()
                                break
                            end
                        until not inRange
                    end)
                else
                    exports["qb-core"]:HideText()
                    inRange = false
                end
            end)
        else
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.already_driving_bus'), 'error')
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("ALREADY DRIVING BUS", Lang:t('error.already_driving_bus'), 3500, "error")
            end 
        end
    else
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.not_in_bus'), 'error')
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("NOT IN BUS", Lang:t('error.not_in_bus'), 3500, "error")
        end 
    end
end)

-- Threads
CreateThread(function()
    local inRange = false
    local PolyZone = CircleZone:Create(vector3(Config.Location.x, Config.Location.y, Config.Location.z), 5, {
        name = "busMain",
        useZ = true,
        debugPoly = false
    })
    PolyZone:onPlayerInOut(function(isPointInside)
        local inVeh = whitelistedVehicle()
        if PlayerData.job.name == "bus" then
            if isPointInside then
                inRange = true
                CreateThread(function()
                    repeat
                        Wait(5)
                        if not inVeh then
                            exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'left')
                            if IsControlJustReleased(0, 38) then
                                busGarage()
                                exports["qb-core"]:HideText()
                                break
                            end
                        else
                            exports["qb-core"]:DrawText(Lang:t('info.bus_stop_work'), 'left')
                            if IsControlJustReleased(0, 38) then
                                if (not NpcData.Active or NpcData.Active and NpcData.NpcTaken == false) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        BusData.Active = false;
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                        RemoveBlip(NpcData.NpcBlip)
                                        exports["qb-core"]:HideText()
                                        resetNpcTask()
                                        break
                                    end
                                else
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify(Lang:t('error.drop_off_passengers'), 'error')
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("DROP PASSANGERS", Lang:t('error.drop_off_passengers'), 3500, "error")
                                    end 
                                end
                            end
                        end
                    until not inRange
                end)
            else
                exports["qb-core"]:HideText()
                inRange = false
            end
        end
    end)
end)
