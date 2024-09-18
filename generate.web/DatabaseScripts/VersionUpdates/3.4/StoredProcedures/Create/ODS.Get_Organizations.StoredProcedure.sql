CREATE PROCEDURE [ODS].[Get_Organizations]
	   @organizationType as varchar(50)
AS
BEGIN

		if(@organizationType = '001073')
		BEGIN

			select distinct o.OrganizationId, o.Name, o.RefOrganizationTypeId, o.ShortName,
			isnull(relation.Parent_OrganizationId, -1) as ParentOrganizationId, i.Identifier as OrganizationStateIdentifier
			from ods.OrganizationDetail o 								
			inner join ods.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem s on i.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
			inner join ods.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId
			inner join ods.RefOrganizationIdentifierType idType on idType.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
			inner join ods.OrganizationRelationship relation on relation.OrganizationId = o.OrganizationId
			inner join ods.Organization parents on parents.OrganizationId = relation.Parent_OrganizationId
			inner join ods.OrganizationDetail od on od.OrganizationId = parents.OrganizationId
			inner join ods.OrganizationIdentifier iparent on od.OrganizationId = iparent.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem sparent on iparent.RefOrganizationIdentificationSystemId = sparent.RefOrganizationIdentificationSystemId
			inner join ods.RefOrganizationType tparent on od.RefOrganizationTypeId = tparent.RefOrganizationTypeId
			inner join ods.RefOrganizationIdentifierType idTypeParent on idTypeParent.RefOrganizationIdentifierTypeId = sparent.RefOrganizationIdentifierTypeId
			where s.Code = 'SEA' and idType.Code = @organizationType and idTypeParent.Code = '001072'

		END
		ELSE
		BEGIN

			select distinct o.OrganizationId, o.Name, o.RefOrganizationTypeId, o.ShortName,
			isnull(relation.Parent_OrganizationId, -1) as ParentOrganizationId, i.Identifier as OrganizationStateIdentifier
			from ods.OrganizationDetail o 								
			inner join ods.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem s on i.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
			inner join ods.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId
			inner join ods.RefOrganizationIdentifierType idType on idType.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
			inner join ods.OrganizationRelationship relation on relation.OrganizationId = o.OrganizationId
			where s.Code = 'SEA' and idType.Code = @organizationType	

		END

END