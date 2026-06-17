IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Def_Desc'
	  AND s.name = N'Staging'
	  AND t.name = N'K12Organization'
	  AND c.name = N'Lea_WebSiteAddress'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The Uniform Resource Locator (URL) for the unique address of a Web page.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'K12Organization'
	  AND c.name = N'Lea_WebSiteAddress'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Web Site Address', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_GlobalId'
	  AND s.name = N'Staging'
	  AND t.name = N'K12Organization'
	  AND c.name = N'Lea_WebSiteAddress'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000704', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_URL'
	  AND s.name = N'Staging'
	  AND t.name = N'K12Organization'
	  AND c.name = N'Lea_WebSiteAddress'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21300', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'MS_Description'
	  AND s.name = N'Staging'
	  AND t.name = N'K12Organization'
	  AND c.name = N'Lea_WebSiteAddress'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';
END;

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'Lea_WebSiteAddress';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Def_Desc'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Local Education Agency Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_GlobalId'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001068', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_URL'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'MS_Description'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'Required'
	  AND s.name = N'Staging'
	  AND t.name = N'K12SchoolComprehensiveSupportIdentificationType'
	  AND c.name = N'LeaIdentifierSea'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
