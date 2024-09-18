-- Release-Specific metadata for the ODS schema
-- e.g. new reference data
----------------------------------
set nocount on
begin try
	begin transaction
	------------------------
	-- Place code here
	------------------------

	-- RefIndicatorStatusType
	-- c199
	if not exists (select * from ods.RefIndicatorStatusType where Code = 'GraduationRateIndicatorStatus')
		begin
			insert into ods.RefIndicatorStatusType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Graduation Rate Indicator Status', 'GraduationRateIndicatorStatus', 'Graduation Rate Indicator Status', null, 1.00)
		end
	-- c200
	if not exists (select * from ods.RefIndicatorStatusType where Code = 'AcademicAchievementIndicatorStatus')
		begin
			insert into ods.RefIndicatorStatusType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Academic Achievement Indicator Status', 'AcademicAchievementIndicatorStatus', 'Academic Achievement Indicator Status', null, 2.00)
		end
	-- c201
	if not exists (select * from ods.RefIndicatorStatusType where Code = 'OtherAcademicIndicatorStatus')
		begin
			insert into ods.RefIndicatorStatusType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Other Academic Indicator Status', 'OtherAcademicIndicatorStatus', 'Other Academic Indicator Status', null, 3.00)
		end
	-- c202
	if not exists (select * from ods.RefIndicatorStatusType where Code = 'SchoolQualityOrStudentSuccessIndicatorStatus')
		begin
			insert into ods.RefIndicatorStatusType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('School Quality or Student Success Indicator Status', 'SchoolQualityOrStudentSuccessIndicatorStatus', 'School Quality or Student Success Indicator Status', null, 4.00)
		end


	-- RefIndicatorStatusSubgroupType
	if not exists (select * from ods.RefIndicatorStatusSubgroupType where Code = 'RaceEthnicity')
		begin
			insert into ods.RefIndicatorStatusSubgroupType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Race Ethnicity', 'RaceEthnicity', 'Race Ethnicity', null, 1.00)
		end

	if not exists (select * from ods.RefIndicatorStatusSubgroupType where Code = 'DisabilityStatus')
		begin
			insert into ods.RefIndicatorStatusSubgroupType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Disability Status', 'DisabilityStatus', 'Disability Status', null, 2.00)
		end

	if not exists (select * from ods.RefIndicatorStatusSubgroupType where Code = 'EnglishLearnerStatus')
		begin
			insert into ods.RefIndicatorStatusSubgroupType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('English Learner Status', 'EnglishLearnerStatus', 'English Learner Status', null, 3.00)
		end

	if not exists (select * from ods.RefIndicatorStatusSubgroupType where Code = 'EconomicallyDisadvantagedStatus')
		begin
			insert into ods.RefIndicatorStatusSubgroupType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Economically DisadvantagedStatus', 'EconomicallyDisadvantagedStatus', 'Economically DisadvantagedStatus', null, 4.00)
		end

	if not exists (select * from ods.RefIndicatorStatusSubgroupType where Code = 'AllStudents')
		begin
			insert into ods.RefIndicatorStatusSubgroupType (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('All Students', 'AllStudents', 'All Students', null, 5.00)
		end


	-- RefIndicatorStateDefinedStatus
	if not exists (select * from ods.RefIndicatorStateDefinedStatus where Code = 'STTDEF')
		begin
			insert into ods.RefIndicatorStateDefinedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('State defined status', 'STTDEF', 'State defined status', null, 1.00)
		end

	if not exists (select * from ods.RefIndicatorStateDefinedStatus where Code = 'TOOFEW')
		begin
			insert into ods.RefIndicatorStateDefinedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Too few students', 'TOOFEW', 'Too few students', null, 2.00)
		end

	if not exists (select * from ods.RefIndicatorStateDefinedStatus where Code = 'NOSTUDENTS')
		begin
			insert into ods.RefIndicatorStateDefinedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('No students in the subgroup', 'NOSTUDENTS', 'No students in the subgroup', null, 3.00)
		end

	if not exists (select * from ods.RefIndicatorStateDefinedStatus where Code = 'MISSING')
		begin
			insert into ods.RefIndicatorStateDefinedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('The status of the indicator for a specific school is not available at the time the file is prepared.', 'MISSING', 'The status of the indicator for a specific school is not available at the time the file is prepared.', null, 4.00)
		end

	-- c203
	if not exists (select * from ods.RefUnexperiencedStatus where Code = 'TCHEXPRNCD')
		begin
			insert into ods.RefUnexperiencedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Experienced teachers', 'TCHEXPRNCD', 'Experienced teachers', null, 1.00)
		end

	if not exists (select * from ods.RefUnexperiencedStatus where Code = 'TCHINEXPRNCD')
		begin
			insert into ods.RefUnexperiencedStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Inexperienced teachers', 'TCHINEXPRNCD', 'Inexperienced teachers', null, 2.00)
		end


	if not exists (select * from ods.RefEmergencyOrProvisionalCredentialStatus where Code = 'TCHWEMRPRVCRD')
		begin
			insert into ods.RefEmergencyOrProvisionalCredentialStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Emergency or Provisional', 'TCHWEMRPRVCRD', 'Emergency or Provisional – Teachers with emergency or provisional credential ', null, 1.00)
		end

	if not exists (select * from ods.RefEmergencyOrProvisionalCredentialStatus where Code = 'TCHWOEMRPRVCRD')
		begin
			insert into ods.RefEmergencyOrProvisionalCredentialStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('No Emergency or Provisional', 'TCHWOEMRPRVCRD', 'No Emergency or Provisional – Teachers without emergency or provisional credential', null, 2.00)
		end


	if not exists (select * from ods.RefOutOfFieldStatus where Code = 'TCHINFLD')
		begin
			insert into ods.RefOutOfFieldStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Teaching in Field', 'TCHINFLD', 'Teaching in Field - Teachers teaching in the subject or field for which they are certified or licensed', null, 1.00)
		end

	if not exists (select * from ods.RefOutOfFieldStatus where Code = 'TCHOUTFLD')
		begin
			insert into ods.RefOutOfFieldStatus (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Not Teaching in Field', 'TCHOUTFLD', 'Not Teaching in Field - Teachers teaching in the subject or field for which they are not certified or license', null, 2.00)
		end

	-- c206
	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'CSI')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Comprehensive Support and Improvement', 'CSI', 'Comprehensive Support and Improvement', null, 1.00)
		end

	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'TSI')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Targeted Support and Improvement', 'TSI', 'Targeted Support and Improvement', null, 2.00)
		end

	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'CSIEXIT')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('CSI - Exit Status', 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', null, 3.00)
		end

	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'TSIEXIT')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('TSI - Exit Status', 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', null, 4.00)
		end

	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'NOTCSITSI')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Not CSI or TSI', 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', null, 5.00)
		end
	if not exists (select * from ods.RefComprehensiveAndTargetedSupport where Code = 'MISSING')
		begin
			insert into ods.RefComprehensiveAndTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('MISSING', 'MISSING', 'MISSING', null, 6.00)
		end


	if not exists (select * from ods.RefComprehensiveSupport where Code = 'CSILOWPERF')
		begin
			insert into ods.RefComprehensiveSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Lowest-performing school', 'CSILOWPERF', 'Lowest-performing school', null, 1.00)
		end

	if not exists (select * from ods.RefComprehensiveSupport where Code = 'CSILOWGR')
		begin
			insert into ods.RefComprehensiveSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Low graduation rate high school', 'CSILOWGR', 'Low graduation rate high school', null, 2.00)
		end

	if not exists (select * from ods.RefComprehensiveSupport where Code = 'CSIOTHER')
		begin
			insert into ods.RefComprehensiveSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Additional targeted support school not exiting such status', 'CSIOTHER', 'Additional targeted support school not exiting such status', null, 3.00)
		end
	if not exists (select * from ods.RefComprehensiveSupport where Code = 'MISSING')
		begin
			insert into ods.RefComprehensiveSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('MISSING', 'MISSING', 'MISSING', null, 4.00)
		end


	if not exists (select * from ods.RefTargetedSupport where Code = 'TSIUNDER')
		begin
			insert into ods.RefTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Consistently underperforming subgroups school', 'TSIUNDER', 'Consistently underperforming subgroups school', null, 1.00)
		end

	if not exists (select * from ods.RefTargetedSupport where Code = 'TSIOTHER')
		begin
			insert into ods.RefTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('Additional targeted support and improvement school', 'TSIOTHER', 'Additional targeted support and improvement school', null, 2.00)
		end
	if not exists (select * from ods.RefTargetedSupport where Code = 'MISSING')
		begin
			insert into ods.RefTargetedSupport (Description, Code, Definition, RefJurisdictionId, SortOrder)
			values ('MISSING', 'MISSING', 'MISSING', null, 3.00)
		end

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
