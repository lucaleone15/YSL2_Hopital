-- Active: 1743084403060@@127.0.0.1@5432@hopital
--Création du type enum pour les sexes des personnes
create type type_sexe as enum ('Homme',
'Femme',
'Non-spécifié', 'Non-binaire');

--Création du type enum pour les médicaments
create type type_medicament as enum ('Comprimé',
'Gélule',
'Aérosol',
'Injection', 
'Capsule');

--Création du type enum pour les RDV
create type type_rdv as enum ('Consultation',
'Examen',
'Opération',
'Suivi',
'Urgence');