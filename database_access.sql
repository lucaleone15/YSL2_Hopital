-- Active: 1743080815125@@127.0.0.1@5432@hopital
CREATE ROLE secretary;
CREATE ROLE doctor;
CREATE ROLE administrator;

GRANT SELECT ON adresse, personne, assurance, medicament, specialisation, hopital, medecin, patient, rendez_vous, patient_rdv_historique, prescription TO secretary;

GRANT SELECT ON adresse, personne, assurance, medicament, specialisation, hopital, medecin, patient, rendez_vous, patient_rdv_historique, prescription TO doctor;

GRANT INSERT, UPDATE ON prescription TO doctor

GRANT ALL PRIVILEGES ON adresse, personne, assurance, medicament, specialisation, hopital, medecin, patient, rendez_vous, patient_rdv_historique, prescription TO administrator;