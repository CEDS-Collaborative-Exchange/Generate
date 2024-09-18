set nocount on

begin try

	UPDATE App.FileSubmissions
	SET submissionyear = '20' + right(submissionyear, 2)

	delete fsfc from app.filesubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where submissionyear in (2020, 2021)

	delete fs from app.FileSubmissions fs 
	left join app.filesubmission_filecolumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
	left join app.filecolumns fc on fsfc.filecolumnid = fc.FileColumnId
	where submissionyear in (2020, 2021)

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