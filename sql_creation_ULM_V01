create table adresse(id serial primary key,
rue_et_num varchar(100) not null,
code_postale varchar(10) not null,
ville varchar(50) not null,
etat varchar(50),
pays varchar(50) not null);

create table personne(id serial primary key,
nom varchar(50) not null,
prenom varchar(50) not null,
telephone varchar(50),
sexe enum("homme",
"femme",
"non-spécifié") not null default "non-spécifié");

create table assurance(id serial primary key,
assurance_nom varchar(30) not null);

create table medicament(id serial primary key,
nom varchar(30) not null,
dosage varchar(10) not null,
med_type enum("comprime",
"gelule",
"aerosol",
"injection") not null);

create table specialisation(id serial primary key,
nom enum("neurologue",
"generaliste",
"pediatre",
"dermatologue",
"psychiatre") not null);

create table hopital(id serial primary key,
adresse_id integer foreign key references adresse(id) not null);

create table medecin(id serial primary key,
personne_id integer foreign key references personne(id) not null,
hopital_id integer foreign key references hopital(id) not null,
specialisation_id integer foreign key references specialisation(id) not null);



create table patient(id serial primary key,
personne_id integer foreign key references personne(id) not null,
assurance_id integer foreign key references assurance(id) not null,
adresse_id integer foreign key references adresse(id) not null,
date_naiss date not null,
complementaire boolean not null);


create table rdv(id serial primary key,
medecin_id integer foreign key references medecin(id) not null,
rdv_date timestamp not null,
motif enum("consultation",
"examen",
"suivi",
"urgence",
"operation") not null);


create table patient_rdv_historique(id serial primary key,
patient_id integer foreign key references patient(id) not null,
rdv_id integer foreign key references rdv(id) not null,
add constraint uc_patient_rdv_historique unique (patient_id,
rdv_id);


create table prescription(id serial primary key,
rdv_id integer foreign key references rdv(id) not null,
medicament_id integer foreign key references medicament(id) not null,
debut_traitement timestamp not null,
fin_traitement timestamp not null);



