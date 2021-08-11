ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local vanbiciklije = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

            local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
			for k in pairs(Config.locations) do
				if GetDistanceBetweenCoords(Config.locations[k].x, Config.locations[k].y, Config.locations[k].z, GetEntityCoords(GetPlayerPed(-1))) < Config.Drawdistance then			
                    DrawText3D(Config.locations[k].x, Config.locations[k].y, Config.locations[k].z, "~g~Nyomj ~w~ [E]~g~ bicikli vissza adásához! ~w~")
                else
                    DrawText3D(Config.locations[k].x, Config.locations[k].y, Config.locations[k].z, '~g~Nyomj ~w~ [E]~g~ a bicikli bérléshez ~w~ | ~w~ 50$ ~w~')
                end
                if IsControlJustPressed(0, 86) then
                    if not vanbiciklije then
                        ESX.TriggerServerCallback('nwrp_esx:checkMoney', function(cb)
                            if cb then
                                Citizen.Wait(400)
                                vanbiciklije = true
                                DoScreenFadeOut(1200)
 
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end
                                TriggerEvent('esx:spawnVehicle', Config.Model)
                            
                                TriggerServerEvent("nwrp_esx:giveItem")
                                exports['b1g_notify']:Notify('true', 'Sikeresen ki bérelted a biciklit!')
                            else
                                Citizen.Wait(400)
                                exports['b1g_notify']:Notify('false', 'Nincs elég pénzed')
                                vanbiciklije = false
                            end
                            DoScreenFadeIn(800)

                        end)
                    else
                        if IsPedOnAnyBike(ped) then
                            DoScreenFadeOut(1200)

                            while not IsScreenFadedOut() do
                                Citizen.Wait(0)
                            end
                            exports['b1g_notify']:Notify('true', 'Sikeresen vissza adtad a biciklit!')
                        TriggerEvent('esx:deleteVehicle')
                        TriggerServerEvent('nwrp_esx:penzvissza')
                        TriggerServerEvent("nwrp_esx:removeItem")
                        vanbiciklije = false
                        DoScreenFadeIn(800)

                        else
                            exports['b1g_notify']:Notify('true', 'Sikeresen vissza adtad a biciklit!')
                        end
                    end
                end
            end
        end
end)

    --3D text

    function DrawText3D(x,y,z, text)
        local onScreen,_x,_y = World3dToScreen2d(x,y,z)
        local px,py,pz = table.unpack(GetGameplayCamCoord())
        local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
     
        local scale = (1/dist)*2
        local fov = (1/GetGameplayCamFov())*100
        local scale = scale*fov
    
        if onScreen then
            SetTextScale(0.5*scale, 0.5*scale)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 150)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(true)
            AddTextComponentString(text)
            EndTextCommandDisplayText(_x, _y)
            
        end
    end

    --blip
    Citizen.CreateThread(function()

        if not Config.EnableBlips then return end
        
        for _, info in pairs(Config.BlipZones) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 1.0)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        end
    end)