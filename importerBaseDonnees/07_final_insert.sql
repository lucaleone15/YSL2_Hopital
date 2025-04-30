-- Active: 1743084403060@@127.0.0.1@5432@hopital
/*//////////////////////////////////////////
********************************************
ADRESSE
********************************************
//////////////////////////////////////////*/
--Ajouter les adresses
insert into
    adresse (
        rue_et_num,
        code_postal,
        ville,
        etat,
        pays
    )
select
    TRIM(parties[1]) as rue_et_num,
    TRIM(subparties[1]) as code_postal,
    TRIM(subparties[2]) as ville,
    TRIM(parties[3]) as etat,
    TRIM(parties[4]) as pays
from (
        select string_to_array(nom, ', ') as parties, string_to_array(
                (string_to_array(nom, ', ')) [2], ' '
            ) as subparties
        from temp_adresse
    ) as temp

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
from temp_personne;

/*//////////////////////////////////////////
********************************************
ASSURANCES
********************************************
//////////////////////////////////////////*/
--Ajoute les assurances à la table finale et évite les duplicats de la meme assurance.
INSERT INTO
    assurance (id, assurance_nom)
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
    medicament (id, nom, dosage, med_type)
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
    specialisation (id, specialisation_nom)
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
from temp_medecin;

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
        date_naiss,
        complementaire
    )
SELECT
    id,
    personne_id,
    assurance_id,
    adresse_id,
    date_naiss,
    complementaire
FROM temp_patient;

/*//////////////////////////////////////////
********************************************
RENDEZ-VOUS
********************************************
//////////////////////////////////////////*/
INSERT INTO
    rendez_vous (
        id,
        medecin_id,
        rdv_date,
        motif
    )
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
SELECT id, patient_id
FROM temp_rdv
where
    patient_id is not null;

/*//////////////////////////////////////////
********************************************
PRESCRIPTION
********************************************
//////////////////////////////////////////*/
-- IMPORT DANS LA TABLE FINALE --
INSERT INTO
    prescription (
        rendezvous_id,
        medicament_id,
        debut_traitement,
        fin_traitement
    )
SELECT t.rdv_id, t.medicament_id, rv.rdv_date, rv.rdv_date + t.duree * INTERVAL '1 day' AS fin_traitement
FROM
    temp_prescription t
    JOIN rendez_vous rv ON rv.id = t.rdv_id
WHERE
    t.duree <= 365;