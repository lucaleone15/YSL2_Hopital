-- Active: 1743084403060@@127.0.0.1@5432@hopital
select * from temp_medecin;

SELECT  * from patient inner join assurance on assurance.id = patient.assurance_id;

SELECT * FROM assurance;


DELETE FROM assurance where assurance.id not in (select assurance_id from patient);

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

select * from personne;

CREATE OR REPLACE FUNCTION format_num(num TEXT)
RETURNS TEXT AS $$
DECLARE
    res TEXT := '';
    i INT := 1;
BEGIN
    WHILE i <= LENGTH(num) LOOP
        res := res || SUBSTRING(num, i, 2);
        IF i + 2 <= LENGTH(num) THEN
            res := res || ' ';
        END IF;
        i := i + 2;
    END LOOP;
    RETURN res;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 1. Nettoyage + découpage extension AVANT transformation
SELECT
    telephone AS original,
    '+' || indicatif || ' ' || format_num (rest) AS telephone_formate,
    extension
FROM (
        SELECT
            telephone,
            -- Extraire extension (sans 'x') si présente
            CASE
                WHEN telephone ~ 'x[0-9]+$' THEN SUBSTRING(
                    telephone
                    FROM 'x([0-9]+)$'
                )
                ELSE NULL
            END AS extension,
            -- Numéro sans caractères spéciaux ET sans extension
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    telephone, 'x[0-9]+$', '', 'g'
                ), '[^0-9+]', '', 'g'
            ) AS cleaned,
            -- Extraction de l’indicatif
            CASE
                WHEN telephone ~ '^\+([0-9]{1,3})' THEN SUBSTRING(
                    telephone
                    FROM '^\+([0-9]{1,3})'
                )
                WHEN telephone ~ '^00([0-9]{1,3})' THEN SUBSTRING(
                    telephone
                    FROM '^00([0-9]{1,3})'
                )
                ELSE '41'
            END AS indicatif,
            -- Extraction du reste du numéro (sans indicatif)
            CASE
                WHEN telephone ~ '^\+([0-9]{1,3})([0-9]+)' THEN SUBSTRING(
                    telephone
                    FROM '^\+[0-9]{1,3}([0-9]+)'
                )
                WHEN telephone ~ '^00([0-9]{1,3})([0-9]+)' THEN SUBSTRING(
                    telephone
                    FROM '^00[0-9]{1,3}([0-9]+)'
                )
                ELSE LTRIM(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                            telephone, 'x[0-9]+$', '', 'g'
                        ), '[^0-9]', '', 'g'
                    ), '0'
                )
            END AS rest
        FROM temp_personne
    ) AS nettoye;