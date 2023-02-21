/**********************************************************************
Author: AEM Corp
Date:	3/1/2022
Description: Migrates Child Count Data from Staging to RDS.FactK12StaffCounts

************************************************************************/
CREATE PROCEDURE  [Staging].[Staging-to-FactK12StaffCounts] 
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @ChildCountDate DATE
		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT

		SELECT @SchoolYearId = DimSchoolYearId
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'Submission'

		DELETE RDS.FactK12StaffCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		INSERT INTO RDS.FactK12StaffCounts
			( SchoolYearId
			, FactTypeId
			, K12StaffId
			, K12StaffStatusId
			, K12SchoolId
			, StaffCount
			, StaffFTE
			, K12StaffCategoryId
			, TitleIIIStatusId
			, LeaId
			, SeaId
			)
		SELECT
			  rsy.DimSchoolYearId						SchoolYearId
			, @FactTypeId								FactTypeId
			, ISNULL(rdks.DimK12StaffId, -1)			K12StaffId
			, ISNULL(rdkss.DimK12StaffStatusId, -1)		K12StaffStatusId
			, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
			, 1											StaffCounts
			, FullTimeEquivalency						StaffFTE
			, ISNULL(rdksc.DimK12StaffCategoryId, -1)	K12StaffCategoryId
			, -1										TitleIIIStatusId
			, ISNULL(rdl.DimLeaID, -1)					LeaId
			, ISNULL(rds.DimSeaId, -1)					SeaId
		FROM Staging.K12StaffAssignment sksa
		JOIN RDS.DimSchoolYears rsy
			ON sksa.SchoolYear = rsy.SchoolYear
		LEFT JOIN RDS.DimLeas rdl
			ON sksa.LEA_Identifier_State = rdl.LeaIdentifierState
			AND @ChildCountDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimK12Schools rdksch
			ON sksa.School_Identifier_State = rdksch.SchoolIdentifierState
			AND @ChildCountDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimSeas rds
			ON @ChildCountDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.vwDimK12StaffCategories rdksc 
			ON rsy.SchoolYear = rdksc.SchoolYear
			AND ISNULL(sksa.K12StaffClassification, 'MISSING') = ISNULL(rdksc.K12StaffClassificationMap, rdksc.K12StaffClassificationCode)
			AND ISNULL(sksa.SpecialEducationStaffCategory, 'MISSING') = ISNULL(rdksc.SpecialEducationSupportServicesCategoryMap, rdksc.SpecialEducationSupportServicesCategoryCode)
			AND ISNULL(sksa.TitleIProgramStaffCategory, 'MISSING') = ISNULL(rdksc.TitleIProgramStaffCategoryMap, rdksc.TitleIProgramStaffCategoryCode)
		LEFT JOIN RDS.vwDimK12StaffStatuses rdkss
			ON rsy.SchoolYear = rdkss.SchoolYear
			AND ISNULL(sksa.SpecialEducationAgeGroupTaught, 'MISSING') = ISNULL(rdkss.SpecialEducationAgeGroupTaughtMap, rdkss.SpecialEducationAgeGroupTaughtCode)
			AND ISNULL(sksa.EmergencyorProvisionalCredentialStatus, 'MISSING') = ISNULL(rdkss.EmergencyOrProvisionalCredentialStatusMap, rdkss.EmergencyOrProvisionalCredentialStatusCode)
			AND ISNULL(sksa.OutOfFieldStatus, 'MISSING') = ISNULL(rdkss.OutOfFieldStatusMap, rdkss.OutOfFieldStatusCode)
			AND CASE 
					WHEN rdksc.K12StaffClassificationCode = 'Paraprofessionals' THEN sksa.ParaprofessionalQualification
					WHEN sksa.HighlyQualifiedTeacherIndicator = 1 THEN 'SPEDTCHFULCRT'
					WHEN sksa.HighlyQualifiedTeacherIndicator = 0 THEN 'SPEDTCHNFULCRT'
					ELSE 'MISSING'
				END = ISNULL(rdkss.QualificationStatusMap, rdkss.QualificationStatusCode)
			AND ISNULL(sksa.InexperiencedStatus, 'MISSING') = ISNULL(rdkss.UnexperiencedStatusMap, rdkss.UnexperiencedStatusCode)
			AND CASE 
				WHEN sksa.CredentialType in ('Certification', 'Licensure')
					AND sksa.CredentialIssuanceDate <= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					AND isnull(sksa.CredentialExpirationDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) >= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					THEN 'FC'
				ELSE 'NFC'
				END = rdkss.CertificationStatusEdFactsCode
		JOIN RDS.DimK12Staff rdks
			ON sksa.Personnel_Identifier_State = rdks.StaffMemberIdentifierState
			AND ISNULL(sksa.FirstName, 'MISSING') = ISNULL(rdks.FirstName, 'MISSING')
			AND ISNULL(sksa.MiddleName, 'MISSING') = ISNULL(rdks.MiddleName, 'MISSING')
			AND ISNULL(sksa.LastName, 'MISSING') = ISNULL(rdks.LastOrSurname, 'MISSING')
			AND @ChildCountDate BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, GETDATE())
			AND @ChildCountDate BETWEEN sksa.AssignmentStartDate AND ISNULL(sksa.AssignmentEndDate, GETDATE())
		ALTER INDEX ALL ON RDS.FactK12StaffCounts REBUILD

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StaffCounts', 'RDS.FactK12StaffCounts', 'FactK12StaffCounts', NULL, ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

		
END
