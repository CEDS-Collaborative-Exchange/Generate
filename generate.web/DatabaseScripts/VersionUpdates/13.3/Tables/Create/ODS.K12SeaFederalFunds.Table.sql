IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'K12SeaFederalFunds' AND Type = N'U')
BEGIN


CREATE TABLE [ODS].[K12SeaFederalFunds](
	[K12seaFederalFundsId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationCalendarSessionId] [int] NOT NULL,
	[StateTransferabilityOfFunds] [bit] NULL,
	[DateStateReceivedTitleIIIAllocation] [date] NULL,
	[DateTitleIIIFundsAvailableToSubgrantees] [date] NULL,
	[NumberOfDaysForTitleIIISubgrants] [numeric](6, 2) NULL,	
	[RecordStartDateTime] [datetime] NULL,
	[RecordEndDateTime] [datetime] NULL,	
 CONSTRAINT [PK_K12SEAFederalFunds] PRIMARY KEY CLUSTERED 
(
	[K12seaFederalFundsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [ODS].[K12SeaFederalFunds]  WITH CHECK ADD  CONSTRAINT [FK_K12SEAFederalFunds_OrganizationCalendarSession] FOREIGN KEY([OrganizationCalendarSessionId])
REFERENCES [ODS].[OrganizationCalendarSession] ([OrganizationCalendarSessionId])


ALTER TABLE [ODS].[K12SeaFederalFunds] CHECK CONSTRAINT [FK_K12SEAFederalFunds_OrganizationCalendarSession]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Did the State transfer funds under the State Transferability authority of Section 6123(a) [CEDS Element: State Transferability of Funds, ID:000445]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaFederalFunds', @level2type=N'COLUMN',@level2name=N'StateTransferabilityOfFunds'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Annual date the State receives the Title III allocation from U.S. Department of Education (ED). [CEDS Element: Date State Received Title III Allocation, ID:000455]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaFederalFunds', @level2type=N'COLUMN',@level2name=N'DateStateReceivedTitleIIIAllocation'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Annual date that Title III funds are available to approved subgrantees. [CEDS Element: Date Title III Funds Available to Subgrantees, ID:000456]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaFederalFunds', @level2type=N'COLUMN',@level2name=N'DateTitleIIIFundsAvailableToSubgrantees'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Average number of days for States receiving Title III funds to make subgrants to subgrantees beginning from July 1 of each year, except under conditions where funds are being withheld. [CEDS Element: Number of Days for Title III Subgrants, ID:000457]' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaFederalFunds', @level2type=N'COLUMN',@level2name=N'NumberOfDaysForTitleIIISubgrants'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Information on the federal funds received by the SEA.' , @level0type=N'SCHEMA',@level0name=N'ODS', @level1type=N'TABLE',@level1name=N'K12SeaFederalFunds'


END
