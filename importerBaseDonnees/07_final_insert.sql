/*//////////////////////////////////////////
********************************************
ADRESSE
********************************************
//////////////////////////////////////////*/
--Ajouter les adresses
INSERT INTO
    adresse (
        id,
        rue_et_num,
        code_postal,
        ville,
        etat,
        pays
    )
SELECT
    id,
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
        SELECT id, string_to_array(nom, ', ') AS parties
        FROM temp_adresse
    ) AS temp;

/*//////////////////////////////////////////
********************************************
PERSONNES
********************************************
//////////////////////////////////////////*/
--Ajoute les données de temp personne à personne final
insert into
    personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
SELECT DISTINCT
    id,
    nom,
    prenom,
    telephone,
    sexe
from temp_personne
    /*WHERE NOT EXISTS(
    SELECT
    nom,
    prenom,
    telephone,
    sexe
    FROM personne
    )*/;

/*//////////////////////////////////////////
********************************************
ASSURANCES
********************************************
//////////////////////////////////////////*/
--Ajoute les assurances à la table finale et évite les duplicats de la meme assurance.
INSERT INTO
    assurance (id, nom)
SELECT DISTINCT
    id,
    assurance_nom
from temp_assurance;

/*//////////////////////////////////////////
********************************************
MEDICAMENT
********************************************
//////////////////////////////////////////*/
-- IMPORT DANS LA TABLE FINALE
INSERT INTO
    medicament (id, nom, dosage, type)
SELECT
    id,
    nom,
    dosage,
    med_type::type_medicament
FROM temp_medicament;

/*//////////////////////////////////////////
********************************************
SPÉCIALISATION
********************************************
//////////////////////////////////////////*/
INSERT INTO
    specialisation (id, nom)
SELECT id, specialisation_nom
from temp_specialisation;

/*//////////////////////////////////////////
********************************************
HÔPITAL
********************************************
//////////////////////////////////////////*/
--Insértion dans la table finale hopital
insert into
    hopital (id, adresse_id, nom)
select DISTINCT
    id,
    adresse_id,
    nom
from temp_hopital;

/*//////////////////////////////////////////
********************************************
MÉDECIN
********************************************
//////////////////////////////////////////*/
insert into
    medecin (
        id,
        personne_id,
        hopital_id,
        specialisation_id
    )
select
    id,
    personne_id,
    hopital_id,
    specialisation_id
from temp_medecin
    /*WHERE NOT EXISTS(
    SELECT
    personne_id
    FROM patient
    )*/;

/*//////////////////////////////////////////
********************************************
PATIENT
********************************************
//////////////////////////////////////////*/
--insérer les données patient temp à patient
INSERT INTO
    patient (
        id,
        personne_id,
        assurance_id,
        adresse_id,
        date_naissance,
        complementaire
    )
SELECT DISTINCT
    id,
    personne_id,
    assurance_id,
    adresse_id,
    date_naiss,
    complementaire
FROM temp_patient
    /*WHERE NOT EXISTS(
    SELECT
    personne_id
    FROM patient
    )*/;

/*//////////////////////////////////////////
********************************************
RENDEZ-VOUS
********************************************
//////////////////////////////////////////*/
INSERT INTO
    rdv (id, medecin_id, date, motif)
SELECT
    temp_rdv.id,
    medecin_id,
    rdv_date,
    motif::type_rdv
FROM temp_rdv
    inner join medecin on medecin.id = medecin_id;

/*//////////////////////////////////////////
********************************************
HISTORIQUE RENDEZ-VOUS
********************************************
//////////////////////////////////////////*/
INSERT INTO
    patient_rdv_historique (rdv_id, patient_id)
SELECT distinct
    temp_rdv.id,
    patient_id
FROM temp_rdv
    Inner join rdv on temp_rdv.id = rdv.id
where
    patient_id is not null
    /*AND patient.id = temp_rdv.patient_id*/;

/*//////////////////////////////////////////
********************************************
PRESCRIPTION
********************************************
//////////////////////////////////////////*/
-- IMPORT DANS LA TABLE FINALE --
INSERT INTO
    prescription (
        rdv_id,
        medicament_id,
        debut_traitement,
        fin_traitement
    )
SELECT t.rdv_id, t.medicament_id, rv.date, rv.date + t.duree * INTERVAL '1 day' AS fin_traitement
FROM temp_prescription t
    JOIN rdv rv ON rv.id = t.rdv_id
WHERE
    t.duree <= 365;

/*//////////////////////////////////////////////
********************************************
SUPPRESSION DES DOUBLONS (PERSONNES SANS LIENS)
********************************************
//////////////////////////////////////////////*/
DELETE FROM personne
WHERE
    id NOT IN (
        SELECT personne_id
        from medecin
    )
    AND id NOT IN (
        SELECT personne_id
        from patient
    );