-- Active: 1743080852662@@127.0.0.1@5432@hopital

-- PAS OUBLIER DE UPDATE LES FOREIGN KEY

-- Enlever les anciennes tables --

DROP TABLE rendez_vous;

DROP TYPE type_rdv;

DROP TABLE temp_rdv;

DROP TABLE 

--POUR LES RDV--
-- CRÉATION DE LA TABLE TEMPORAIRE --

create temp table temp_rdv(
id integer primary key,
patient_id integer,
medecin_id integer,
rdv_date date,
motif varchar
);

-- IMPORT DES DONNÉES DANS TABLE TEMPORAIRE --


copy temp_rdv(id, patient_id, medecin_id, rdv_date, motif)
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\rdv.csv'
WITH CSV HEADER
DELIMITER ';';

-- CREATION TABLE TEMPORAIRE RDV_HISTORIQUE

create temp table temp_rdv_historique(
id serial primary key,
patient_id integer,
rdv_id integer
);

-- CRÉATION DU TYPE ENUM --

create type type_rdv as enum ('Consultation',
'Examen',
'Opération',
'Suivi',
'Urgence');

-- CRÉATION DE LA TABLE RENDEZ_VOUS FINALE --

create table rendez_vous(id serial primary key,
medecin_id integer references medecin(id) not null,
rdv_date date not null,
motif type_rdv not null);

-- IMPORT DE RDV DANS LA TABLE FINALE --

INSERT INTO rendez_vous (id, medecin_id, rdv_date, motif)
SELECT id, medecin_id, rdv_date, motif::type_rdv FROM temp_rdv;

-- CREATION DE LA TABLE RDV_HISTORIQUE
create table patient_rdv_historique(id serial primary key,
patient_id integer references patient(id) not null,
rdv_id integer references rendez_vous(id) not null,
date_rdv date not null);

-- IMPORT patient_rdv_historique DANS LA TABLE FINALE --

INSERT INTO patient_rdv_historique (rdv_id, patient_id)
SELECT id, patient_id FROM temp_rdv;

-- TEST --

SELECT *
FROM rendez_vous;

SELECT *
FROM prescription;

SELECT *
FROM patient_rdv_historique
INNER JOIN patient p ON p.id = patient_rdv_historique.patient_id;






