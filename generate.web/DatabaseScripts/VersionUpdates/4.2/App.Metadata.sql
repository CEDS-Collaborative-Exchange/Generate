set nocount on


begin try

	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Debug')
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA Debug'
	END
	
	delete fsfc from app.filesubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (12, 19, 39, 41, 44, 46, 48, 52, 95, 96, 97, 98, 99, 118, 120) and submissionyear in (2020, 2021)

	delete fs from app.FileSubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where fs.generatereportid in (12, 19, 39, 41, 44, 46, 48, 52, 95, 96, 97, 98, 99, 118, 120) and submissionyear in (2020, 2021)

	DECLARE @reportId int, @reportCode varchar(20)
	
	DECLARE generatereport_cursor CURSOR FOR 
	select GenerateReportId, ReportCode
	from  app.GenerateReports 
	where generatereportid in (12, 19, 39, 41, 44, 46, 48, 52, 95, 96, 97, 98, 99, 118, 120)

	OPEN generatereport_cursor
	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2019', '2020'
		exec App.Rollover_Previous_Year_Metadata @reportCode, '2020', '2021'


	FETCH NEXT FROM generatereport_cursor INTO @reportId, @reportCode
	END
	CLOSE generatereport_cursor
	DEALLOCATE generatereport_cursor
	
	exec App.Rollover_Previous_Year_Metadata 'c002', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c029', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c039', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c052', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c130', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c190', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c196', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c197', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c198', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c206', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c207', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c212', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c033', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c059', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c089', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c129', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c175', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c178', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c179', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c185', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c188', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c189', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c005', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c006', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c007', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c009', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c045', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c050', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c054', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c067', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c086', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c088', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c099', '2021', '2022'
	--exec App.Rollover_Previous_Year_Metadata 'c116', '2021', '2022' -- Some sort of issue with 116 metadata
	exec App.Rollover_Previous_Year_Metadata 'c121', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c122', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c126', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c134', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c137', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c139', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c141', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c143', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c144', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c145', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c165', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c170', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c194', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c195', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c203', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c210', '2021', '2022'
	exec App.Rollover_Previous_Year_Metadata 'c211', '2021', '2022'

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