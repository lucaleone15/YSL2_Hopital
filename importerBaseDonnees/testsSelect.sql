-- Active: 1743084403060@@127.0.0.1@5432@hopital
select * from temp_medecin;

select * from temp_specialisation;

select * from temp_rdv;

select *
from temp_rdv
where
    medecin_id not in (
        select id
        from medecin
    );

select * from patient_rdv_historique;

select * FROM patient;

select * from temp_adresse;

select * from rendez_vous;

select pe.nom, pe.prenom, ad.ville, rdv_date, motif
from
    personne pe
    inner join patient pa on pe.id = pa.personne_id
    inner join adresse ad on ad.id = pa.adresse_id
    inner join patient_rdv_historique prh on prh.patient_id = pa.id
    inner join rendez_vous rdv on rdv.id = prh.rdv_id
where
    pe.id = 23;