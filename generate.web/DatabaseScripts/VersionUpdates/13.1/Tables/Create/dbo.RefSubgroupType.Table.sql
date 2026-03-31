IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefSubgroupType' AND Type = N'U')
BEGIN
    CREATE TABLE [dbo].[RefSubgroupType](
	    [RefSubgroupTypeId] [int] IDENTITY(1,1) NOT NULL,
	    [Description] [nvarchar](100) NOT NULL,
	    [Code] [nvarchar](50) NULL,
	    [Definition] [nvarchar](4000) NULL,
	    [RefJurisdictionId] [int] NULL,
	    [SortOrder] [decimal](5, 2) NULL,
	CONSTRAINT [PK_RefSubgroupType] PRIMARY KEY CLUSTERED 
    (
	    [RefSubgroupTypeId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroupType_Organization]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroupType]'))
ALTER TABLE [dbo].[RefSubgroupType]  WITH CHECK ADD  CONSTRAINT [FK_RefSubgroupType_Organization] FOREIGN KEY([RefJurisdictionId])
REFERENCES [dbo].[Organization] ([OrganizationId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroupType_Organization]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroupType]'))
ALTER TABLE [dbo].[RefSubgroupType] CHECK CONSTRAINT [FK_RefSubgroupType_Organization]


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'RefSubgroupType', N'COLUMN',N'RefSubgroupTypeId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RefSubgroupType', @level2type=N'COLUMN',@level2name=N'RefSubgroupTypeId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'RefSubgroupType', N'COLUMN',N'Description'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List of subgroup types.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RefSubgroupType', @level2type=N'COLUMN',@level2name=N'Description'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'RefSubgroupType', N'COLUMN',N'Code'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code or abbreviation for the type.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RefSubgroupType', @level2type=N'COLUMN',@level2name=N'Code'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'RefSubgroupType', N'COLUMN',N'RefJurisdictionId'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate key from Organization identifying the publisher of the reference value.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RefSubgroupType', @level2type=N'COLUMN',@level2name=N'RefJurisdictionId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'RefSubgroupType', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List of subgroup types.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RefSubgroupType'



