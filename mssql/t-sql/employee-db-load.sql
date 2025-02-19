-- Load data
--
INSERT INTO HR.Unit (unit_id, unit_name)
VALUES 
	('DC00358', 'HPC');
--
INSERT INTO HR.Associate (associate_id, associate_name, associate_desig, unit_id)
VALUES 
		('2221829', 'Subramanian,K', 'SA', 'DC00358'),
		('889085', 'Saravanan,M', 'A', 'DC00358'),
		('2186642', 'Venkadesh,MK', 'A', 'DC00358'),
		('2329161', 'Krishna,RajKumar S', 'PAT', 'DC00358'),
		('2329142', 'Arkodeep,Dey', 'PAT', 'DC00358'),
		('2144624', 'Vasanth Kumar,Ravichandran', 'PAT', 'DC00358'),
		('921723', 'Ramya,KR', 'A', 'DC00358'),
		('2233934', 'BANDI,RAGHUNATHA REDDY', 'A', 'DC00358'),
		('201070', 'Sabyasachi Mitra', 'SM', 'DC00358'),
		('132138', 'Padmapriya,Vasudevan', 'M', 'DC00358');
--
BEGIN TRANSACTION
COMMIT TRANSACTION
-
INSERT INTO HR.AssociateMGR (associate_id, home_mgr_id, effective_dt, termination_dt)
VALUES 
	('132138', '201070', '2023-02-01', '9999-12-31');
--
BEGIN TRANSACTION
	INSERT INTO HR.AssociateMGR (associate_id, home_mgr_id, effective_dt, termination_dt)
	VALUES 
		('2221829', '201070', '2023-03-01', '2023-12-31'),
		('2221829', '132138', '2024-01-01', '9999-12-31'),
		('889085', '201070',  '2023-06-10', '2023-11-30'),
		('889085', '132138',  '2023-12-01', '9999-12-31');
COMMIT TRANSACTION;
--
BEGIN TRANSACTION
	INSERT INTO HR.AssociateSal
	VALUES
		('2221829', '2022-02-10', '2022-10-23', 0.0, 1200000, 1200000),
		('2221829', '2022-10-24', '2023-09-15', 8, 1200000, 1296000),
		('2221829', '2023-09-16', '2024-09-15', 4, 1296000, 1347840);
COMMIT TRANSACTION;
UPDATE HR.AssociateSal
SET salary_term_dt = '9999-12-31'
WHERE salary_term_dt = '2024-09-15'
--
BEGIN TRANSACTION
INSERT INTO HR.Project (project_id, project_name, associate_id, assoc_proj_doj_dt, assoc_proj_term_dt)
	VALUES 
		('1000394841', 'EH_AD_Claims_Core_Flex', '2221829', '2022-02-10', '9999-12-31'),
		('1000394841', 'EH_AD_Claims_Core_Flex', '889085', '2023-06-10', '9999-12-31');
COMMIT TRANSACTION;
--
BEGIN TRANSACTION
INSERT INTO HR.AssociateYEA
	(associate_id, associate_YEA_year, home_mgr_id, associate_rating, project_id, unit_id)
	VALUES 
		('2221829', '2023', '201070', '3', '1000394841', 'DC00358'),
		('2221829', '2024', '132138', '5', '1000394841', 'DC00358'),
		('889085', '2023',  '201070', '5', '1000394841', 'DC00358'),
		('889085', '2024',  '132138', '3', '1000394841', 'DC00358');
COMMIT TRANSACTION;