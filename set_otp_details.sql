ALTER PROCEDURE set_otp_details
(
	@pi_id   bigint,
	@pi_otp	 int,
	@po_code tinyint out
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To store OTP details
TEST SCRIPT
DECLARE @po1 tinyint;
EXEC set_otp_details
   @pi_id = 5, @pi_otp = 417396, @po_code = @po1 OUTPUT

	print @po1 ;
	print @po2 ;
SELECT * FROM send_otp_log 

SELECT * FROm RND
DELETE FROM mst_users WHERE first_name is null
***************************************************************************************/

DECLARE 
@v_current_date   datetime2,
@v_count		  tinyint = 0;
BEGIN
		
	
	SELECT @v_count = 1 FROm send_otp_log
	where id =@pi_id and otp = @pi_otp;


	if @v_count = 1
		BEGIN
			UPDATE send_otp_log  set is_matched = 1
			where id = @pi_id	;
			SET @po_code = 1;
		END
		
	if @v_count <> 1
		BEGIN					
			UPDATE send_otp_log  set is_matched = 2
			where id = @pi_id	;	
			SET @po_code = 0;
		END
		
	
END 