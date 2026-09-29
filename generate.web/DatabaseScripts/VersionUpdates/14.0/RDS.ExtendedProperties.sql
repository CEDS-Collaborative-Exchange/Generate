IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentPerpetrators', N'COLUMN', N'IncidentPerpetratorTypeCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentPerpetrators', @level2type = N'COLUMN', @level2name = N'IncidentPerpetratorTypeCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who committed an incident. A “perpetrator” is an individual involved in an incident as an offender (the person who committed the infraction constituting the incident).', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentPerpetrators', @level2type = N'COLUMN', @level2name = N'IncidentPerpetratorTypeCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentPerpetrators', N'COLUMN', N'IncidentPerpetratorTypeDescription'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentPerpetrators', @level2type = N'COLUMN', @level2name = N'IncidentPerpetratorTypeDescription';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who committed an incident. A “perpetrator” is an individual involved in an incident as an offender (the person who committed the infraction constituting the incident).', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentPerpetrators', @level2type = N'COLUMN', @level2name = N'IncidentPerpetratorTypeDescription';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentVictims', N'COLUMN', N'IncidentVictimTypeCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentVictims', @level2type = N'COLUMN', @level2name = N'IncidentVictimTypeCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who was injured or otherwise harmed as a direct result of the incident. A “victim” is the individual who suffers injury or harm that directly results from the incident.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentVictims', @level2type = N'COLUMN', @level2name = N'IncidentVictimTypeCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentVictims', N'COLUMN', N'IncidentVictimTypeDescription'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentVictims', @level2type = N'COLUMN', @level2name = N'IncidentVictimTypeDescription';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who was injured or otherwise harmed as a direct result of the incident. A “victim” is the individual who suffers injury or harm that directly results from the incident.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentVictims', @level2type = N'COLUMN', @level2name = N'IncidentVictimTypeDescription';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentWitnesses', N'COLUMN', N'IncidentWitnessTypeCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentWitnesses', @level2type = N'COLUMN', @level2name = N'IncidentWitnessTypeCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who witnessed the incident and can give a firsthand account of an incident that was seen‚ heard‚ or experienced.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentWitnesses', @level2type = N'COLUMN', @level2name = N'IncidentWitnessTypeCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'BridgeK12IncidentIncidentWitnesses', N'COLUMN', N'IncidentWitnessTypeDescription'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentWitnesses', @level2type = N'COLUMN', @level2name = N'IncidentWitnessTypeDescription';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'Information on the type of individual who witnessed the incident and can give a firsthand account of an incident that was seen‚ heard‚ or experienced.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'BridgeK12IncidentIncidentWitnesses', @level2type = N'COLUMN', @level2name = N'IncidentWitnessTypeDescription';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_URL', N'SCHEMA', N'RDS', N'TABLE', N'DimCohortExclusions', N'COLUMN', N'CohortExclusionCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohortExclusions', @level2type = N'COLUMN', @level2name = N'CohortExclusionCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'ttps://ceds.ed.gov/element/000106', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohortExclusions', @level2type = N'COLUMN', @level2name = N'CohortExclusionCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_URL', N'SCHEMA', N'RDS', N'TABLE', N'DimCohortExclusions', N'COLUMN', N'CohortExclusionDescription'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohortExclusions', @level2type = N'COLUMN', @level2name = N'CohortExclusionDescription';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'ttps://ceds.ed.gov/element/000106', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohortExclusions', @level2type = N'COLUMN', @level2name = N'CohortExclusionDescription';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_URL', N'SCHEMA', N'RDS', N'TABLE', N'DimCohorts', N'COLUMN', N'CohortDescription'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohorts', @level2type = N'COLUMN', @level2name = N'CohortDescription';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'ttps://ceds.ed.gov/element/000711', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCohorts', @level2type = N'COLUMN', @level2name = N'CohortDescription';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Def_Desc', N'SCHEMA', N'RDS', N'TABLE', N'ReportEDFactsK12StudentCounts', N'COLUMN', N'StateAnsiCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The American National Standards Institute (ANSI) two-digit code for the state.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_Element', N'SCHEMA', N'RDS', N'TABLE', N'ReportEDFactsK12StudentCounts', N'COLUMN', N'StateAnsiCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'State ANSI Code', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_GlobalId', N'SCHEMA', N'RDS', N'TABLE', N'ReportEDFactsK12StudentCounts', N'COLUMN', N'StateAnsiCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000424', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'CEDS_URL', N'SCHEMA', N'RDS', N'TABLE', N'ReportEDFactsK12StudentCounts', N'COLUMN', N'StateAnsiCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
END;
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21414', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';

IF EXISTS (SELECT 1 FROM fn_listextendedproperty(N'MS_Description', N'SCHEMA', N'RDS', N'TABLE', N'ReportEDFactsK12StudentCounts', N'COLUMN', N'StateAnsiCode'))
BEGIN
EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
END;
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'ReportEDFactsK12StudentCounts', @level2type = N'COLUMN', @level2name = N'StateAnsiCode';
