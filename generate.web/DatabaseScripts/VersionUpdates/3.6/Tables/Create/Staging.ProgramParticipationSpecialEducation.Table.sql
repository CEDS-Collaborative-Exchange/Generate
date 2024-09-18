CREATE TABLE Staging.ProgramParticipationSpecialEducation (
			 ID INT IDENTITY(1, 1) Primary Key
			,Student_Identifier_State VARCHAR(100)
			,LEA_Identifier_State VARCHAR(100)
			,School_Identifier_State VARCHAR(100)
			,ProgramParticipationBeginDate DATE
			,ProgramParticipationEndDate DATE NULL
			,SpecialEducationExitReason VARCHAR(100) NULL
			,IDEAEducationalEnvironmentForEarlyChildhood VARCHAR(100)
			,IDEAEducationalEnvironmentForSchoolAge VARCHAR(100)
			,PersonID INT
			,OrganizationID_School INT
			,OrganizationID_LEA INT NULL
			,LEAOrganizationID_Program INT
			,SchoolOrganizationID_Program INT
			,LEAOrganizationPersonRoleId_Program INT
			,SchoolOrganizationPersonRoleId_Program INT
			,PersonProgramParticipationID_LEA INT
			,PersonProgramParticipationID_School INT
			,RunDateTime DATETIME
		  );

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'Student_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'School_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'ProgramParticipationBeginDate' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'ProgramParticipationEndDate' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'SpecialEducationExitReason' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefSpecialEducationExitReason', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'SpecialEducationExitReason' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'IDEAEducationalEnvironmentForEarlyChildhood' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefIDEAEducationalEnvironmentEC', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'IDEAEducationalEnvironmentForEarlyChildhood' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'IDEAEducationalEnvironmentForSchoolAge' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefIDEAEducationalEnvironmentSchoolAge', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationSpecialEducation', @level2type = N'Column', @level2name = 'IDEAEducationalEnvironmentForSchoolAge' 
