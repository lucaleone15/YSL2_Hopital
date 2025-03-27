/*insert adresses final, adresses des medecins*/
insert
	into
	adresse (rue_et_num,
	code_postal,
	ville,
	etat,
	pays)
select
	TRIM(parties[1]) as rue_et_num,
	TRIM(subparties[1]) as code_postal,
	TRIM(subparties[2]) as ville,
	TRIM(parties[3]) as etat,
	TRIM(parties[4]) as pays
from
	(
	select
		string_to_array(adresse,
		', ') as parties,
		string_to_array((string_to_array(adresse,
		', '))[2],
		' ') as subparties
	from
		medecin_temp
) as temp
on
	conflict (rue_et_num,
	code_postal) do nothing;

--Ajouter les adresses des patient
insert
	into
	adresse (rue_et_num,
	code_postal,
	ville,
	etat,
	pays)
select
	TRIM(parties[1]) as rue_et_num,
	TRIM(subparties[1]) as code_postal,
	TRIM(subparties[2]) as ville,
	TRIM(parties[3]) as etat,
	TRIM(parties[4]) as pays
from
	(
	select
		string_to_array(adresse,
		', ') as parties,
		string_to_array((string_to_array(adresse,
		', '))[2],
		' ') as subparties
	from
		patient_temp
) as temp
on
	conflict (rue_et_num,
	code_postal) do nothing;
