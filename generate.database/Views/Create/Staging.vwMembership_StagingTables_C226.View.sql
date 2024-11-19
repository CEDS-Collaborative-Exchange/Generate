CREATE VIEW [Staging].[vwMembership_StagingTables_C226]
AS

    SELECT stg.*
    FROM [debug].[vwMembership_StagingTables] stg 
	INNER JOIN 
	(		
		SELECT DISTINCT InputCode ,SchoolYear
		FROM Staging.SourceSystemReferenceData where TableName = 'RefOperationalStatus' 
		AND OutputCode  IN ('Open','New')--'Closed','Added','ChangedBoundary','Inactive','FutureAgency','Reopened')
	) SchOpSta ON stg.School_OperationalStatus = SchOpSta.InputCode AND stg.SchoolYear = SchOpSta.SchoolYear
	INNER JOIN 
	(		
		SELECT DISTINCT InputCode ,SchoolYear
		FROM Staging.SourceSystemReferenceData where TableName = 'RefSchoolType' 
		AND OutputCode  IN ('Regular','Special', 'CareerAndTechnical', 'Alternative')--,'Reportable')
	) SchType ON stg.School_Type = SchType.InputCode AND stg.SchoolYear = SchType.SchoolYear
	INNER JOIN  
	(
		SELECT DISTINCT InputCode ,SchoolYear
		FROM Staging.SourceSystemReferenceData where TableName = 'RefGradeLevel' 
		--AND SchoolYear = A.SchoolYear
		AND OutputCode  IN
		('01','02','03','04','05','06','07','08','09','10','11','12','KG','PK',
		CASE WHEN
				(
				SELECT ISNULL( CASE WHEN r.ResponseValue = 'true' THEN 1 ELSE 0 END, 0 )  
				FROM app.ToggleQuestions q 
				LEFT OUTER JOIN app.ToggleResponses r 
					ON r.ToggleQuestionId = q.ToggleQuestionId
				WHERE q.EmapsQuestionAbbrv = 'ADULTEDU'
				) = 1 THEN 'ABE' ELSE '' END,
		CASE WHEN
				(
				SELECT ISNULL( CASE WHEN r.ResponseValue = 'true' THEN 1 ELSE 0 END, 0 )  
				FROM app.ToggleQuestions q 
				LEFT OUTER JOIN app.ToggleResponses r 
					ON r.ToggleQuestionId = q.ToggleQuestionId
				WHERE q.EmapsQuestionAbbrv = 'CCDGRADE13'
				) = 1 THEN '13' ELSE '' END,
		CASE WHEN
				(
				SELECT ISNULL( CASE WHEN r.ResponseValue = 'true' THEN 1 ELSE 0 END, 0 )  
				FROM app.ToggleQuestions q 
				LEFT OUTER JOIN app.ToggleResponses r 
					ON r.ToggleQuestionId = q.ToggleQuestionId
				WHERE q.EmapsQuestionAbbrv = 'CCDUNGRADED'
				) = 1 THEN 'UG' ELSE '' END 		

		)	
	) GRD ON stg.GradeLevel = GRD.InputCode AND stg.SchoolYear = GRD.SchoolYear
	WHERE stg.EconomicDisadvantageStatus = 1

/*


CREATE VIEW Staging.vwMembership_StagingTables_C226
AS
    SELECT 
        *
    FROM [debug].[vwMembership_StagingTables]
    WHERE EconomicDisadvantageStatus = 1

*/

GO
