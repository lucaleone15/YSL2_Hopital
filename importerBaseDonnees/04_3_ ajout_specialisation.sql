-- Création table spécialisation
create table specialisation (
    id SERIAL PRIMARY KEY,
    specialisation_nom VARCHAR(30) NOT NULL
);

-- Insertion donnée dans table spécialité
INSERT INTO
    specialisation (specialisation_nom)
select DISTINCT
    specialite
from temp_medecin
where
    temp_medecin.specialite IS NOT NULL;

-- Ajout de la colonne specialisation_id dans temp_medecin
ALTER TABLE temp_medecin ADD COLUMN specialisation_id INTEGER;

ALTER TABLE temp_medecin
ADD CONSTRAINT fk_specialisation FOREIGN KEY (specialisation_id) REFERENCES specialisation (id);

-- Ajoute les id des spécialisation dans temp_medecin
UPDATE temp_medecin tm
SET
    specialisation_id = s.id
FROM specialisation s
WHERE
    tm.specialite = s.specialisation_nom;