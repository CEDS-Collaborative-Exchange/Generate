CREATE FUNCTION [dbo].[GetCollectionId](@DataCollectionName varchar(20))
RETURNS INT
AS BEGIN
	DECLARE @DataCollectionId INT
	
	Select @DataCollectionId = dc.DataCollectionId
	From dbo.DataCollection dc 
	where RefDataCollectionStatusId=2 
	and SourceSystemName like '%GeneralCollection%' 
	and substring(DataCollectionName,1,CHARINDEX(' ',DataCollectionName)+4) = @DataCollectionName

	RETURN (@DataCollectionId)
END