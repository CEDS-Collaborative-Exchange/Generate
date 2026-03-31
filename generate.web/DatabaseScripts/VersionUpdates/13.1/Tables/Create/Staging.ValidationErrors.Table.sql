CREATE TABLE Staging.ValidationErrors
    ( Id INT IDENTITY(1, 1) PRIMARY KEY
	, ProcessName VARCHAR(100)
	, TableName VARCHAR(100)
	, ElementName VARCHAR(100)
	, ErrorSimple VARCHAR(500)
	, ErrorDetail VARCHAR(500)
	, ErrorGroup INT
	, Identifier VARCHAR(100)
	, CreateDate DATETIME
	)

