--Affiche le nombre de prescription par patient
SELECT CONCAT(personne.prenom, ' ', personne.nom) AS patient, COUNT(prescription.id) AS nombre_prescriptions
FROM prescription
INNER JOIN rdv ON prescription.rdv_id = rdv.id
INNER JOIN patient_rdv_historique ON patient_rdv_historique.rdv_id = rdv.id
INNER JOIN patient ON patient_rdv_historique.patient_id = patient.id
INNER JOIN personne ON patient.personne_id = personne.id
GROUP BY personne.id
ORDER BY patient;

--Tableau pour les consultations avec les patients, les médecins et les rendez-vous
SELECT CONCAT(personne_patient.prenom, ' ', personne_patient.nom) AS patient, rdv.date, rdv.motif, CONCAT(personne_medecin.prenom, ' ', personne_medecin.nom) AS medecin
FROM patient
INNER JOIN personne AS personne_patient ON patient.personne_id = personne_patient.id
INNER JOIN patient_rdv_historique ON patient_rdv_historique.patient_id = patient.id
INNER JOIN rdv ON patient_rdv_historique.rdv_id = rdv.id
INNER JOIN medecin ON rdv.medecin_id = medecin.id
INNER JOIN personne AS personne_medecin ON medecin.personne_id = personne_medecin.id
ORDER BY patient, rdv.date DESC;

--Affiche les spécialités des médecins qui comptent le plus de rendez-vous
SELECT specialisation.nom AS specialisation, COUNT(rdv.id) AS nombre_rdv
FROM specialisation
INNER JOIN medecin ON medecin.specialisation_id = specialisation.id
INNER JOIN rdv ON rdv.medecin_id = medecin.id
GROUP BY specialisation
ORDER BY nombre_rdv DESC;
