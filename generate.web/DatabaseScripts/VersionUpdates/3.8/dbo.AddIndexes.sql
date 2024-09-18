PRINT N'Adding indexes for Generate migrations';

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType]
	ON [dbo].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId],[RefOrganizationIdentifierTypeId])
	INCLUDE ([Identifier],[OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_Identifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_Identifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType]
	ON [dbo].[OrganizationIdentifier] ([Identifier],[RefOrganizationIdentificationSystemId],[RefOrganizationIdentifierTypeId])
	INCLUDE ([OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationDetail' and i.name = 'IX_OrganizationDetail_RefOrganizationType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationDetail_RefOrganizationType]
	ON [dbo].[OrganizationDetail] ([RefOrganizationTypeId])
	INCLUDE ([OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationDetail' and i.name = 'ID_OrganizationDetail_OrganizationId_RefOrganizationTypeId') BEGIN
	CREATE NONCLUSTERED INDEX [ID_OrganizationDetail_OrganizationId_RefOrganizationTypeId]
	ON [dbo].[OrganizationDetail] ([OrganizationId],[RefOrganizationTypeId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'PersonIdentifier' and i.name = 'IX_PersonIdentifier_Identifier_RefPersonIdentificationSystemId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_PersonIdentifier_Identifier_RefPersonIdentificationSystemId]
	ON [dbo].[PersonIdentifier] ([Identifier],[RefPersonIdentificationSystemId])
	INCLUDE ([PersonId],[DataCollectionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_OrganizationId_Identifier') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_OrganizationId_Identifier]
	ON [dbo].[OrganizationIdentifier] ([OrganizationId])
	INCLUDE ([Identifier])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_RefOrganizationIdentificationSystemId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_RefOrganizationIdentificationSystemId]
	ON [dbo].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId])
	INCLUDE ([Identifier],[OrganizationId],[DataCollectionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationPersonRoleRelationship' and i.name = 'IX_OrganizationPersonRoleRelationship_OrganizationPersonRoleId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRoleRelationship_OrganizationPersonRoleId]
	ON [dbo].[OrganizationPersonRoleRelationship] ([OrganizationPersonRoleId])
	INCLUDE ([OrganizationPersonRoleId_Parent])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationPersonRoleRelationship' and i.name = 'IX_OrganizationPersonRoleRelationship_OrganizationPersonRoleId_Parent') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRoleRelationship_OrganizationPersonRoleId_Parent]
	ON [dbo].[OrganizationPersonRoleRelationship] ([OrganizationPersonRoleId_Parent])
	INCLUDE ([OrganizationPersonRoleId])
END 

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationPersonRoleRelationship' and i.name = 'IX_OrganizationPersonRoleRelationship_RecordEndDateTime') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationPersonRoleRelationship_RecordEndDateTime]
	ON [dbo].[OrganizationPersonRoleRelationship] ([RecordEndDateTime])
	INCLUDE ([OrganizationPersonRoleId],[OrganizationPersonRoleId_Parent],[RecordStartDateTime])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationRelationship' and i.name = 'IX_OrganizationRelationship_OrganizationId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationRelationship_OrganizationId]
	ON [dbo].[OrganizationRelationship] ([OrganizationId])
	INCLUDE ([Parent_OrganizationId])
END
PRINT N'Adding indexes for Generate migrations';

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType]
	ON [dbo].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId],[RefOrganizationIdentifierTypeId])
	INCLUDE ([Identifier],[OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_Identifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_Identifier_RefOrganizationIdentifiationSystemId_RefOrganizationIdentifierType]
	ON [dbo].[OrganizationIdentifier] ([Identifier],[RefOrganizationIdentificationSystemId],[RefOrganizationIdentifierTypeId])
	INCLUDE ([OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationDetail' and i.name = 'IX_OrganizationDetail_RefOrganizationType') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationDetail_RefOrganizationType]
	ON [dbo].[OrganizationDetail] ([RefOrganizationTypeId])
	INCLUDE ([OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationDetail' and i.name = 'ID_OrganizationDetail_OrganizationId_RefOrganizationTypeId') BEGIN
	CREATE NONCLUSTERED INDEX [ID_OrganizationDetail_OrganizationId_RefOrganizationTypeId]
	ON [dbo].[OrganizationDetail] ([OrganizationId],[RefOrganizationTypeId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_OrganizationId_Identifier') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_OrganizationId_Identifier]
	ON [dbo].[OrganizationIdentifier] ([OrganizationId])
	INCLUDE ([Identifier])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationIdentifier' and i.name = 'IX_OrganizationIdentifier_RefOrganizationIdentificationSystemId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationIdentifier_RefOrganizationIdentificationSystemId]
	ON [dbo].[OrganizationIdentifier] ([RefOrganizationIdentificationSystemId])
	INCLUDE ([Identifier],[OrganizationId],[DataCollectionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationRelationship' and i.name = 'IX_OrganizationRelationship_OrganizationId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationRelationship_OrganizationId]
	ON [dbo].[OrganizationRelationship] ([OrganizationId])
	INCLUDE ([Parent_OrganizationId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'PersonIdentifier' and i.name = 'IX_PersonIdentifier_PersonId_Identifier') BEGIN
	CREATE NONCLUSTERED INDEX [IX_PersonIdentifier_PersonId_Identifier]
	ON [dbo].[PersonIdentifier] ([PersonId],[Identifier])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'PersonDemographicRace' and i.name = 'IX_PersonDemographicRace_PersonId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_PersonDemographicRace_PersonId]
	ON [dbo].[PersonDemographicRace] ([PersonId])
	INCLUDE ([RefRaceId],[RecordStartDateTime],[RecordEndDateTime])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationProgramType' and i.name = 'IX_OrganizationProgramType_RefProgramTypeId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_RefProgramTypeId]
	ON [dbo].[OrganizationProgramType] ([RefProgramTypeId])
	INCLUDE ([OrganizationId],[RecordStartDateTime],[RecordEndDateTime])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'OrganizationProgramType' and i.name = 'IX_OrganizationProgramType_OrganizationId_RefProgramTypeId_StartEndDates') BEGIN
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_OrganizationId_RefProgramTypeId_StartEndDates]
	ON [dbo].[OrganizationProgramType] ([OrganizationId],[RefProgramTypeId],[RecordStartDateTime],[RecordEndDateTime])
END

IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'PersonProgramParticipation' and i.name = 'IX_PersonProgramParticipation_RefParticipationTypeId') BEGIN
	CREATE NONCLUSTERED INDEX [IX_PersonProgramParticipation_RefParticipationTypeId]
	ON [dbo].[PersonProgramParticipation] ([RefParticipationTypeId])
	INCLUDE ([OrganizationPersonRoleId])
END