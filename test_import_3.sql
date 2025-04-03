-- Active: 1743080852662@@127.0.0.1@5432@hopital
/*
UPDATE temp_medecin
SET specialite = REPLACE(specialite, 'È', 'é')
WHERE specialite LIKE '%È%';
*/
SELECT DISTINCT specialite FROM temp_medecin

-- drop table temp_specialisation;

create temp table specialisation (
    medecin_id INTEGER,
    specialisation_nom VARCHAR(30) NOT NULL
);

create table specialisation (
    id SERIAL PRIMARY KEY,
    specialisation_nom VARCHAR(30) NOT NULL
);
 drop table specialisation;
 
INSERT INTO
    specialisation (specialisation_nom)
select DISTINCT
    specialite
from temp_medecin
where
    temp_medecin.specialite IS NOT NULL;

ALTER TABLE temp_medecin
DROP COLUMN specialite;

SELECT * FROM specialisation;
SELECT * FROM temp_medecin;