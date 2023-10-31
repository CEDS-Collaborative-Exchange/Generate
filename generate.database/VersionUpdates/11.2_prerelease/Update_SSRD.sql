-- Add values for Exit Grade Level, used for Dropout C032 ---------------------------
if not exists (
select top 1 * from staging.SourceSystemReferenceData
where TableName = 'RefGradeLevel' and TableFilter = '001210' and SchoolYear = 2023)
begin
	insert into staging.SourceSystemReferenceData
	select SchoolYear, TableName, '001210', InputCode, OutputCode
	from staging.SourceSystemReferenceData
	where tablename = 'RefGradeLevel' and SchoolYear = 2023 and TableFilter = '000131'
end