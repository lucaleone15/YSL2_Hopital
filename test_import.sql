-- ADRESSE
create temp table temp_adresse (
    id serial primary key,
    nom VARCHAR(200)
);

create table hopital (
    id serial PRIMARY key,
    adresse_id integer references adresse (id) not null
);

INSERT into
    temp_adresse (nom)
select DISTINCT
    adresse
from temp_patient;

INSERT into
    temp_adresse (nom)
select DISTINCT
    adresse_hopital
from temp_medecin;

CREATE table adresse ( id serial primary key, nom VARCHAR(200) );

INSERT into adresse (nom) select DISTINCT nom from temp_adresse;

create type type_sexe as enum ('homme',
'femme',
'non-spécifié');

create temp table temp_personne (
    id integer,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe varchar(15) default 'non-spécifié'
);

drop table temp_personne;

insert into
    temp_personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
SELECT id, nom, prenom, telephone, sexe
from temp_medecin;

INSERT into
    temp_personne (
        id,
        nom,
        prenom,
        telephone,
        sexe
    )
select id, nom, prenom, telephone, sexe
from temp_patient;

CREATE table personne (
    id serial PRIMARY KEY,
    nom varchar(50) not null,
    prenom varchar(50) not null,
    telephone varchar(50),
    sexe varchar(15) default 'non-spécifié'
)

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

-- ASSURANCE 
create temp table temp_assurance (
    id serial primary key,
    assurance_nom varchar(60) not null
);

INSERT INTO
    temp_assurance (assurance_nom)
select DISTINCT
    assurance
from temp_patient
where
    temp_patient.assurance not like '%+%';

INSERT INTO
    temp_assurance (assurance_nom)
select DISTINCT
    TRIM(
        (
            string_to_array(assurance, '+')
        ) [1]
    ) as assurance
from temp_patient;

create table assurance (
    id serial PRIMARY KEY,
    assurance_nom VARCHAR(30) not null
);

INSERT INTO
    assurance (assurance_nom)
SELECT DISTINCT
    assurance_nom
from temp_assurance;

--SELECT * from assurance;

-- COMPLEMENTAIRE
alter table temp_patient add complementaire BOOLEAN;

update temp_patient
set
    complementaire = true
where
    temp_patient.assurance LIKE '%+%';

UPDATE temp_patient
set
    complementaire = false
where
    temp_patient.assurance NOT LIKE '%+%';

alter table temp_patient add assurance_id int;

UPDATE temp_patient tp
SET
    assurance_id = a.id
FROM assurance a
WHERE
    tp.assurance LIKE a.assurance_nom || '%';
select assurance.assurance_nom, temp_patient.id, temp_patient.assurance from temp_patient
inner join assurance on assurance.id = temp_patient.assurance_id;
