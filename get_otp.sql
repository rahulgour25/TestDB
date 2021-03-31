ALTER  PROCEDURE get_otp
(
	@pi_user_id   bigint
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To store OTP details
TEST SCRIPT
DECLARE @po1 tinyint, @po varchar(100);
EXEC get_otp
   @pi_user_id = 10
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
		
	
				SELECT		Id				,
				user_id			,
				mobile			,
				OTP				
				FROM send_otp_log
				WHERE is_matched = 0
				AND USER_ID = @pi_user_id;
	
END 