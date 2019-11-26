INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_gouvernor','Gouvernement',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_gouvernor','Gouvernement',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_gouvernor', 'Gouvernement', 1)
;

INSERT INTO `jobs` (name, label) VALUES 
	('gouvernor','Gouvernement')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('gouvernor',0,'security_gouvernor','Garde du Corps',2500,'{}','{}'),
	('gouvernor', 1, 'assistant', 'Assistant', 1500, '{}', '{}'),
	('gouvernor', 2,'boss','Président',5000,'{}','{}')
;
