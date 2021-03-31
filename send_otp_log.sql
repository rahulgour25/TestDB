CREATE TABLE send_otp_log
( 
Id				bigint,
user_id			bigint,
mobile			varchar(30), 
OTP				int,
response		text, 
created_date	datetime2,
is_matched		tinyint,
created_by		varchar(100)
);

CREATE SEQUENCE send_otp_log_seq
  START WITH 1
  INCREMENT BY 1;