--DROP TABLE mst_users;

CREATE TABLE mst_users
(
    user_id 				bigint,
    uhid					varchar(100),
    first_name 				varchar(50) ,
    middle_name 			varchar(50) ,
    last_name 				varchar(50) ,
    user_name 				varchar(300) ,
    email 					varchar(100) ,
    contactno 				varchar(50) ,
    city					varchar(100) ,	
    pincode					int,
    linkedin_id 			varchar(50) ,
    website 				varchar(100) ,
    isactive 				tinyint,    
    hash_password 			varchar(100) ,
	user_type_id 			tinyint,
    password_never_expire 	tinyint,
    about_user 				varchar(500) ,
    delete_flag 			tinyint,
    last_login_date 		datetime2,
    created_date 			datetime2,
    created_by 				varchar(100) ,
    last_modified_date 		datetime2,
    last_modified_by 		varchar(100) ,
    profile_pic 			varchar(200) ,
    sys_profile_pic 		varchar(200) ,
    personal_phone 			varchar ,
    is_available 			tinyint , 
    CONSTRAINT mst_users_pkey PRIMARY KEY (user_id)
);


CREATE SEQUENCE mst_users_user_id_seq
  START WITH 1
  INCREMENT BY 1;