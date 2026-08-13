IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_GlobalId'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordEndDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001918', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_URL'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordEndDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_GlobalId'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordStartDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001917', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_URL'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordStartDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';


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

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Def_Desc'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The year, month and day on which a person was born.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Birthdate', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_GlobalId'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000033', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_URL'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21033', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'MS_Description'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'Required'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'Birthdate'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';
END;

EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Birthdate';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherInexperiencedStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherInexperiencedStatus';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Teacher Inexperienced Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherInexperiencedStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Def_Desc'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherOutOfFieldStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'An indication of whether teachers have been identified as teaching a subject or field for which they are not certified or licensed as defined by the state.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherOutOfFieldStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Teacher Out of Field Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_GlobalId'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherOutOfFieldStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001962', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_URL'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherOutOfFieldStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22930', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'MS_Description'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'EdFactsTeacherOutOfFieldStatus'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';
END;

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'EdFactsTeacherOutOfFieldStatus';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'Lookup'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'SpecialEducationStaffCategory'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'SpecialEducationStaffCategory';
END;

EXECUTE sp_addextendedproperty @name = N'Lookup', @value = N'RefSpecialEducationStaffCategory', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'SpecialEducationStaffCategory';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'Required'
	  AND s.name = N'Staging'
	  AND t.name = N'K12StaffAssignment'
	  AND c.name = N'SpecialEducationStaffCategory'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'SpecialEducationStaffCategory';
END;

EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'SpecialEducationStaffCategory';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Def_Desc'
	  AND s.name = N'Staging'
	  AND t.name = N'OrganizationFederalFunding'
	  AND c.name = N'ReapAlternativeFundingStatusCode'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'An indication that the local education agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title VI, Section 6211 of ESEA as amended.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_Element'
	  AND s.name = N'Staging'
	  AND t.name = N'OrganizationFederalFunding'
	  AND c.name = N'ReapAlternativeFundingStatusCode'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Rural Education Achievement Program Alternative Funding Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_GlobalId'
	  AND s.name = N'Staging'
	  AND t.name = N'OrganizationFederalFunding'
	  AND c.name = N'ReapAlternativeFundingStatusCode'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000560', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'CEDS_URL'
	  AND s.name = N'Staging'
	  AND t.name = N'OrganizationFederalFunding'
	  AND c.name = N'ReapAlternativeFundingStatusCode'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21552', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';

