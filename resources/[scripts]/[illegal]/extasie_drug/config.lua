Config = {}
Config.DrawDistance = 100.0
Config.Locale = 'fr'
Config.MarkerColor = { r = 0, g = 128, b = 0 }

Config.Zones = {
	Vente = {
		Pos = { x = -480.86, y = -63.16, z = 39.99 },
		Size = { x = 1.5, y = 1.5, z = 0.5 },
		Type = -1,
		ItemTime = 4000,
		ItemDb_name = 'extasie',
		ItemName = 'Extasie',
		ItemMax = 100,
		ItemRemove = 1,
		ItemRequires = 'extasie',
		ItemRequires_name = 'Extasie',
		ItemDrop = 100,
		ItemPrice = 600,
	},

	Traitement = {
		Pos = { x = -1153.71, y = -1521.54, z = 10.63 },
		Size = { x = 1.5, y = 1.5, z = 0.5 },
		Type = -1,
		ItemTime = 2000,
		ItemDb_name = 'extasie',
		ItemName = 'Extasie',
		ItemMax = 100,
		ItemAdd = 1,
		ItemRemove = 1,
		ItemRequires = 'lsd',
		ItemRequires_name = 'LSD',
		ItemRequires1 = 'coffee',
		ItemRequires_name1 = 'Café',
		ItemDrop = 100,
	},
}
