CREATE  PROCEDURE get_users
(	
	@pi_user_id					integer -- it will be null in case of Add new user with flag 'A'	
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To store user details
TEST SCRIPT
DECLARE @po1 tinyint, @po2 varchar(100);
EXEC get_users
   @pi_user_id = 0
	print @po1 ;
	print @po2 ;
SELECT * FROM mst_users 
SELECT * FROm RND
DELETE FROM mst_users WHERE first_name is null
***************************************************************************************/

DECLARE 
@v_current_date   datetime2,
@v_count		  tinyint;
BEGIN
		
		IF @pi_user_id =  0 
			BEGIN
				SELECT		user_id,
						first_name ,
						middle_name ,
						last_name,
						email,
						contactno,
						city,
						pincode,
						created_by,
						created_date,
						case when user_type_id = 1 THEN 'Patient' when user_type_id = 2 THEN 'Doctor'
						end as user_type
				FROM mst_users
				--WHERE delete_flag = 0 -- only active user
				ORDER BY created_date
				FOR JSON AUTO;
			END
		IF @pi_user_id >  0
			BEGIN
				SELECT	user_id,
						first_name ,
						middle_name ,
						last_name,
						email,
						contactno,
						city,
						pincode,
						created_by,
						created_date,
						case when user_type_id = 1 THEN 'Patient' when user_type_id = 2 THEN 'Doctor'
						end as user_type
				FROM mst_users
				WHERE user_id = @pi_user_id
				FOR JSON AUTO;
			END

		
END 