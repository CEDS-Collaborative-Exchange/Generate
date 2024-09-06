CREATE TABLE Staging.PersonRace (
    [ID]                       INT           IDENTITY (1, 1) NOT NULL,
    [Student_Identifier_State] VARCHAR (100) NULL,
    [Lea_Identifier_State]     VARCHAR (100) NULL,
    [School_Identifier_State]  VARCHAR (100) NULL,
    [RaceType]                 VARCHAR (100) NULL,
    [RecordStartDateTime]      DATETIME      NULL,
    [RecordEndDateTime]        DATETIME      NULL,
    [PersonDemographicRaceId]  INT           NULL,
    [RunDateTime]              DATETIME      NULL
	)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'Lea_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'School_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RaceType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefRace', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RaceType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonRace', @level2type = N'Column', @level2name = 'RecordStartDateTime' 
