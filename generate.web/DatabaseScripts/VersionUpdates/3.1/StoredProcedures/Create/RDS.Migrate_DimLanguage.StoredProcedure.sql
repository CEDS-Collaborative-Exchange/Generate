CREATE PROCEDURE [RDS].[Migrate_DimLanguage]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
       
	   declare @languageUseTypeId as int 
       select @languageUseTypeId = RefLanguageUseTypeId from ods.RefLanguageUseType where Code ='Native'
             
       select distinct
             d.DimStudentId,
             d.PersonId,
             d.DimCountDateId,
             l.Code as 'LanguageCode'          
       from @studentDates d
       inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId
       inner join ods.PersonLanguage pl on pl.PersonId = r.PersonId and pl.RefLanguageUseTypeId =@languageUseTypeId
       inner join ods.RefLanguage l on l.RefLanguageId = pl.RefLanguageId
       where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
END


