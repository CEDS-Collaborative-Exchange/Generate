CREATE PROCEDURE [dbo].[Get_Organizations]
	   @organizationType as varchar(50)
AS
BEGIN

		if(@organizationType = '001073')
		BEGIN

			select distinct o.OrganizationId, o.Name, o.RefOrganizationTypeId, o.ShortName,
			isnull(relation.Parent_OrganizationId, -1) as ParentOrganizationId, i.Identifier as OrganizationStateIdentifier
			from dbo.OrganizationDetail o 								
			inner join dbo.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
			inner join dbo.RefOrganizationIdentificationSystem s on i.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
			inner join dbo.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId
			inner join dbo.RefOrganizationIdentifierType idType on idType.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
			inner join dbo.OrganizationRelationship relation on relation.OrganizationId = o.OrganizationId
			inner join dbo.Organization parents on parents.OrganizationId = relation.Parent_OrganizationId
			inner join dbo.OrganizationDetail od on od.OrganizationId = parents.OrganizationId
			inner join dbo.OrganizationIdentifier iparent on od.OrganizationId = iparent.OrganizationId
			inner join dbo.RefOrganizationIdentificationSystem sparent on iparent.RefOrganizationIdentificationSystemId = sparent.RefOrganizationIdentificationSystemId
			inner join dbo.RefOrganizationType tparent on od.RefOrganizationTypeId = tparent.RefOrganizationTypeId
			inner join dbo.RefOrganizationIdentifierType idTypeParent on idTypeParent.RefOrganizationIdentifierTypeId = sparent.RefOrganizationIdentifierTypeId
			where s.Code = 'SEA' and idType.Code = @organizationType and idTypeParent.Code = '001072'

		END
		ELSE
		BEGIN

			select distinct o.OrganizationId, o.Name, o.RefOrganizationTypeId, o.ShortName,
			isnull(relation.Parent_OrganizationId, -1) as ParentOrganizationId, i.Identifier as OrganizationStateIdentifier
			from dbo.OrganizationDetail o 								
			inner join dbo.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
			inner join dbo.RefOrganizationIdentificationSystem s on i.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
			inner join dbo.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId
			inner join dbo.RefOrganizationIdentifierType idType on idType.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
			inner join dbo.OrganizationRelationship relation on relation.OrganizationId = o.OrganizationId
			where s.Code = 'SEA' and idType.Code = @organizationType	

		END

END