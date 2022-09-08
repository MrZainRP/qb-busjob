local QBCore = exports['qb-core']:GetCoreObject()

function NearBus(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.Locations) do
        local dist = #(coords - vector3(v.x,v.y,v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('qb-busjob:server:NpcPay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Payment = math.random(Config.paylow, Config.payhigh)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then 
                Payment = Payment + math.random(Config.basebonuslow, Config.basebonushigh) 
            end
            Player.Functions.AddMoney('cash', Payment)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

-----------------
--BONUS PAYMENT--
-----------------

RegisterNetEvent('qb-busjob:server:NPCBonusLevel0', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level0Low, Config.Level0High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel1', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level1Low, Config.Level1High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel2', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level2Low, Config.Level2High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel3', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level3Low, Config.Level3High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel4', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level4Low, Config.Level4High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel5', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level5Low, Config.Level5High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel6', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level6Low, Config.Level6High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel7', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level7Low, Config.Level7High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('qb-busjob:server:NPCBonusLevel8', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Bonus = math.random(Config.Level8Low, Config.Level8High)
    if Player.PlayerData.job.name == "bus" then
        if NearBus(src) then
            Player.Functions.AddMoney('cash', Bonus)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end)
