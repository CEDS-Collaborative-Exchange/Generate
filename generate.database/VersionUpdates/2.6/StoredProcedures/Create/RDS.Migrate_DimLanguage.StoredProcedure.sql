



CREATE PROCEDURE [RDS].[Migrate_DimLanguage]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
       
declare @languageUseTypeId as int 
       select @languageUseTypeId = RefLanguageUseTypeId from ods.RefLanguageUseType where Code ='Native'
             
       select 
             s.DimStudentId,
             sch.K12SchoolId,
             s.StudentPersonId as PersonId,
             d.DimCountDateId,
             l.Code as 'LanguageCode'          
       from rds.DimStudents s 
       inner join @studentDates d on s.DimStudentId = d.DimStudentId
       inner join ods.OrganizationPersonRole r on r.PersonId = s.StudentPersonId
       inner join ods.Organization o on o.OrganizationId = r.OrganizationId
       inner join ods.K12School sch on o.OrganizationId = sch.OrganizationId
       inner join ods.PersonLanguage pl on pl.PersonId = r.PersonId and pl.RefLanguageUseTypeId =@languageUseTypeId
       inner join ods.RefLanguage l on l.RefLanguageId = pl.RefLanguageId
       where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
END


