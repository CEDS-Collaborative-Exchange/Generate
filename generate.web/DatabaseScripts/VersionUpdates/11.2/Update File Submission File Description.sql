--Use the function to remove the numeric values in the FileSubmissionDescription column
UPDATE app.FileSubmissions
SET FileSubmissionDescription = dbo.fn_StripCharacters(FileSubmissionDescription, '^ a-z4-9')
