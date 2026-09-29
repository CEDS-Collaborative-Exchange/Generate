CREATE PROCEDURE [RDS].[Migrate_DimTitleIStatuses_School]
	@orgDates AS SchoolDateTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	
	SELECT DISTINCT
		  org.DimSchoolYearId
		, org.DimSchoolId
		, ISNULL(tiss.Code, 'MISSING') AS TitleISchoolStatusCode
		, ISNULL(tiis.Code, 'MISSING') AS TitleIinstructionalServiceCode
		, ISNULL(kltiss.Code, 'MISSING') AS Title1SupportServiceCode
		, ISNULL(tipt.Code , 'MISSING') AS Title1ProgramTypeCode		
	FROM @OrgDates org
	JOIN   (SELECT 
				  MAX(ds.DimK12SchoolId) AS DimK12SchoolId
				, MAX(schStatus.RefTitleISchoolStatusId) AS RefTitleISchoolStatusID
				, MAX(ps.RefTitleIProgramTypeId) AS RefTitleIProgramTypeId
				, MAX(ps.RefTitleIInstructionalServicesId) AS RefTitleIInstructionalServicesId
				, MAX(tss.RefK12LeaTitleISupportServiceId) AS RefK12LeaTitleISupportServiceId
			FROM dbo.OrganizationIdentifier i
			JOIN dbo.RefOrganizationIdentifierType roit 
				ON i.RefOrganizationIdentifierTypeId = roit.RefOrganizationIdentifierTypeId
		  		AND roit.Code = '001073'
			JOIN dbo.RefOrganizationIdentificationSystem rois 
				ON i.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		  		AND rois.RefOrganizationIdentifierTypeId = roit.RefOrganizationIdentifierTypeId
			JOIN RDS.DimK12Schools ds
				ON i.Identifier = ds.SchoolIdentifierState
			JOIN @OrgDates orgDates
				ON ISNULL(i.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(i.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate 
			JOIN dbo.K12School sch 
				ON i.OrganizationId = sch.OrganizationId
				AND (@dataCollectionId IS NULL OR sch.DataCollectionId = @dataCollectionId)	
				AND ISNULL(sch.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(sch.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate 
			JOIN dbo.K12SchoolStatus schStatus 
				ON sch.K12SchoolId = schStatus.K12SchoolId
				AND (@dataCollectionId IS NULL OR schStatus.DataCollectionId = @dataCollectionId)	
				AND ISNULL(sch.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(sch.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate
			JOIN dbo.K12programOrService ps 
				ON ps.OrganizationId = i.OrganizationId	
				AND (@dataCollectionId IS NULL OR ps.DataCollectionId = @dataCollectionId)	
				AND ISNULL(ps.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(ps.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate
			JOIN dbo.K12LeaTitleISupportService tss 
				ON i.OrganizationId = sch.OrganizationId
				AND (@dataCollectionId IS NULL OR tss.DataCollectionId = @dataCollectionId)	
				AND ISNULL(tss.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(tss.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate 
			WHERE (@dataCollectionId IS NULL OR i.DataCollectionId = @dataCollectionId)	
			GROUP BY i.OrganizationId, i.RecordStartDateTime, sch.RecordStartDateTime, ps.RecordStartDateTime, tss.RecordStartDateTime
			HAVING i.RecordStartDateTime = MAX(i.RecordStartDateTime)
				AND sch.RecordStartDateTime = MAX(sch.RecordStartDateTime)
				AND ps.RecordStartDateTime = MAX(ps.RecordStartDateTime)
				AND tss.RecordStartDateTime = MAX(tss.RecordStartDateTime)
			) latest ON latest.DimK12SchoolId = org.DimSchoolId
	LEFT JOIN dbo.RefTitleISchoolStatus tiss 
		ON tiss.RefTitleISchoolStatusId = latest.RefTitleISchoolStatusId
	LEFT JOIN dbo.RefTitleIProgramType tipt 
		ON tipt.RefTitleIProgramTypeId = latest.RefTitleIProgramTypeId
	LEFT JOIN dbo.RefTitleIInstructionalServices tiis 
		ON tiis.RefTitleIInstructionalServicesId = latest.RefTitleIInstructionalServicesId
	LEFT JOIN dbo.RefK12LeaTitleISupportService kltiss
		ON kltiss.RefK12LEATitleISupportServiceId = latest.RefK12LEATitleISupportServiceId
	
END	

