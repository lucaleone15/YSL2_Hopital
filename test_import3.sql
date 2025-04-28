-- Active: 1743080852662@@127.0.0.1@5432@hopital

-- Enlever les anciennes tables --

DROP TABLE rendez_vous;

DROP TYPE type_rdv;

DROP TABLE temp_rdv;

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
from 'csv\rdv.csv'
WITH CSV HEADER
DELIMITER ';';

-- CREATION TABLE TEMPORAIRE RDV_HISTORIQUE

create temp table temp_rdv_historique(
id integer primary key,
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
date_rdv date not null,
type_rdv not null);

-- IMPORT DE RDV DANS LA TABLE FINALE --

INSERT INTO rendez_vous (id, patient_id, medecin_id, date_rdv, motif)
SELECT id, patient_id, medecin_id, motif::rdv_type FROM temp_rdv;

-- CREATION DE LA TABLE RDV_HISTORIQUE

create table patient_rdv_historique(id serial primary key,
patient_id integer references patient(id) not null,
rdv_id integer references rendez_vous(id) not null,
date_rdv date not null,
type_rdv not null);

-- IMPORT patient_rdv_historique DANS LA TABLE FINALE --

INSERT INTO patient_rdv_historique (id, patient_id, rdv_id)
SELECT id, medecin_id, medecin_id, motif::rdv_type FROM temp_rdv;

-- TEST --

SELECT *
FROM rendez_vous






