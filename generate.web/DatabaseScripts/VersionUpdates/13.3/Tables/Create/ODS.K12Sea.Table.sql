IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'K12Sea' AND Type = N'U')
BEGIN

CREATE TABLE [ODS].[K12Sea](
	[K12SeaId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[RefStateANSICode] [char](2) NULL,
	[RecordStartDateTime] [datetime] NULL,
	[RecordEndDateTime] [datetime] NULL,	
 CONSTRAINT [PK_K12Sea] PRIMARY KEY CLUSTERED 
(
	[K12SeaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [ODS].[K12Sea]  WITH CHECK ADD  CONSTRAINT [FK_K12Sea_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [ODS].[Organization] ([OrganizationId])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [ODS].[K12Sea] CHECK CONSTRAINT [FK_K12Sea_Organization]


ALTER TABLE [ODS].[K12Sea]  WITH CHECK ADD  CONSTRAINT [FK_K12SEA_RefStateANSICode] FOREIGN KEY([RefStateANSICode])
REFERENCES [ODS].[RefStateANSICode] ([Code])


ALTER TABLE [ODS].[K12Sea] CHECK CONSTRAINT [FK_K12SEA_RefStateANSICode]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inherited surrogate key from Organization.' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12Sea', @level2type=N'COLUMN',@level2name=N'OrganizationId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The American National Standards Institute (ANSI) two-digit code for the state. [CEDS Element: State ANSI Code, ID:000424]  (Foreign key - RefStateANSICode)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12Sea', @level2type=N'COLUMN',@level2name=N'RefStateANSICode'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SEA is the state-level entity primarily responsible for the supervision of the state''s public elementary and secondary schools.' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12Sea'


END
