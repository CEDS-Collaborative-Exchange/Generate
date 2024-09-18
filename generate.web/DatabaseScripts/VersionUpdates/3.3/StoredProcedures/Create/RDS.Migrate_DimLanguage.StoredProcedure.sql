CREATE PROCEDURE [RDS].[Migrate_DimLanguage]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
       
	   declare @languageUseTypeId as int 
       select @languageUseTypeId = RefLanguageUseTypeId from ods.RefLanguageUseType where Code ='Native'
             
   	   declare @organizationElementTypeId as int
	   select @organizationElementTypeId = RefOrganizationElementTypeId
	   from ods.RefOrganizationElementType 
	   where [Code] = '001156'

	   declare @leaOrgTypeId as int
	   select @leaOrgTypeId = RefOrganizationTypeId
	   from ods.RefOrganizationType 
	   where ([Code] = 'LEA') and RefOrganizationElementTypeId = @organizationElementTypeId

	   declare @schoolOrgTypeId as int
	   select @schoolOrgTypeId = RefOrganizationTypeId
	   from ods.RefOrganizationType 
	   where ([Code] = 'K12School') and RefOrganizationElementTypeId = @organizationElementTypeId

       select distinct
             d.DimStudentId,
             d.PersonId,
             d.DimCountDateId,
             l.Code as 'LanguageCode'          
	 from @studentDates d
	   inner join ods.PersonIdentifier pi on d.PersonId = pi.PersonId
       inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId
	   inner join ods.OrganizationDetail od on r.OrganizationId = od.OrganizationId and od.RefOrganizationTypeId in (@leaOrgTypeId, @schoolOrgTypeId)
       inner join ods.PersonLanguage pl on pl.PersonId = r.PersonId and pl.RefLanguageUseTypeId = @languageUseTypeId
       inner join ods.RefLanguage l on l.RefLanguageId = pl.RefLanguageId
     where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
END


