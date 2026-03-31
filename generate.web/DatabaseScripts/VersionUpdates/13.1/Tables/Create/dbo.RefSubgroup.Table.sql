IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefSubgroup' AND Type = N'U')
BEGIN
CREATE TABLE [dbo].[RefSubgroup](
	[RefSubgroupId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[Code] [nvarchar](50) NULL,
	[Definition] [nvarchar](max) NULL,
	[RefJurisdictionId] [int] NULL,
	[RefSubgroupTypeId] [int] NULL,
	[SortOrder] [decimal](5, 2) NULL,
 CONSTRAINT [PK_RefSubgroup] PRIMARY KEY CLUSTERED 
(
	[RefSubgroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroup_Org]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroup]'))
ALTER TABLE [dbo].[RefSubgroup]  WITH CHECK ADD  CONSTRAINT [FK_RefSubgroup_Org] FOREIGN KEY([RefJurisdictionId])
REFERENCES [dbo].[Organization] ([OrganizationId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroup_Org]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroup]'))
ALTER TABLE [dbo].[RefSubgroup] CHECK CONSTRAINT [FK_RefSubgroup_Org]


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroup_RefSubgroupType]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroup]'))
ALTER TABLE [dbo].[RefSubgroup]  WITH CHECK ADD  CONSTRAINT [FK_RefSubgroup_RefSubgroupType] FOREIGN KEY([RefSubgroupTypeId])
REFERENCES [dbo].[RefSubgroupType] ([RefSubgroupTypeId])


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefSubgroup_RefSubgroupType]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefSubgroup]'))
ALTER TABLE [dbo].[RefSubgroup] CHECK CONSTRAINT [FK_RefSubgroup_RefSubgroupType]

