CREATE PROCEDURE [RDS].[Migrate_DimPersonnelStatuses]
	@personnelDates as PersonnelDateTableType READONLY
AS
BEGIN
	declare @k12PersonnelRoleId as int
	select @k12PersonnelRoleId = RoleId from ods.[Role] where Name = 'K12 Personnel'

	declare @credentialQuery as table (
		DimPersonnelId int,
		PersonId int,
		DimCountDateId int,
		Credentialed bit,
		QualificationStatusCode varchar(50)
	)
	insert into @credentialQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		Credentialed,
		QualificationStatusCode		
	)

	select distinct p.DimPersonnelId,
		p.PersonId,
		p.DimCountDateId,
		1,
		qual.Code as QualificationStatusCode
	from @personnelDates p
	inner join ods.PersonCredential cred on p.PersonId = cred.PersonId
	inner join ods.RefCredentialType credType on cred.RefCredentialTypeId = credType.RefCredentialTypeId
	left outer join ods.StaffCredential staffCred on cred.PersonCredentialId = staffCred.PersonCredentialId
		and p.SubmissionYearDate between ISNULL(staffCred.RecordStartDateTime, p.SubmissionYearDate) and ISNULL(staffCred.RecordEndDateTime, GETDATE())
	left outer join ods.RefParaprofessionalQualification qual on staffCred.RefParaprofessionalQualificationId = qual.RefParaprofessionalQualificationId
	where credType.Code = 'Certification' or credType.Code = 'Licensure'
	and cred.IssuanceDate <= p.SubmissionYearDate and (cred.ExpirationDate is null or cred.ExpirationDate >= SubmissionYearDate)

	declare @personnelStatusQuery as table (
		DimPersonnelId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		AgeGroupCode varchar(50),
		CertificationStatusCode varchar(50),
		PersonnelTypeCode varchar(50),
		QualificationStatusCode varchar(50),
		StaffCategoryCode varchar(50),
		PersonnelFTE decimal(18,3),
		UnexperiencedStatusCode varchar(50),
		EmergencyOrProvisionalCredentialStatusCode varchar(50),
		OutOfFieldStatusCode varchar(50)
	)

	insert into @personnelStatusQuery
	(
		DimPersonnelId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		StaffCategoryCode,
		PersonnelFTE,
		UnexperiencedStatusCode,
		EmergencyOrProvisionalCredentialStatusCode,
		OutOfFieldStatusCode
	)
	select 
		p.DimPersonnelId,
		sch.DimSchoolId,
		r.PersonId,
		d.DimCountDateId,
		isnull(ageGroup.Code, 'MISSING') as AgeGroupCode,
		case
			when cred.Credentialed = 1 then 'FC'
			else 'NFC'
		end as CertificationStatusCode,
		case
			when classif.Code = 'SpecialEducationTeachers' then 'TEACHER'
			when classif.Code = 'Paraprofessionals' then 'PARAPROFESSIONAL'
			when not staffCat.Code is null then 'STAFF'
			else 'MISSING'
		end as PersonnelTypeCode,
		case
			when classif.Code = 'Paraprofessionals' then isnull(cred.QualificationStatusCode, 'MISSING')
			when classif.Code = 'SpecialEducationTeachers' AND staff.HighlyQualifiedTeacherIndicator = 1 then 'SPEDTCHFULCRT'
			when classif.Code = 'SpecialEducationTeachers' AND staff.HighlyQualifiedTeacherIndicator = 0 then 'SPEDTCHNFULCRT'
			when d.DimCountDateId<8 AND staff.HighlyQualifiedTeacherIndicator = 1 then 'HQ'
			when d.DimCountDateId<8 AND staff.HighlyQualifiedTeacherIndicator = 0 then 'NHQ'
			when staff.HighlyQualifiedTeacherIndicator = 1 then 'SPEDTCHFULCRT'
			when staff.HighlyQualifiedTeacherIndicator = 0 then 'SPEDTCHNFULCRT'
			else 'MISSING'
		end
		as QualificationStatusCode,
		isnull(staffCat.Code, 'MISSING') as StaffCategoryCode,
		staff.FullTimeEquivalency,
		isnull(unexp.Code, 'MISSING') as UnexperiencedStatusCode,
		isnull(emerg.Code, 'MISSING') as EmergencyOrProvisionalCredentialStatusCode,
		isnull(outf.Code, 'MISSING') as OutOfFieldStatusCode
	from @personnelDates d
	inner join rds.DimPersonnel p on d.DimPersonnelId = p.DimPersonnelId
	inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId
		and r.RoleId = @k12PersonnelRoleId
	inner join ods.K12staffAssignment staff on r.OrganizationPersonRoleId = staff.OrganizationPersonRoleId
		and d.SubmissionYearDate between ISNULL(staff.RecordStartDateTime, d.SubmissionYearDate) and ISNULL(staff.RecordEndDateTime, GETDATE())
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = r.OrganizationId
	left outer join ods.RefSpecialEducationAgeGroupTaught ageGroup on staff.RefSpecialEducationAgeGroupTaughtId = ageGroup.RefSpecialEducationAgeGroupTaughtId
	left outer join ods.RefSpecialEducationStaffCategory staffCat on staff.RefSpecialEducationStaffCategoryId = staffCat.RefSpecialEducationStaffCategoryId
	left outer join ods.RefK12StaffClassification classif on staff.RefK12StaffClassificationId = classif.RefEducationStaffClassificationId
	left outer join @credentialQuery cred on d.DimPersonnelId = cred.DimPersonnelId and d.DimCountDateId = cred.DimCountDateId
	left join ods.RefUnexperiencedStatus unexp on unexp.RefUnexperiencedStatusId=staff.RefUnexperiencedStatusId
	left join ods.RefEmergencyOrProvisionalCredentialStatus emerg on emerg.RefEmergencyOrProvisionalCredentialStatusId=staff.RefEmergencyOrProvisionalCredentialStatusId
	left join ods.RefOutOfFieldStatus outf on outf.RefOutOfFieldStatusId=staff.RefOutOfFieldStatusId
	where p.DimPersonnelId <> -1
	and r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)	
	order by p.DimPersonnelId

	-- output
	select
		DimPersonnelId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		isnull(AgeGroupCode, 'MISSING'),
		isnull(CertificationStatusCode, 'MISSING'),
		isnull(PersonnelTypeCode, 'MISSING'),
		isnull(QualificationStatusCode, 'MISSING'),
		isnull(StaffCategoryCode, 'MISSING'),
		PersonnelFTE,
		isnull(UnexperiencedStatusCode, 'MISSING'),
		isnull(EmergencyOrProvisionalCredentialStatusCode, 'MISSING'),
		isnull(OutOfFieldStatusCode, 'MISSING')
	from @personnelStatusQuery
END
