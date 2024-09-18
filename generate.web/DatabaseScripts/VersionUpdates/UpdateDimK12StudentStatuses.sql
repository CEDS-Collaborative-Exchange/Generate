--Need to update the HighSchoolDiplomaTypeCode to the CEDS value
update [generate].[RDS].[DimK12StudentStatuses]
set HighSchoolDiplomaTypeCode = '00806'
where HighSchoolDiplomaTypeEdFactsCode = 'REGDIP'

update [generate].[RDS].[DimK12StudentStatuses]
set HighSchoolDiplomaTypeCode = '00811'
where HighSchoolDiplomaTypeEdFactsCode = 'OTHCOM'

update [generate].[RDS].[DimK12StudentStatuses]
set HighSchoolDiplomaTypeCode = '00816'
where HighSchoolDiplomaTypeEdFactsCode = 'HSDGED'