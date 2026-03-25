CREATE PROCEDURE [RDS].[Populate_DimOrganizationCalendarSession]
	@SchoolYear SMALLINT = NULL
AS

	WITH ocs AS (
		SELECT DISTINCT
			  cs.BeginDate
			, cs.EndDate
			, st.Code AS SessionCode
			, st.Description AS SessionDescription
			, atd.Code AS AcademicTermDesignatorCode
			, atd.Description AS AcademicTermDesignatorDescription
		FROM dbo.OrganizationCalendarSession cs
		JOIN dbo.RefSessionType st
			ON cs.RefSessionTypeId = st.RefSessionTypeId
		JOIN dbo.RefAcademicTermDesignator atd
			ON cs.RefAcademicTermDesignatorId = atd.RefAcademicTermDesignatorId
	)
	MERGE RDS.DimOrganizationCalendarSession AS trgt
	USING ocs AS src
		ON trgt.BeginDate = src.BeginDate
		AND trgt.EndDate = src.EndDate
		AND trgt.SessionCode = src.SessionCode
		AND trgt.AcademicTermDesignatorCode = src.AcademicTermDesignatorCode
	WHEN NOT MATCHED THEN
		INSERT (
			  BeginDate
			, EndDate
			, SessionCode
			, SessionDescription
			, AcademicTermDesignatorCode
			, AcademicTermDesignatorDescription
			)
		VALUES (
			  src.BeginDate
			, src.EndDate
			, src.SessionCode
			, src.SessionDescription
			, src.AcademicTermDesignatorCode
			, src.AcademicTermDesignatorDescription
			);