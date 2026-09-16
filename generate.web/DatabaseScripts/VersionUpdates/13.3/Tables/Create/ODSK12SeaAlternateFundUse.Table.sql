IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'K12SeaAlternateFundUse' AND Type = N'U')
BEGIN


CREATE TABLE [ODS].[K12SeaAlternateFundUse](
	[K12SEAlternateFundUseId] [int] IDENTITY(1,1) NOT NULL,	
	[RefAlternateFundUsesId] [int] NOT NULL,
	[K12seaFederalFundsId] [int] NOT NULL,
	[RecordStartDateTime] [datetime] NULL,
	[RecordEndDateTime] [datetime] NULL,	
 CONSTRAINT [PK_K12SEAAlternateFundUse] PRIMARY KEY CLUSTERED 
(
	[K12SEAlternateFundUseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [ODS].[K12SeaAlternateFundUse]  WITH CHECK ADD  CONSTRAINT [FK_K12SeaAlternateFundUse_K12seaFederalFunds] FOREIGN KEY([K12seaFederalFundsId])
REFERENCES [ODS].[K12SeaFederalFunds] ([K12seaFederalFundsId])


ALTER TABLE [ODS].[K12SeaAlternateFundUse] CHECK CONSTRAINT [FK_K12SeaAlternateFundUse_K12seaFederalFunds]


ALTER TABLE [ODS].[K12SeaAlternateFundUse]  WITH CHECK ADD  CONSTRAINT [FK_K12SEAAlternateFundUse_RefAlternateFundUses] FOREIGN KEY([RefAlternateFundUsesId])
REFERENCES [ODS].[RefAlternateFundUses] ([RefAlternateFundUsesId])


ALTER TABLE [ODS].[K12SeaAlternateFundUse] CHECK CONSTRAINT [FK_K12SEAAlternateFundUse_RefAlternateFundUses]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surrogate Key' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaAlternateFundUse', @level2type=N'COLUMN',@level2name=N'K12SEAlternateFundUseId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Purposes that funds available under ESEA section 6111 (Grants for State Assessments and Related Activities) were used for purposes other than the costs of the development of the State assessments and standards required by section 1111(b). [CEDS Element: Uses of Funds for Purposes other than Standards and Assessment Development, ID:000459]  (Foreign key - RefAlternateFundUse)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaAlternateFundUse', @level2type=N'COLUMN',@level2name=N'RefAlternateFundUsesId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Purposes that funds available under ESEA section 6111 (Grants for State Assessments and Related Activities) were used for purposes other than the costs of the development of the State assessments and standards required by section 1111(b). [CEDS Element: Uses of Funds for Purposes other than Standards and Assessment Development, ID:000459] (Foreign key - RefAlternateFundUse)' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaAlternateFundUse'

END
