Config                      = {}
Config.Locale               = 'fr'

Config.Accounts             = { 'bank', 'black_money' }
Config.AccountLabels        = { bank = _U('bank'), black_money = _U('black_money') }

Config.EnableSocietyPayouts = true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.ShowDotAbovePlayer   = false
Config.DisableWantedLevel   = true
Config.EnableHud            = true -- enable the default hud? Display current job and accounts (black, bank & cash)

Config.PaycheckInterval     = 20 * 60000 -- 20 minutes
Config.MaxPlayers           = GetConvarInt('sv_maxclients', 32) -- set this value to 255 if you're running OneSync

Config.EnableDebug          = false
