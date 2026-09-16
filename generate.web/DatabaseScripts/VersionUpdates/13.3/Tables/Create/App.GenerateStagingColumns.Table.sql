CREATE TABLE [App].[GenerateStagingColumns](
	[StagingColumnId] [int] IDENTITY(1,1) NOT NULL,
	[StagingTableId] [int] NOT NULL,
	[StagingColumnName] [varchar](100) NULL,
	[DataType] [varchar](25) NULL,
	[MaxLength] [int] NULL,
	[SSRDRefTableName] [varchar](100) NULL,
	[SSRDTableFilter] [varchar](20) NULL,
 CONSTRAINT [PK_App.GenerateStagingColumns] PRIMARY KEY CLUSTERED 
(
	[StagingColumnId] ASC,
	[StagingTableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

