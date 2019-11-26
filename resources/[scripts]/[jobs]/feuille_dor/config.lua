Config = {}
Config.DrawDistance = 100.0
Config.Locale = 'fr'
Config.MaxInService = 8
Config.MarkerColor = { r = 0, g = 128, b = 0 }
Config.EnablePlayerManagement = true

Config.Cloakrooms = {
	Cloakroom = {
		Pos = { x = -76.29, y = -1410.08, z = 29.35},
		Size = { x = 1.0, y = 1.0, z = 1.0 },
		Type = 20
	},
}


Config.Zones = {

	Vente = {
		Pos = { x = -1174.15, y = -1572.32, z = 4.36 },
		Size = { x = 2.0, y = 2.0, z = 2.0 },
		Type = 29,
		ItemTime = 500,
		ItemDb_name = 'weed',
		ItemName = 'Weed',
		ItemMax = 100,
		ItemRemove = 1,
		ItemRequires = 'weed',
		ItemRequires_name = 'Weed',
		ItemDrop = 100,
		ItemPrice = 20,
	},

	Recolte = {
		--Pos   = { x = 2215.88, y = 5576.37, z = 52.58},
		Pos = { x = -78.29, y = -1401.65, z = 28.35 },
		Size = { x = 3.0, y = 3.0, z = 2.0 },
		Type = -1,
		ItemTime = 500,
		ItemDb_name = 'weedhead',
		ItemName = 'Tête de weed',
		ItemMax = 50,
		ItemAdd = 1,
		ItemRemove = 1,
		ItemRequires = 'weedhead',
		ItemRequires_name = 'Tête de weed',
		ItemDrop = 100,
	},

	Traitement = {
		--Pos   = { x = 2221.61, y = 5614.64, z = 54.9 },
		Pos = { x = -79.10, y = -1394.19, z = 28.65 },
		Size = { x = 3.0, y = 3.0, z = 2.0 },
		Type = -1,
		ItemTime = 500,
		ItemDb_name = 'weed',
		ItemName = 'Weed',
		ItemMax = 100,
		ItemAdd = 2,
		ItemRemove = 1,
		ItemRequires = 'weed',
		ItemRequires_name = 'Weed',
		ItemDrop = 100,
	},

	CarGarage = {
		--Pos   = { x = 2197.191, y = 5610.72, z = 53.56 },
		Pos = { x = -76.94, y = -1411.84, z = 29.35 },
		Size = { x = 1.0, y = 1.0, z = 1.0 },
		Type = 36,
		InsideShop = vector3(228.5, -993.5, -99.5),
		SpawnPoints = {
			--{ coords = vector3(2200.4, 5616.0, 53.87), heading = 90.0, radius = 6.0 },
			{ coords = vector3(-82.11, -1411.70, 29.35), heading = 90.0, radius = 6.0 },
		}
	},

	BossActions = {
		--Pos = { x = 2222.73, y = 5608.47, z = 54.70 },
		Pos = { x = -84.115, y = -1401.28, z = 29.36 },
		Size = { x = 1.0, y = 1.0, z = 1.0 },
		Type = 22
	},
}


Config.Uniforms = {
	jardin_wear = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 65, ['torso_2'] = 2,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 38, ['pants_2'] = 2,
			['shoes_1'] = 24, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 2, ['tshirt_2'] = 0,
			['torso_1'] = 59, ['torso_2'] = 2,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 38, ['pants_2'] = 2,
			['shoes_1'] = 24, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	},
}


Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'pony', label = 'Weedmobile', price = 35000 }
	},
	jardinier = {},
	boss = {}
}
