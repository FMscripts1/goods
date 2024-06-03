--GLOBAL VARIABLES
QBCore = exports['qb-core']:GetCoreObject()
currentScriptName = GetCurrentResourceName()
    ----config----
vehList = config.vehicle.list
    ----player----
_pped = PlayerPedId()
_ppCoords = GetEntityCoords(_pped)
_ppHeading = GetEntityHeading(_pped)
_ppVec4 = vector4(_ppCoords, _ppHeading)
    --------------
jobPed = nil
jobPedPhoneObj = nil
cam = nil
vehChoice = nil
veh = nil
obj = nil
deliveryCoord  = nil
deliveryBlip  = nil
dataNumber = nil
jobTimer = 0

intervalManagementBool = false
eventIsStart = false
playerHasCrateInHands = false
isMsgSend = false
doorStatusOpen = true

--EVENTS REGISTER
RegisterNetEvent('Goods:Client:createVehicle')