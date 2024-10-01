CREATE VIEW [Staging].[vwK12Staff_StagingTables_C112]
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
		ON  sssrd.SchoolYear = YEAR(RecordStartDateTime)
		AND sssrd.TableName = 'RefSpecialEducationAgeGroupTaught'
		AND sssrd.InputCode = kss.SpecialEducationAgeGroupTaught
   JOIN Staging.SourceSystemReferenceData sssrd2
		ON  sssrd2.SchoolYear = YEAR(RecordStartDateTime)
		AND sssrd2.TableName = 'RefParaprofessionalQualification'
		AND sssrd2.InputCode = kss.[ParaprofessionalQualificationStatus] 
  WHERE [FullTimeEquivalency] > 0



