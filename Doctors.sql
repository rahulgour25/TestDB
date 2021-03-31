---Table structures 

CREATE TABLE mst_skills
(
	skill_id		int,
	skill_name		varchar(100)
);

CREATE SEQUENCE mst_skills_skill_id_seq
  START WITH 1
  INCREMENT BY 1;

TRUNCATE TABLE mst_skills;

insert into mst_skills
VALUES
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Internal Medicine'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Pediatrics'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Cardiology'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Obstetrics and Gynecology'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Neurosurgery'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Orthopedics'),
(NEXT VALUE FOR mst_skills_skill_id_seq, 'Ophthalmologists');



CREATE TABLE mst_doctors_degrees
(
	degree_id		int,
	degree_name		varchar(100)
);

CREATE SEQUENCE mst_doctors_degrees_id_seq
  START WITH 1
  INCREMENT BY 1;

TRUNCATE TABLE mst_doctors_degrees;


insert into mst_doctors_degrees
VALUES
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'MBBS – Bachelor of Medicine, Bachelor of Surgery.'),
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'BDS – Bachelor of Dental Surgery.'),
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'BAMS – Bachelor of Ayurvedic Medicine and Surgery.'),
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'BUMS – Bachelor of Unani Medicine and Surgery.'),
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'BHMS – Bachelor of Homeopathy Medicine and Surgery.'),
(NEXT VALUE FOR mst_doctors_degrees_id_seq,'BYNS- Bachelor of Yoga and Naturopathy Sciences.');

--DROP TABLE mst_hospitals



CREATE TABLE mst_hospitals
(
	hospital_id		int,
	hospital_name	varchar(500),
	hospital_Address  text,
	pincode			int
);

CREATE SEQUENCE mst_hospitals_id_seq
  START WITH 1
  INCREMENT BY 1;

TRUNCATE TABLE mst_hospitals;

insert into mst_hospitals
VALUES
(NEXT VALUE FOR mst_hospitals_id_seq,'W Pratiksha Sector 56','Sector 56 Gurgaon',122001 ),
(NEXT VALUE FOR mst_hospitals_id_seq,'Artimis','Sector 52', 122002 ),
(NEXT VALUE FOR mst_hospitals_id_seq,'Medanta','Sector 38', 122003);
--DROP TABLE mst_doctor_skills;

CREATE TABLE mst_doctor_skills
(
    doctor_id 				bigint,   
    skills_id				int,	
	creator_id				bigint,
	created_date			datetime2,
	created_by				varchar(100)
);

INSERT INTO mst_doctor_skills
VALUES(10,2,1,GETDATE(),'Rahul'),
(11,3,1,GETDATE(),'Rahul');


--DROP TABLE mst_doctor_hospitals
CREATE TABLE mst_doctor_hospitals
(
    doctor_id 				bigint,
	hospital_id				bigint,	
	creator_id				bigint,
	created_date			datetime2,
	created_by				varchar(100)
);

TRUNCATE TABLE mst_doctor_hospitals;

INSERT INTO mst_doctor_hospitals
VALUES(10,1,1,GETDATE(),'Rahul'),
(10,2,1,GETDATE(),'Rahul'),
(11,2,1,GETDATE(),'Rahul');


CREATE TABLE mst_doctor_profile
(
    doctor_id 				bigint,
	highest_degree_id		int,
	degree					bigint,
	Area_of_experties		varchar(100),
	experience				tinyint,
	summary_of_work_experience text,
	creator_id				int,
	created_date			datetime2,
	created_by				varchar(100)
);

INSERT INTO mst_doctor_profile
VALUES
(10,1,2,' immune system disorders such as asthma, eczema, food allergies',12,null,1,GETDATE(),'Rahul');

--DROP TABLE txn_import_doctor_profile

CREATE TABLE txn_import_doctor_profile
(
	first_name		varchar(100),
	last_name		varchar(100),
	email			varchar(100),
	contactno		varchar(100),
	highest_degree  varchar(100),
	speciality			varchar(1000),
	experience		int,
	area_of_experties varchar(8000),
	hospital_name	varchar(1000),
	hospital_address varchar(1000),
	user_id			 bigint,
	hospital_id		 int,
	skill_id		 int,
	highest_degree_id int,	
	error_reason	 text,
	is_processed	 tinyint default 0
);

CREATE TABLE txn_log
(
log_id			bigint,
error_source	varchar(100),
error			text, 
log_date	datetime2
);
