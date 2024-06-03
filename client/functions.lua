local function loadPlayerPed()
    _pped = PlayerPedId()
    _ppCoords = GetEntityCoords(_pped)
    _ppHeading = GetEntityHeading(_pped)
    _ppVec4 = vector4(_ppCoords, _ppHeading)
    return {ped = _pped, coords = _ppCoords, h = ppHeading}
end

local function startUI()
    if not eventIsStart then
        SendNUIMessage({
            script = GetCurrentResourceName(),
            type = "ui",
            display = true,
        })
        SetNuiFocus(true, true)
    end
end

local function drawText2DPerFrame(x,y, text, r,g,b,a)
    local text = tostring(text)
    local x , y = x * 1.0 , y * 1.0
    local r , g , b, a = tonumber(r) , tonumber(g) , tonumber(b) , tonumber(a)

    --SetTextFont(1)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextScale(1.0, 1.0)
    SetTextColour(r,g,b,a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 150)
    --SetTextDropshadow()
    --SetTextOutline()

    SetTextEntry("String")
    AddTextComponentString(text)
    DrawText( x,y )

    local width = #text * 0.015;
    DrawRect(x,y + 0.035, width,0.06, 0,0,0,170)
end

local function clearPedEffects(ped)
    ClearPedTasks(ped)
    SetEntityInvincible(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, false)
    FreezeEntityPosition(ped, false)
end

local function destroyCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, true)
    cam = nil
end

local function _End_(params) -- end of script or end of event
    destroyCam()
    clearPedEffects(_pped)

    SetBlipRoute(deliveryBlip, false)
    RemoveBlip(deliveryBlip)

    QBCore.Functions.DeleteVehicle(veh)
    veh = nil
    vehChoice = nil

    SetEntityAsMissionEntity(obj, false, false)
    DeleteObject(obj)
    obj = nil

    isMsgSend = false
    doorStatusOpen = true
    eventIsStart = false
    playerHasCrateInHands = false
    exports['qb-core']:HideText()

    if params == "script" then
        SetEntityAsMissionEntity(jobPed, false, false)
        DeleteEntity(jobPed)
        SetEntityAsMissionEntity(jobPedPhoneObj, false, false)
        DeleteObject(jobPedPhoneObj)
        intervalManagementBool = false
    end
end

local function playAnim(ped, animDict, animName)
    repeat RequestAnimDict(animDict) Wait(1) until HasAnimDictLoaded(animDict)
    TaskPlayAnim(ped, animDict, animName, 6.0, -6.0, -1, 50, 0, 0, 0, 0)
end

-- environment management
function createBlips(coords, text, sprite, scale, color, useFlashTimer)
    local blip = AddBlipForCoord(coords)
    SetBlipScale(blip, scale)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    if useFlashTimer then SetBlipFlashTimer(blip, 7000) end
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function requestHashPed(model)
    local pedHash = GetHashKey(model)
    RequestModel(pedHash)
    RequestCollisionForModel(pedHash)
    repeat Wait(0) until HasModelLoaded(pedHash) and HasCollisionForModelLoaded(pedHash)
    return pedHash
end

local function createPedWithParms(pedHash, coords)
    local ped = CreatePed(1, pedHash, coords, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    return ped
end

local function createPhone(coords, pedToAttach, boneIndex)
    local phone = CreateObject(GetHashKey("prop_phone_cs_frank"), config.ped.coords.x,config.ped.coords.y,config.ped.coords.z + 5, false,false,false)
    SetEntityCollision(phone, false)
    local bone = GetPedBoneIndex(pedToAttach, 18905)
    AttachEntityToEntity(phone, pedToAttach, bone, -0.1,0.02,0.02, 120.,150.0,-60.0, false, false, false, false, false, false)
    return phone
end

function jobPedManagement()
    local pedHash = requestHashPed(config.ped.model)

    jobPed = createPedWithParms(pedHash, config.ped.coords)

    playAnim(jobPed, 'misslsdhsclipboard@base', 'base')

    jobPedPhoneObj = createPhone({config.ped.coords.xy,config.ped.coords.z + 5}, jobPed, 18905)

    exports['qb-target']:AddTargetEntity(jobPed, {
        options = {
            {
                type = 'client',
                action = function()
                    startUI()
                end,
                icon = config.text.qbTargetPedIcons,
                label = config.text.qbTargetPed,
            },
        },
        distance = 1.5
    })
end

local function jobPedInterval()
    local distance = #(_ppCoords - config.ped.coords.xyz)
    if distance > 30 then
        SetEntityAlpha(jobPed, 0)
        SetEntityAlpha(jobPedPhoneObj, 0)
        return 5000
    elseif distance > 15 then
        SetEntityAlpha(jobPed, 100)
        SetEntityAlpha(jobPedPhoneObj, 100)
        return 2000
    else
        SetEntityAlpha(jobPed, 255)
        SetEntityAlpha(jobPedPhoneObj, 255)
        return 2000
    end
end

-- vehicle management
local function vehCam()
    if cam == nil then
        SetEntityInvincible(_pped, true)
        SetBlockingOfNonTemporaryEvents(_pped, true)
        FreezeEntityPosition(_pped, true)

        cam = CreateCamera('DEFAULT_SCRIPTED_CAMERA', false)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1000, true, true)
    end
    AttachCamToEntity(cam, veh, -5.0,  0.0, 3.0, true)
    PointCamAtEntity(cam, veh)
