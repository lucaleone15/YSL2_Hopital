/*creation adresse*/
create table adresse (
    id serial primary key,
    rue_et_num varchar(100) not null,
    code_postal varchar(10) not null,
    ville varchar(50) not null,
    etat varchar(50),
    pays varchar(50) not null
);

/*creation personne*/
create table personne (
    id serial primary key,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe type_sexe default 'Non-spécifié'
);

/*creation assurance*/
create table assurance (
    id serial primary key,
    nom varchar(30) not null
);

/*creation medoc*/
create table medicament (
    id serial primary key,
    nom varchar(30) not null,
    dosage varchar(10) not null,
    type type_medicament not null
);

/*creation specialisation medecin*/
create table specialisation (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL
);

/*creation hopital*/
create table hopital (
    id serial primary key,
    adresse_id integer references adresse (id) not null,
    nom varchar(50) not null
);

/*creation medecin*/
create table medecin (
    id serial primary key,
    personne_id integer references personne (id) not null,
    hopital_id integer references hopital (id) not null,
    specialisation_id integer references specialisation (id) not null
);

/*creation patient*/
create table patient (
    id serial primary key,
    personne_id integer references personne (id) not null,
    assurance_id integer references assurance (id) not null,
    adresse_id integer references adresse (id) not null,
    date_naissance date not null,
    complementaire boolean not null
);

/*creation rdv*/
create table rdv (
    id serial primary key,
    medecin_id integer references medecin (id) not null,
    date date not null,
    motif type_rdv not null
);

/*creation historique patient*/
create table patient_rdv_historique (
    id serial primary key,
    patient_id integer references patient (id) not null,
    rdv_id integer references rdv (id) not null,
    CONSTRAINT unique_patient_rdv UNIQUE (patient_id, rdv_id)
);

/*creation prescription*/
CREATE TABLE prescription (
    id SERIAL PRIMARY KEY,
    rdv_id INTEGER REFERENCES rdv (id) NOT NULL,
    medicament_id INTEGER REFERENCES medicament (id) NOT NULL,
    debut_traitement DATE NOT NULL,
    fin_traitement DATE NOT NULL
);