if not exists (select name from sys.schemas where name = N'Utilities')
	begin
		exec ('create schema Utilities authorization dbo')
	end