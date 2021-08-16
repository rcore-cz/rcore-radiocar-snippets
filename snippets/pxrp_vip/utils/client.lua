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
    if ESX then    
        ESX.TriggerServerCallback('pxrp_vip:getVIPStatus', function(vip)
            isVip = vip
        end, GetPlayerServerId(PlayerId()), '1')     
    end        
end)

-- if you want this script for... lets say like only vip, edit this function.
function YourSpecialPermission()
    return isVip
end
