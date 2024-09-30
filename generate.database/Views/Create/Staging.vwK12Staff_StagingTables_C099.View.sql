CREATE VIEW [Staging].[vwK12Staff_StagingTables_C099]	
AS
SELECT sssrd.SchoolYear
	  ,[StaffMemberIdentifierState]
      ,[LeaIdentifierSea]
      ,[SchoolIdentifierSea]
      ,[FullTimeEquivalency]
      ,[SpecialEducationStaffCategory]
      ,[K12StaffClassification]
      ,[TitleIProgramStaffCategory]
      ,[TeachingCredentialType]
      ,[CredentialIssuanceDate]
      ,[CredentialExpirationDate]
      ,[ParaprofessionalQualificationStatus]
	  ,[SpecialEducationTeacherQualificationStatus]
      ,[SpecialEducationAgeGroupTaught]
      ,[HighlyQualifiedTeacherIndicator]
      ,[AssignmentStartDate]
      ,[AssignmentEndDate]
      ,[EdFactsTeacherInexperiencedStatus]
      ,[EDFactsTeacherOutOfFieldStatus]
      ,[RecordStartDateTime]
      ,[RecordEndDateTime]
  FROM [debug].[vwK12Staff_StagingTables] kss
  JOIN Staging.SourceSystemReferenceData sssrd
		ON  sssrd.SchoolYear = YEAR(RecordEndDateTime)
		AND sssrd.TableName = 'RefSpecialEducationStaffCategory'
		AND sssrd.InputCode = kss.SpecialEducationStaffCategory
   JOIN Staging.SourceSystemReferenceData sssrd2
		ON  sssrd2.SchoolYear = YEAR(RecordEndDateTime)
		AND sssrd2.TableName = 'RefSpecialEducationTeacherQualificationStatus'
		AND sssrd2.InputCode = kss.[SpecialEducationTeacherQualificationStatus]
  WHERE [FullTimeEquivalency] > 0



