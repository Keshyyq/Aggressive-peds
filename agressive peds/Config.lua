Config = {}

Config.defaultRespawnTime = 40*60*1000 -- 40min

Config.Locations = {
    {
        coords = vector4(-666.83526611328, -1207.5611572266, 10.606995582581, 70.45654296875),
        model = `csb_mweather`,
        weapon = `WEAPON_CARBINERIFLE`,
        respawnTime = 30000, -- 30 sek
        priceForKill = 100,
        items = {
            {
                name = "water",
                min = 1,
                max = 3
            },
            {
                name = "bread",
                min = 2,
                max = 2
            }
        }
    }
}