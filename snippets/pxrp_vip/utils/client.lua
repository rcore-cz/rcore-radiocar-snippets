ESX = nil
local isVip = false

CreateThread(function()
	local breakMe = 0
    while ESX == nil do
        Wait(100)
		breakMe = breakMe + 1
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		if breakMe > 10 then
			break
		end
    end
end)

CreateThread(function()
	ESX.TriggerServerCallback('pxrp_vip:getVIPStatus', function(vip)
		isVip = vip
	end, GetPlayerServerId(PlayerId()), '1')
end)

-- this will send information to server.
function CheckPlayerCar(vehicle)
	if ESX then
		local veh = ESX.Game.GetVehicleProperties(vehicle)
		TriggerServerEvent("rcore_radiocar:openUI", veh.plate)
	else
		TriggerServerEvent("rcore_radiocar:openUI", GetVehicleNumberPlateText(vehicle))
	end
end

-- if you want this script for... lets say like only vip, edit this function.
function YourSpecialPermission()
    return isVip
end
