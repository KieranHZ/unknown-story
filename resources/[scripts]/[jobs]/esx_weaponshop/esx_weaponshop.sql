USE `essentialmode`;

CREATE TABLE `weashops` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`zone` varchar(255) NOT NULL,
	`item` varchar(255) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weapon', "Permis de port d'arme")
;

INSERT INTO `weashops` (`zone`, `item`, `price`) VALUES
	('GunShop','WEAPON_PISTOL', 30000),
	('BlackWeashop','WEAPON_PISTOL', 60000),
	('GunShop', 'WEAPON_FLASHLIGHT', 600),
	('BlackWeashop', 'WEAPON_FLASHLIGHT', 1200),
	('GunShop', 'WEAPON_MACHETE', 600),
	('BlackWeashop', 'WEAPON_MACHETE', 1100),
	('GunShop', 'WEAPON_NIGHTSTICK', 560),
	('BlackWeashop', 'WEAPON_NIGHTSTICK', 1120),
	('GunShop', 'WEAPON_BAT', 350),
	('BlackWeashop', 'WEAPON_BAT', 700),
	('GunShop', 'WEAPON_STUNGUN', 4500),
	('BlackWeashop', 'WEAPON_STUNGUN', 9000),
	('BlackWeashop', 'WEAPON_MICROSMG', 120000),
	('BlackWeashop', 'WEAPON_PUMPSHOTGUN', 160000),
	('BlackWeashop', 'WEAPON_ASSAULTRIFLE', 350000),
	('BlackWeashop', 'WEAPON_SPECIALCARBINE', 450000),
	('BlackWeashop', 'WEAPON_SNIPERRIFLE', 2400000),
	('BlackWeashop', 'WEAPON_FIREWORK', 3000000),
	('BlackWeashop', 'WEAPON_GRENADE', 45000),
	('BlackWeashop', 'WEAPON_BZGAS', 12000),
	('GunShop', 'WEAPON_FIREEXTINGUISHER', 1000),
	('BlackWeashop', 'WEAPON_FIREEXTINGUISHER', 2000),
	('GunShop', 'WEAPON_BALL', 50),
	('BlackWeashop', 'WEAPON_BALL', 50),
	('BlackWeashop', 'WEAPON_SMOKEGRENADE', 12000),
	('BlackWeashop', 'WEAPON_APPISTOL', 110000),
	('BlackWeashop', 'WEAPON_CARBINERIFLE', 28000000),
	('BlackWeashop', 'WEAPON_HEAVYSNIPER', 30000000),
	('BlackWeashop', 'WEAPON_MINIGUN', 70000000),
	('BlackWeashop', 'WEAPON_STICKYBOMB', 85000)
;
