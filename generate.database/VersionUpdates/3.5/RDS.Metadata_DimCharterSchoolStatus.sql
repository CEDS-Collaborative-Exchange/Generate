--Populate DimCharterSchoolStatus table
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @appropriationmethodId AS INT
		DECLARE @appropriationmethodCode AS VARCHAR(50)
		DECLARE @appropriationmethodDescription AS VARCHAR(200)
		DECLARE @appropriationmethodEdFactsCode AS VARCHAR(50)

		DECLARE @charterschoolstatusTable TABLE
		(
			appropriationmethodId INT,
			appropriationmethodCode VARCHAR(50),
			appropriationmethodDescription VARCHAR(200),
			appropriationmethodEdFactsCode VARCHAR(50)
		); 

		INSERT INTO @charterschoolstatusTable (AppropriationMethodId, AppropriationMethodCode, AppropriationMethodDescription, AppropriationMethodEdFactsCode) 
		VALUES 
		(-1, 'MISSING', 'Missing', 'MISSING')

		INSERT INTO @charterschoolstatusTable (AppropriationMethodId, AppropriationMethodCode, AppropriationMethodDescription, AppropriationMethodEdFactsCode) 
		VALUES 
		(1, 'STEAPRDRCT', 'Direct from state', 'STEAPRDRCT')

		INSERT INTO @charterschoolstatusTable (AppropriationMethodId, AppropriationMethodCode, AppropriationMethodDescription, AppropriationMethodEdFactsCode)  
		VALUES 
		(2, 'STEAPRTHRULEA', 'Through local school district', 'STEAPRTHRULEA')
		
		INSERT INTO @charterschoolstatusTable (AppropriationMethodId, AppropriationMethodCode, AppropriationMethodDescription, AppropriationMethodEdFactsCode)  
		VALUES 
		(3, 'STEAPRALLOCLEA', 'Allocation by local school district', 'STEAPRALLOCLEA')			

		DECLARE charterschoolstatus_cursor CURSOR FOR 
		SELECT AppropriationMethodId, AppropriationMethodCode, AppropriationMethodDescription, AppropriationMethodEdFactsCode
		FROM @charterschoolstatusTable

		OPEN charterschoolstatus_cursor

		FETCH NEXT FROM charterschoolstatus_cursor INTO @appropriationmethodId, @appropriationmethodCode, @appropriationmethodDescription, @appropriationmethodEdFactsCode
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF  @AppropriationMethodCode = 'MISSING'
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM RDS.[DimCharterSchoolStatus] WHERE AppropriationMethodCode = @AppropriationMethodCode)
					BEGIN
						SET IDENTITY_INSERT RDS.[DimCharterSchoolStatus] ON
							INSERT INTO [RDS].[DimCharterSchoolStatus] 
								([DimCharterSchoolStatusId]
								,[AppropriationMethodId]
								,[AppropriationMethodCode]
								,[AppropriationMethodDescription]
								,[AppropriationMethodEdFactsCode])
								VALUES(-1,@appropriationmethodId, @appropriationmethodCode, @appropriationmethodDescription, @appropriationmethodEdFactsCode)						

						SET IDENTITY_INSERT RDS.[DimCharterSchoolStatus] OFF
					END
				END
			ELSE
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM RDS.[DimCharterSchoolStatus] WHERE AppropriationMethodCode = @appropriationmethodCode)
					BEGIN
						INSERT INTO [RDS].[DimCharterSchoolStatus] 
							([AppropriationMethodId],[AppropriationMethodCode],[AppropriationMethodDescription],[AppropriationMethodEdFactsCode])
							VALUES(@appropriationmethodId, @appropriationmethodCode, @appropriationmethodDescription, @appropriationmethodEdFactsCode)			
					END
				END
		FETCH NEXT FROM charterschoolstatus_cursor INTO @appropriationmethodId, @appropriationmethodCode, @appropriationmethodDescription, @appropriationmethodEdFactsCode
		END
		CLOSE charterschoolstatus_cursor
		DEALLOCATE charterschoolstatus_cursor
	COMMIT TRANSACTION
END TRY
 
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()
	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
END CATCH
 
SET NOCOUNT OFF
