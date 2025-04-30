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
select DISTINCT
    TRIM(
        (
            string_to_array(assurance, '+')
        ) [1]
    ) as assurance
from temp_patient;