end

local function changeVeh(index)
    DeleteEntity(veh)
    veh = nil
    local modelHash = GetHashKey(vehList[index].model)
    RequestModel(modelHash)
    RequestCollisionForModel(modelHash)
    repeat Wait(0) until HasModelLoaded(modelHash) or HasCollisionForModelLoaded(modelHash)
    veh = CreateVehicle(modelHash, config.vehicle.spawnCoords, false, false)
    SetEntityAlpha(veh, 150)
end

local function createVeh()
    SetEntityAlpha(veh, 255)
    for i=1,#vehList[vehChoice].door do
        SetVehicleDoorOpen(veh, vehList[vehChoice].door[i], false, false)
    end
    SetVehicleNumberPlateText(veh, config.vehicle.plate)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    --SetVehicleDoorsLocked(veh, 1)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
end

local function byingVeh(money)
    clearPedEffects(_pped)
    if veh ~= nil then
        QBCore.Functions.TriggerCallback('Goods:Server:CallBack:removeMoney', function(bool)
            if bool then
                createVeh()
                QBCore.Functions.Notify(config.text.vehicleBuying, 'success', 1000)
            else
                _End_()
                QBCore.Functions.Notify(config.text.vehicleCantBuying, 'error', 1000)
            end
        end, money)
    else
        QBCore.Functions.Notify(config.text.vehicleCantBuying, 'error', 1000)
    end
    Wait(1000)
    destroyCam()
end

function vehKeyPress()
    local index = 1
    changeVeh(index)
    vehCam()
    while true do
        DisableAllControlActions(0)
        if IsDisabledControlPressed(0, config.vehicle.control.forRight) then
            if index >= #vehList then index = 0 end
            index = index + 1
            changeVeh(index)
            vehCam()
        elseif IsDisabledControlPressed(0, config.vehicle.control.forLeft) then
            if index <= 1 then index = #vehList + 1 end
            index = index - 1
            changeVeh(index)
            vehCam()
        elseif IsDisabledControlJustReleased(0, config.vehicle.control.forDone) then
            vehChoice = index
            byingVeh(vehList[vehChoice].price)
            return true
        elseif IsDisabledControlJustReleased(0, 202) then
            _End_()
            startUI()
            return false
        end
        drawText2DPerFrame(0.5,0.9, config.text.vehicleChoiceTextBefore .. vehList[index].price  .. config.text.vehicleChoiceTextAfter, 255,0,0,255)
        Wait(0)
    end
end

local function pedInVehCloseDoor()
    if not isMsgSend then
        exports['qb-core']:DrawText(config.text.qbDrawTextVehicleHelp, "right")
        isMsgSend = true
        Citizen.SetTimeout(5000, function()
            exports['qb-core']:HideText()
        end)
    end
    if IsControlJustReleased(0, config.interactKey) then
        for i=1,#vehList[vehChoice].door do
            if doorStatusOpen then
                SetVehicleDoorShut(veh, vehList[vehChoice].door[i], true)
            else
                SetVehicleDoorOpen(veh, vehList[vehChoice].door[i], false, false)
            end
        end
        doorStatusOpen = not doorStatusOpen
    end
end

