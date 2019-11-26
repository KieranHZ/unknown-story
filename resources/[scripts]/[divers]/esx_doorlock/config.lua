Config = {}
Config.Locale = 'fr'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		objName = 'v_ilev_ph_door01',
		objCoords  = {x = 434.747, y = -980.618, z = 30.839},
		textCoords = {x = 434.747, y = -981.50, z = 31.50},
		authorizedJobs = { 'police', 'fbi' },
		locked = false,
		distance = 2.5
	},

	{
		objName = 'v_ilev_ph_door002',
		objCoords  = {x = 434.747, y = -983.215, z = 30.839},
		textCoords = {x = 434.747, y = -982.50, z = 31.50},
		authorizedJobs = { 'police', 'fbi' },
		locked = false,
		distance = 2.5
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objCoords  = {x = 449.698, y = -986.469, z = 30.689},
		textCoords = {x = 450.104, y = -986.388, z = 31.739},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objCoords  = {x = 464.361, y = -984.678, z = 43.834},
		textCoords = {x = 464.361, y = -984.050, z = 44.834},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objCoords  = {x = 461.286, y = -985.320, z = 30.839},
		textCoords = {x = 461.50, y = -986.00, z = 31.50},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objCoords  = {x = 452.618, y = -982.702, z = 30.689},
		textCoords = {x = 453.079, y = -982.600, z = 31.739},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objCoords  = {x = 447.238, y = -980.630, z = 30.689},
		textCoords = {x = 447.200, y = -980.010, z = 31.739},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = {x = 443.97, y = -989.033, z = 30.6896},
		textCoords = {x = 444.020, y = -989.445, z = 31.739},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 4
	},

	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = {x = 445.37, y = -988.705, z = 30.6896},
		textCoords = {x = 445.350, y = -989.445, z = 31.739},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 4
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 463.815, y = -992.686, z = 24.9149},
		textCoords = {x = 463.30, y = -992.686, z = 25.10},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.381, y = -993.651, z = 24.914},
		textCoords = {x = 461.806, y = -993.308, z = 25.064},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.331, y = -998.152, z = 24.914},
		textCoords = {x = 461.806, y = -998.800, z = 25.064},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.704, y = -1001.92, z = 24.9149},
		textCoords = {x = 461.806, y = -1002.450, z = 25.064},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = {x = 463.478, y = -1003.538, z = 25.005},
		textCoords = {x = 464.00, y = -1003.50, z = 25.50},
		authorizedJobs = { 'police', 'fbi' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		objName = 'v_ilev_rc_door2',
		objCoords  = {x = 467.371, y = -1014.452, z = 26.536},
		textCoords = {x = 468.09, y = -1014.452, z = 27.1362},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 4
	},

	{
		objName = 'v_ilev_rc_door2',
		objCoords  = {x = 469.967, y = -1014.452, z = 26.536},
		textCoords = {x = 469.35, y = -1014.452, z = 27.136},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 4
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objCoords  = {x = 488.894, y = -1017.210, z = 27.146},
		textCoords = {x = 488.894, y = -1020.210, z = 30.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objCoords  = {x = 1855.105, y = 3683.516, z = 34.266},
		textCoords = {x = 1855.105, y = 3683.516, z = 35.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		objName = 'v_ilev_shrf2door',
		objCoords  = {x = -443.14, y = 6015.685, z = 31.716},
		textCoords = {x = -443.14, y = 6015.685, z = 32.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = false,
		distance = 2.5
	},

	{
		objName = 'v_ilev_shrf2door',
		objCoords  = {x = -443.951, y = 6016.622, z = 31.716},
		textCoords = {x = -443.951, y = 6016.622, z = 32.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = false,
		distance = 2.5
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = {x = 1844.998, y = 2604.810, z = 44.638},
		textCoords = {x = 1844.998, y = 2608.50, z = 48.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = {x = 1818.542, y = 2604.812, z = 44.611},
		textCoords = {x = 1818.542, y = 2608.40, z = 48.00},
		authorizedJobs = { 'police', 'fbi' },
		locked = true,
		distance = 12,
		size = 2
	},

--[[	--Entrée principale Pacific Bank
	{
		objName = 'hei_prop_hei_bankdoor_new',
		objCoords  = {x = 231.34, y = 215.627, z = 106.28},
		textCoords = {x = 231.34, y = 215.627, z = 107.28},
		authorizedJobs = { 'banker' },
		locked = true,
		distance = 2.5
	},

	{
		objName = 'hei_prop_hei_bankdoor_new',
		objCoords  = {x = 231.89, y = 214.45, z = 106.28},
		textCoords = {x = 231.89, y = 214.45, z = 107.28},
		authorizedJobs = { 'banker' },
		locked = true,
		distance = 2.5
	},

	--Entrée côté ATM Pacific Bank
	{
		objName = 'hei_prop_hei_bankdoor_new',
		objCoords  = {x = 259.15, y = 214.81, z = 106.28},
		textCoords = {x = 259.15, y = 214.81, z = 107.28},
		authorizedJobs = { 'banker' },
		locked = true,
		distance = 2.5
	},

	{
		objName = 'hei_prop_hei_bankdoor_new',
		objCoords  = {x = 258.78, y = 213.66, z = 106.28},
		textCoords = {x = 258.78, y = 213.66, z = 107.28},
		authorizedJobs = { 'banker' },
		locked = true,
		distance = 2.5
	},

	--Pièce Menu Gestion argent entreprise
	{
		objName = 'v_ilev_bk_door2',
		objCoords  = {x = 262.08, y = 214.44, z = 110.28},
		textCoords = {x = 262.08, y = 214.44, z = 111.28},
		authorizedJobs = { 'banker' },
		locked = true,
		distance = 2.5
	},]]

	-- Entrée Benny's
	{
		objName = 'lr_prop_supermod_door_01',
		objCoords  = {x = -205.69, y = -1310.42, z = 31.29},
		textCoords = {x = -205.69, y = -1310.42, z = 33.29},
		authorizedJobs = { 'custom' },
		locked = true,
		distance = 16
	},

--[[	-- Manoir
	{
		objName = 'prop_lrggate_02_ld',
		objCoords  = {x = -1471.107, y = 68.26, z = 53.29},
		textCoords = {x = -1471.107, y = 68.26, z = 54.29},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 10
	},

	-- Manoir
	{
		objName = 'prop_lrggate_02_ld',
		objCoords  = {x = -1613.75, y = 77.95, z = 61.57},
		textCoords = {x = -1613.75, y = 77.95, z = 62.57},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 10
	},]]

	-- Manoir
	{
		objName = 'bh1_36_gate_iref',
		objCoords  = {x = -1441.30, y = 172.43, z = 55.81},
		textCoords = {x = -1441.30, y = 172.43, z = 56.81},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 2.5
	},

	-- Manoir
	{
		objName = 'bh1_36_gate_iref',
		objCoords  = {x = -1434.58, y = 235.52, z = 59.9},
		textCoords = {x = -1434.58, y = 235.52, z = 60.9},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 2.5
	},

	-- Manoir
	{
		objName = 'bh1_36_gate_iref',
		objCoords  = {x = -1461.75, y = 65.83, z = 52.91},
		textCoords = {x = -1461.75, y = 65.83, z = 53.91},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 2.5
	},

	-- Manoir
	{
		objName = 'bh1_36_gate_iref',
		objCoords  = {x = -1578,371, y = 153,207, z = 58,96855},
		textCoords = {x = -1578,371, y = 153,207, z = 59,96855},
		authorizedJobs = { 'gouvernor', 'police' },
		locked = true,
		distance = 2.5
	},

	-- Concess
	-- X:-37,33113 Y:-1108,873 Z:26,7198 RIGHT
	-- X:-39,13366 Y:-1108,218 Z:26,7198 LEFT
	{
		objName = 'v_ilev_csr_door_r',
		objCoords  = {x = -37,80, y = -1108,53, z = 26,46},
		textCoords = {x = -37,80, y = -1108,53, z = 27,46},
		authorizedJobs = { 'cardealer' },
		locked = true,
		distance = 2.5
	},
	{
		objName = 'v_ilev_csr_door_l',
		objCoords  = {x = -39,13366, y = -1108,218, z = 26,46},
		textCoords = {x = -39,13366, y = -1108,218, z = 27,46},
		authorizedJobs = { 'cardealer' },
		locked = true,
		distance = 2.5
	},

    -- Concess
    -- SECOND X:-60,54582 Y:-1094,749 Z:26,88872
    -- SECOND X:-59,89302 Y:-1092,952 Z:26,88362
    --
    {
        objName = 'v_ilev_csr_door_r',
        objCoords  = {x = -60,54582, y = -1094,749, z = 26,88872},
        textCoords = {x = -60,54582, y = -1094,749, z = 27,88872},
        authorizedJobs = { 'cardealer' },
        locked = true,
        distance = 2.5
    },
    {
        objName = 'v_ilev_csr_door_l',
        objCoords  = {x = -59,89302, y = -1092,952, z = 26,88362},
        textCoords = {x = -59,89302, y = -1092,952, z = 27,88362},
        authorizedJobs = { 'cardealer' },
        locked = true,
        distance = 2.5
    },

	-- Concess GARAGE
	--objName = 'prop_com_ls_door_01'
	--objCoords  = {x = -29.32, y = -1086.49, z = 27.58}
    {
        objName = 'prop_com_ls_door_01',
        objCoords  = {x = -29.32, y = -1086.49, z = 27.58},
        textCoords = {x = -29.32, y = -1086.49, z = 28.58},
        authorizedJobs = { 'cardealer' },
        locked = true,
        distance = 9.5
    },

	-- Feuilledor door Prop_LD_jail_door
--[[    {
        objName = 'Prop_LD_jail_door',
        objCoords  = {x = -81.81, y = -1406.55, z = 29.32},
        textCoords = {x = -81.81, y = -1406.55, z = 29.32},
        authorizedJobs = { 'feuilledor' },
        locked = true,
        distance = 2.5
    },]]
    {
        objName = 'prop_indus_meet_door_r',
        objCoords  = {x = -86.72, y = -1400.56, z = 32.3},
        textCoords = {x = -86.72, y = -1400.56, z = 33.3},
        authorizedJobs = { 'feuilledor' },
        locked = true,
        distance = 2.5
    },
    {
        objName = 'V_ILev_Carmod3Door',
        objCoords  = {x = -86.66, y = -1411.89, z = 29.32},
        textCoords = {x = -86.66, y = -1411.89, z = 30.32},
        authorizedJobs = { 'feuilledor' },
        locked = true,
        distance = 9.5
    },
    --[[

        -- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
        {
            objName = 'prop_gate_airport_01',
            objCoords  = {x = 420.133, y = -1017.301, z = 28.086},
            textCoords = {x = 420.133, y = -1021.00, z = 32.00},
            authorizedJobs = { 'police', 'fbi' },
            locked = true,
            distance = 14,
            size = 2
        }
        --]]

	--Transistep
	{
		objName = 'prop_gate_docks_ld',
		objCoords  = {x = 10.64414, y = -2542.213, z = 5.047173},
		textCoords = {x = 10.64414, y = -2542.213, z = 7.047173},
		authorizedJobs = { 'transistep' },
		locked = true,
		distance = 20
	},
	{
		objName = 'prop_gate_docks_ld',
		objCoords  = {x = 19.40451, y = -2529.702, z = 5.047173},
		textCoords = {x = 19.40451, y = -2529.702, z = 7.047173},
		authorizedJobs = { 'transistep' },
		locked = true,
		distance = 20
	},
	{
		objName = 'prop_gate_docks_ld',
		objCoords  = {x = -202.6151, y = -2515.309, z = 5.047173},
		textCoords = {x = -202.6151, y = -2515.309, z = 7.047173},
		authorizedJobs = { 'transistep' },
		locked = true,
		distance = 20
	},
	{
		objName = 'prop_gate_docks_ld',
		objCoords  = {x = -187.3406, y = -2515.309, z = 5.047173},
		textCoords = {x = -187.3406, y = -2515.309, z = 7.047173},
		authorizedJobs = { 'transistep' },
		locked = true,
		distance = 20
	},
}