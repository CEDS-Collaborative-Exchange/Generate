declare @dimensionId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EdFactsCertificationStatus'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'CertificationStatusID'

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'ParaprofessionalQualificationStatus'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'QualificationID'