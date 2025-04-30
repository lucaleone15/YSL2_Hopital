-- Active: 1743084403060@@127.0.0.1@5432@hopital
--Ajout au patient temporaire l'id de l'assurance
alter table temp_patient add assurance_id int;

--Défini les id aux assurances corréspondantes (le || % indique que le nom de l'assurance doit commencer par a.assurance_nom et en suite %)
UPDATE temp_patient tp
SET
    assurance_id = ta.id
FROM temp_assurance ta
WHERE
    tp.assurance LIKE ta.assurance_nom || '%';

--Créer une colone pour les id des adresse des patients temp
alter TABLE temp_patient add adresse_id int;

--Lier les adresses aux patients temp
UPDATE temp_patient tp
SET
    adresse_id = ad.id
FROM temp_adresse ad
WHERE
    tp.adresse = ad.nom;

--Ajouter une colone pour les id des personnes aux patients temp
ALTER TABLE temp_patient ADD personne_id int;

-- lier les patients temp aux personnes
UPDATE temp_patient tp
SET
    personne_id = pers.id
FROM temp_personne pers
WHERE
    pers.nom = tp.nom
    AND pers.prenom = tp.prenom;