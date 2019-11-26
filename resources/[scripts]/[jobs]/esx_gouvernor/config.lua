----------------------------------------------------------------------
----------------------- Developped by AlphaKush ----------------------
----------------------------------------------------------------------

Config              = {}
Config.DrawDistance = 100.0
Config.MarkerColor  = {r = 0, g = 0, b = 240}
Config.EnableSocietyOwnedVehicles = false -- à tester
Config.EnablePlayerManagement     = true
Config.MaxInService               = 8
Config.Locale = 'fr'
Config.ImpotInterval        = 24 * 60 * 60000 -- 1 mois
Config.ImpotValue			= 5

Config.Cloakrooms = {
	CloakRoom = { --Vestaire privé président
		Pos   = {x = 124.201, y = -767.784, z = 242.15},
		--Pos   = {x = -473.86, y = -334.09, z = 91.007},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Type  = 20
	}
}

Config.Zones = {
	OfficeEnter = { --entré du batiement
		Pos   = {x = 136.14, y = -761.97, z = 44.85},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Type  = 26
	},

	OfficeExit = { -- sorti du batiment
		Pos   = {x = 136.14, y = -761.97, z = 241.25},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Type  = 26
	},

	OfficeInside = { -- spawn interieur batiment
		Pos   = {x = 135.32885742188, y = -764.09942626953, z = 242.15211486816},
		--Pos   = {x = -484.81475830078, y = -335.34713745117, z = 90.007614135742},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	OfficeOutside = { --spawn exterieur batiment
		--Pos   = {x = -428.12902832031, y = 1115.4178466797, z = 325.76840209961},
		Pos   = {x = 135.32885742188, y = -764.09942626953, z = 45.75},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	OfficeActions = { -- Marker action boss
		Pos   = {x = 156.23593139648, y = -740.03515625, z = 242.1519317624},
		--Pos   = {x = -449.40557861328, y = -339.91738891602, z = 90.007621765137},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 22
	},

	--- Garage ----

	CarGarage = {
		Pos   = { x = 61.715, y = -748.005, z = 44.215 },
		--Pos   = { x = -467.5237121582, y = 1128.8880615234, z = 325.85531616211 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 36,
		InsideShop = vector3(228.5, -993.5, -99.5),
		SpawnPoints = {
--			{ coords = vector3(-460.72052001953, 1127.3813476563, 324.85491943359), heading = 90.0, radius = 6.0 },
			{ coords = vector3(62.93, -742.95, 44.22), heading = 90.0, radius = 6.0 },

		}
	},

	------------ TP hélico -----------
	HelicoEnter = { -- entrée helico
		Pos   = {x = 138.03, y = -765.38, z = 242.15},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Type  = 34
	},

	HelicoInside = { -- spawn interieur place helico
		Pos   = {x = -499.70416259766, y = -322.44952392578, z = 72.168121337891},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	HelicoExit = { -- exit helico
		Pos   = {x = -499.54034423828, y = -324.3981628418, z = 72.168121337891},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	HelicoOutside = { -- spawn interieur batiment president
		Pos   = {x = 135.32885742188, y = -764.09942626953, z = 242.15211486816},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	HelicoSpawner = { -- Menu pour spawn l'hélico
		Pos   = {x = -499.01245117188, y = -317.38745117188, z = 72.168121337891},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	HelicoSpawnPoint = { --Spawn de l'hélico sur la plateforme
		Pos   = {x = -506.28784179688, y = -307.75677490234, z = 75.047210693359}, --Heading = 291.4347
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	HelicoDeleter = { -- Marker pour ranger l'hélico
		Pos   = {x = -506.3141784668, y = -307.77444458008, z = 74.047294616699},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'stretch', label = 'Limousine', price = 10 },
		{ model = 'fbi2', label = 'SUV', price = 10 }
	},
	security_gouvernor = {},
	assistant = {},
	boss = {}
}