IF EXISTS (
	SELECT 1
	FROM sys.extended_properties ep
	INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
	WHERE ep.name = N'MS_Description'
	  AND s.name = N'Staging'
	  AND t.name = N'OrganizationFederalFunding'
	  AND c.name = N'ReapAlternativeFundingStatusCode'
)
BEGIN
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
END;

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'ReapAlternativeFundingStatusCode';
﻿
-- ==========================================================================================
-- CIID-9061: Backfill CEDS_GlobalId / CEDS_Element extended properties on EDFacts-required
-- Staging columns that were missing them, so the ETL Checklist mapper can surface every
-- required column as a CEDS mapping target. GlobalIds resolved from App.EtlMetadata and the
-- existing Staging CEDS annotations. Idempotent: drop-if-exists then add; column-guarded.
-- ==========================================================================================

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.AssessmentResult'), N'DataCollectionName', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'AssessmentResult' AND c.name = N'DataCollectionName')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'DataCollectionName';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001966', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'DataCollectionName';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'AssessmentResult' AND c.name = N'DataCollectionName')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'DataCollectionName';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Data Collection Name', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'DataCollectionName';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.AssessmentResult'), N'SchoolYear', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'AssessmentResult' AND c.name = N'SchoolYear')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'SchoolYear';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000243', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'SchoolYear';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'AssessmentResult' AND c.name = N'SchoolYear')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'SchoolYear';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'School Year', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'SchoolYear';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.Discipline'), N'DisciplineMethodOfCwd', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'Discipline' AND c.name = N'DisciplineMethodOfCwd')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineMethodOfCwd';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000538', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineMethodOfCwd';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'Discipline' AND c.name = N'DisciplineMethodOfCwd')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineMethodOfCwd';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Discipline Method of Children with Disabilities', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineMethodOfCwd';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Enrollment'), N'HispanicLatinoEthnicity', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'HispanicLatinoEthnicity')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'HispanicLatinoEthnicity';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000144', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'HispanicLatinoEthnicity';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'HispanicLatinoEthnicity')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'HispanicLatinoEthnicity';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Hispanic or Latino Ethnicity', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'HispanicLatinoEthnicity';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Enrollment'), N'FoodServiceEligibility', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'FoodServiceEligibility')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'FoodServiceEligibility';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000092', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'FoodServiceEligibility';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'FoodServiceEligibility')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'FoodServiceEligibility';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Eligibility Status for School Food Service Programs', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'FoodServiceEligibility';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Enrollment'), N'LanguageHome', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'LanguageHome')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageHome';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000317', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageHome';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'LanguageHome')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageHome';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'ISO 639-2 Language Code', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageHome';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Enrollment'), N'LanguageNative', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'LanguageNative')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageNative';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000317', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageNative';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Enrollment' AND c.name = N'LanguageNative')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageNative';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'ISO 639-2 Language Code', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'LanguageNative';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'School_ComprehensiveSupport', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_ComprehensiveSupport')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_ComprehensiveSupport';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001923', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_ComprehensiveSupport';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_ComprehensiveSupport')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_ComprehensiveSupport';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Comprehensive Support and Improvement Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_ComprehensiveSupport';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'School_SchoolDangerousStatus', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_SchoolDangerousStatus')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_SchoolDangerousStatus';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000210', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_SchoolDangerousStatus';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_SchoolDangerousStatus')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_SchoolDangerousStatus';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Persistently Dangerous Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_SchoolDangerousStatus';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'School_TargetedSupport', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_TargetedSupport')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_TargetedSupport';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001924', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_TargetedSupport';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'School_TargetedSupport')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_TargetedSupport';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Targeted Support and Improvement Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_TargetedSupport';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'LEA_MepProjectType', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'LEA_MepProjectType')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_MepProjectType';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000463', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_MepProjectType';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'K12Organization' AND c.name = N'LEA_MepProjectType')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_MepProjectType';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Migrant Education Program Project Type', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_MepProjectType';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.OrganizationGradeOffered'), N'GradeOffered', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'OrganizationGradeOffered' AND c.name = N'GradeOffered')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000131', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'OrganizationGradeOffered' AND c.name = N'GradeOffered')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Grades Offered', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'EconomicDisadvantageStatus')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000086', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'EconomicDisadvantageStatus')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Economic Disadvantage Status', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'IdeaIndicator')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000151', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'IdeaIndicator')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'IDEA Indicator', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'LeaIdentifierSea')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001068', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'LeaIdentifierSea')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Local Education Agency Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'Race')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001943', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'SchoolPerformanceIndicators' AND c.name = N'Race')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Race', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.StateDetail'), N'SeaContact_Identifier', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'StateDetail' AND c.name = N'SeaContact_Identifier')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_Identifier';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001070', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_Identifier';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'StateDetail' AND c.name = N'SeaContact_Identifier')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_Identifier';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Staff Member Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_Identifier';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.StateDetail'), N'SeaContact_PhoneNumber', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_GlobalId' AND s.name = N'Staging' AND t.name = N'StateDetail' AND c.name = N'SeaContact_PhoneNumber')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_PhoneNumber';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000279', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_PhoneNumber';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
        INNER JOIN sys.tables t ON t.object_id = c.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE ep.name = N'CEDS_Element' AND s.name = N'Staging' AND t.name = N'StateDetail' AND c.name = N'SeaContact_PhoneNumber')
        EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_PhoneNumber';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Telephone Number', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaContact_PhoneNumber';
END;


