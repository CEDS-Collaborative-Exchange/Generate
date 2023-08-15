IF EXISTS (SELECT 1 
			FROM sys.schemas a 
			JOIN sys.tables b 
				ON a.schema_id = b.schema_id 
			LEFT JOIN sys.columns c 
				ON b.object_id = c.object_id 
			JOIN sys.extended_properties d 
				ON d.major_id = b.object_id 
				AND d.minor_id = c.column_id
			WHERE a.name = 'Staging' 
			AND b.name = 'OrganizationGradeOffered' 
			AND c.name = 'GradeOffered' 
			AND d.name = 'Lookup'
           )
BEGIN
	EXEC sp_updateextendedproperty   
		@name=N'Lookup'
		, @value=N'RefGradeLevel'
		, @level0type=N'SCHEMA', @level0name=N'Staging'
		, @level1type=N'TABLE', @level1name=N'OrganizationGradeOffered'
		, @level2type=N'COLUMN', @level2name=N'GradeOffered';
END

IF EXISTS (SELECT 1 
			FROM sys.schemas a 
			JOIN sys.tables b 
				ON a.schema_id = b.schema_id 
			LEFT JOIN sys.columns c 
				ON b.object_id = c.object_id 
			JOIN sys.extended_properties d 
				ON d.major_id = b.object_id 
				AND d.minor_id = c.column_id
			WHERE a.name = 'Staging' 
			AND b.name = 'OrganizationGradeOffered' 
			AND c.name = 'GradeOffered' 
			AND d.name = 'TableFilter'
           )
BEGIN
	EXEC sp_updateextendedproperty   
		@name=N'TableFilter'
		, @value=N'000131'
		, @level0type=N'SCHEMA', @level0name=N'Staging'
		, @level1type=N'TABLE', @level1name=N'OrganizationGradeOffered'
		, @level2type=N'COLUMN', @level2name=N'GradeOffered'
END
