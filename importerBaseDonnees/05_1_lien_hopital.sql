-- Active: 1743084403060@@127.0.0.1@5432@hopital
--ajouter l'id des adresses temp à temp hopital
alter table temp_hopital add adresse_id int;


--lier les adresses temp à temp hopital
UPDATE temp_hopital th
SET
    adresse_id = ad.id
FROM temp_adresse ad
WHERE
    th.adresse = ad.nom;