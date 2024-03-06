/****************************************************
CIID-5808
January 15, 2024
If K12PersonRace contains duplicate records for Student, LEA, School, Race and SchoolYear, 
the view RDS.vwUnduplicatedRaceMap would treat this as "Multiple Races".  To prevent this,
create a Unique Constraint on table Staging.K12PersonRace to not allow duplicate
records into the table from the ETL.
*****************************************************/

if exists(
	SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='UC_K12PersonRace'
	)
	begin
		ALTER TABLE staging.K12PersonRace DROP CONSTRAINT [UC_K12PersonRace]
	end	

alter table staging.K12PersonRace
add constraint UC_K12PersonRace 
UNIQUE (StudentIdentifierState, LEAIdentifierSeaAccountability, SchoolIdentifierSea, RaceType, SchoolYear)