-- Active: 1743084403060@@127.0.0.1@5432@hopital
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

--Ajouter les adresses (adresses utilisées pour lier l'hopital à son adresse) et nom des hopitaux
insert into
    temp_hopital (adresse, nom)
SELECT DISTINCT
    adresse_hopital,
    hopital
from temp_medecin;

--insérer les données des médecins dans les personnes (temp)
insert into
    temp_personne (nom, prenom, telephone, sexe)
SELECT
    nom,
    prenom,
    telephone,
    sexe::type_sexe --cast en type enum
from temp_medecin;

--insérer les données des patients dans les personnes (temp)
INSERT into
    temp_personne (nom, prenom, telephone, sexe)
select
    nom,
    prenom,
    telephone,
    sexe::type_sexe --cast en type enum
from temp_patient;

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
SELECT DISTINCT
    TRIM(SPLIT_PART(assurance, '+', 1)) AS assurance
FROM temp_patient
WHERE
    assurance LIKE '%+%'
    AND TRIM(SPLIT_PART(assurance, '+', 1)) NOT IN (
        SELECT assurance_nom
        FROM temp_assurance
    );

--Ajout dans specialisation
INSERT INTO
    temp_specialisation (specialisation_nom)
select DISTINCT
    specialite
from temp_medecin
where
    temp_medecin.specialite IS NOT NULL;