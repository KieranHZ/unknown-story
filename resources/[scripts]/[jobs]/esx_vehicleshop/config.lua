Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType 				  = 1
Config.MarkerSize 				  = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 128, g = 128, b = 0 }
Config.EnablePlayerManagement     = true -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false -- use with EnablePlayerManagement disabled, or else it wont have any effects
Config.ResellPercentage           = 50

Config.Locale                     = 'fr'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true
Config.MaxInService = 8

Config.Cloakrooms = {
	Cloakroom = {
		Pos = { x = -36.6, y = -1084.7, z = 26.422},
		Size = { x = 1.0, y = 1.0, z = 1.0 },
		Type = 20
	},
}
Config.Zones = {
	ShopEntering = {
		Pos   = { x = -33.777, y = -1102.021, z = 26.422 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 36
	},

	ShopInside = {
		Pos     = { x = -47.570, y = -1097.221, z = 25.422 },
		Size    = { x = 1.0, y = 1.0, z = 1.0 },
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -28.637, y = -1085.691, z = 25.565 },
		Size    = { x = 1.0, y = 1.0, z = 1.0 },
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -32.065, y = -1114.277, z = 26.422 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = { x = -18.227, y = -1078.558, z = 25.675 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = (Config.EnablePlayerManagement and 27 or -1)
	},

	ResellVehicle = {
		Pos   = { x = -44.630, y = -1080.738, z = 25.683 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	},
	CarGarage = {
		Pos = { x = -9.010, y = -1090.84, z = 26.67 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 36,
		InsideShop = vector3(228.5, -993.5, -99.5),
		SpawnPoints = {
			{ coords = vector3(-14.88, -1092.96, 26.67), heading = 90.0, radius = 6.0 },
		},
		hint = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage',
	},
}

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 31, ['tshirt_2'] = 0,
			['torso_1'] = 101, ['torso_2'] = 2,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 48, ['pants_2'] = 0,
			['shoes_1'] = 40, ['shoes_2'] = 9,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 29, ['tshirt_2'] = 0,
			['torso_1'] = 86, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 9,
			['pants_1'] = 101, ['pants_2'] = 12,
			['shoes_1'] = 3, ['shoes_2'] = 3,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
	novice_wear = {
		male = {
			['tshirt_1'] = 31, ['tshirt_2'] = 0,
			['torso_1'] = 101, ['torso_2'] = 2,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 48, ['pants_2'] = 0,
			['shoes_1'] = 40, ['shoes_2'] = 9,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 26, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 98, ['pants_2'] = 13,
			['shoes_1'] = 26, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
	experienced_wear = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 248, ['torso_2'] = 15,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 16,
			['pants_1'] = 102, ['pants_2'] = 0,
			['shoes_1'] = 32, ['shoes_2'] = 3,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 26, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 98, ['pants_2'] = 13,
			['shoes_1'] = 26, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 31, ['tshirt_2'] = 2,
			['torso_1'] = 31, ['torso_2'] = 5,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 35, ['pants_2'] = 0,
			['shoes_1'] = 21, ['shoes_2'] = 9,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 26, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 98, ['pants_2'] = 13,
			['shoes_1'] = 26, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'flatbed', label = 'Camion plateau', price = 25000 },
		{ model = 'freightliner', label = 'Dépaneuse poids légers', price = 25000 },
		{ model = 'hdwrecker', label = 'Dépaneuse poids lourds', price = 50000 },
		{ model = 'SlamVan3', label = 'SlamVan Custom', price = 25000 },
	},
	recruit = {},
	novice = {},
	experienced = {},
	boss = {}
}
