-- Metadata changes for the ODS schema
----------------------------------
set nocount on
begin try
	begin transaction


		if not exists(select 1 from ods.RefAcademicCareerAndTechnicalOutcomesInProgram)
		begin
			
			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Earned high school course credits','EARNCRE','Earned high school course credits',1)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Enrolled in a GED program','ENROLLGED','Enrolled in a GED program',2)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Earned a GED','EARNGED','Earned a GED',3)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Obtained high school diploma','EARNDIPL','Obtained high school diploma',4)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Were accepted and/or enrolled into post-secondary education','POSTSEC','Were accepted and/or enrolled into post-secondary education',5)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Enrolled in job training courses/programs','ENROLLTRAIN','Enrolled in job training courses/programs',6)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesInProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Obtained employment','OBTAINEMP','Obtained employment',7)

		end

		if not exists(select 1 from ods.RefAcademicCareerAndTechnicalOutcomesExitedProgram)
		begin

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Enrolled in local district school','ENROLLSCH','Enrolled in local district school',1)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Earned high school course credits','EARNCRE','Earned high school course credits',2)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Enrolled in a GED program','ENROLLGED','Enrolled in a GED program',3)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Earned a GED','EARNGED','Earned a GED',4)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Obtained high school diploma','EARNDIPL','Obtained high school diploma',5)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Were accepted and/or enrolled into post-secondary education','POSTSEC','Were accepted and/or enrolled into post-secondary education',6)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Enrolled in job training courses/programs','ENROLLTRAIN','Enrolled in job training courses/programs',7)

			INSERT INTO [ODS].[RefAcademicCareerAndTechnicalOutcomesExitedProgram]([Description],[Code],[Definition],[SortOrder]) 
			VALUES('Obtained employment','OBTAINEMP','Obtained employment',8)

		end

		IF NOT EXISTS (SELECT * FROM [ODS].[RefVirtualSchoolStatus] WHERE Code = 'FaceVirtual')
		 INSERT INTO [ODS].[RefVirtualSchoolStatus] (
		  [Description]
		  ,[Code]
		  ,[Definition]
		 ) VALUES (
		  'Face Virtual'
		  ,'FaceVirtual'
		  ,'The school focuses on a systematic program of virtual instruction but includes some physical meetings among students or with teachers.'
		 )
		IF NOT EXISTS (SELECT * FROM [ODS].[RefVirtualSchoolStatus] WHERE Code = 'FullVirtual')
		 INSERT INTO [ODS].[RefVirtualSchoolStatus] (
		  [Description]
		  ,[Code]
		  ,[Definition]
		 ) VALUES (
		  'Full Virtual'
		  ,'FullVirtual'
		  ,'The school has no physical building where students meet with each other or with teachers and all instruction is virtual.'
		 )
		IF NOT EXISTS (SELECT * FROM [ODS].[RefVirtualSchoolStatus] WHERE Code = 'NotVirtual')
		 INSERT INTO [ODS].[RefVirtualSchoolStatus] (
		  [Description]
		  ,[Code]
		  ,[Definition]
		 ) VALUES (
		  'Not Virtual'
		  ,'NotVirtual'
		  ,'The school does not offer any virtual instruction.'
		 )
		IF NOT EXISTS (SELECT * FROM [ODS].[RefVirtualSchoolStatus] WHERE Code = 'SupplementalVirtual')
		 INSERT INTO [ODS].[RefVirtualSchoolStatus] (
		  [Description]
		  ,[Code]
		  ,[Definition]
		 ) VALUES (
		  'Supplemental Virtual'
		  ,'SupplementalVirtual'
		  ,'The school offers virtual courses but virtual instruction is not the primary means of instruction.'
		 )

		IF NOT EXISTS (SELECT * FROM [ODS].[RefProgramType] WHERE Code = 76000)
		INSERT INTO [ODS].[RefProgramType] (
			[Description]
			,[Code]
			,[Definition]
		) VALUES (
			'Homeless program'
			,76000
			,'Homeless program'
		)


	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
