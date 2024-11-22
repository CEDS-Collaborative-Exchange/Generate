CREATE VIEW [RDS].[vwK12Staff_FactTable_C099] 
AS
SELECT f.K12StaffStaffMemberIdentifierState
      ,f.LeaIdentifierSea
      ,f.LeaIdentifierNces
      ,f.LeaOrganizationName
      ,f.SchoolIdentifierSea
      ,f.NameOfInstitution
      ,f.SpecialEducationAgeGroupTaughtEdFactsCode
      ,f.EdFactsCertificationStatusEdFactsCode
      ,f.SpecialEducationTeacherQualificationStatusEdFactsCode
      ,f.SpecialEducationSupportServicesCategoryEdFactsCode
      ,f.StaffCount
      ,f.StaffFullTimeEquivalency
  FROM debug.vwK12Staff_FactTable f
  WHERE f.StaffFullTimeEquivalency > 0
  AND ISNULL(f.EdFactsCertificationStatusEdFactsCode, '') <> ''
  AND ISNULL(f.SpecialEducationTeacherQualificationStatusEdFactsCode, '') <> ''
  AND ISNULL(f.SpecialEducationSupportServicesCategoryEdFactsCode, '') <> ''
GO


