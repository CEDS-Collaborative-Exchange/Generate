CREATE VIEW [rds].[vwCEDS_DataWarehouse_Extended_Properties] 
AS

	SELECT	DISTINCT  
			s.name		AS [Schema Name]
			, o.name	AS [Table Name]
			, c.name	AS [Column Name]
			, ep.name	AS [Property Name]
			, ep.value	AS [Property Value]
	FROM		sys.extended_properties		ep		
	LEFT JOIN	sys.all_objects				o		ON ep.major_id		= o.object_id 
	LEFT JOIN	sys.schemas					s		ON o.schema_id		= s.schema_id
	LEFT JOIN	sys.columns					c		ON ep.major_id		= c.object_id	AND ep.minor_id		= c.column_id

	WHERE 	s.name = 'RDS'
	--uncomment/modify the where clause conditions as necessary
	--AND		o.name = ''				--Fact or Dimension table name (FactK12StudentCounts, DimK12EnrollmentStatuses, etc...)
	--AND		c.name like '%Entry%'	--Wildcard search for Column Name in a Fact or Dimension Table 
	--AND		ep.name = ''			--The specific extended property (CEDS_Def_Desc, CEDS_ElementTechnicalName, CEDS_GlobalId, CEDS_URL, MS_Description)
