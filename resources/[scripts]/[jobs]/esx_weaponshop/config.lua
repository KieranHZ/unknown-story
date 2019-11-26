Config               = {}

Config.DrawDistance  = 100
Config.Size          = { x = 1.5, y = 1.5, z = 0.5 }
Config.Color         = { r = 0, g = 128, b = 255 }
Config.Type          = 1
Config.Locale        = 'fr'

Config.LicenseEnable = true -- only turn this on if you are using esx_license
Config.LicensePrice  = 10000

Config.Zones = {

	PPA = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(459.58, -982.28, 29.68)
		}
	},

	GunShop = {
		Legal = true,
		Items = {
			{ weapon = 'WEAPON_PISTOL', components = { 200, 500, 1000, 4000, nil }, price = 30000, ammoPrice = 500, AmmoToGive = 20 },
			{ weapon = 'WEAPON_NIGHTSTICK', price = 560},
			{ weapon = 'WEAPON_STUNGUN', price = 4500},
			{ weapon = 'WEAPON_FLASHLIGHT', price = 600},
			{ weapon = 'WEAPON_BAT', price = 350},
			{ weapon = 'WEAPON_BALL', price = 50},
		},
		Locations = {
			vector3(-662.1, -935.3, 20.8),
			vector3(810.2, -2157.3, 28.6),
			vector3(1693.4, 3759.5, 33.7),
			vector3(-330.2, 6083.8, 30.4),
			vector3(252.3, -50.0, 68.9),
			vector3(22.0, -1107.2, 28.8),
			vector3(2567.6, 294.3, 107.7),
			vector3(-1117.5, 2698.6, 17.5),
			vector3(842.4, -1033.4, 27.1),
		}
	},

	BlackWeashop = {
		Legal = false,
		Items = {
			{ weapon = 'WEAPON_PISTOL', price = 40000, ammoPrice = 500, AmmoToGive = 10 },
			{ weapon = 'WEAPON_MICROSMG', price = 200000, ammoPrice = 2000, AmmoToGive = 10 },
			{ weapon = 'WEAPON_PUMPSHOTGUN', price = 230000, ammoPrice = 2300, AmmoToGive = 10 },
			{ weapon = 'WEAPON_ASSAULTRIFLE', price = 350000, ammoPrice = 3500, AmmoToGive = 10 },
			{ weapon = 'WEAPON_SNIPERRIFLE', price = 2100000, ammoPrice = 40000, AmmoToGive = 5 },
			{ weapon = 'WEAPON_FLASHLIGHT', price = 600},
			{ weapon = 'WEAPON_SMOKEGRENADE', price = 12000},
			{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 1000},
			{ weapon = 'WEAPON_BALL', price = 50},
			{ weapon = 'WEAPON_STUNGUN', price = 9000},
			{ weapon = 'WEAPON_NIGHTSTICK', price = 1120},
			{ weapon = 'WEAPON_MACHETE', price = 1500},
			{ weapon = 'WEAPON_BAT', price = 700}
		},
		Locations = {
			vector3(153.42, -3074.79, 4.8)
		}
	}
}
