CREATE VIEW [RDS].[vwK12Staff_FactTable_C112] 
AS
SELECT f.K12StaffStaffMemberIdentifierState
      ,f.LeaIdentifierSea
      ,f.LeaIdentifierNces
      ,f.LeaOrganizationName
      ,f.SchoolIdentifierSea
      ,f.NameOfInstitution
      ,f.SpecialEducationAgeGroupTaughtEdFactsCode
      ,f.EdFactsCertificationStatusEdFactsCode
      ,ParaprofessionalQualificationStatusEdFactsCode
      ,f.StaffCount
      ,f.StaffFullTimeEquivalency
  FROM debug.vwK12Staff_FactTable f
  WHERE f.StaffFullTimeEquivalency > 0
  AND ISNULL(f.SpecialEducationAgeGroupTaughtEdFactsCode, '') <> ''
  AND ISNULL(f.ParaprofessionalQualificationStatusEdFactsCode, '') <> ''
GO


