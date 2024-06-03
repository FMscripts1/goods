--THREADS
CreateThread(function()
    Wait(1000)
    -- send config infos to UI
    SendNUIMessage({
        script = GetCurrentResourceName(),
        type = "ui",
        configuration = config.ui
    })
    createBlips(config.ped.coords, config.blip.text, config.blip.sprite, config.blip.scale, config.blip.color, false)
    jobPedManagement()
    intervalManagementBool = true
    intervalManagement()
end)

RegisterNUICallback('closeUI', function(data, cb)
    -- POST data gets parsed as JSON automatically
    local closeMenu = data.closeMenu

    if closeMenu then
        SetNuiFocus(false, false)
        dataNumber = tonumber(data.number)
        if dataNumber ~= nil and data.useCar ~= nil then
            local go = true
            if data.useCar == 1 then go = vehKeyPress() end
            if go then startJob() end
        end
    end
end)