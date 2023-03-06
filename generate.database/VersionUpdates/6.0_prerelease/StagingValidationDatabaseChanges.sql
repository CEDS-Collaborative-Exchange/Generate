-- Database Changes for Staging Validation --

-- Add StagingValidationRuleId column to staging.STagingValidationResults table
alter table staging.StagingValidationResults
add StagingValidationRuleId int

-- Add Additional DataMigrationTypes
insert into App.DataMigrationTypes	select 'StagingValidation', 'Staging Data Validation'
insert into App.DataMigrationTypes	select 'RDSValidation', 'RDS Data Validation'


-- Add Staging Validation Rules ------------------------------------------
-- LEAs with conflicting values in some columns
insert into staging.StagingValidationRules
select 'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', 'Generate', 'K12Organization', NULL, 'Bad Value', NULL, NULL, 
'where LEA_Identifier_State in (
select LEA_Identifier_State from (
		SELECT DISTINCT	
			LEA_Name
			, LEA_Identifier_NCES 
			, LEA_Identifier_State 
			, Prior_LEA_Identifier_State 
			, LEA_IsReportedFederally AS ReportedFederally
			, LEA_CharterLeaStatus
			, LEA_CharterSchoolIndicator
		FROM Staging.K12Organization) A
group by LEA_Identifier_State
having count(*) > 1)
',
'An LEA with different values in some columns will cause the RDS Migration to fail',
'Critical'

-- Conflicting Organization Phones
insert into staging.StagingValidationRules
select 'Directory',
'Generate', 
'OrganizationPhone', NULL, 'Bad Value', NULL, NULL, 
'where OrganizationIdentifier in (
select OrganizationIdentifier from (
		SELECT	
			OrganizationIdentifier
			, OrganizationType
			, InstitutionTelephoneNumberType 
			, RecordStartDateTime
		FROM Staging.OrganizationPhone) A
group by OrganizationIdentifier
having count(*) > 1
)
',
'An organization with multiple phone numbers of the same type will cause a merge error in the RDS migration',
'Critical'

-- PersonStatus should have an LEA and School Identifier that Exists in K12Organization
insert into staging.StagingValidationRules
select 'ChildCount, Exiting, Discipline, Assessment, Membership',
'Generate', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps 
left join Staging.K12Organization sko
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
where sko.LEA_Identifier_State is null and sko.School_Identifier_State is null
',
'One or more records in PersonStatus are associated with an LEA/School that does not exist in K12Enrollment',
'Warning'

-- PersonStatus student should exist in K12Enrollment
insert into staging.StagingValidationRules
select 'ChildCount, Exiting, Discipline, Assessment, Membership',
'Generate', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps
left join Staging.K12Enrollment ske
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
	and sps.Student_Identifier_State = ske.Student_Identifier_State
where ske.Student_Identifier_State is null
',
'One or more records in PersonStatus do not have a student record in K12Enrollment',
'Warning'

