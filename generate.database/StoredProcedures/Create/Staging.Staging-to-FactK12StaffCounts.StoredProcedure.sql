/**********************************************************************
Author: AEM Corp
Date:	3/1/2022
Description: Migrates Staff Data from Staging to RDS.FactK12StaffCounts

NOTE: This Stored Procedure processes files: 059, 065, 067, 070, 099, 112, 203
************************************************************************/
CREATE PROCEDURE  [Staging].[Staging-to-FactK12StaffCounts] 
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
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

		INSERT INTO RDS.FactK12StaffCounts ( 
			SchoolYearId
			, FactTypeId
			, SeaId
			, LeaId
			, K12SchoolId
			, K12StaffId
			, K12StaffStatusId
			, K12StaffCategoryId
			, TitleIIIStatusId
			, StaffCount
			, StaffFullTimeEquivalency
		)
		SELECT
			rsy.DimSchoolYearId							SchoolYearId
			, @FactTypeId								FactTypeId
			, ISNULL(rds.DimSeaId, -1)					SeaId
			, ISNULL(rdl.DimLeaID, -1)					LeaId
			, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
			, ISNULL(rdks.DimK12StaffId, -1)			K12StaffId
			, ISNULL(rdkss.DimK12StaffStatusId, -1)		K12StaffStatusId
			, ISNULL(rdksc.DimK12StaffCategoryId, -1)	K12StaffCategoryId
			, -1										TitleIIIStatusId
			, 1											StaffCounts
			, FullTimeEquivalency						StaffFullTimeEquivalency
		FROM Staging.StaffAssignment ssa
		JOIN RDS.DimSchoolYears rsy
			ON ssa.SchoolYear = rsy.SchoolYear
		LEFT JOIN RDS.DimLeas rdl
			ON ssa.LeaIdentifierSea = rdl.LeaIdentifierSea
			AND @ChildCountDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ssa.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND @ChildCountDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimSeas rds
			ON @ChildCountDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.vwDimK12StaffCategories rdksc 
			ON rsy.SchoolYear = rdksc.SchoolYear
			AND ISNULL(ssa.K12StaffClassification, 'MISSING') = ISNULL(rdksc.K12StaffClassificationMap, rdksc.K12StaffClassificationCode)
			AND ISNULL(ssa.SpecialEducationStaffCategory, 'MISSING') = ISNULL(rdksc.SpecialEducationSupportServicesCategoryMap, rdksc.SpecialEducationSupportServicesCategoryCode)
			AND ISNULL(ssa.TitleIProgramStaffCategory, 'MISSING') = ISNULL(rdksc.TitleIProgramStaffCategoryMap, rdksc.TitleIProgramStaffCategoryCode)
		LEFT JOIN RDS.vwDimK12StaffStatuses rdkss
			ON rsy.SchoolYear = rdkss.SchoolYear
			AND ISNULL(ssa.SpecialEducationAgeGroupTaught, 'MISSING') = ISNULL(rdkss.SpecialEducationAgeGroupTaughtMap, rdkss.SpecialEducationAgeGroupTaughtCode)
--			AND ISNULL(ssa.EmergencyorProvisionalCredentialStatus, 'MISSING') = ISNULL(rdkss.EmergencyOrProvisionalCredentialStatusMap, rdkss.EmergencyOrProvisionalCredentialStatusCode)
			AND ISNULL(ssa.EDFactsTeacherOutOfFieldStatus, 'MISSING') = ISNULL(rdkss.EDFactsTeacherOutOfFieldStatusMap, rdkss.EDFactsTeacherOutOfFieldStatusCode)
			AND CASE 
					WHEN rdksc.K12StaffClassificationCode = 'Paraprofessionals' THEN ssa.ParaprofessionalQualification
					WHEN ssa.HighlyQualifiedTeacherIndicator = 1 THEN 'SPEDTCHFULCRT'
					WHEN ssa.HighlyQualifiedTeacherIndicator = 0 THEN 'SPEDTCHNFULCRT'
					ELSE 'MISSING'
				END = ISNULL(rdkss.QualificationStatusMap, rdkss.QualificationStatusCode)
			AND ISNULL(ssa.EdFactsTeacherInexperiencedStatus, 'MISSING') = ISNULL(rdkss.EdFactsTeacherInexperiencedStatusMap, rdkss.EdFactsTeacherInexperiencedStatusCode)
			AND CASE 
				WHEN ssa.TeachingCredentialType in ('Certification', 'Licensure')
					AND ssa.CredentialIssuanceDate <= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					AND isnull(ssa.CredentialExpirationDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) >= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					THEN 'FC'
				ELSE 'NFC'
				END = rdkss.EdFactsCertificationStatusEdFactsCode
		JOIN RDS.DimPeople rdp
			ON ssa.StaffMemberIdentifierState = rdp.K12StaffStaffMemberIdentifierState
			AND rdp.IsActiveK12StaffMember = 1
			AND ISNULL(ssa.FirstName, 'MISSING') = ISNULL(rdp.FirstName, 'MISSING')
			AND ISNULL(ssa.MiddleName, 'MISSING') = ISNULL(rdp.MiddleName, 'MISSING')
			AND ISNULL(ssa.LastOrSurname, 'MISSING') = ISNULL(rdp.LastOrSurname, 'MISSING')
			AND @ChildCountDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())
			AND @ChildCountDate BETWEEN ssa.AssignmentStartDate AND ISNULL(ssa.AssignmentEndDate, GETDATE())
		ALTER INDEX ALL ON RDS.FactK12StaffCounts REBUILD

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StaffCounts', 'RDS.FactK12StaffCounts', 'FactK12StaffCounts', NULL, ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH
		
END
