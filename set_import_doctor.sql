ALTER PROCEDURE set_import_doctor
( 
	@po_code		tinyint OUTPUT
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To import doctor details
TEST SCRIPT
DECLARE @po1 tinyint;
EXEC set_import_doctor
   @po_code = @po1 OUTPUT

	print @po1 ;
	print @po2 ;
SELECT * FROM txn_log 
SELECT * FROM txn_import_doctor_profile
SELECT * FROm mst_doctor_profile
DELETE FROM mst_users WHERE first_name is null
***************************************************************************************/

DECLARE 
@v_current_date   datetime2,
@SQL NVARCHAR(1000)
BEGIN
	BEGIN TRY
		SET @SQL = 'TRUNCATE TABLE txn_import_doctor_profile'
		exec sp_executesql @SQL;
	  
		INSERT INTO txn_import_doctor_profile
		( 
			first_name ,
			last_name	,	
			email		,	
			contactno	,	
			highest_degree,  
			experience,
			speciality	,		
			area_of_experties,
			hospital_name	,
			hospital_address,
			is_processed
		)
		SELECT 
			first_name,		
			last_name	,	
			TRIM(email)		,	
			trim(contactno)	,	
			degree,  
			experience,
			speciality	,		
			are_of_experties,
			hospital_name	,
			hospital_address,0
		FROM Doctor
		
		UPDATE txn_import_doctor_profile
		SET error_reason = 'Contact Number cannot be blank'
		WHERE contactno is null;

		UPDATE txn_import_doctor_profile
		SET error_reason = concat(error_reason,';','Invalid Contact Number ')
		WHERE len(contactno) < 10;

		UPDATE txn_import_doctor_profile
		SET error_reason = concat(error_reason,';','Invalid Value in experience ')
		WHERE NOT experience >= 0;

		UPDATE txn_import_doctor_profile
		SET error_reason = concat(error_reason,';','Please enter valid email id')
		WHERE NOT email LIKE '%_@__%.__%'
			AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', email) = 0;

	
		UPDATE txn_import_doctor_profile
		SEt user_id = mst.user_id from txn_import_doctor_profile temp JOIN mst_users mst
						ON mst.contactno = temp.contactno
				
		WHERE error_reason is null;

		INSERT INTO  mst_users
					( 
						user_id,
						first_name ,
						middle_name ,
						last_name,
						email,
						contactno,
						city,
						hash_password,
						pincode,
						created_by,
						created_date,
						user_type_id
					)
					SELECT 
					NEXT VALUE FOR mst_users_user_id_seq,
					first_name ,
						null ,
						last_name,
						email,
						contactno,
						null,
						HASHBYTES('MD5','12345'),
						null,
						'Backend',
						GETDATE(),
						2
					 FROM txn_import_doctor_profile
					 WHERE user_id is null and error_reason is null;

					
			UPDATE txn_import_doctor_profile 
			SEt user_id = mst.user_id from txn_import_doctor_profile temp JOIN mst_users mst
						ON mst.contactno = temp.contactno				
				
			WHERE error_reason is null and temp.user_id is null;	
			--SELECT * FROm txn_import_doctor_profile
			UPDATE txn_import_doctor_profile 
			SET skill_id = mst.skill_id from txn_import_doctor_profile temp JOIN mst_skills mst
						on upper(mst.skill_name) = upper(temp.speciality)
			WHERE error_reason is null;

			INSERT INTO mst_skills
			SELECT NEXT VALUE FOR mst_skills_skill_id_seq,speciality FROM (
			SELECT	DISTINCT(temp.speciality) as speciality
			FROM txn_import_doctor_profile temp
			WHERE skill_id is null and error_reason is null
			) x;

			UPDATE txn_import_doctor_profile 
			SET skill_id = mst.skill_id from txn_import_doctor_profile temp JOIN mst_skills mst
						On upper(mst.skill_name) = upper(temp.speciality)			
			WHERE error_reason is null   and temp.skill_id is null ;

		
			UPDATE txn_import_doctor_profile
			SET highest_degree_id =  mst.degree_id from txn_import_doctor_profile temp JOIN mst_doctors_degrees mst
									  ON upper(mst.degree_name) = upper(temp.highest_degree)									
			WHERE error_reason is null  

			INSERT INTO mst_doctors_degrees
			SELECT NEXT VALUE FOR mst_doctors_degrees_id_seq,highest_degree from (
			SELECT DISTINCT(temp.highest_degree) as highest_degree
			FROM txn_import_doctor_profile temp
			WHERE highest_degree_id is null and error_reason is null) x;

			UPDATE txn_import_doctor_profile
			SET highest_degree_id = mst.degree_id from txn_import_doctor_profile temp JOIN mst_doctors_degrees mst
									  ON upper(mst.degree_name) = upper(temp.highest_degree)
			WHERE error_reason is null   and temp.highest_degree_id is null ;


			UPDATE txn_import_doctor_profile
			SET hospital_id =  mst.hospital_id from txn_import_doctor_profile temp JOIN mst_hospitals mst
									  ON upper(mst.hospital_name) = upper(temp.hospital_name)									
			WHERE error_reason is null  

			INSERT INTO mst_hospitals
			SELECT NEXT VALUE FOR mst_hospitals_id_seq,hospital_name , null , null from (
			SELECT DISTINCT(temp.hospital_name) as hospital_name
			FROM txn_import_doctor_profile temp
			WHERE hospital_id is null and error_reason is null ) x;

			UPDATE txn_import_doctor_profile
			SET hospital_id =  mst.hospital_id from txn_import_doctor_profile temp JOIN mst_hospitals mst
									  ON upper(mst.hospital_name) = upper(temp.hospital_name)		
			WHERE error_reason is null   and temp.hospital_id is null ;

			DELETE  FROM mst from mst_doctor_profile as mst join txn_import_doctor_profile as  temp 
								on mst.doctor_id = temp.user_id  where temp.error_reason is null ;

			
			INSERT INTO mst_doctor_profile
			(
				doctor_id 				,
				highest_degree_id		,
				degree					,
				Area_of_experties		,
				experience				,
				summary_of_work_experience ,
				creator_id				,
				created_date			,
				created_by		
			)
			SELECT user_id,
				   highest_degree_id,
				   highest_degree_id,
				   Area_of_experties,
				   cast(experience as tinyint),
				   null,
				   null,
				   GETDATE(),
				   'Backend'
			 FROM txn_import_doctor_profile
			 WHERE error_reason is null 

			 DELETE  FROM mst from mst_doctor_hospitals as mst join txn_import_doctor_profile as  temp 
								on mst.doctor_id = temp.user_id  where temp.error_reason is null ;

			 INSERT INTO mst_doctor_hospitals
			 (
			 doctor_id 		,
			 hospital_id	,	
			 creator_id		,
			 created_date	,
			 created_by
			)
			 SELECT user_id,
			 hospital_id,
			 null,
			 GETDATE(),
			'Backend'
			FROM txn_import_doctor_profile
			WHERE error_reason is null 


			DELETE  FROM mst from mst_doctor_skills as mst join txn_import_doctor_profile as  temp 
								on mst.doctor_id = temp.user_id  where temp.error_reason is null ;

			 INSERT INTO mst_doctor_skills
			 (
			 doctor_id 		,
			 skills_id	,	
			 creator_id		,
			 created_date	,
			 created_by
			)
			 SELECT user_id,
			 skill_id,
			 null,
			 GETDATE(),
			'Backend'
			FROM txn_import_doctor_profile
			WHERE error_reason is null 

			SET @po_code = 1;

	END TRY

	BEGIN CATCH
		ROLLBACK
		SET @po_code = 0;		
		INSERT INTO txn_log
		(
		log_id,
		error_source,
		error, 
		log_date
		)
		VALUES
		(
			0, 'set_import_doctor',ERROR_MESSAGE(),GETDATE()
		)
	END CATCH
END

