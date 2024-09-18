CREATE PROCEDURE [ODS].[Get_Organizations]
	   @organizationType as varchar(50)
AS
BEGIN

		select o.OrganizationId, o.Name, o.RefOrganizationTypeId, o.ShortName,
		isnull(relation.Parent_OrganizationId, -1) as ParentOrganizationId, i.Identifier as OrganizationStateIdentifier
		from ods.OrganizationDetail o 								
		inner join ods.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
		inner join ods.RefOrganizationIdentificationSystem s on i.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
		inner join ods.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId
		inner join ods.RefOrganizationIdentifierType idType on idType.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
		left outer join ods.OrganizationRelationship relation on relation.OrganizationId = o.OrganizationId
		where s.Code = 'SEA' and idType.Code = @organizationType	

END