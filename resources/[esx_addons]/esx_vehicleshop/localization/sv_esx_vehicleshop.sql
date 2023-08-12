USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_cardealer','Bilförsäljare',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_cardealer','Bilförsäljare',1)
;

INSERT INTO `jobs` (name, label) VALUES
	('cardealer','Bilförsäljare')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('cardealer',0,'recruit','Nyanställd',10,'{}','{}'),
	('cardealer',1,'novice','Nybörjare',25,'{}','{}'),
	('cardealer',2,'experienced','Erfaren',40,'{}','{}'),
	('cardealer',3,'boss','Chef',0,'{}','{}')
;

CREATE TABLE `cardealer_vehicles` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`vehicle` varchar(255) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `vehicle_sold` (
	`client` VARCHAR(50) NOT NULL,
	`model` VARCHAR(50) NOT NULL,
	`plate` VARCHAR(50) NOT NULL,
	`soldby` VARCHAR(50) NOT NULL,
	`date` VARCHAR(50) NOT NULL,

	PRIMARY KEY (`plate`)
);

CREATE TABLE `owned_vehicles` (
	`owner` varchar(22) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NULL DEFAULT NULL,
	`stored` TINYINT(1) NOT NULL DEFAULT '0',

	PRIMARY KEY (`plate`)
);

CREATE TABLE `rented_vehicles` (
	`vehicle` varchar(60) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`player_name` varchar(255) NOT NULL,
	`base_price` int(11) NOT NULL,
	`rent_price` int(11) NOT NULL,
	`owner` varchar(22) NOT NULL,

	PRIMARY KEY (`plate`)
);

CREATE TABLE `vehicle_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `vehicle_categories` (name, label) VALUES
	('compacts','Småbil'),
	('coupes','Coupés'),
	('sedans','Sedans'),
	('sports','Sportbil'),
	('sportsclassics','Klassik sportbil'),
	('super','Super'),
	('muscle','Muskel'),
	('offroad','Off Road'),
	('suvs','SUVs'),
	('vans','Vans'),
	('motorcycles','Motorcykel')
;

CREATE TABLE `vehicles` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,

	PRIMARY KEY (`model`)
);

INSERT INTO `vehicles` (name, model, price, category) VALUES
	('Blade','blade',15000,'muscle'),
	('Dukes','dukes',28000,'muscle'),
	('Gauntlet','gauntlet',30000,'muscle'),
	('Faction','faction',20000,'muscle'),
	('Blista','blista',8000,'compacts'),
	('Panto','panto',10000,'compacts'),
	('Bison','bison',45000,'vans'),
	('Camper','camper',42000,'vans'),
	('Journey','journey',6500,'vans'),
	('Minivan','minivan',13000,'vans'),
	('Paradise','paradise',19000,'vans'),
	('Rumpo','rumpo',15000,'vans'),
	('Surfer','surfer',12000,'vans'),
	('Youga','youga',10800,'vans'),
	('Emperor','emperor',8500,'sedans'),
	('Mesa','mesa',16000,'suvs'),
	('Patriot','patriot',55000,'suvs'),
	('Blazer','blazer',6500,'offroad'),
	('Guardian','guardian',45000,'offroad'),
	('Sandking','sandking',55000,'offroad'),
	('Banshee','banshee',70000,'sports'),
	('Carbonizzare','carbonizzare',75000,'sports'),
	('Coquette','coquette',65000,'sports'),
	('Jester','jester',65000,'sports'),
	('Kuruma','kuruma',30000,'sports'),
	('Omnis','omnis',35000,'sports'),
	('Tropos','tropos',40000,'sports'),
	('Adder','adder',900000,'super'),
	('Sultan RS','sultanrs',65000,'super'),
	('Voltic','voltic',90000,'super'),
	('Akuma','AKUMA',7500,'motorcycles'),
	('Bagger','bagger',13500,'motorcycles'),
	('Bati 801','bati',12000,'motorcycles'),
	('Bati 801RR','bati2',19000,'motorcycles'),
	('BF400','bf400',6500,'motorcycles'),
	('BMX (velo)','bmx',5000,'motorcycles'),
	('Cruiser (velo)','cruiser',510,'motorcycles'),
	('Enduro','enduro',5500,'motorcycles'),
	('Esskey','esskey',4200,'motorcycles'),
	('Vespa','faggio2',2800,'motorcycles'),
	('Fixter (velo)','fixter',225,'motorcycles'),
	('Gargoyle','gargoyle',16500,'motorcycles'),
	('PCJ-600','pcj',6200,'motorcycles'),
	('Sanchez','sanchez',5300,'motorcycles'),
	('Vader','vader',7200,'motorcycles'),
	('Kamacho', 'kamacho', 1500000, 'offroad'),
	('Neon', 'neon', 2400000, 'sports'),
;
