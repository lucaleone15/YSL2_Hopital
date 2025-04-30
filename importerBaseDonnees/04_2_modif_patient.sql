--Ajoute une colone d'assurance complémentaire aux patients temporaire
alter table temp_patient add complementaire BOOLEAN;

--Met à jour temp patient en true si la personne a une complémentaire (d'ou le +)
update temp_patient
set
    complementaire = true
where
    temp_patient.assurance LIKE '%+%';

--Met à jour temp patient en false si la personne n'a pas de complémentaire (d'ou le +)
UPDATE temp_patient
set
    complementaire = false
where
    temp_patient.assurance NOT LIKE '%+%';