--This will house the grades offered at the School level
CREATE TABLE Staging.OrganizationGradeOffered (
	 Id INT IDENTITY(1, 1) Primary Key
	,OrganizationIdentifier VARCHAR(100)
	,GradeOffered VARCHAR(100)
	,OrganizationId VARCHAR(100)
	,K12SchoolGradeOfferedId INT
	,RunDateTime DATETIME
	)

CREATE NONCLUSTERED INDEX IX_Staging_OrganizationGradesOffered_OrganizationId
    ON Staging.OrganizationGradeOffered (OrganizationId);   

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationGradeOffered', @level2type = N'Column', @level2name = 'OrganizationIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationGradeOffered', @level2type = N'Column', @level2name = 'GradeOffered' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefStateANSICode', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationGradeOffered', @level2type = N'Column', @level2name = 'GradeOffered' 
exec sp_addextendedproperty @name = N'TableFilter', @value = N'000100', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationGradeOffered', @level2type = N'Column', @level2name = 'GradeOffered' 