-- CIID-9061 (follow-up): two more EDFacts-required columns confirmed CEDS-mappable (per SME review).
-- IsSecondaryDisability -> IDEA Disability Type; HomelessNightTimeResidence_StartDate -> Status Start Date
-- (the latter is a pivot of Homeless Primary Nighttime Residence + Status Start Date; annotate the date).
IF COLUMNPROPERTY(OBJECT_ID(N'Staging.IdeaDisabilityType'), N'IsSecondaryDisability', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_GlobalId' AND s.name=N'Staging' AND t.name=N'IdeaDisabilityType' AND c.name=N'IsSecondaryDisability')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'IdeaDisabilityType', @level2type=N'COLUMN', @level2name=N'IsSecondaryDisability';
    EXECUTE sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001733', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'IdeaDisabilityType', @level2type=N'COLUMN', @level2name=N'IsSecondaryDisability';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_Element' AND s.name=N'Staging' AND t.name=N'IdeaDisabilityType' AND c.name=N'IsSecondaryDisability')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_Element', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'IdeaDisabilityType', @level2type=N'COLUMN', @level2name=N'IsSecondaryDisability';
    EXECUTE sp_addextendedproperty @name=N'CEDS_Element', @value=N'IDEA Disability Type', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'IdeaDisabilityType', @level2type=N'COLUMN', @level2name=N'IsSecondaryDisability';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'HomelessNightTimeResidence_StartDate', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_GlobalId' AND s.name=N'Staging' AND t.name=N'PersonStatus' AND c.name=N'HomelessNightTimeResidence_StartDate')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'PersonStatus', @level2type=N'COLUMN', @level2name=N'HomelessNightTimeResidence_StartDate';
    EXECUTE sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001227', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'PersonStatus', @level2type=N'COLUMN', @level2name=N'HomelessNightTimeResidence_StartDate';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_Element' AND s.name=N'Staging' AND t.name=N'PersonStatus' AND c.name=N'HomelessNightTimeResidence_StartDate')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_Element', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'PersonStatus', @level2type=N'COLUMN', @level2name=N'HomelessNightTimeResidence_StartDate';
    EXECUTE sp_addextendedproperty @name=N'CEDS_Element', @value=N'Status Start Date', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'PersonStatus', @level2type=N'COLUMN', @level2name=N'HomelessNightTimeResidence_StartDate';
END;

-- CIID-9061 (CEDS Ontology follow-up): 3 more required columns resolved to CEDS elements via the
-- CEDS ontology graph. The rest of the reviewed set (Charter LEA Status, McKinney-Vento Subgrant,
-- Discipline Action Identifier, Parental Involvement Reservation Funds, School Performance Indicator
-- Category/Status/Type/StateDefinedStatus, SubgroupCode) returned no CEDS element and are left un-annotated.

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'Lea_TitleIinstructionalService', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_GlobalId' AND s.name=N'Staging' AND t.name=N'K12Organization' AND c.name=N'Lea_TitleIinstructionalService')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_TitleIinstructionalService';
    EXECUTE sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000282', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_TitleIinstructionalService';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_Element' AND s.name=N'Staging' AND t.name=N'K12Organization' AND c.name=N'Lea_TitleIinstructionalService')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_Element', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_TitleIinstructionalService';
    EXECUTE sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Instructional Services', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_TitleIinstructionalService';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.K12Organization'), N'Lea_K12LeaTitleISupportService', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_GlobalId' AND s.name=N'Staging' AND t.name=N'K12Organization' AND c.name=N'Lea_K12LeaTitleISupportService')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_K12LeaTitleISupportService';
    EXECUTE sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000289', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_K12LeaTitleISupportService';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_Element' AND s.name=N'Staging' AND t.name=N'K12Organization' AND c.name=N'Lea_K12LeaTitleISupportService')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_Element', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_K12LeaTitleISupportService';
    EXECUTE sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Support Services', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'K12Organization', @level2type=N'COLUMN', @level2name=N'Lea_K12LeaTitleISupportService';
END;

IF COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'SchoolQualityOrStudentSuccessIndicatorType', 'ColumnId') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_GlobalId' AND s.name=N'Staging' AND t.name=N'SchoolPerformanceIndicators' AND c.name=N'SchoolQualityOrStudentSuccessIndicatorType')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN', @level2name=N'SchoolQualityOrStudentSuccessIndicatorType';
    EXECUTE sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'002140', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN', @level2name=N'SchoolQualityOrStudentSuccessIndicatorType';
    IF EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.columns c ON c.object_id=ep.major_id AND c.column_id=ep.minor_id INNER JOIN sys.tables t ON t.object_id=c.object_id INNER JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE ep.name=N'CEDS_Element' AND s.name=N'Staging' AND t.name=N'SchoolPerformanceIndicators' AND c.name=N'SchoolQualityOrStudentSuccessIndicatorType')
        EXECUTE sp_dropextendedproperty @name=N'CEDS_Element', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN', @level2name=N'SchoolQualityOrStudentSuccessIndicatorType';
    EXECUTE sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Quality or Student Success Indicator Type', @level0type=N'SCHEMA', @level0name=N'Staging', @level1type=N'TABLE', @level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN', @level2name=N'SchoolQualityOrStudentSuccessIndicatorType';
END;
