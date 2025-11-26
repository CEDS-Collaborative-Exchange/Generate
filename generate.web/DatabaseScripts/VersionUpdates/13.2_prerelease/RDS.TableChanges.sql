    --Update the column name in ReportEDFactsSchoolPerformanceIndicators

   	IF COL_LENGTH('RDS.ReportEDFactsSchoolPerformanceIndicators', 'ECODISSTATUS') IS NOT NULL
	BEGIN
		exec sp_rename 'RDS.ReportEDFactsSchoolPerformanceIndicators.ECODISSTATUS', 'ECONOMICDISADVANTAGESTATUS', 'COLUMN';
	END

