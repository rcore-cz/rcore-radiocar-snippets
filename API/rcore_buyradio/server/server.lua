local ESX = nil
-- We will preload ESX module into local variable
TriggerEvent(Config.ESX, function(esx) ESX = esx end)

-- Event that get called from client side when player open menu and push item "yes" in menu
-- it will check if player has enough money to buy radio to the vehicle, if yes it will
-- remove player money and give vehicle the radio.
-- if he doesnt have money it we will send him a message about not having enough money to buy the radio.
-- simple check if the vehicle already doesnt have radio so he wont buy it twice.
RegisterNetEvent("rcore_buyradio:BuyRadioVehicle")
AddEventHandler("rcore_buyradio:BuyRadioVehicle", function(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() > Config.RadioPrice then
        if not exports.rcore_radiocar:HasCarRadio(plate) then
            xPlayer.removeMoney(Config.RadioPrice)
            exports.rcore_radiocar:GiveRadioToCar(plate)
            TriggerClientEvent("esx:showNotification", source, "Your vehicle has now a radio! Enjoy it!")
        else
            TriggerClientEvent("esx:showNotification", source, "Dont be silly, your vehicle already has a radio. :D")
        end
    else
        TriggerClientEvent("esx:showNotification", source, "I am sorry but you do not have enough money for radio! :/ next time maybe.")
    end
end)