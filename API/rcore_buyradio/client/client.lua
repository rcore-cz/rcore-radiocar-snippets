local ESX = nil

-- will display a help text on left top screen
function showHelpNotification(text)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, 5000)
end

-- Will open player menu with simple yes/no and will call server event to buy the radio.
function OpenPlayerMenu()
end

-- We will preload ESX module into local variable
CreateThread(function()
    local tries = 10
    while not ESX do
        Wait(100)
        TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        tries = tries - 1
        if tries == 0 then
            print("You forgot to change ESX shared object in config, please do it now or the script wont work properly.")
            break
        end
    end
end)

-- We will create a markers around the map that are defined in config
CreateThread(function()
    for k, v in pairs(Config.MarkerList) do
        local marker = createMarker()

        marker.setType(v.style)

        marker.setPosition(v.pos)
        marker.setScale(v.size)
        marker.setColor(v.color)
        marker.setInRadius(5.0)

        marker.setRotation(v.rotate)
        marker.setFaceCamera(v.faceCamera)

        if v.onlyInVehicle then marker.setOnlyVehicle(v.onlyInVehicle) end

        marker.setKeys(Config.KeyListToInteract)

        -- on enter we will check if player is in vehicle if yes show open message of no show deny message.
        marker.on("enter", function()
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                showHelpNotification("Push ~INPUT_CONTEXT~ to open menu")
            else
                showHelpNotification("You need to be in vehicle!")
            end
        end)

        marker.on("leave", function()
            ESX.UI.Menu.CloseAll()
        end)

        -- on key event we control if player is in vehicle if yes = open menu, if no = nothing will happen
        marker.on("key", function()
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local elements = {
                    {
                        label = "Yes! I want the radio!",
                        value = "yes"
                    },
                    {
                        label = "no, I do not want the radio.",
                        value = "no"
                    }
                }

                local options = {
                    title = "The radio will cost: <font color = 'green'>$" .. Config.RadioPrice .. "</font>",
                    align = 'bottom-right',
                    elements = elements
                }

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'asdasdasdasdasdas', options, function(data, menu)
                    menu.close()
                    -- if player push button for "yes" it will call a server event with vehicle plate.
                    if data.current.value == 'yes' then
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        TriggerServerEvent("rcore_buyradio:BuyRadioVehicle", ESX.Game.GetVehicleProperties(veh).plate)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
        end)

        marker.render()
    end
end)