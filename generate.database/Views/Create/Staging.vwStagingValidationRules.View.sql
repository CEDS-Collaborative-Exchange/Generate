CREATE view [Staging].[vwStagingValidationRules]
as

--update staging.StagingValidationRules set enabled = 1 where StagingValidationRuleId = 133

select
	svr.StagingValidationRuleId,
	X.StagingValidationRuleId StagingValidationRuleId_XREF,
	avsv.ReportGroup,
	avsv.ReportGroupId,
	avsv.ReportCode,
	avsv.ReportName,
	avsv.GenerateReportId,
	avsv.StagingTableName,
	avsv.StagingTableId,
	avsv.StagingColumnName,
	avsv.StagingColumnId,
	X.GenerateReportId GenerateReportId_XREF,
	X.Enabled Enabled_XREF,

	svr.RuleDscr,
	svr.Condition,
	svr.ValidationMessage,
	svr.Severity,
	svr.CreatedBy,
	svr.CreateDateTime

from app.vwStagingRelationships avsv
left join staging.StagingValidationRules svr
	on svr.StagingTableId = avsv.StagingTableId
	and svr.StagingColumnId = avsv.StagingColumnId
left join staging.StagingValidationRules_ReportsXREF X
	on (avsv.GenerateReportId = X.GenerateReportId or X.GenerateReportId = -1)
	and svr.StagingValidationRuleId = X.StagingValidationRuleId

