CachedOwners = {}
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


function MySQLSyncfetchAll(query, table, cb)
    return exports['ghmattimysql']:executeSync(query, table, cb)
end

function MySQLAsyncfetchAll(query, table, cb)
    return exports['ghmattimysql']:execute(query, table, cb)
end

---
-- sync / async

function MySQLSyncexecute(query, table, cb)
    return exports['ghmattimysql']:executeSync(query, table, cb)
end

function MySQLAsyncexecute(query, table, cb)
    return exports['ghmattimysql']:execute(query, table, cb)
end


function IsVehiclePlayer(source, licensePlate, cb)
    MySQLAsyncfetchAll("SELECT * FROM owned_vehicles WHERE plate = @spz",{
        ['@spz'] = licensePlate,
    }, function(result)
        if #result == 0 then
            cb(false)
        else
            cb(true)
        end
    end)
end


-- check vehicle SPZ, does it have radio ? yes -> lets open UI
-- or is vehicle stolen ? or bought -> open UI
RegisterNetEvent("rcore_radiocar:openUI")
AddEventHandler("rcore_radiocar:openUI", function(spz)
    local player = source
    local xPlayer = QBCore.Functions.GetPlayer(player)

    if Config.OnlyCarWhoHaveRadio then
        if exports.rcore_radiocar:HasCarRadio(spz) then
            TriggerClientEvent("rcore_radiocar:openUI", player)
        end
        return
    end
    if Config.OnlyOwnerOfTheCar then 
        if not CachedOwners[spz] then
            local identifier = QBCore.Functions.GetIdentifier(player, "steam")
            local result = MySQLSyncfetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @identifier", {['@plate'] = spz, ['@identifier'] = identifier})
            if #result ~= 0 then
                TriggerClientEvent("rcore_radiocar:openUI", player)
            end
            CachedOwners[spz] = result[1] or result
        else
            if CachedOwners[spz].plate == spz and CachedOwners[spz].owner == identifier then
                TriggerClientEvent("rcore_radiocar:openUI", player)
            end
        end
    else
        if not CachedOwners[spz] then 
            local result = MySQLSyncfetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = spz})
            if #result ~= 0 then
                TriggerClientEvent("rcore_radiocar:openUI", player)
            end
            CachedOwners[spz] = result[1] or result
        else
            if CachedOwners[spz].plate == spz then
                TriggerClientEvent("rcore_radiocar:openUI", player)
            end
        end
    end
end)