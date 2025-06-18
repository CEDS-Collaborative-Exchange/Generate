CREATE TABLE [Staging].[PrimaryDisability] (
    [Student_Identifier_State] VARCHAR (100) NULL,
    [DisabilityType]           VARCHAR (100) NULL,
    [RecordStartDateTime]      DATETIME      NULL,
    [RecordEndDateTime]        DATETIME      NULL,
    [PersonId]                 INT           NULL,
    [RunDateTime]              DATETIME      NULL
);

EXECUTE sp_addextendedproperty @name = N'Lookup', @value = N'RefDisabilityType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PrimaryDisability', @level2type = N'COLUMN', @level2name = N'DisabilityType';
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PrimaryDisability', @level2type = N'COLUMN', @level2name = N'DisabilityType';
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PrimaryDisability', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PrimaryDisability', @level2type = N'COLUMN', @level2name = N'Student_Identifier_State';
