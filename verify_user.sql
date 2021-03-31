CREATE PROCEDURE verify_user
(
	@pi_username varchar(100) 
)
AS
/***************************************************************************
CREATED BY : RAHUL GOUR ON 17 APR 2020
PURPOSE : to validate user

declare @po1 varchar(100);
exec verify_user @pi_username = '9811200576'
print @po1;
SELECT * FROM RND 
****************************************************************************/
DECLARE
@v_user_exists_count  integer = 0
BEGIN
        SElect @v_user_exists_count =  user_id from mst_users
        where (lower(email) = lower(@pi_username) OR lower(contactno) = lower(@pi_username))
		and delete_flag = 1;

        If @v_user_exists_count > 0
			BEGIN
     			select 	mu.user_id, hash_password, first_name,
      					user_type_id
     			from mst_users mu
				FOR JSON PATH
			END 
        
		
END