create temp
table temp_patient (
    id integer,
    nom varchar,
    prenom varchar,
    date_naiss date,
    adresse varchar,
    telephone varchar,
    assurance varchar,
    sexe varchar
);

--Médecin
create temp
table temp_medecin (
    id integer,
    nom varchar,
    prenom varchar,
    specialite varchar,
    hopital varchar,
    telephone varchar,
    sexe varchar,
    adresse_hopital varchar
);

-- Rendez-vous
create temp
table temp_rdv (
    id integer primary key,
    patient_id integer,
    medecin_id integer,
    rdv_date date,
    motif varchar
);

-- Prescription
create temp
table temp_prescription (
    id integer,
    rdv_id integer,
    medicament_id integer,
    duree integer
);

--Adresse
create temp
table temp_adresse (
    id serial primary key,
    nom VARCHAR(200)
);

--Hôpital
create temp
table temp_hopital (
    id serial PRIMARY key,
    adresse varchar,
    nom varchar
);

--Personne
create temp
table temp_personne (
    id serial,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe type_sexe default 'Non-spécifié'
);

--Assurance
create temp
table temp_assurance (
    id serial primary key,
    assurance_nom varchar(60) not null
);

--Medicament
create temp
table temp_medicament (
    id integer,
    nom varchar,
    dosage varchar,
    med_type varchar
);

-- CREATION TABLE TEMPORAIRE RDV_HISTORIQUE

create temp
table temp_rdv_historique (
    id serial primary key,
    patient_id integer,
    rdv_id integer
);

--Spécialisation
create temp
table temp_specialisation (
    id SERIAL PRIMARY KEY,
    specialisation_nom VARCHAR(30) NOT NULL
);