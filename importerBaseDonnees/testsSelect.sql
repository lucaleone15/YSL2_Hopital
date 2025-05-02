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

Create temp TABLE test_adresse (
    id serial primary key,
    rue_et_num varchar(100) not null,
    code_postal varchar(10) not null,
    ville varchar(50) not null,
    etat varchar(50),
    pays varchar(50) not null
)

INSERT INTO
    test_adresse (
        rue_et_num,
        code_postal,
        ville,
        etat,
        pays
    )
SELECT
    TRIM(parties[1]) AS rue_et_num,
    TRIM(
        split_part(parties[2], ' ', 1)
    ) AS code_postal,
    TRIM(
        SUBSTRING(
            parties[2]
            FROM POSITION(' ' IN parties[2]) + 1
        )
    ) AS ville,
    TRIM(parties[3]) AS etat,
    TRIM(parties[4]) AS pays
FROM (
        SELECT string_to_array(adresse, ', ') AS parties
        FROM temp_patient
    ) AS temp;

    select * from test_adresse;