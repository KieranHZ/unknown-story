--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 0


-- If true, ignore rest of file
Config.WeightSqlBased = false


-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:


Config.localWeight = {
    gold = 500,
    copper = 500,
    diamond = 500,
    iron = 500,
    washed_stone = 500,
    stone = 500,
    wood = 500,
    cutted_wood = 500,
    packaged_plank = 500,
    petrol = 500,
    fish = 500,
    packaged_chicken = 500,
    slaughtered_chicken = 500,
    alive_chicken = 500,
    petrol_raffin = 500,
    essence = 500,
    whool = 500,
    fabric = 500,
    clothe = 500,
    bag = 2500,
	bread = 125,
	water = 330,
    weedhead = 80,
    weed = 40,
    mechanic_piece = 2500,
    ergot = 80,
    lsd = 40,
    extasie = 40,
    coffee = 40,
	WEAPON_COMBATPISTOL = 100, -- poid poir une munnition
    WEAPON_KNIFE = 500,
    WEAPON_NIGHTSTICK = 300,
    WEAPON_HAMMER = 700,
    WEAPON_BAT = 700,
    WEAPON_PISTOL = 100,
    WEAPON_PISTOL50 = 100,
    WEAPON_APPISTOL = 100,
    WEAPON_REVOLVER = 100,
    WEAPON_SNSPISTOL = 100,
    WEAPON_HEAVYPISTOL = 100,
    WEAPON_VINTAGEPISTOL = 100,
    WEAPON_MICROSMG = 100,
    WEAPON_SMG = 100,
    WEAPON_ASSAULTSMG = 100,
    WEAPON_MINISMG = 100,
    WEAPON_MACHINEPISTOL = 100,
    WEAPON_COMBATPDW = 100,
    WEAPON_PUMPSHOTGUN = 100,
    WEAPON_SAWNOFFSHOTGUN = 100,
    WEAPON_ASSAULTSHOTGUN = 100,
    WEAPON_BULLPUPSHOTGUN = 100,
    WEAPON_HEAVYSHOTGUN = 100,
    WEAPON_ASSAULTRIFLE = 100,
    WEAPON_CARBINERIFLE = 100,
    WEAPON_ADVANCEDRIFLE = 100,
    WEAPON_SPECIALCARBINE = 100,
    WEAPON_BULLPUPRIFLE = 100,
    WEAPON_COMPACTRIFLE = 100,
    WEAPON_MG = 100,
    WEAPON_COMBATMG = 100,
    WEAPON_GUSENBERG = 100,
    WEAPON_HEAVYSNIPER = 100,
    WEAPON_MARKSMANRIFLE = 100,
    WEAPON_GRENADELAUNCHER = 100,
    WEAPON_RPG = 100,
    WEAPON_STINGER = 100,
    WEAPON_MINIGUN = 100,
    WEAPON_GRENADE = 100,
    WEAPON_STICKYBOMB = 100,
    WEAPON_SMOKEGRENADE = 100,
    WEAPON_BZGAS = 100,
    WEAPON_MOLOTOV = 100,
    WEAPON_FIREEXTINGUISHER = 100,
    WEAPON_PETROLCAN = 100,
    WEAPON_DIGISCANNER = 100,
    WEAPON_BALL = 100,
    WEAPON_BOTTLE = 100,
    WEAPON_DAGGER = 100,
    WEAPON_FIREWORK = 100,
    WEAPON_MUSKET = 100,
    WEAPON_STUNGUN = 100,
    WEAPON_HOMINGLAUNCHER = 100,
    WEAPON_PROXMINE = 100,
    WEAPON_SNOWBALL = 100,
    WEAPON_FLAREGUN = 100,
    WEAPON_GARBAGEBAG = 100,
    WEAPON_HANDCUFFS = 100,
    WEAPON_MARKSMANPISTOL = 100,
    WEAPON_KNUCKLE = 100,
    WEAPON_HATCHET = 100,
    WEAPON_RAILGUN = 100,
    WEAPON_MACHETE = 100,
    WEAPON_SWITCHBLADE = 100,
    WEAPON_DBSHOTGUN = 100,
    WEAPON_AUTOSHOTGUN = 100,
    WEAPON_BATTLEAXE = 100,
    WEAPON_COMPACTLAUNCHER = 100,
    WEAPON_PIPEBOMB = 100,
    WEAPON_POOLCUE = 100,
    WEAPON_WRENCH = 100,
    WEAPON_FLASHLIGHT = 100,
    GADGET_NIGHTVISION = 100,
    GADGET_PARACHUTE = 100,
    WEAPON_FLARE = 100,
    WEAPON_DOUBLEACTION = 100,
    black_money = 0, -- poids pour un argent
}


Config.VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 70000, --SUV
    [3] = 25000, --Coupes
    [4] = 30000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 5000, --Sports
    [7] = 5000, --Super
    [8] = 5000, --Motorcycles
    [9] = 80000, --Off-road
    [10] = 100000, --Industrial
    [11] = 70000, --Utility
    [12] = 80000, --Vans
    [13] = 0, --Cycles
    [14] = 5000, --Boats
    [15] = 20000, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 40000, --Emergency
    [19] = 0, --Military
    [20] = 70000, --Commercial
    [21] = 0, --Trains
}

Config.VehicleLimitSave = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 70000, --SUV
    [3] = 25000, --Coupes
    [4] = 30000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 5000, --Sports
    [7] = 5000, --Super
    [8] = 5000, --Motorcycles
    [9] = 80000, --Off-road
    [10] = 100000, --Industrial
    [11] = 70000, --Utility
    [12] = 80000, --Vans
    [13] = 0, --Cycles
    [14] = 5000, --Boats
    [15] = 20000, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 40000, --Emergency
    [19] = 0, --Military
    [20] = 70000, --Commercial
    [21] = 0, --Trains
}
