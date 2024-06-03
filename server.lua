local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('Goods:Server:CallBack:removeMoney', function(source, cb, money)
    _src = source
    money = tonumber(money)
    local Player = QBCore.Functions.GetPlayer(_src)
    local bool = Player.Functions.RemoveMoney('cash', money, "banking-quick-withdraw")
    cb(bool)
end)

RegisterNetEvent("Goods:Server:giveMoney")
AddEventHandler("Goods:Server:giveMoney", function(money)
    _src = source
    money = tonumber(money)
    local Player = QBCore.Functions.GetPlayer(_src)
    QBCore.Functions.GetPlayer(_src).Functions.AddMoney('cash', money, "banking-quick-withdraw")
end)