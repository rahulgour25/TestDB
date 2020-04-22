ALTER PROCEDURE get_doctor_list
(
	@pi_doctor_id	bigint,
	@pi_skill_id	int,
	@pi_hospital_id	int
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To get doctor details
TEST SCRIPT
DECLARE @po1 tinyint;
EXEC get_doctor_list
   @pi_doctor_id = 10, @pi_skill_id = 0, @pi_hospital_id = 1

	print @po1 ;
	print @po2 ;
SELECT * FROM send_otp_log 

SELECT * FROm RND
DELETE FROM mst_users WHERE first_name is null
***************************************************************************************/

DECLARE 
@v_current_date   datetime2
BEGIN
		
	DECLARE @v_query NVARCHAR(MAX);

	--SET @pi_doctor_id  = CAST(@pi_doctor_id as nvarchar(max));
	--SET @pi_skill_id  = CAST(@pi_skill_id as nvarchar(max));
	--SET @pi_hospital_id  = CAST(@pi_hospital_id as nvarchar(max));
	
	SET @v_query = N'SELECT doctor_name, user_id,
		   contactno,
		   skills_id,
		   skill_name,
		   x.hospital_id,
		   hospital_name

	FROM (
	SELECT mu.user_id, CONCAT_WS('' '',first_name,last_name) as doctor_name,
		   contactno,
		   skills_id,
		   hospital_id
	FROM mst_users mu
	LEFT JOIN
	(
		SELECT doctor_id , skills_id
		FROM mst_doctor_skills
	) mst_doctor_skills
	ON mst_doctor_skills.doctor_id = mu.user_id
	LEFT JOIN
	(
		SELECT hospital_id, doctor_id
		FROM mst_doctor_hospitals
	) mst_doctor_hospitals
	ON mst_doctor_hospitals.doctor_id = mu.user_id
	where user_type_id = 2
	) X
	LEFT JOIN
	( SELECT skill_id,	
			 skill_name
	  from MST_SKILLS
	) MST_SKILLS
	ON MST_SKILLS.skill_id = x.skills_id
	LEFT JOIN
	( SELECT hospital_id,	
			 hospital_name
	  from MST_hospitals
	) MST_hospitals
	ON MST_hospitals.hospital_id = x.hospital_id  WHERE 1 = 1 ' ;

	IF @pi_doctor_id > 0 
		BEGIN
			SET @v_query  +=  '  AND user_id =  @pidoctor_id ' ;
		END

	IF @pi_skill_id > 0
		BEGIN
			SET @v_query  +=  '  AND skills_id =  @piskill_id ' ;
		END

	IF @pi_hospital_id > 0
		BEGIN
			SET @v_query  +=  '  AND x.hospital_id = @pihospital_id ';
		END

	EXEC sp_executesql @v_query , N'@pidoctor_id bigint , @piskill_id INT, @pihospital_id int',
	@pidoctor_id = @pi_doctor_id, @piskill_id = @pi_skill_id, @pihospital_id = @pi_hospital_id;

END 