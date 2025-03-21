//salut
create temp patient(
id int,
nom varchar(50)
prenom varchar(50)
date_naiss date
adresse varchar
telephone varchar(30)
assurance varchar
sexe enum('Homme', 'Femme', 'Non-binaire')
);

copy patient(id, nom, prenom, date_naiss, adresse, telephone, assurance, sexe)
from 'C:\Users\loann\Documents\InfraDon\boxoffice.csv'
WITH CSV HEADER;

create temp medecin(
id int,
nom varchar(50)
prenom varchar(50)
date_naiss date
adresse varchar
telephone varchar(30)
assurance varchar
sexe enum('Homme', 'Femme', 'Non-binaire')
);
// je sais pas
