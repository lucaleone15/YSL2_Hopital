-- Active: 1743080852662@@127.0.0.1@5432@hopital
-- Patient
create temp table temp_patient(
id integer,
nom varchar,
prenom varchar,
date_naiss date,
adresse varchar,
telephone varchar,
assurance varchar,
sexe varchar
);

copy temp_patient(id, nom, prenom, date_naiss, adresse, telephone, assurance, sexe)
from 'csv/patients.csv'
WITH CSV HEADER
DELIMITER ';';

--Médecin 
create temp table temp_medecin(
id integer,
nom varchar,
prenom varchar,
specialite varchar,
hopital varchar,
telephone varchar,
sexe varchar,
adresse_hopital varchar
);

copy temp_medecin(id, nom, prenom, specialite, hopital, telephone, sexe, adresse_hopital)
from 'csv/medecins'.csv
WITH CSV HEADER
DELIMITER ';';

-- Rendez-vous
create temp table temp_rdv(
id integer primary key,
patient_id integer,
medecin_id integer,
rdv_date date,
motif varchar
);

copy temp_rdv(id, patient_id, medecin_id, rdv_date, motif)
from 'csv\rdv.csv'
WITH CSV HEADER
DELIMITER ';';

-- Médicament
create temp table temp_medicament(
id integer,
nom varchar,
dosage varchar,
med_type varchar
);

copy temp_medicament(id, nom, dosage, med_type)
from 'csv\medoc.csv'
WITH CSV HEADER
DELIMITER ';';

-- Prescription
create temp table temp_prescription(
id integer,
rdv_id integer,
medicament_id integer,
duree integer
);

copy temp_prescription(id, rdv_id, medicament_id, duree)
from 'csv\prescriptions.csv'
WITH CSV HEADER
DELIMITER ';';
