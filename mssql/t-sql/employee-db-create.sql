USE TSQLV6;
GO
--
IF OBJECT_ID ('HR.Project') IS NOT NULL
	DROP TABLE HR.Project;
--
IF OBJECT_ID ('HR.AssociateYEA')  IS NOT NULL
	DROP TABLE HR.AssociateYEA;
--
IF OBJECT_ID ('HR.AssociateSal')  IS NOT NULL
	DROP TABLE HR.AssociateSal;
--
IF OBJECT_ID ('HR.AssociateMGR')  IS NOT NULL
	DROP TABLE HR.AssociateMGR;
--
IF OBJECT_ID ('HR.Associate') IS NOT NULL
	DROP TABLE HR.Associate;
--
IF OBJECT_ID ('HR.Unit') IS NOT NULL
	DROP TABLE HR.Unit;
--
CREATE TABLE HR.Unit
(
	unit_id VARCHAR(10),
	unit_name VARCHAR(10),
	CONSTRAINT pk_unit PRIMARY KEY (unit_id)	
);
--
CREATE TABLE HR.Associate
(
	associate_id VARCHAR(10),
	associate_name VARCHAR(40),
	associate_current_sal DECIMAL (10,4),
	associate_desig VARCHAR (10),
	unit_id VARCHAR (10)
	CONSTRAINT pk_associate PRIMARY KEY (associate_id),
	CONSTRAINT fk_unit_associate FOREIGN KEY (unit_id)
		 REFERENCES HR.Unit (unit_id)
);
--
-- change table HR.Associate
ALTER TABLE HR.Associate
DROP COLUMN associate_current_sal;
--
ALTER TABLE HR.Associate
DROP CONSTRAINT fk_unit_associate;
--
ALTER TABLE HR.Associate
ADD CONSTRAINT fk_unit_associate FOREIGN KEY (unit_id)
		 REFERENCES HR.Unit (unit_id) ON DELETE CASCADE;
--
CREATE TABLE HR.AssociateMGR
(
	associate_id VARCHAR(10),
	home_mgr_id VARCHAR(10),
	effective_dt DATE,
	termination_dt DATE,
	CONSTRAINT pk_assoc_mgr PRIMARY KEY (associate_id,home_mgr_id, effective_dt),
	CONSTRAINT fk_assoc_Assoc FOREIGN KEY (associate_id)
		REFERENCES HR.associate (associate_id) ON DELETE CASCADE,
	CONSTRAINT fk_assoc_mgr FOREIGN KEY (home_mgr_id)
		REFERENCES HR.Associate (associate_id)
);
--
CREATE TABLE HR.AssociateSal
(
	associate_id VARCHAR(10),
	salary_eff_dt DATE,
	salary_term_dt DATE,
	salary_hike DECIMAL (5,2),
	prev_gross_salary DECIMAL (10,4),
	new_gross_salary DECIMAL (10,4),
	CONSTRAINT pk_AssociateSal PRIMARY KEY (associate_id, salary_eff_dt),
	CONSTRAINT fk_AssociateSal_Assoc FOREIGN KEY (associate_id)
		REFERENCES HR.Associate (associate_id) ON DELETE CASCADE
);
ALTER TABLE HR.AssociateSal
ALTER COLUMN prev_gross_salary DECIMAL (18,4);
ALTER TABLE HR.AssociateSal
ALTER COLUMN new_gross_salary DECIMAL (18,4);
--
CREATE TABLE HR.Project
(
	project_id VARCHAR(10),
	project_name VARCHAR (30),
	associate_id VARCHAR(10),
	associate_proj_doj DATE,
	associate_proj_lwd DATE,
	CONSTRAINT pk_project PRIMARY KEY (project_id,associate_id,associate_proj_doj),
	CONSTRAINT fk_associate FOREIGN KEY (associate_id)
		REFERENCES HR.Associate (associate_id) ON DELETE CASCADE
);
sp_rename 'HR.Project.associate_proj_doj', 'assoc_proj_doj_dt', 'COLUMN';
sp_rename 'HR.Project.associate_proj_lwd', 'assoc_proj_term_dt', 'COLUMN';
--
CREATE TABLE HR.AssociateYEA
(
	associate_id VARCHAR(10),
	associate_YEA_year VARCHAR(4),
	home_mgr_id VARCHAR(10),
	associate_rating VARCHAR (1),
	project_id VARCHAR(10),
	unit_id VARCHAR (10),
	CONSTRAINT pk_assoc_yea PRIMARY KEY (associate_id, associate_YEA_year),
	CONSTRAINT fk_assocyea_assoc FOREIGN KEY (associate_id)
		REFERENCES HR.associate (associate_id) ON DELETE CASCADE,
	CONSTRAINT fk_assocyea_unit FOREIGN KEY (unit_id)
		REFERENCES HR.Unit (unit_id)
);
--


