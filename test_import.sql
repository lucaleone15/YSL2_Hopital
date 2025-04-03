--créer table temp patient
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
--importer csv de patient
copy temp_patient(id, nom, prenom, date_naiss, adresse, telephone, assurance, sexe)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\patients.csv'
WITH CSV HEADER
DELIMITER ';';

--créer temp Médecin 
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
--importer csv médecin
copy temp_medecin(id, nom, prenom, specialite, hopital, telephone, sexe, adresse_hopital)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\medecins.csv'
WITH CSV HEADER
DELIMITER ';';


--Création de la tablwe temp adresse
create temp table temp_adresse (
    id serial primary key,
    nom VARCHAR(200)
);
--Création de la table hopital
create table hopital (
    id serial PRIMARY key,
    adresse_id integer references adresse (id) not null
);
--Ajouter les adresses des patients à la table temp adresse
INSERT into
    temp_adresse (nom)
select DISTINCT
    adresse
from temp_patient;
--Ajouter les adresses des médecins (donc de l'hopital) à temp adresse
INSERT into
    temp_adresse (nom)
select DISTINCT
    adresse_hopital
from temp_medecin;
--Création de la table adresse
CREATE table adresse ( id serial primary key, nom VARCHAR(200) );
--Ajouter les adresses de la table temporaire à la table final en faisant attention à ne pas avoir de duplicats
INSERT into adresse (nom) select DISTINCT nom from temp_adresse;
--Création du type enum pour les sexes des personnes
create type type_sexe as enum ('Homme',
'Femme',
'Non-spécifié', 'Non-binaire');
--Création de la table temp personne
create temp table temp_personne (
    id integer,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe type_sexe default 'Non-spécifié'
);
--Supprimer la table temp personne EN CAS D'ERREUR UNIQUEMENT
drop table temp_personne;
--Supprimer type enum des sexes EN CAS D'ERREUR UNIQUEMENT
drop type type_sexe;
--insérer les données des médecins dans les personnes (temp)
insert into
    temp_personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
SELECT
    id,
    nom,
    prenom,
    telephone,
    sexe::type_sexe --cast en type enum
from temp_medecin;
--insérer les données des patients dans les personnes (temp)
INSERT into
    temp_personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
select
    id,
    nom,
    prenom,
    telephone,
    sexe::type_sexe --cast en type enum
from temp_patient;
--Passage des sexes NULL en Non-spécifié
update temp_personne set sexe = 'Non-spécifié' where sexe is NULL;
--Ajoute la contrainte NUT NULL pour les sexes
alter table temp_personne alter column sexe set not null;
--Creation de la table finale de personne
CREATE table personne (
    id serial PRIMARY KEY,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe varchar(15) default 'non-spécifié'
)
--Ajoute les données de temp personne à personne final
insert into
    personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
SELECT DISTINCT
    id,
    nom,
    prenom,
    telephone,
    sexe
from temp_personne;

/*select * from personne;*/
--Création de la table temp assurance
create temp table temp_assurance (
    id serial primary key,
    assurance_nom varchar(60) not null
);
--Ajout des données d'assurance. Ajoute uniquement les noms des assurances des gens sans complémentaire
INSERT INTO
    temp_assurance (assurance_nom)
select DISTINCT
    assurance
from temp_patient
where
    temp_patient.assurance not like '%+%';
--Ajout des données d'assurance. Ajoute uniquement les noms d'assurances des personnes avec complémentaire (d'ou le +)
INSERT INTO
    temp_assurance (assurance_nom)
select DISTINCT
    TRIM(
        (
            string_to_array(assurance, '+')
        ) [1]
    ) as assurance
from temp_patient;
--Création de la table finale des assurances
create table assurance (
    id serial PRIMARY KEY,
    assurance_nom VARCHAR(30) not null
);
--Ajoute les assurances à la table finale et évite les duplicats de la meme assurance.
INSERT INTO
    assurance (assurance_nom)
SELECT DISTINCT
    assurance_nom
from temp_assurance;

/*SELECT * from assurance;*/
--Ajoute une colone d'assurance complémentaire aux patients temporaire
alter table temp_patient add complementaire BOOLEAN;
--Met à jour temp patient en true si la personne a une complémentaire (d'ou le +)
update temp_patient
set
    complementaire = true
where
    temp_patient.assurance LIKE '%+%';
--Met à jour temp patient en false si la personne n'a pas de complémentaire (d'ou le +)
UPDATE temp_patient
set
    complementaire = false
where
    temp_patient.assurance NOT LIKE '%+%';
--Ajout au patient temporaire l'id de l'assurance
alter table temp_patient add assurance_id int;
--Défini les id aux assurances corréspondantes (le || % indique que le nom de l'assurance doit commencer par a.assurance_nom et en suite %)
UPDATE temp_patient tp
SET
    assurance_id = a.id
FROM assurance a
WHERE
    tp.assurance LIKE a.assurance_nom || '%';

/*select assurance.assurance_nom, temp_patient.id, temp_patient.assurance
from temp_patient
inner join assurance on assurance.id = temp_patient.assurance_id;*/
--Ajoute une contrainte NOT NULL à l'assurance_id
alter TABLE temp_patient alter COLUMN assurance_id SET NOT NULL;
--Ajoute une contrainte NOT NULL au fait d'avoir une complémentaire
alter TABLE temp_patient alter COLUMN complementaire SET NOT NULL;

select * from temp_patient;
