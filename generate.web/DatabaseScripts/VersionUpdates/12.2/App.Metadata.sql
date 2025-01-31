declare @dimensionId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EdFactsCertificationStatus'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'CertificationStatusID'

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'ParaprofessionalQualificationStatus'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'QualificationID'


if not exists (select * from app.generatereport_organizationlevels where GenerateReportId = 136 and OrganizationLevelId = 1)
begin 
	insert into app.generatereport_organizationlevels values (136,1)
end

if not exists (select * from app.generatereport_organizationlevels where GenerateReportId = 136 and OrganizationLevelId = 2)
begin 
	Print 'here'
	insert into app.generatereport_organizationlevels values (136,2)
end

Update app.GenerateReports set FactTableId = 1 where ReportCode = 'c222'