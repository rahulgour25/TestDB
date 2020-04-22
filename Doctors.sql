CREATE TABLE mst_skills
(
	skill_id		int,
	skill_name		varchar(100)
);

TRUNCATE TABLE mst_skills;

insert into mst_skills
VALUES
(1, 'Internal Medicine'),
(2, 'Pediatrics'),
(3, 'Cardiology'),
(4, 'Obstetrics and Gynecology'),
(5, 'Neurosurgery'),
(6, 'Orthopedics'),
(7, 'Ophthalmologists');



CREATE TABLE mst_doctors_degrees
(
	degree_id		int,
	degree_name		varchar(100)
);

TRUNCATE TABLE mst_doctors_degrees;


insert into mst_doctors_degrees
VALUES
(1,'MBBS – Bachelor of Medicine, Bachelor of Surgery.'),
(2,'BDS – Bachelor of Dental Surgery.'),
(3,'BAMS – Bachelor of Ayurvedic Medicine and Surgery.'),
(4,'BUMS – Bachelor of Unani Medicine and Surgery.'),
(5,'BHMS – Bachelor of Homeopathy Medicine and Surgery.'),
(6,'BYNS- Bachelor of Yoga and Naturopathy Sciences.');

--DROP TABLE mst_hospitals

CREATE TABLE mst_hospitals
(
	hospital_id		int,
	hospital_name	varchar(500),
	hospital_Address  text,
	pincode			int
);

TRUNCATE TABLE mst_hospitals;

insert into mst_hospitals
VALUES
(1,'W Pratiksha Sector 56','Sector 56 Gurgaon',122001 ),
(2,'Artimis','Sector 52', 122002 ),
(3,'Medanta','Sector 38', 122003);
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