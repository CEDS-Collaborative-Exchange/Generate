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
