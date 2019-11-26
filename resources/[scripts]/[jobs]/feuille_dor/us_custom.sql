INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_custom', 'US Custom', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_custom', 'US Custom', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('custom', 'US Custom')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('custom',0,'recrue','Recrue',12,'{}','{}'),
	('custom',2,'experimente','Experimente',36,'{}','{}'),
	('custom',4,'boss','Patron',0,'{}','{}')
;
