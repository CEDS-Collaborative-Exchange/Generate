declare @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT

--Add FS222 to metadata table
if not exists (select 1 from app.GenerateReport_FactType where GenerateReportId = 136)
begin
	insert into app.GenerateReport_FactType
	values (136, 12)
end


--Set the dimension for Disability Status for 037
select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'IdeaIndicator'

update app.FileColumns
set DimensionId = @dimensionId
where ColumnName = 'DisabilityStatusID'
and DisplayName = 'Disability Status (Only)'


--Activate FS210 in the report list
update app.generatereports
set isactive = 1
where reportcode = 'c210'

--Remove the Report Code from the Report Title
update app.generatereports 
set ReportName = substring(reportname, 7, len(reportname))
where substring(reportname, 1, 5) like 'c%:'

Update app.GenerateReports set FactTableId = 1 where ReportCode = 'c222'

--Add the new OrganizationTitleI dimension to the metadata
if (select count(*)
	from app.DimensionTables 
	where DimensionTableName = 'DimOrganizationTitleIStatuses'
	) = 0
begin
	insert into app.DimensionTables
	values('DimOrganizationTitleIStatuses',1)
end

--Change the DimensionFieldName associated with DimTitleIStatuses
update d	
set DimensionFieldName = 'TitleIIndicator'
from app.categories c
	inner join app.Category_Dimensions cd
		on c.CategoryId = cd.CategoryId
	inner join app.Dimensions d
		on cd.DimensionId = d.DimensionId
where c.CategoryCode = 'TITLEIPROG'

--roll back the 2025 metadata for 2024 for FS134
if (select count(*)
	from app.filesubmissions fs
	left join app.filesubmission_filecolumns fsfc 
		on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc 
		on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (53) 
	and submissionyear in (2024) 
) = 0
begin 
	exec app.Rollover_Previous_Year_Metadata 'c134', '2025', '2024'
end

--roll back the 2025 metadata for 2024 for FS037
if (select count(*)
	from app.filesubmissions fs
	left join app.filesubmission_filecolumns fsfc 
		on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc 
		on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (43) 
	and submissionyear in (2024) 
) = 0
begin 
	exec app.Rollover_Previous_Year_Metadata 'c037', '2025', '2024'
end


--Update Rds.DimFactTypes to include missing files/correctly identify with the correct FactType
update rds.DimFactTypes
set FactTypeDescription = 'ASSESSMENT - 050,113,125,126,137,138,139,175,178,179,185,188,189,210,211,224,225'
where FactTypeCode = 'assessment'

update rds.DimFactTypes
set FactTypeDescription = 'ORGANIZATIONSTATUS - 199,200,201,202'
where FactTypeCode = 'organizationstatus'

update rds.DimFactTypes
set FactTypeDescription = 'TITLEI - 037,134,222'
where FactTypeCode = 'titleI'

update rds.DimFactTypes
set FactTypeDescription = 'MIGRANTEDUCATIONPROGRAM - 054,121,145,165'
where FactTypeCode = 'migranteducationprogram'

update rds.DimFactTypes
set FactTypeDescription = 'IMMIGRANT - '
where FactTypeCode = 'immigrant'


--fs 137 metadata

select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimAssessments'

IF NOT EXISTS(SELECT 1 from app.Dimensions where DimensionFieldName = 'AssessmentTypeAdministeredToEnglishLearners')
BEGIN
	INSERT INTO [App].[Dimensions]
			   ([DimensionFieldName]
			   ,[DimensionTableId]
			   ,[IsCalculated]
			   ,[IsOrganizationLevelSpecific])
	VALUES('AssessmentTypeAdministeredToEnglishLearners',@dimensionTableId,0,0)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'AssessmentTypeAdministeredToEnglishLearners'
SELECT TOP 1 @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'ASMTADMNSTRDELP' order by CategoryId desc

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


SELECT TOP 1 @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'FIRSTASSESS' order by CategoryId desc
select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AssessedFirstTime'

delete from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId

