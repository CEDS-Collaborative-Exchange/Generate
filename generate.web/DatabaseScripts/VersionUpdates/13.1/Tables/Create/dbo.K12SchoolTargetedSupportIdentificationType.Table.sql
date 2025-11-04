IF NOT EXISTS (SELECT 1 FROM sys.tables t INNER JOIN sys.schemas s on t.schema_id = s.schema_id WHERE s.name = N'dbo' AND t.Name = N'K12SchoolComprehensiveSupportIdentificationType' AND Type = N'U')IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'K12SchoolTargetedSupportIdentificationType' AND Type = N'U')
BEGIN
CREATE TABLE [dbo].[K12SchoolTargetedSupportIdentificationType](
	[K12SchoolTargetedSupportIdentificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[K12SchoolId] [int] NOT NULL,
	[RefTargetedSupportId] [int] NOT NULL,
	[RefSubgroupId] [int] NOT NULL,
	[RefComprehensiveSupportReasonApplicabilityId] [int] NOT NULL,
	[RecordStartDateTime] datetime NULL,
	[RecordEndDateTime] datetime NULL,
 CONSTRAINT [PK_K12SchoolTargetedSupportIdentificationType] PRIMARY KEY CLUSTERED 
(
	[K12SchoolTargetedSupportIdentificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_K12School]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_K12School] FOREIGN KEY([K12SchoolId])
REFERENCES dbo.[K12School] ([K12SchoolId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_K12School]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_K12School]


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_RefSubgroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_RefSubgroup] FOREIGN KEY([RefSubgroupId])
REFERENCES [dbo].[RefSubgroup] ([RefSubgroupId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_RefSubgroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_RefSubgroup]


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_RefComprehensiveSupportReasonApplicability]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_RefComprehensiveSupportReasonApplicability] FOREIGN KEY([RefComprehensiveSupportReasonApplicabilityId])
REFERENCES [dbo].[RefComprehensiveSupportReasonApplicability] ([RefComprehensiveSupportReasonApplicabilityId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolTargetedSupportIdentificationType_RefComprehensiveSupportReasonApplicability]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolTargetedSupportIdentificationType]'))
ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_RefComprehensiveSupportReasonApplicability]



IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'K12SchoolTargetedSupportIdentificationTypeId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'K12SchoolTargetedSupportIdentificationTypeId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'K12SchoolId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key - K12 School' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'K12SchoolId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'RefSubgroupId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reasons for identification as a targeted support or improvement school or additional targeted support or improvement school.  (Foreign key - RefSubgroup)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RefSubgroupId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'RefComprehensiveSupportReasonApplicabilityId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication of whether a reason applies.  (Foreign key - RefComprehensiveSupportReasonApplicabilityId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RefComprehensiveSupportReasonApplicabilityId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reasons for identification for targeted support and improvement (TSI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType'



