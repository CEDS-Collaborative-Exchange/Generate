exec sp_rename 'RDS.FactCustomCounts.StateCode', 'StateAbbreviationCode', 'COLUMN';
exec sp_rename 'RDS.FactCustomCounts.StateName', 'StateAbbreviationDescription', 'COLUMN';
