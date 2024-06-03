# Goods [[New]]()
_Players can delievery crate to a random point (set in config) and earn money_

## Video
---------------------------------------------------------------
[![Watch the video](upload://aykIUjLNNlT9OXrq9KhAaPB1u7s.webp)](https://youtu.be/KbqL8gSKPWQ)

## Socials
---------------------------------------------------------------
[![image](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@fmscripts)
[![image](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/FMscripts1)

# Script details
---------------------------------------------------------------
### Get Now (**FREE**) :
> [Tebex link]()
> [Github link]()

<details>
<summary>CONFIG</summary>
Code:

    config = {}

    config.jobTime = 5 -- minute
    config.ui = {}
    config.ui.title = "Crates List"
    config.ui.items =
    {
    -- {title = // title in the UI //, img = // image in the UI ( images/... ) //, crateToGiveInGame = {Model = // model of crate //, reward = // QBCore money //, price = // QBCore money //}}
    -- view " https://gta-objects.xyz/objects " to download image
    {title = "crate n°1", img = "crate1.jpg", textReward = "Reward: ", textPrice = "Price: ", crateToGiveInGame = {model = "prop_drop_armscrate_01b", reward = 1500, price = 500}}, -- prop_drop_armscrate_01b
    {title = "crate n°2", img = "crate2.jpg", textReward = "Reward: ", textPrice = "Price: ", crateToGiveInGame = {model = "gr_prop_gr_bulletscrate_01a", reward = 500, price = 500}}, -- gr_prop_gr_bulletscrate_01a  1689716886
    {title = "crate n°3", img = "crate3.jpg", textReward = "Reward: ", textPrice = "Price: ", crateToGiveInGame = {model = "prop_drop_armscrate_01b", reward = 500, price = 500}}, -- prop_drop_armscrate_01b  1877891248
    {title = "crate n°4", img = "crate4.jpg", textReward = "Reward: ", textPrice = "Price: ", crateToGiveInGame = {model = "sm_prop_smug_rsply_crate02a", reward = 500, price = 500}}, -- sm_prop_smug_rsply_crate02a  1340115820
    {title = "crate n°5", img = "crate5.jpg", textReward = "Reward: ", textPrice = "Price: ", crateToGiveInGame = {model = "xm_prop_smug_crate_s_medical", reward = 500, price = 500}},  -- xm_prop_smug_crate_s_medical  -1122773000
    }
    config.ui.buyCrate = {}
    config.ui.buyCrate.MenuRentingCarText = "renting a car ?"
    config.ui.buyCrate.MenuRentingCarButtonAndRadioText = {labelRadio = {"yes", "no"}, submit = "Purchase"}
    config.interactKey = 51 --E

    config.ped = {}
    config.ped.model = "a_m_m_paparazzi_01"
    config.ped.coords = vector4(-1013.72, -489.07, 36.05, 120.0)

    config.blip = {}
    config.blip.coords = vector4(-1013.72, -489.07, 36.05, 120.0)
    config.blip.scale = 0.8
    config.blip.sprite = 85
    config.blip.color = 2
    config.blip.text = "~b~Job: ~w~Delivery"

    config.vehicle = {}
    config.vehicle.spawnCoords = vector4(-1050.97, -503.69, 36.04, 24.98)
    config.vehicle.plate = "MARCHAND"
    config.vehicle.list =
    {
    -- WARNING for collision of crate and vehicle
    {model = "mule2", price = 100, door = {0,5}--[[ door(s) to open ]]},
    {model = "benson", price = 200, door = {0,5}},

    }
    config.vehicle.control =
    {
    -- for the choice of vehicule
    forRight = 15, -- SCROLLWHEEL UP
    forLeft = 14, -- SCROLLWHEEL DOWN
    forDone = 22 -- spacebar
    }

    config.deliveryPoint = {}
    config.deliveryPoint.coords =
    {
    vector3(964.17, -1856.9, 31.2),
    vector3(-1556.66, 230.01, 59.51),
    vector3(-975.18, -2544.79, 13.98),
    }
    config.deliveryPoint.areaDistance = 7
    config.deliveryPoint.blip = {}
    config.deliveryPoint.blip.scale = 0.8
    config.deliveryPoint.blip.sprite = 85
    config.deliveryPoint.blip.color = 1
    config.deliveryPoint.blip.text = "~r~DELIVERY POINT"

    config.text = {}
    config.text.qbTargetPed = "do the job"
    config.text.qbTargetPedIcons = "fa-solid fa-truck"
    config.text.qbTargetCrate = "Take"
    config.text.qbTargetCrateIcons = "fa-solid fa-truck-fast"
    config.text.crateBuying = "You buying a crate"
    config.text.crateCantBuy = "You don't have enough money"
    config.text.vehicleChoiceTextBefore = "Price: "
    config.text.vehicleChoiceTextAfter = " $"
    config.text.vehicleBuying = "You buying a vehicle"
    config.text.vehicleCantBuying = "You don't have enough money"
    config.text.qbNotifyCrateHelp = "Put this crate into the vehicle"
    config.text.qbDrawTextCrateKeyIndicator = "Press [E] to set down the crate"
    config.text.qbDrawTextVehicleHelp = "Press [E] to open/close vehicle door"
    config.text.qbNotifyOnDeliveryPointsError = "Bring crate AND vehicle !"
    config.text.qbNotifyOnDeliveryPointsSucess = "Good job"

</details>
