CREATE   VIEW [RDS].[vwUnduplicatedRaceMap] 
AS 
       SELECT 
                Student_Identifier_State
              , OrganizationIdentifier
			  , OrganizationType
              , rdr.RaceCode
              , SchoolYear
       FROM (
              SELECT 
                       Student_Identifier_State
                     , OrganizationIdentifier
                     , OrganizationType
					
                     , CASE 
                           WHEN COUNT(OutputCode) > 1 THEN 'TwoOrMoreRaces'
                           ELSE MAX(OutputCode)
                       END as RaceCode
                     , spr.SchoolYear
              FROM staging.PersonRace spr
              JOIN Staging.SourceSystemReferenceData sssrd
                     ON spr.RaceType = sssrd.InputCode
                     AND spr.SchoolYear = sssrd.SchoolYear
                     AND sssrd.TableName = 'RefRace'
              GROUP BY
                       Student_Identifier_State
                     , OrganizationIdentifier
                     , OrganizationType
                     , spr.SchoolYear
					 
       ) AS stagingRaces
       JOIN RDS.DimRaces rdr
              ON stagingRaces.RaceCode = rdr.RaceCode
			
