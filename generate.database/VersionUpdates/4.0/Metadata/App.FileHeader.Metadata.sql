
declare @fileSubmissionId as int, @fileColumnId as int
if NOT EXISTS(Select 1 from app.FileSubmissions where FileSubmissionDescription = 'HEADER')
BEGIN
	INSERT INTO [App].[FileSubmissions]([FileSubmissionDescription]) VALUES('HEADER')

	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(50,'FileType','String','','FILELAYOUTTYPE')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(10,'TotalRecords','Number','','')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(25,'FileName','String','','')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(32,'FileIdentifier','String','','FILEID')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(458,'Filler','String','','')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(1,'CarriageReturn/LineFeed','Control Character','','')
	INSERT INTO [App].[FileColumns]([ColumnLength],[ColumnName],[DataType],[DisplayName],[XMLElementName]) VALUES(9,'FileReportingPeriod','String','','')

	select @fileSubmissionId = FileSubmissionId from app.FileSubmissions where FileSubmissionDescription = 'HEADER'

	if(@fileSubmissionId > 0)
	begin
		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FileType'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,50,0,1,1)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'TotalRecords'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,60,0,2,51)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FileName'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,85,0,3,61)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FileIdentifier'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,117,0,4,86)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Filler'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,584,0,6,127)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'CarriageReturn/LineFeed'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,586,0,7,585)

		select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FileReportingPeriod'
		INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]) VALUES(@fileSubmissionId,@fileColumnId,126,0,5,118)
	end
END