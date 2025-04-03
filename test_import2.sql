-- Active: 1743080815125@@127.0.0.1@5432@hopital
--POUR LES MÉDICAMENT--

create temp table temp_medicament(
id integer,
nom varchar,
dosage varchar,
med_type varchar
);

copy temp_medicament(id, nom, dosage, med_type)
from '/private/tmp/medoc.csv'
WITH CSV HEADER
DELIMITER ';';

create type type_medicament as enum ('Comprimé',
'Gélule',
'Aérosol',
'Injection', 
'Capsule');

DROP TABLE medicament;

DROP TYPE type_medicament;

DROP TABLE temp_medicament;

create table medicament(id serial primary key,
nom varchar(30) not null,
dosage varchar(10) not null,
med_type type_medicament not null);

INSERT INTO medicament (id, nom, dosage, med_type)
SELECT id, nom, dosage, med_type::type_medicament FROM temp_medicament;


SELECT *
FROM medicament






