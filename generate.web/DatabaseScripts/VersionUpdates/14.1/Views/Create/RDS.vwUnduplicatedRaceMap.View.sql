CREATE VIEW [RDS].[vwUnduplicatedRaceMap] 
AS 
    SELECT 
        StudentIdentifierState
        , LeaIdentifierSeaAccountability
	    , SchoolIdentifierSea
        , RaceMap
        , SchoolYear
    FROM (
        SELECT 
            StudentIdentifierState
            , LeaIdentifierSeaAccountability
            , SchoolIdentifierSea
            , CASE
                WHEN COUNT(InputCode) > 1 OR MAX(sssrd.OutputCode) = 'DemographicRaceTwoOrMoreRaces'
                    -- Either the student has multiple distinct race records, or their single
                    -- record is already self-identified as multi-race (whichever InputCode
                    -- spelling was used) - normalize both to the current canonical InputCode
                    -- so downstream joins to RDS.DimRaces resolve consistently.
                    -- Prefer an InputCode that actually resolves to a current RDS.DimRaces
                    -- row (via RaceMap) - there can be more than one InputCode mapped to the
                    -- 'DemographicRaceTwoOrMoreRaces' OutputCode (e.g. a retired legacy
                    -- spelling alongside the current one), and only one of them is valid.
                    THEN (select top 1 sssrd2.inputcode
                                   from staging.SourceSystemReferenceData sssrd2
                                   inner join RDS.vwDimRaces rdr2
                                       on rdr2.RaceMap = sssrd2.InputCode
                                       and rdr2.SchoolYear = sssrd2.SchoolYear
                                   where sssrd2.TableName = 'refRace'
                                   and sssrd2.schoolyear = spr.SchoolYear
                                   and sssrd2.outputcode = 'DemographicRaceTwoOrMoreRaces'
                            )
                    ELSE max(sssrd.InputCode)
            END as RaceMap
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
    ) stagingRaces
			
