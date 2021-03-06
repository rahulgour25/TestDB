ALTER  PROCEDURE set_users
(
	@pi_action					varchar,  -- 'A' to add new user 'E' to Edit user and 'D' to delete particular user
	@pi_user_id					integer, -- it will be null in case of Add new user with flag 'A'
	@pi_hash_password			varchar(100),
	@pi_first_name				varchar(100),
	@pi_middle_name				varchar(100),
	@pi_last_name				varchar(100),  --last name
	@pi_email_id				varchar(100),
	@pi_contactno				varchar(100),	
	@pi_city					varchar(100),
	@pi_pincode					integer,
	@pi_user_type_id			tinyint, --1 --> for patient, 2--> Doctor
	@pi_created_by				varchar(100),
	@po_code					tinyint  OUTPUT,
	@po_message					varchar(100)  OUTPUT
)
AS
/***********************************************************************
CREATED BY : RAHUL GOUR
CREATED ON : 16th APR  2020
PURPOSE	   : To store user details
TEST SCRIPT
DECLARE @po1 tinyint, @po2 varchar(100);
EXEC set_users
    @pi_action = 'E', @pi_user_id = 10, @pi_hash_password = null, @pi_first_name ='Bincy',
	@pi_middle_name	= null,	
	@pi_last_name	= 'Yadav'	,
	@pi_email_id	= 'manoj@gmail.com',	
	@pi_contactno	= 999246415,	
	@pi_city	= 'Gurgaon'	,	
	@pi_pincode		= 122011,	
	@pi_user_type_id	= 1,		
	@pi_created_by= 'Web',		
    @po_code = @po1 OUTPUT,
	@po_message = @po2 OUTPUT;

	print @po1 ;
	print @po2 ;
SELECT * FROM mst_users 
SELECT * FROm send_otp_log
SELECT * FROm RND
SELECT * FROM FROM mst_users WHERE first_name is null

***************************************************************************************/

DECLARE 
@v_current_date   datetime2,
@v_count		  tinyint,
@v_user_id		   bigint,
@v_otp			  int,
@v_old_contactno varchar(100),
@v_generate_otp	  tinyint = 0;
BEGIN

BEGIN TRY

	--CREATE TABLE RND (VAL TEXT);
	--DELETE  FROM RND;
	SET @v_user_id = @pi_user_id

	IF @pi_action in ('A', 'E') 
		BEGIN
			IF @pi_first_name IS NULL
				BEGIN
					--INSERT INTO RND VALUES (@pi_first_name);
					SET @po_code = 0
					SET @po_message = 'First name cannot be blank'
					RETURN
				END
			IF @pi_last_name IS NULL
				BEGIN
					SET @po_code = 0
					SET @po_message = 'Last name cannot be blank'
					RETURN
				END
			IF @pi_contactno IS NULL
				BEGIN
					SET @po_code = 0
					SET @po_message = 'Contact No. cannot be blank'
					RETURN
				END
			IF @pi_pincode IS NULL
				BEGIN
					SET @po_code = 0
					SET @po_message = 'Pincode cannot be blank'
					RETURN
				END

			IF @pi_action = 'E'
				BEGIN
					SELECT @v_count = count(1) from 
					mst_users
					WHERE user_id <> @pi_user_id
					AND contactno = @pi_contactno;

					IF @v_count > 0 
						BEGIN
							SET @po_code = 0;
							SET @po_message = 'Contact number already exists with different patient';
							RETURN
						END
				END

				BEGIN
					SELECT @v_old_contactno = contactno from 
					mst_users
					WHERE user_id = @pi_user_id;

					IF @v_old_contactno  <>  @pi_contactno
						BEGIN
							SET @v_generate_otp = 1;							
						END
				END
			IF @pi_action = 'A'
				BEGIN
					SELECT @v_count = count(1) from 
					mst_users
					WHERE contactno = @pi_contactno;

					IF @v_count > 0 
						BEGIN
							SET @po_code = 0;
							SET @po_message = 'Contact number already exists with different patient';
							RETURN
						END
				END
		END

	SET  @v_current_date =  GETDATE();

    IF @pi_action = 'A'  -- For Add
		BEGIN
			SET @v_user_id = NEXT VALUE FOR mst_users_user_id_seq;

			INSERT INTO mst_users
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
			VALUES  (
					@v_user_id,
					@pi_first_name,
					@pi_middle_name,
					@pi_last_name,
					@pi_email_id,
					@pi_contactno,
					@pi_city,		
					@pi_hash_password,
					@pi_pincode,
					@pi_created_by,
					@v_current_date,
					1 -- for patient
				);

				SET @po_code = 1;
				SET @po_message = 'Record saved successfully';

				 SET @v_generate_otp = 1 
		END
	
	IF @v_generate_otp = 1 
			BEGIN
				SELECT @v_otp = LEFT(CAST(RAND()*1000000000+999999 AS INT),6);

				INSERT INTO send_otp_log
				(
				Id				,
				user_id			,
				mobile			,
				OTP				,
				response		,
				created_date	,
				is_matched		,
				created_by		
				)
				VALUES
				(
					NEXT VALUE FOR send_otp_log_seq,
					@v_user_id,
					@pi_contactno,
					@v_otp,
					null,
					@v_current_date,
					0,
					'user entry'
				)
		END

	IF @pi_action = 'E'  -- For Update
		BEGIN
			UPDATE mst_users
			SET 
				first_name  = @pi_first_name,
				middle_name = @pi_middle_name,
				last_name   = @pi_last_name,
				email = @pi_email_id,
				contactno  = @pi_contactno,
				city  = @pi_city,
				last_modified_date = @v_current_date,
				last_modified_by = @pi_created_by
			WHERE user_id = @pi_user_id;
		
			SET @po_code = 1;
			SET @po_message = 'Record updated successfully';
		END
	IF @pi_action = 'D' -- For Deleted 
		BEGIN
			UPDATE mst_users
			SET 
				delete_flag  = 1,
				last_modified_date = @v_current_date,
				last_modified_by = @pi_created_by
			WHERE user_id = @pi_user_id
		
			SET @po_code = 1;
			SET @po_message = 'Record deleted successfully';
		END
END TRY

BEGIN CATCH

		SET @po_code = 0;
		SET @po_message = 'Error to save this record';

END CATCH
END