-- Release-Specific table changes for the ODS schema
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefCharterLeaStatus' AND Type = N'U')
		BEGIN		
			CREATE TABLE [ODS].[RefCharterLeaStatus](
			[RefCharterLeaStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] [nvarchar](100) NOT NULL,
			[Code] [nvarchar](50) NULL,
			[Definition] [nvarchar](4000) NULL,
			[RefJurisdictionId] [int] NULL,
			[SortOrder] [decimal](5, 2) NULL,
			 CONSTRAINT [PK_RefCharterLeaStatus] PRIMARY KEY CLUSTERED 
			(
				[RefCharterLeaStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [ODS].[RefCharterLeaStatus]  WITH CHECK ADD  CONSTRAINT [FK_RefCharterLeaStatus_Organization] FOREIGN KEY([RefJurisdictionId])
			REFERENCES [ODS].[Organization] ([OrganizationId])

			ALTER TABLE [ODS].[RefCharterLeaStatus] CHECK CONSTRAINT [FK_RefCharterLeaStatus_Organization]

		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefCharterLeaStatusId' AND Object_ID = Object_ID(N'[ODS].[k12Lea]'))
		BEGIN
			ALTER TABLE [ODS].[k12Lea] ADD RefCharterLeaStatusId int null

			ALTER TABLE [ODS].[K12Lea]  WITH CHECK ADD  CONSTRAINT [FK_K12Lea_RefCharterLeaStatus] FOREIGN KEY([RefCharterLeaStatusId])
			REFERENCES [ODS].[RefCharterLeaStatus] ([RefCharterLeaStatusId])

			ALTER TABLE [ODS].[K12Lea] CHECK CONSTRAINT [FK_K12Lea_RefCharterLeaStatus]
		END

	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
