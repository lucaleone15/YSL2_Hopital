-- Active: 1743080815125@@127.0.0.1@5432@hopital
/* Médecins avec des informations contradictoires :
Ajoutez des médecins avec le même nom mais des spécialités différentes (homonymes).
Challenge : Repérer ces doublons logiques.*/

SELECT * FROM specialisation;
SELECT * FROM personne;

-- Ajout d'une personne qui a le même nom qu'un médecin
INSERT INTO personne (id, nom, prenom, telephone, sexe)
VALUES ('69', 'Thomas', 'Michael', '021 555 01 01', 'Homme');

-- Ajouter d'un médecin qui a l'id de la personne créé avant et qui a une autre spécialisation 
INSERT INTO medecin (personne_id, hopital_id, specialisation_id)
VALUES (69, 1, 2);

-- Voir si deux médecins avec le même nom et prénom ont une spécialité différente
SELECT p.nom, p.prenom, COUNT(DISTINCT m.specialisation_id) AS nb_specialites
FROM medecin m
JOIN personne p ON m.personne_id = p.id
GROUP BY p.nom, p.prenom
HAVING COUNT(DISTINCT m.specialisation_id) > 1;

------------------------------------------------------------------
/* Rendez-vous en conflit :
Ajoutez des rendez-vous pour un même patient avec des horaires qui se chevauchent.
Challenge : Détecter et corriger les conflits d'agenda. */

-- Insérer une personne
INSERT INTO personne (id, nom, prenom, sexe) VALUES ('70', 'Martin', 'Alice', 'Femme');

-- Insérer une adresse

INSERT INTO adresse (id, rue_et_num, code_postal, ville, pays) 
VALUES ('66', 'Rue de l''Hôpital 1', '1000', 'Lausanne', 'Suisse');

-- Créer le patient

INSERT INTO patient (id, personne_id, assurance_id, adresse_id, date_naissance, complementaire)
VALUES (1000, 70, 1, 66, '1990-01-01', TRUE);

-- Supposons que l'ID retourné soit 1
-- Créer 2 rendez-vous le même jour avec 2 médecins différents

SELECT * FROM rdv

DELETE FROM rdv WHERE ID = 1;

INSERT INTO rdv (id, medecin_id, date, motif) VALUES (1, 2579, '2025-05-10', 'Consultation');
INSERT INTO rdv (id, medecin_id, date, motif) VALUES (2, 2928, '2025-05-10', 'Suivi');

-- Lier les 2 rendez-vous au même patient
INSERT INTO patient_rdv_historique (patient_id, rdv_id) VALUES (1000, 1);
INSERT INTO patient_rdv_historique (patient_id, rdv_id) VALUES (1000, 2);

-- Vérification pour voir si un patient a plusieurs rdv à la même date
SELECT
    p.id AS patient_id,
    p.personne_id,
    r.date,
    COUNT(*) AS nb_rdv
FROM patient_rdv_historique pr
JOIN patient p ON pr.patient_id = p.id
JOIN rdv r ON pr.rdv_id = r.id
GROUP BY p.id, p.personne_id, r.date
HAVING COUNT(*) > 1;

-- Changement de la date pour corriger
UPDATE rdv
SET date = '2025-05-11'
WHERE id = 2; -- ou l’ID du rdv à modifier
