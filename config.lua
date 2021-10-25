Config = {}

Config.Locale = 'en'

Config.DisplayRadar = true -- Only show radar when player is into vehicle.
Config.SpeedUnit = 'kmh' -- kmh/mph
Config.EnableDobleJob = true -- Only for esx
Config.Logo = "https://cdn.discordapp.com/attachments/896182274012360725/901979947944509440/iloveyourmom72.png" -- Server logo
Config.Commands = {
    RefreshRate = 'refreshrate'
}

Config.Locales = {
    ['en'] = {
        -- Vehicle hud
        gear_text = 'Gear',
        -- Refresh rate
        refreshRate = 'The hud will now refresh every %s seconds.'
    },
    ['es'] = {
        -- Hud del vehículo
        gear_text = 'Marcha',
        -- Tasa de refresco
        refreshRate = 'Ahora el hud se refrescara cada %s segundos'
    }
}