-- Active: 1743080737413@@127.0.0.1@5432@hopital
--Affiche le nombre de prescription par patient
SELECT CONCAT(personne.prenom, ' ', personne.nom) AS patient, COUNT(prescription.id) AS nombre_prescriptions
FROM prescription
INNER JOIN rendez_vous ON prescription.rendezvous_id = rendez_vous.id
INNER JOIN patient_rdv_historique ON patient_rdv_historique.rdv_id = rendez_vous.id
INNER JOIN patient ON patient_rdv_historique.patient_id = patient.id
INNER JOIN personne ON patient.personne_id = personne.id
GROUP BY personne.id;

--Tableau pour les consultations avec les patients, les médecins et les rendez-vous
SELECT CONCAT(nom_patient.prenom, ' ', nom_patient.nom) AS patient, rendez_vous.rdv_date, rendez_vous.motif, CONCAT(nom_medecin.prenom, ' ', nom_medecin.nom) AS medecin
FROM patient
INNER JOIN personne AS nom_patient ON patient.personne_id = nom_patient.id
INNER JOIN patient_rdv_historique ON patient_rdv_historique.patient_id = patient.id
INNER JOIN rendez_vous ON patient_rdv_historique.rdv_id = rendez_vous.id
INNER JOIN medecin ON rendez_vous.medecin_id = medecin.id
INNER JOIN personne AS nom_medecin ON medecin.personne_id = nom_medecin.id
ORDER BY patient, rendez_vous.rdv_date DESC;

--Affiche les spécialités des médecins qui comptent le plus de rendez-vous
SELECT specialisation.specialisation_nom AS specialisation, COUNT(rendez_vous.id) AS nombre_rdv
FROM specialisation
INNER JOIN medecin ON medecin.specialisation_id = specialisation.id
INNER JOIN rendez_vous ON rendez_vous.medecin_id = medecin.id
GROUP BY specialisation
ORDER BY nombre_rdv DESC;
