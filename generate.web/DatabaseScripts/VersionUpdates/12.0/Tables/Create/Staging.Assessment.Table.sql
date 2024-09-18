CREATE TABLE Staging.Assessment (
	 ID INT IDENTITY(1, 1) Primary Key
	,AssessmentTitle VARCHAR(100)
	,AssessmentShortName VARCHAR(100)
	,AssessmentAcademicSubject VARCHAR(100)
	,AssessmentPurpose VARCHAR(100)
	,AssessmentType VARCHAR(100)
	,AssessmentTypeAdministeredToChildrenWithDisabilities VARCHAR(100)
	,AssessmentFamilyTitle VARCHAR(100)
	,AssessmentFamilyShortName VARCHAR(100)
	,AssessmentAdministrationStartDate DATE
	,AssessmentAdministrationFinishDate DATE
	,AssessmentPerformanceLevelIdentifier VARCHAR(100)
	,AssessmentPerformanceLevelLabel VARCHAR(100)
	,AssessmentId INT
	,AssessmentAdministrationId INT
	,AssessmentSubtestId INT
	,AssessmentFormId INT
	,AssessmentPerformanceLevelId INT
	,RunDateTime DATETIME
	);

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentTitle'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentShortName'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentAcademicSubject'
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefAcademicSubject', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentAcademicSubject'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentPurpose'
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefAssessmentPurpose', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentPurpose'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentType'
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefAssessmentType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentType'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentTypeAdministeredToChildrenWithDisabilities'
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefAssessmentTypeChildrenWithDisabilities', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentTypeAdministeredToChildrenWithDisabilities'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentFamilyTitle'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentFamilyShortName'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentAdministrationStartDate'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentAdministrationFinishDate'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentPerformanceLevelIdentifier'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Assessment', @level2type = N'Column', @level2name = 'AssessmentPerformanceLevelLabel'

 
