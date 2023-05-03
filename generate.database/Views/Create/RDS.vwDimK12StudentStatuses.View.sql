CREATE VIEW [RDS].[vwDimK12StudentStatuses] 
AS
	SELECT DISTINCT
		  DimK12StudentStatusId
		, rsy.SchoolYear

--have to find these
		, MobilityStatus12moCode
		, CASE MobilityStatus12moCode
			WHEN 'QAD' THEN 1 
			ELSE -1
		  END AS MobilityStatus12moMap
		, MobilityStatusSYCode	
		, CASE MobilityStatusSYCode
			WHEN 'QMRSY' THEN 1 
			ELSE -1
		  END AS MobilityStatusSYMap
		, ReferralStatusCode	
		, CASE ReferralStatusCode
			WHEN 'ReferralServices' THEN 1 
			ELSE -1
		  END AS ReferralStatusMap
		, MobilityStatus36moCode
		, CASE MobilityStatus36moCode
			WHEN 'QAD36' THEN 1 
			ELSE -1
		  END AS MobilityStatus36moMap
		, PlacementStatusCode
		, CASE PlacementStatusCode
			WHEN 'Placed' THEN 1 
			WHEN 'NotPlaced' THEN 0 
			ELSE -1
		  END AS PlacementStatusMap
		, PlacementTypeCode		--ADVTRAIN, EMPLOYMENT, MILITARY, POSTSEC
		, PlacementTypeCode AS PlacementTypeMap
--

		, NSLPDirectCertificationIndicatorCode
		, CASE NSLPDirectCertificationIndicatorCode 
			WHEN 'YES' THEN 1 
			WHEN 'NO' THEN 0
			ELSE -1
		  END AS NSLPDirectCertificationIndicatorMap
	FROM rds.DimK12StudentStatuses rdkss
