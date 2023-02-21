-- DimPersonnelStatuses

set nocount on;

begin try
	begin transaction

			declare @expectedCount as int
			select @expectedCount = count(*) from rds.DimPersonnelStatuses

		if(@expectedCount <> 6804)
		BEGIN
		
			delete from rds.FactPersonnelCounts
			delete from rds.DimPersonnelStatuses where DimPersonnelStatusId <> -1

		
			declare @ageGroupId as int
			declare @ageGroupCode as varchar(50)
			declare @ageGroupDescription as varchar(200)
			declare @ageGroupEdFactsCode as varchar(50)

			declare @ageGroupTable table(
				ageGroupId int,
				ageGroupCode varchar(50),
				ageGroupDescription varchar(200),
				ageGroupEdFactsCode varchar(50)
			); 

			insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) values (1, '3TO5', '3 through 5', '3TO5')
			insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) values (2, '6TO21', '6 through 21', '6TO21')

			declare @certificationStatusId as int
			declare @certificationStatusCode as varchar(50)
			declare @certificationStatusDescription as varchar(200)
			declare @certificationStatusEdFactsCode as varchar(50)

			declare @certificationStatusTable table(
				certificationStatusId int,
				certificationStatusCode varchar(50),
				certificationStatusDescription varchar(200),
				certificationStatusEdFactsCode varchar(50)
			); 

			insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) values (1, 'FC', 'Fully certified or licensed', 'FC')
			insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) values (2, 'NFC', 'Not fully certified or licensed', 'NFC')

			declare @personnelTypeId as int
			declare @personnelTypeCode as varchar(50)
			declare @personnelTypeDescription as varchar(200)
			declare @personnelTypeEdFactsCode as varchar(50)

			declare @personnelTypeTable table(
				personnelTypeId int,
				personnelTypeCode varchar(50),
				personnelTypeDescription varchar(200),
				personnelTypeEdFactsCode varchar(50)
			); 

			insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
			values 
			(1, 'STAFF', 'Related services personnel', 'STAFF')

			insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
			values 
			(2, 'TEACHER', 'Teacher', 'TEACHER')

			insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
			values 
			(3, 'PARAPROFESSIONAL', 'Paraprofessional', 'PARAPROFESSIONAL')


			declare @qualificationStatusId as int
			declare @qualificationStatusCode as varchar(50)
			declare @qualificationStatusDescription as varchar(200)
			declare @qualificationStatusEdFactsCode as varchar(50)

			declare @qualificationStatusTable table(
				qualificationStatusId int,
				qualificationStatusCode varchar(50),
				qualificationStatusDescription varchar(200),
				qualificationStatusEdFactsCode varchar(50)
			); 

			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (1, 'HQ', 'Highly qualified', 'HQ')
			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (2, 'NHQ', 'Not highly qualified', 'NHQ')
			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (3, 'Qualified', 'Qualified', 'Q')
			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (4, 'NotQualified', 'Not qualified', 'NQ')
			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (5, 'SPEDTCHFULCRT', 'Fully certified', 'SPEDTCHFULCRT')
			insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (6, 'SPEDTCHNFULCRT', 'Not fully certified', 'SPEDTCHNFULCRT')

			declare @unexperiencedStatusId as int
			declare @unexperiencedStatusCode as varchar(50)
			declare @unexperiencedStatusDescription as varchar(200)
			declare @unexperiencedStatusEdFactsCode as varchar(50)

			declare @unexperiencedStatusTable table(
					UnexperiencedStatusId int,
					UnexperiencedStatusCode varchar(50),
					UnexperiencedStatusDescription varchar(200),
					UnexperiencedStatusEdFactsCode varchar(50)
				); 

			insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
			values(-1, 'MISSING', 'Missing', 'MISSING')
			insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
			values(1, 'TCHEXPRNCD', 'Experienced teachers', 'TCHEXPRNCD')
			insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
			values(2, 'TCHINEXPRNCD', 'Inexperienced teachers', 'TCHINEXPRNCD')

			declare @emergencyOrProvisionalCredentialStatusId as int
			declare @emergencyOrProvisionalCredentialStatusCode as varchar(50)
			declare @emergencyOrProvisionalCredentialStatusDescription as varchar(200)
			declare @emergencyOrProvisionalCredentialStatusEdFactsCode as varchar(50)

			declare @emergencyOrProvisionalCredentialStatusTable table(
					EmergencyOrProvisionalCredentialStatusId int,
					EmergencyOrProvisionalCredentialStatusCode varchar(50),
					EmergencyOrProvisionalCredentialStatusDescription varchar(200),
					EmergencyOrProvisionalCredentialStatusEdFactsCode varchar(50)
				); 

			insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
			values(-1, 'MISSING', 'Missing', 'MISSING')
			insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
			values(1, 'TCHWEMRPRVCRD', 'Emergency or Provisional – Teachers with emergency or provisional credential', 'TCHWEMRPRVCRD')
			insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
			values(2, 'TCHWOEMRPRVCRD', 'No Emergency or Provisional – Teachers without emergency or provisional credential', 'TCHWOEMRPRVCRD')

			declare @outOfFieldStatusId as int
			declare @outOfFieldStatusCode as varchar(50)
			declare @outOfFieldStatusDescription as varchar(200)
			declare @outOfFieldStatusEdFactsCode as varchar(50)

			declare @OutOfFieldStatusTable table(
					OutOfFieldStatusId int,
					OutOfFieldStatusCode varchar(50),
					OutOfFieldStatusDescription varchar(200),
					OutOfFieldStatusEdFactsCode varchar(50)
				); 

			insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
			values(-1, 'MISSING', 'Missing', 'MISSING')
			insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
			values(1, 'TCHINFLD', 'Teaching in field', 'TCHINFLD')
			insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
			values(2, 'TCHOUTFLD', 'Not teaching in field', 'TCHOUTFLD')
		
			insert into RDS.DimPersonnelStatuses
			(
				AgeGroupId, AgeGroupCode, AgeGroupDescription, AgeGroupEdFactsCode,
				CertificationStatusId, CertificationStatusCode, CertificationStatusDescription, CertificationStatusEdFactsCode,
				PersonnelTypeId, PersonnelTypeCode, PersonnelTypeDescription, PersonnelTypeEdFactsCode,
				QualificationStatusId, QualificationStatusCode, QualificationStatusDescription, QualificationStatusEdFactsCode,
				UnexperiencedStatusId, UnexperiencedStatusCode, UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode,
				EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode,
				OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
			)
			select AgeGroupId, AgeGroupCode, AgeGroupDescription, AgeGroupEdFactsCode,
				CertificationStatusId, CertificationStatusCode, CertificationStatusDescription, CertificationStatusEdFactsCode,
				PersonnelTypeId, PersonnelTypeCode, PersonnelTypeDescription, PersonnelTypeEdFactsCode,
				QualificationStatusId, QualificationStatusCode, QualificationStatusDescription, QualificationStatusEdFactsCode,
				UnexperiencedStatusId, UnexperiencedStatusCode, UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode,
				EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode,
				OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
			from @ageGroupTable
			cross join @certificationStatusTable
			cross join @personnelTypeTable
			cross join @qualificationStatusTable
			cross join @unexperiencedStatusTable
			cross join @emergencyOrProvisionalCredentialStatusTable
			cross join @OutOfFieldStatusTable
			except
			select AgeGroupId, AgeGroupCode, AgeGroupDescription, AgeGroupEdFactsCode,
				CertificationStatusId, CertificationStatusCode, CertificationStatusDescription, CertificationStatusEdFactsCode,
				PersonnelTypeId, PersonnelTypeCode, PersonnelTypeDescription, PersonnelTypeEdFactsCode,
				QualificationStatusId, QualificationStatusCode, QualificationStatusDescription, QualificationStatusEdFactsCode,
				UnexperiencedStatusId, UnexperiencedStatusCode, UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode,
				EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode,
				OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
			from @ageGroupTable
			cross join @certificationStatusTable
			cross join @personnelTypeTable
			cross join @qualificationStatusTable
			cross join @unexperiencedStatusTable
			cross join @emergencyOrProvisionalCredentialStatusTable
			cross join @OutOfFieldStatusTable
			where ageGroupCode = 'MISSING' and CertificationStatusCode = 'MISSING' and PersonnelTypeCode = 'MISSING' and QualificationStatusCode = 'MISSING' 
			and UnexperiencedStatusCode = 'MISSING' and EmergencyOrProvisionalCredentialStatusCode = 'MISSING' and OutOfFieldStatusCode = 'MISSING'

		END

	commit transaction

end try
begin catch

	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end

	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()

	declare @sev as int
	set @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

end catch

set nocount off;