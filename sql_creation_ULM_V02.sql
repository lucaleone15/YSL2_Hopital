/*creation adresse*/
create table adresse(id serial primary key,
rue_et_num varchar(100) not null,
code_postale varchar(10) not null,
ville varchar(50) not null,
etat varchar(50),
pays varchar(50) not null);

/*creation personne*/
create type type_sexe as enum ('homme',
'femme',
'non-spécifié');
create table personne(id serial primary key,
nom varchar(50) not null,
prenom varchar(50) not null,
telephone varchar(50),
sexe type_sexe not null default 'non-spécifié');

/*creation assurance*/
create table assurance(id serial primary key,
assurance_nom varchar(30) not null);

/*creation medoc*/ 
create type type_medicament as enum ('comprime',
'gelule',
'aerosol',
'injection');
create table medicament(id serial primary key,
nom varchar(30) not null,
dosage varchar(10) not null,
med_type type_medicament not null);

/*creation specialisation medecin*/ 
create type type_specialisation as enum ('neurologue',
'generaliste',
'pediatre',
'dermatologue',
'psychiatre');
create table specialisation(id serial primary key,
nom type_specialisation not null);

/*creation hopital*/ 
create table hopital(id serial primary key,
adresse_id integer references adresse(id) not null);

/*creation medecin*/ 
create table medecin(id serial primary key,
personne_id integer references personne(id) not null,
hopital_id integer references hopital(id) not null,
specialisation_id integer references specialisation(id) not null);

/*creation patient*/ 
create table patient(id serial primary key,
personne_id integer references personne(id) not null,
assurance_id integer references assurance(id) not null,
adresse_id integer references adresse(id) not null,
date_naiss date not null,
complementaire boolean not null);

/*creation rdv*/ 
create type type_motif_rdv as enum ('consultation',
'examen',
'suivi',
'urgence',
'operation');
create table rdv(id serial primary key,
medecin_id integer references medecin(id) not null,
rdv_date timestamp not null,
motif type_motif_rdv not null);

/*creation historique patient*/ 
create table patient_rdv_historique(id serial primary key,
patient_id integer references patient(id) not null,
rdv_id integer references rdv(id) not null,
unique (patient_id,
rdv_id));

/*creation prescription*/ 
create table prescription(id serial primary key,
rdv_id integer references rdv(id) not null,
medicament_id integer references medicament(id) not null,
debut_traitement timestamp not null,
fin_traitement timestamp not null);



