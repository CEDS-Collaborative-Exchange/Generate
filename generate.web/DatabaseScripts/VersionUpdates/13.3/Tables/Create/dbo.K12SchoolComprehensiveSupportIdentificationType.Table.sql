IF NOT EXISTS (SELECT 1 FROM sys.tables t INNER JOIN sys.schemas s on t.schema_id = s.schema_id WHERE s.name = N'dbo' AND t.Name = N'K12SchoolComprehensiveSupportIdentificationType' AND Type = N'U')
BEGIN
    CREATE TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType](
	    [K12SchoolComprehensiveSupportIdentificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	    [K12SchoolId] [int] NOT NULL,
	    [RefComprehensiveSupportId] [int] NOT NULL,
	    [RefSubgroupsId] [int] NOT NULL,
	    [RefComprehensiveSupportReasonApplicabilityId] [int] NOT NULL,
	    [RecordStartDateTime] [datetime] NULL,
	    [RecordEndDateTime] [datetime] NULL,
	CONSTRAINT [PK_K12SchoolComprehensiveSupportIdentificationType] PRIMARY KEY CLUSTERED 
    (
	    [K12SchoolComprehensiveSupportIdentificationTypeId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
       

    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_K12School]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_K12School] FOREIGN KEY([K12SchoolId])
    REFERENCES [dbo].[K12School] ([K12SchoolId])
    

    IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_K12School]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_K12School]
    

    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupport]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupport] FOREIGN KEY([RefComprehensiveSupportId])
    REFERENCES [dbo].[RefComprehensiveSupport] ([RefComprehensiveSupportId])
    

    IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupport]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupport]
    

    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupportReasonApplicability]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupportReasonApplicability] FOREIGN KEY([RefComprehensiveSupportReasonApplicabilityId])
    REFERENCES [dbo].[RefComprehensiveSupportReasonApplicability] ([RefComprehensiveSupportReasonApplicabilityId])
    

    IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupportReasonApplicability]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefComprehensiveSupportReasonApplicability]
    

    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefSubgroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefSubgroups] FOREIGN KEY([RefSubgroupsId])
    REFERENCES [dbo].[RefSubgroup] ([RefSubgroupId])
    

    IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_RefSubgroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12SchoolComprehensiveSupportIdentificationType]'))
    ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType] CHECK CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_RefSubgroups]
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'K12SchoolComprehensiveSupportIdentificationTypeId'))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'K12SchoolComprehensiveSupportIdentificationTypeId'
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'K12SchoolId'))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key - K12 School' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'K12SchoolId'
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RefComprehensiveSupportId'))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reasons for identification as a comprehensive support or improvement schools.  (Foreign key - RefComprehensiveSupport)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RefComprehensiveSupportId'
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RefSubgroupId'))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reasons for identification as a targeted support or improvement school or additional targeted support or improvement school.  (Foreign key - RefSubgroup)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RefSubgroupsId'
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RefComprehensiveSupportReasonApplicabilityId'))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication of whether a reason applies.  (Foreign key - RefComprehensiveSupportReasonApplicability)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RefComprehensiveSupportReasonApplicabilityId'
    

    IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', NULL,NULL))
	    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reasons for identification for comprehensive support and improvement (CSI) or for targeted support and improvement (TSI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType'
    

END