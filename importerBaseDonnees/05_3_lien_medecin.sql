-- Active: 1743084403060@@127.0.0.1@5432@hopital
--ajouter une ligne pour les id de l'hopital à médecins temp
alter table temp_medecin add hopital_id int;

--Relier médecin temp à hopital
UPDATE temp_medecin mp
SET
    hopital_id = hp.id
FROM temp_hopital hp
WHERE
    hp.nom = mp.hopital;

--Ajouter une colone pour les id des personnes aux medecins temp
ALTER TABLE temp_medecin ADD personne_id int;

-- lier les medecins temp aux personnes
UPDATE temp_medecin tm
SET
    personne_id = pers.id
FROM temp_personne pers
WHERE
    pers.nom = tm.nom
    AND pers.prenom = tm.prenom;

-- Ajout de la colonne specialisation_id dans temp_medecin
ALTER TABLE temp_medecin ADD COLUMN specialisation_id INTEGER;

-- Ajoute les id des spécialisation dans temp_medecin
UPDATE temp_medecin tm
SET
    specialisation_id = s.id
FROM temp_specialisation s
WHERE
    tm.specialite = s.specialisation_nom;