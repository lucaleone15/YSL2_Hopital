-- Active: 1743080852662@@127.0.0.1@5432@hopital


-- Enlever les anciennes tables --

DROP TABLE prescription;

DROP TABLE temp_prescription;

-- Temporaire Prescription
create temp table temp_prescription(
id integer,
rdv_id integer,
medicament_id integer,
duree integer
);

copy temp_prescription(id, rdv_id, medicament_id, duree)
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\prescriptions.csv'
WITH CSV HEADER
DELIMITER ';';

-- Crée la table finale

CREATE TABLE prescription (
    id SERIAL PRIMARY KEY,
    rendezvous_id INTEGER REFERENCES rendez_vous(id) NOT NULL,
    medicament_id INTEGER REFERENCES medicament(id) NOT NULL,
    debut_traitement DATE NOT NULL,
    fin_traitement DATE NOT NULL
);

-- IMPORT DANS LA TABLE FINALE --

INSERT INTO prescription (rendezvous_id, medicament_id, debut_traitement, fin_traitement)
SELECT 
    t.rdv_id,
    t.medicament_id,
    rv.date AS debut_traitement,
    rv.date + t.duree * INTERVAL '1 day' AS fin_traitement
FROM temp_prescription t
JOIN rendez_vous rv ON rv.id = t.rdv_id;

