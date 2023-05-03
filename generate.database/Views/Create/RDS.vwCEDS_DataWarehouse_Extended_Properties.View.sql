CREATE VIEW [rds].[vwCEDS_DataWarehouse_Extended_Properties] 
AS

	SELECT	DISTINCT  
			s.name			AS [Schema Name]
			, t.name		AS [Table Name]
			, c.name		AS [Column Name]
			, ep.name		AS [Property Name]
			, ep.value		AS [Property Value]
	FROM		sys.extended_properties		ep		
	LEFT JOIN	sys.tables					t		ON ep.major_id		= t.object_id 
	LEFT JOIN	sys.schemas					s		ON t.schema_id		= s.schema_id
	LEFT JOIN	sys.columns					c		ON ep.major_id		= c.object_id	AND ep.minor_id		= c.column_id

	WHERE 	s.name = 'RDS'
	AND		ep.name like '%CEDS%'
	--uncomment/modify the where clause conditions as necessary
	--AND	o.name = ''									--Fact or Dimension table name (FactK12StudentCounts, DimK12EnrollmentStatuses, etc...)
	--AND	c.name like '%Entry%'						--Wildcard search for Column Name in a Fact or Dimension Table 
	--AND	ep.name = ''								--The specific extended property (CEDS_Def_Desc, CEDS_ElementTechnicalName, CEDS_GlobalId, CEDS_URL)
	--AND 	convert(varchar(max), ep.value) like '% %'	--Wildcard search in the Extended Property value (search for CEDS Global IDs, strings in the definition or the technical name)
	ORDER BY	[Table Name], [Column Name]
