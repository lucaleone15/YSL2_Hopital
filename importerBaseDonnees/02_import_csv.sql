--Ajouter dans temp_patient
copy temp_patient (
    id,
    nom,
    prenom,
    date_naiss,
    adresse,
    telephone,
    assurance,
    sexe
)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\patients.csv'
WITH
    CSV HEADER DELIMITER ';';

--Ajouter dans temp_medecin
copy temp_medecin (
    id,
    nom,
    prenom,
    specialite,
    hopital,
    telephone,
    sexe,
    adresse_hopital
)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\medecins.csv'
WITH
    CSV HEADER DELIMITER ';';

--Ajouter dans temp_rdv
copy temp_rdv (
    id,
    patient_id,
    medecin_id,
    rdv_date,
    motif
)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\rdv.csv'
WITH
    CSV HEADER DELIMITER ';';

--Ajouter dans temp_medicament
copy temp_medicament (id, nom, dosage, med_type)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\medoc.csv'
WITH
    CSV HEADER DELIMITER ';';

--Ajouter dans temp_prescription
copy temp_prescription (
    id,
    rdv_id,
    medicament_id,
    duree
)
from 'C:\Users\yanni\OneDrive\HEIG\Cours\24-25 2S\InfraDon1\Projet\prescriptions.csv'
WITH
    CSV HEADER DELIMITER ';';