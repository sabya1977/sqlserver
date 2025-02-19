SELECT 
	A.associate_id, 
	A.associate_name, 
	A.associate_desig, 
	ASAL.salary_eff_dt,
	ASAL.salary_term_dt,
	YEA.associate_YEA_year,
	YEA.home_mgr_id,
	YEA.associate_rating
FROM
	HR.Associate A
INNER JOIN 
	HR.AssociateSal ASAL
ON A.associate_id = ASAL.associate_id
   AND CONVERT(date, GETDATE()) BETWEEN ASAL.salary_eff_dt and ASAL.salary_term_dt
INNER JOIN
	HR.AssociateYEA YEA
ON YEA.associate_id = ASAL.associate_id AND YEA.associate_YEA_year = '2024';



