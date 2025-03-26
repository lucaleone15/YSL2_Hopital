-- Patient
create temp table patient(
id integer primary key,
nom varchar(50),
prenom varchar(50),
date_naiss date,
adresse varchar,
telephone varchar(30),
assurance varchar,
sexe varchar
);

copy patient(id, nom, prenom, date_naiss, adresse, telephone, assurance, sexe)
from 'csv\patient.csv'
WITH CSV HEADER;

--Médecin 
create temp table medecin(
id integer primary key,
nom varchar(50),
prenom varchar(50),
specialite enum(Neurologue, Généraliste, Pédiatre, Dermatologue, Psychiatre),
telephone varchar()
sexe varchar,
adresse_hopital varchar()
);

copy medecin(id, nom, prenom, specialite, telephone, sexe, adresse_hopital)
from 'csv\medecins.csv'
WITH CSV HEADER;

-- Rendez-vous
create temp table rdv(
id integer primary key,
patient_id integer references patient(id),
medecin_id integer references medecin(id),
rdv_date date,
motif varchar
);

copy rdv(id, patient_id, medecin_id, rdv_date)
from 'csv\rdv.csv'
WITH CSV HEADER;

-- Médicament
create temp table medicament(
id integer primary key,
nom varchar,
dosage varchar,
med_type varchar
)

copy medicament(id, nom, dosage, med_type)
from 'csv\medoc.csv'
WITH CSV HEADER;

-- Prescription
create temp table prescription(
id integer primary key,
rdv_id integer,
medicament_id integer,
duree integer
);

copy prescription(id, rdv_id, medicament_id, duree)
from 'csv\prescriptions.csv'
WITH CSV HEADER;
