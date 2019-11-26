Config = {}
Config.DrawDistance = 100.0

Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableVaultManagement = true
Config.EnableHelicopters = false
Config.EnableMoneyWash = true
Config.MaxInService = 8
Config.Locale = 'fr'
Config.MissCraft = 10
Config.MarkerColor = { r = 171, g = 35, b = 205 }

Config.AuthorizedVehicles = {
    Shared = {
        { model = 'rumpo', label = 'Unicorn Camionette', price = 35000 }
    },
    barman = {},
    dancer = {},
    boss = {}
}

Config.Blips = {
    Blip = {
        Pos = { x = 129.246, y = -1299.363, z = 29.501 },
        Sprite = 121,
        Display = 4,
        Scale = 0.7,
        Colour = 27,
    },
}

Config.Cloakrooms = {
    Cloakrooms = {
        Pos = { x = 105.111, y = -1303.221, z = 27.788 },
        Size = { x = 1.5, y = 1.5, z = 1.0 },
        Type = 27,
    },
}

Config.Zones = {
    Vaults = {
        Pos = { x = 93.406, y = -1291.753, z = 28.288 },
        Size = { x = 1.3, y = 1.3, z = 1.0 },
        Type = 23,
    },

    Fridge = {
        Pos = { x = 135.478, y = -1288.615, z = 28.289 },
        Size = { x = 1.6, y = 1.6, z = 1.0 },
        Type = 23,
    },

    CarGarage = {
        Pos = { x = 137.177, y = -1278.757, z = 29.371 },
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Type = 36,
        InsideShop = vector3(228.5, -993.5, -99.5),
        SpawnPoints = {
            { coords = vector3(143.04, -1275.72, 29.11), heading = 90.0, radius = 6.0 },
        }
    },

    BossActions = {
        Pos = { x = 94.951, y = -1294.021, z = 28.268 },
        Size = { x = 1.5, y = 1.5, z = 1.0 },
        Type = 1,
    },


    -----------------------
    -------- SHOPS --------

    Flacons = {
        Pos = { x = -2955.242, y = 385.897, z = 14.041 },
        Size = { x = 1.6, y = 1.6, z = 1.0 },
        Type = 23,
        Items = {
            { name = 'jager', label = _U('jager'), price = 3 },
            { name = 'vodka', label = _U('vodka'), price = 4 },
            { name = 'rhum', label = _U('rhum'), price = 2 },
            { name = 'whisky', label = _U('whisky'), price = 7 },
            { name = 'tequila', label = _U('tequila'), price = 2 },
            { name = 'martini', label = _U('martini'), price = 5 }
        },
    },

    NoAlcool = {
        Pos = { x = 178.028, y = 307.467, z = 104.392 },
        Size = { x = 1.6, y = 1.6, z = 1.0 },
        Type = 23,
        Items = {
            { name = 'soda', label = _U('soda'), price = 4 },
            { name = 'jusfruit', label = _U('jusfruit'), price = 3 },
            { name = 'icetea', label = _U('icetea'), price = 4 },
            { name = 'energy', label = _U('energy'), price = 7 },
            { name = 'drpepper', label = _U('drpepper'), price = 2 },
            { name = 'limonade', label = _U('limonade'), price = 1 }
        },
    },

    Apero = {
        Pos = { x = 98.675, y = -1809.498, z = 26.095 },
        Size = { x = 1.6, y = 1.6, z = 1.0 },
        Type = 23,
        Items = {
            { name = 'bolcacahuetes', label = _U('bolcacahuetes'), price = 7 },
            { name = 'bolnoixcajou', label = _U('bolnoixcajou'), price = 10 },
            { name = 'bolpistache', label = _U('bolpistache'), price = 15 },
            { name = 'bolchips', label = _U('bolchips'), price = 5 },
            { name = 'saucisson', label = _U('saucisson'), price = 25 },
            { name = 'grapperaisin', label = _U('grapperaisin'), price = 15 }
        },
    },

    Ice = {
        Pos = { x = 26.979, y = -1343.457, z = 28.517 },
        Size = { x = 1.6, y = 1.6, z = 1.0 },
        Type = 23,
        Items = {
            { name = 'ice', label = _U('ice'), price = 1 },
            { name = 'menthe', label = _U('menthe'), price = 2 }
        },
    },
}


-----------------------
----- TELEPORTERS -----

Config.TeleportZones = {
    EnterBuilding = {
        Pos = { x = 132.608, y = -1293.978, z = 28.269 },
        Size = { x = 1.2, y = 1.2, z = 0.1 },
        Color = { r = 128, g = 128, b = 128 },
        Marker = 1,
        Hint = _U('e_to_enter_1'),
        Teleport = { x = 126.742, y = -1278.386, z = 28.569 }
    },

    ExitBuilding = {
        Pos = { x = 132.517, y = -1290.901, z = 28.269 },
        Size = { x = 1.2, y = 1.2, z = 0.1 },
        Color = { r = 128, g = 128, b = 128 },
        Marker = 1,
        Hint = _U('e_to_exit_1'),
        Teleport = { x = 131.175, y = -1295.598, z = 28.569 },
    },
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
    barman_outfit = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 40, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 40,
            ['pants_1'] = 28, ['pants_2'] = 2,
            ['shoes_1'] = 38, ['shoes_2'] = 4,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 8, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 5,
            ['pants_1'] = 44, ['pants_2'] = 4,
            ['shoes_1'] = 0, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 2
        }
    },
    dancer_outfit_1 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 40,
            ['pants_1'] = 61, ['pants_2'] = 9,
            ['shoes_1'] = 16, ['shoes_2'] = 9,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 22, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 4,
            ['pants_1'] = 22, ['pants_2'] = 0,
            ['shoes_1'] = 18, ['shoes_2'] = 0,
            ['chain_1'] = 61, ['chain_2'] = 1
        }
    },
    dancer_outfit_2 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 62, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 4, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 22, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 4,
            ['pants_1'] = 20, ['pants_2'] = 2,
            ['shoes_1'] = 18, ['shoes_2'] = 2,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },
    dancer_outfit_3 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 4, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 22, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 19, ['pants_2'] = 1,
            ['shoes_1'] = 19, ['shoes_2'] = 3,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },
    dancer_outfit_4 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 61, ['pants_2'] = 5,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 82, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 63, ['pants_2'] = 11,
            ['shoes_1'] = 41, ['shoes_2'] = 11,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },
    dancer_outfit_5 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 21, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 5,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 63, ['pants_2'] = 2,
            ['shoes_1'] = 41, ['shoes_2'] = 2,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },
    dancer_outfit_6 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 81, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 18, ['torso_2'] = 3,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 63, ['pants_2'] = 10,
            ['shoes_1'] = 41, ['shoes_2'] = 10,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },
    dancer_outfit_7 = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 40,
            ['pants_1'] = 61, ['pants_2'] = 9,
            ['shoes_1'] = 16, ['shoes_2'] = 9,
            ['chain_1'] = 118, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 3, ['tshirt_2'] = 0,
            ['torso_1'] = 111, ['torso_2'] = 6,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 63, ['pants_2'] = 6,
            ['shoes_1'] = 41, ['shoes_2'] = 6,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    }
}
