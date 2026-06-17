-----------------------------------------------------
--Modify Staging.K12Enrollment field lengths
-----------------------------------------------------
    --truncate the table so there are no conflicts with existing data
        TRUNCATE TABLE Staging.K12Enrollment

    --update the field lengths
        IF COL_LENGTH('Staging.K12Enrollment', 'FirstName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ALTER COLUMN FirstName NVARCHAR(75);
        END
 
        IF COL_LENGTH('Staging.K12Enrollment', 'MiddleName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ALTER COLUMN MiddleName NVARCHAR(75);
        END

        IF COL_LENGTH('Staging.K12Enrollment', 'LastOrSurname') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ALTER COLUMN LastOrSurname NVARCHAR(75);
        END

