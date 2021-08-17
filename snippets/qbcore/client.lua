QBCore = nil
Citizen.CreateThread(function()
    local breakMe = 0
	while QBCore == nil do
		Wait(100)
        breakMe = breakMe + 1
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        if breakMe > 10 then
            break
        end		
	end
end)

-- this will send information to server.
function CheckPlayerCar(vehicle)
	if QBCore ~= nil then
		local veh = QBCore.Functions.GetVehicleProperties(vehicle)
		TriggerServerEvent("rcore_radiocar:openUI", veh.plate)
	else
		TriggerServerEvent("rcore_radiocar:openUI", GetVehicleNumberPlateText(vehicle))
	end
end

-- if you want this script for... lets say like only vip, edit this function.
function YourSpecialPermission()
    return true
end

function GetVehiclePlate()
    if ESX then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local veh = QBCore.Functions.GetVehicleProperties(vehicle)
		return veh.plate
    else
       return GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
    end
    return "none"
end

AddEventHandler("rcore_radiocar:updateMusicInfo", function(data)
    if QBCore ~= nil then
        local spz = QBCore.Functions.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId())).plate
        TriggerServerEvent("rcore_radiocar:updateMusicInfo", data.label, data.url, spz, data.index)
    else
        TriggerServerEvent("rcore_radiocar:updateMusicInfo", data.label, data.url, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())),data.index)
    end
end)