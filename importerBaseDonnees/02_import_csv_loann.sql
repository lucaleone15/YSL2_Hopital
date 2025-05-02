-- Active: 1743080815125@@127.0.0.1@5432@hopital
-- Patient
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
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\patients.csv'
WITH
    CSV HEADER DELIMITER ';';

--Médecin

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
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\medecins.csv'
WITH
    CSV HEADER DELIMITER ';';

-- Rendez-vous

copy temp_rdv (
    id,
    patient_id,
    medecin_id,
    rdv_date,
    motif
)
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\rdv.csv'
WITH
    CSV HEADER DELIMITER ';';

-- Médicament

copy temp_medicament (id, nom, dosage, med_type)
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\medoc.csv'
WITH
    CSV HEADER DELIMITER ';';

-- Prescription

copy temp_prescription (
    id,
    rdv_id,
    medicament_id,
    duree
)
from 'C:\Users\loann\Documents\GitHub\YSL2_Hopital\csv\prescriptions.csv'
WITH
    CSV HEADER DELIMITER ';';