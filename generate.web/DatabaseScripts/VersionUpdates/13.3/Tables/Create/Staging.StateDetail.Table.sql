--This will house the all state data, including SEA contact, which is the Cheif Information Officer for Reporting FS029
CREATE TABLE Staging.StateDetail (
	  OrganizationId INT NULL
	, StateCode CHAR(2)
	, SeaName VARCHAR(250)
	, SeaShortName VARCHAR(20)
	, SeaStateIdentifier VARCHAR(7)
	, Sea_WebSiteAddress VARCHAR(300)
	, SeaContact_FirstName VARCHAR(100)
	, SeaContact_LastOrSurname VARCHAR(100)
	, SeaContact_PersonalTitleOrPrefix VARCHAR(100)
	, SeaContact_ElectronicMailAddress VARCHAR(100)
	, SeaContact_PhoneNumber VARCHAR(100)
	, SeaContact_Identifier VARCHAR(100)
	, PersonId INT
	, RunDateTime DATETIME
)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'StateCode' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefState', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'StateCode' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaName' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaShortName' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaStateIdentifier' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefStateANSICode', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaStateIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'Sea_WebSiteAddress' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaContact_FirstName' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaContact_LastOrSurname' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaContact_ElectronicMailAddress' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaContact_PhoneNumber' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StateDetail', @level2type = N'Column', @level2name = 'SeaContact_Identifier' 