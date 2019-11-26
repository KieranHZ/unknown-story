Config = {}

Config.DrawDistance = 100.0
Config.MarkerType = 1
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 146, g = 216, b = 254 }

Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true
Config.EnableESXIdentity = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds = false -- turn this on if you want custom peds
Config.EnableLicenses = true -- enable if you're using esx_license

Config.EnableHandcuffTimer = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer = 10 * 60000 -- 10 mins

Config.EnableJobBlip = true -- enable blips for colleagues, requires esx_society

Config.MaxInService = 8
Config.Locale = 'fr'

Config.PoliceStations = {

    LSPD = {

        Blip = {
            Coords = vector3(425.1, -979.5, 30.7),
            Sprite = 60,
            Display = 4,
            Scale = 0.7,
            Colour = 29
        },

        Cloakrooms = {
            vector3(452.6, -992.8, 30.6)
        },

        Armories = {
            vector3(451.7, -980.1, 30.6)
        },

        Vehicles = {
            {
                Spawner = vector3(450, -1017.92, 28.526),
                InsideShop = vector3(228.5, -993.5, -99.5),
                SpawnPoints = {
                    { coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
                    { coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0 },
                    { coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0 },
                    { coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0 }
                }
            },

            {
                Spawner = vector3(473.3, -1018.8, 28.0),
                InsideShop = vector3(228.5, -993.5, -99.0),
                SpawnPoints = {
                    { coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0 },
                    { coords = vector3(484.1, -1023.1, 27.5), heading = 302.5, radius = 6.0 }
                }
            }
        },

        Helicopters = {
            {
                Spawner = vector3(461.1, -981.5, 43.6),
                InsideShop = vector3(477.0, -1106.4, 43.0),
                SpawnPoints = {
                    { coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
                }
            }
        },

        BossActions = {
            vector3(448.4, -973.2, 30.6)
        }

    }

}

Config.AuthorizedWeapons = {
    recruit = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
        { weapon = 'WEAPON_TEARGAS', price = 0 }
    },

    officer = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },

    sergeant = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', components = { 0, 0, 0, 0, 0, nil, nil, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },

    captain = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', components = { 0, 0, 0, 0, 0, nil, nil, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
        { weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 }
    },

    lieutenant = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', components = { 0, 0, 0, 0, 0, nil, nil, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 }
    },

    chef = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', components = { 0, 0, 0, 0, 0, nil, nil, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_HEAVYSNIPER', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
        { weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 }
    },

    boss = {
        { weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_CARBINERIFLE', components = { 0, 0, 0, 0, 0, nil, nil, nil }, price = 0 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
        { weapon = 'WEAPON_HEAVYSNIPER', price = 0 },
        { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
        { weapon = 'WEAPON_STUNGUN', price = 0 },
        { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
        { weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 }
    }
}

Config.AuthorizedVehicles = {
    Shared = {
        { model = 'police', label = 'Vl 1', price = 35000 },
        { model = 'sheriff2', label = 'Vl 5', price = 45000 },
        { model = 'policeb', label = 'Moto', price = 25000 },
        { model = 'policet', label = 'Fourgonette', price = 43000 },
        { model = 'riot', label = 'Anti Émeutes', price = 96000 },
        { model = 'fbi2', label = 'SUV banalisé', price = 56000 },
        { model = 'fbi', label = 'Bufallo banalisée', price = 64000 },
        { model = 'pbus', label = 'Bus pénitentier', price = 118000 }
    },

    recruit = {},

    officer = {},

    sergeant = {},

    intendent = {},

    lieutenant = {},

    chef = {},

    boss = {}
}

Config.AuthorizedHelicopters = {
    Shared = {
        { model = 'polmav', label = 'Hélicoptere', price = 200000 }
    },
    recruit = {},
    officer = {},
    sergeant = {},
    intendent = {},
    lieutenant = {},
    chef = {},
    boss = {}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
    recruit_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0

        }
    },
    officer_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },
    sergeant_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 8, ['decals_2'] = 1,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 7, ['decals_2'] = 1,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },
    intendent_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 8, ['decals_2'] = 2,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 7, ['decals_2'] = 2,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },
    lieutenant_wear = { -- currently the same as intendent_wear
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 8, ['decals_2'] = 2,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 7, ['decals_2'] = 2,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },
    captain_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 8, ['decals_2'] = 3,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 7, ['decals_2'] = 3,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },
    boss_wear = { -- currently the same as chef_wear
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 8, ['decals_2'] = 3,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 7, ['decals_2'] = 3,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    },


    undercover_wear = { -- currently the same as chef_wear
        male = {
            ['chain_1'] = 0, ['chain_2'] = 0

        },
        female = {
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },


    bullet_wear = {
        male = {
            ['bproof_1'] = 11, ['bproof_2'] = 1
        },
        female = {
            ['bproof_1'] = 13, ['bproof_2'] = 1
        }
    },

    nobullet_wear = {
        male = {
            ['bproof_1'] = -1, ['bproof_2'] = 0
        },
        female = {
            ['bproof_1'] = -1, ['bproof_2'] = 0
        }
    },

    gilet_wear = {
        male = {
            ['tshirt_1'] = 59, ['tshirt_2'] = 1
        },
        female = {
            ['tshirt_1'] = 36, ['tshirt_2'] = 1
        }
    },

    nogilet_wear = {
        male = {
            ['tshirt_1'] = 58, ['tshirt_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35, ['tshirt_2'] = 0
        }
    }


}