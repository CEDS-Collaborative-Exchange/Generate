



CREATE PROCEDURE [RDS].[Migrate_DimAges]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	select 
		s.DimStudentId,
		s.StudentPersonId as PersonId,
		d.DimCountDateId,
		case 
			when s.BirthDate is null then 'MISSING'
			when (CONVERT(int,CONVERT(char(8), d.SubmissionYearDate,112))-CONVERT(char(8), s.BirthDate,112))/10000  <= 0 then 'MISSING'
			else CONVERT(varchar(5), (CONVERT(int,CONVERT(char(8), d.SubmissionYearDate,112))-CONVERT(char(8), s.BirthDate,112))/10000)
		end as AgeCode
	from rds.DimStudents s
	inner join @studentDates d on s.DimStudentId = d.DimStudentId
END

