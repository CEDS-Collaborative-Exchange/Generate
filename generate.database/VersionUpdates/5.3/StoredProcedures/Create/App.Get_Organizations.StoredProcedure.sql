CREATE PROCEDURE [App].[Get_Organizations]
	   @organizationType as varchar(50),
	   @schoolYear SMALLINT
AS
BEGIN
		if(@organizationType = '001073') -- Schools
		BEGIN
			select distinct 
				  SchoolIdentifierState AS 'OrganizationId'
				, NameOfInstitution AS 'Name'
				, Null AS 'RefOrganizationTypeId'
				, NULL AS 'ShortName'
				, LeaIdentifierState AS 'ParentOrganizationId'
				, SchoolIdentifierState AS 'OrganizationStateIdentifier'
			from rds.DimK12Schools
			where NameOfInstitution is not null
				AND RecordStartDateTime <= CAST('6/30/' + CAST(@schoolYear AS VARCHAR(4)) AS DATE)
				AND (RecordEndDateTime IS NULL 
					OR RecordEndDateTime >= CAST('7/1/' + CAST(@schoolYear - 1 AS VARCHAR(4)) AS DATE))
			order by NameOfInstitution
		END
		ELSE
		BEGIN
			select distinct 
				  LeaIdentifierState AS 'OrganizationId'
				, LEAName AS 'Name'
				, NULL AS 'RefOrganizationTypeId'
				, NULL AS 'ShortName'
				, NULL AS 'ParentOrganizationId'
				, LeaIdentifierState AS 'OrganizationStateIdentifier'  
			from rds.dimleas 
			where LeaName is not null
				AND RecordStartDateTime <= CAST('06/30/' + CAST(@schoolYear AS VARCHAR(4)) AS DATE)
				AND (RecordEndDateTime IS NULL 
					OR RecordEndDateTime >= CAST('07/01/' + CAST(@schoolYear - 1 AS VARCHAR(4)) AS DATE))
			order by LEAName
		END
END