-- crate
local function attachCrate(ped)
    local bone = GetPedBoneIndex(ped, 57005)
    AttachEntityToEntity(obj, ped, bone, 0.2,0.0,-0.2, -100.0,0.0,0.0, false, false, false, false, true, true)
end

local function getCrate()
    attachCrate(_pped)
    playAnim(_pped, 'anim@heists@box_carry@', 'walk')
    playerHasCrateInHands = true

    exports['qb-core']:DrawText(config.text.qbDrawTextCrateKeyIndicator, "right")
    Wait(5000)
    exports['qb-core']:HideText()
end

local function createCrate()
    local objHash = config.ui.items[dataNumber].crateToGiveInGame.model
    RequestModel(objHash)
    repeat Wait(0) until HasModelLoaded(objHash) or HasCollisionForModelLoaded(objHash)
    obj = CreateObject(objHash, 0.0,0.0,0.0, true, true, false)
    --PlaceObjectOnGroundProperly(obj)
    SetEntityCollision(obj, true, true)
    getCrate()
    exports['qb-target']:AddTargetEntity(obj, {
        options = {
            {
                type = 'client',
                action = function()
                    getCrate()
                end,
                icon = config.text.qbTargetCrateIcons,
                label = config.text.qbTargetCrate,
            },
        },
        distance = 3.5
    })
end

-- interval
function intervalManagement()
    local interval = 5000
    local msgIsSend = false
    while intervalManagementBool do
        loadPlayerPed()
        if not eventIsStart then
            interval = jobPedInterval()
        else
            interval = 5
            if playerHasCrateInHands then
                if IsControlJustReleased(0, 51) then
                    playerHasCrateInHands = false
                    clearPedEffects(_pped)
                    DetachEntity(obj, true, true)
                    interval = 2500
                end
            elseif IsPedInVehicle(_pped, veh, false) then
                interval = 5
                pedInVehCloseDoor()
            else
                interval = 2500
                isMsgSend = false
            end
            if  #(_ppCoords - deliveryCoord) <= config.deliveryPoint.areaDistance then
                interval = 1
                DrawMarker(23, deliveryCoord.x, deliveryCoord.y, deliveryCoord.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 0, 50, false, true, 2, nil, nil, false)
                if #(GetEntityCoords(obj) - deliveryCoord) <= config.deliveryPoint.areaDistance and #(GetEntityCoords(veh) - deliveryCoord) <= config.deliveryPoint.areaDistance then
                    _End_()
                    QBCore.Functions.Notify(config.text.qbNotifyOnDeliveryPointsSucess, "success", 1000)
                    TriggerServerEvent("Goods:Server:giveMoney", config.ui.items[dataNumber].crateToGiveInGame.reward)
                else
                    if not msgIsSend then
                        QBCore.Functions.Notify(config.text.qbNotifyOnDeliveryPointsError, "error", 1000)
                        msgIsSend = true
                    end
                end
            else
                msgIsSend = false
            end
        end
        Wait(interval)
    end
end

-- start
function startJob()
    QBCore.Functions.TriggerCallback('Goods:Server:CallBack:removeMoney', function(bool)
        if bool then
            QBCore.Functions.Notify(config.text.crateBuying, 'success', 1000)
            SetEntityAlpha(jobPed, 0)
            SetEntityAlpha(jobPedPhoneObj, 0)
            Citizen.SetTimeout(config.jobTime * 1000 * 60, function() _End_() end)
            eventIsStart = true
            deliveryCoord = config.deliveryPoint.coords[math.random(#config.deliveryPoint.coords)]
            deliveryBlip = createBlips(deliveryCoord, config.deliveryPoint.blip.text, config.deliveryPoint.blip.sprite, config.deliveryPoint.blip.scale, config.deliveryPoint.blip.color, true)
            SetBlipRoute(deliveryBlip, true)
            QBCore.Functions.Notify(config.text.qbNotifyCrateHelp, "primary", 1000)
            createCrate(dataNumber)
        else
            QBCore.Functions.Notify(config.text.crateCantBuy, 'error', 1000)
            _End_()
        end
    end, config.ui.items[dataNumber].crateToGiveInGame.price)
end

AddEventHandler("onResourceStop", function()
    if GetCurrentResourceName() == currentScriptName then
        _End_("script")
    end
end)