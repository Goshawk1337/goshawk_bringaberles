ESX = nil
loaded = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    loaded = true
end)

local vanbiciklije = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

            local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
			for k in pairs(Config.locations) do
				if GetDistanceBetweenCoords(Config.locations[k].x, Config.locations[k].y, Config.locations[k].z, GetEntityCoords(GetPlayerPed(-1)))  < Config.Drawdistance then
                    if vanbiciklije then                  
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
        
        for _, info in pairs(Config.locations) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 1.0)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Bicikli bérlés")
            EndTextCommandSetBlipName(info.blip)
        end
    end)     

    config = {
        {ped3, "a_m_m_afriamer_01", "~b~Lester", vector3(-243.3, -987.2, 28.3), 250.08, "WORLD_HUMAN_COP_IDLES", false},
        {ped4, "a_m_m_prolhost_01", "~b~Drog Dealer", vector3(-523.5, -263.7, 34.5), 330.26, "WORLD_HUMAN_COP_IDLES", false}
    
    
    
    }
    
    
    Citizen.CreateThread(function()
        while not loaded do 
            Citizen.Wait(200)
        end
    
        while true do 
            Citizen.Wait(200)
    
            for k,v in ipairs(config) do
    
                if not DoesEntityExist(v[1]) then
                    RequestModel(v[2])
    
                    while not HasModelLoaded(v[2]) do 
                        Citizen.Wait(200) 
                    end
                    config[k][1] = CreatePed(4, v[2], v[4].x, v[4].y, v[4].z, v[5])
    
                    SetEntityAsMissionEntity(config[k][1])
                    FreezeEntityPosition(config[k][1], true)
                    SetBlockingOfNonTemporaryEvents(config[k][1], true)
                    SetEntityInvincible(config[k][1], true)
                    TaskStartScenarioInPlace(config[k][1], v[6])
    
                    SetModelAsNoLongerNeeded(v[2])
    
    
                end
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1),false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v[4].x, v[4].y, v[4].z)
    
                if dist < 3 then
                    v[7] = true
                else
                    v[7] = false
                end
    
            end
        end
    
    end)