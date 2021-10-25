-- Vars
ESX = nil
Script = {
    Zones = { ['golf'] = "Los Santos Golf Club", ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" },
    Speeds = {
        ['kmh'] = 3.6,
        ['mph'] = 2.236936
    }
}
PLAYER = {
    RefreshRate = 1, -- Default hud refresh rate
    Hunger = 0,
    Thirst = 0,
    Stress = 0,
    Loaded = false
}

-- Core init
if GetResourceState('es_extended') == 'started' then
    -- If u use esx_legacy u can remove this and add import in the fxmanifest.lua
    CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
    end)

elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetSharedObject()
end

-- Commands
RegisterCommand(Config.Commands.RefreshRate, function(src, args)
    if args[1] then
        PLAYER.RefreshRate = args[1]
        Notify(string.format(Config.Locales[Config.Locale].refreshRate, args[1]), 2000)
    end
end)

-- Threads

CreateThread(function()
    local cash = 'money'
    if GetResourceState('qb-core') == 'started' then
        cash = 'cash'
    end
    local job = ""
    local dobleJob = nil
    while true do
        if PLAYER.Loaded then
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            local street1, street2 = GetStreetNameAtCoord(PlayerCoords, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local PlayerVehicle = GetVehiclePedIsIn(Player)
            if GetResourceState('es_extended') == 'started' then
                local PD = ESX.GetPlayerData()
                job = PD.job.label.." - "..PD.job.grade_label
                if Config.EnableDobleJob then
                    dobleJob = PD.job2.label.." - "..PD.job2.grade_label
                end
            else
                local PD = QBCore.PlayerData
                job = PD.job.label.." - "..PD.job.grade.name
            end
            getPlayerStatus()
            SendNUIMessage({
                bank = getPlayerMoney('bank'),
                money = getPlayerMoney(cash),
                vehicle = (PlayerVehicle ~= 0),
                main_street = Script.Zones[GetNameOfZone(PlayerCoords)],
                substreet = GetStreetNameFromHashKey(street2),
                stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
                pause = IsPauseMenuActive(), 
                health = GetEntityHealth(Player), 
                armour = GetPedArmour(Player),
                logo = Config.Logo,
                -- Needs
                hunger = PLAYER.Hunger,
                thirst = PLAYER.Thirst,
                stress = PLAYER.Stress,
                -- Vehicle
                speed = getVehicleData(Player, PlayerVehicle).speed,
                speedunit = Config.SpeedUnit,
                gear_text = Config.Locales[Config.Locale].gear_text,
                gear = getVehicleData(Player, PlayerVehicle).gear,
                fuel = getVehicleData(Player, PlayerVehicle).fuel,
                -- Job
                job = job,
                job2 = dobleJob
            })

            HideHudComponentThisFrame(2) -- WEAPON_ICON
            HideHudComponentThisFrame(3) -- CASH
            HideHudComponentThisFrame(4) -- MP_CASH
            HideHudComponentThisFrame(6) -- MP_MESSAGE
            HideHudComponentThisFrame(7) -- VEHICLE_NAME
            HideHudComponentThisFrame(8) -- AREA_NAME
            HideHudComponentThisFrame(9) -- STREET_NAME
            HideHudComponentThisFrame(13) -- CASH_CHANGE
            HideHudComponentThisFrame(17) -- SAVING_GAME
            HideHudComponentThisFrame(20) -- WEAPON_WHEEL_STATS

            if Config.DisplayRadar then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then 
                    DisplayRadar(false)
                else
                    DisplayRadar(true)
                end
            end
        end

        Wait(PLAYER.RefreshRate * 1000)
    end
end)

-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PLAYER.Loaded = true
end)

RegisterNetEvent('esx:playerLoaded', function()
    PLAYER.Loaded = true
end)

-- Funcs
function getPlayerMoney(account)
    if GetResourceState('es_extended') == 'started' then
        for i,v in pairs(ESX.GetPlayerData().accounts) do
            if v.name == account then
                return groupDigits(v.money)
            end
        end
    else
        return groupDigits(QBCore.PlayerData.money[account])
    end
end

function groupDigits(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())..right
end

function getPlayerStatus()
    if GetResourceState('es_extended') == 'started' then
        AddEventHandler('esx_status:onTick', function(status)
            for i,v in pairs(status) do
                if v.name == 'hunger' then 
                    PLAYER.Hunger = v.percent
                elseif v.name == 'thirst' then 
                    PLAYER.Thirst = v.percent
                elseif v.name == 'stress' then 
                    PLAYER.Stress = v.percent
                end
            end
        end)
    else
        PLAYER.Thirst = QBCore.PlayerData.metadata['thirst']
        PLAYER.Hunger = QBCore.PlayerData.metadata['hunger']
        if Config.Stress then
            PLAYER.Stress = QBCore.PlayerData.metadata['stress']
        end
    end
end

function getVehicleData(Player, PlayerVehicle)
    if IsPedInAnyVehicle(Player) then
        local speed = math.floor((GetEntitySpeed(PlayerVehicle) * Script.Speeds[Config.SpeedUnit]) + 0.5)
        local gear = GetVehicleCurrentGear(PlayerVehicle)
        local fuel = math.floor(GetVehicleFuelLevel(PlayerVehicle))
        
        return {speed = speed, gear = gear, fuel = fuel}
    else
        return {speed = 0, gear = 0, fuel = 0}
    end
end

function Notify(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end