-- Active: 1743084403060@@127.0.0.1@5432@hopital
select *from temp_medecin;

select * from temp_specialisation;

select * from temp_rdv;


select * from temp_rdv where medecin_id not in (select id from medecin);

select * from patient_rdv_historique;

select * FROM patient;
select * from temp_adresse;