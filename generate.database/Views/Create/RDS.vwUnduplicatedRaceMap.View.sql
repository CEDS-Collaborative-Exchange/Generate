CREATE   VIEW [RDS].[vwUnduplicatedRaceMap] 
AS 
       SELECT 
              StudentIdentifierState
              , LeaIdentifierSeaAccountability
		, SchoolIdentifierSea
              , rdr.RaceCode
              , SchoolYear
       FROM (
              SELECT 
                     StudentIdentifierState
                     , LeaIdentifierSeaAccountability
                     , SchoolIdentifierSea
					
                     , CASE 
                           WHEN COUNT(OutputCode) > 1 THEN 'TwoOrMoreRaces'
                           ELSE MAX(OutputCode)
                       END as RaceCode
                     , spr.SchoolYear
              FROM staging.K12PersonRace spr
              JOIN Staging.SourceSystemReferenceData sssrd
                     ON spr.RaceType = sssrd.InputCode
                     AND spr.SchoolYear = sssrd.SchoolYear
                     AND sssrd.TableName = 'RefRace'
              GROUP BY
                     StudentIdentifierState
                     , LeaIdentifierSeaAccountability
                     , SchoolIdentifierSea
                     , spr.SchoolYear
					 
       ) AS stagingRaces
       JOIN RDS.DimRaces rdr
              ON stagingRaces.RaceCode = rdr.RaceCode
			
