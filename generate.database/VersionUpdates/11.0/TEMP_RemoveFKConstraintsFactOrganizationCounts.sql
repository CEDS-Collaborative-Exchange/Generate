-- Temporarily dropping these until we can work through this

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId
-- END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId
-- END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId
-- END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_CharterSchoolStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_CharterSchoolStatusId
END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId
END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_ComprehensiveAndTargetedSupportId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_ComprehensiveAndTargetedSupportId
END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_ReasonApplicabilityId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_ReasonApplicabilityId
END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_FactTypeId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_FactTypeId
-- END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_K12OrganizationStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_K12OrganizationStatusId
END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_K12SchoolId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_K12SchoolId
-- END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_K12SchoolStateStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_K12SchoolStateStatusId
END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_K12SchoolStatusId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_K12SchoolStatusId
-- END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_K12StaffId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_K12StaffId
END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_LeaId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_LeaId
-- END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_SchoolYearId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_SchoolYearId
-- END

-- IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_SeaId', 'F') IS NOT NULL)
-- BEGIN
--    ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_SeaId
-- END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_SubgroupId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_SubgroupId
END

IF (OBJECT_ID('RDS.FK_FactOrganizationCounts_TitleIStatusId', 'F') IS NOT NULL)
BEGIN
   ALTER TABLE RDS.FactOrganizationCounts DROP CONSTRAINT FK_FactOrganizationCounts_TitleIStatusId
END

