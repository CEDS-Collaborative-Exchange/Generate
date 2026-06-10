IF NOT EXISTS (SELECT 1 FROM sys.tables t INNER JOIN sys.schemas s on t.schema_id = s.schema_id WHERE s.name = N'Staging' AND t.Name = N'K12SchoolComprehensiveSupportIdentificationType' AND Type = N'U')
BEGIN
CREATE TABLE [Staging].[K12SchoolComprehensiveSupportIdentificationType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[K12SchoolComprehensiveSupportIdentificationTypeId] [varchar](100) NULL,
	[SchoolYear] [varchar](4) NULL,
	[LEA_Identifier_State] [varchar](100) NULL,
	[School_Identifier_State] [varchar](100) NULL,
	[ComprehensiveSupport] [varchar](20) NULL,
	[ComprehensiveSupportReasonApplicability] [varchar](20) NULL,
	[RecordStartDateTime] [datetime] NULL,
	[RecordEndDateTime] [datetime] NULL,
	[OrganizationId] [int] NULL,
	[K12SchoolId] [int] NULL,
	[RunDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END


--IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RecordId'))
--	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'K12SchoolComprehensiveSupportIdentificationTypeId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'SchoolYear'))
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'SchoolYear'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'LEA_Identifier_State'))
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'School_Identifier_State'))
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupport'))
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupport' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupport'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupportReasonApplicability' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RecordStartDateTime'))
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Identifier' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'OrganizationId'))
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'OrganizationId'


IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'TableType' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType'



