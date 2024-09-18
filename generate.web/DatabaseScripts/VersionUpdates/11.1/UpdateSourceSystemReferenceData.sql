----------------------------------------------------------
--Add new mappings to Staging.SourceSystemReferenceData
----------------------------------------------------------

--check for existing 2023 assessment type administered mappings in SSRD
declare @ssrdCount int
set @ssrdCount = (select count(*) 
					from staging.SourceSystemReferencedata 
					where tablename = 'RefAssessmentTypeChildrenWithDisabilities'
					and schoolyear = 2023
				)

--Change the SSRD table name to match the new CEDS table name if rows for 2023 exist
if isnull(@ssrdCount, 0)  > 0
begin
	update staging.SourceSystemReferencedata 
	set TableName = 'RefAssessmentTypeAdministered'
	where TableName = 'RefAssessmentTypeChildrenWithDisabilities'
	and SchoolYear = 2023
end

--add the necessary assessment type administered rows for SSRD 
if isnull(@ssrdCount, 0) = 0
begin
	insert into staging.SourceSystemReferenceData (
		SchoolYear
		, TableName
		, TableFilter
		, InputCode
		, OutputCode
	)
	values 
	--standard assessment values
	(2023, 'RefAssessmentTypeAdministered', NULL, 'REGASSWOACC', 'REGASSWOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'REGASSWACC', 'REGASSWACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'ALTASSALTACH', 'ALTASSALTACH'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'ALTASSGRADELVL', 'ALTASSGRADELVL'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'ALTASSMODACH', 'ALTASSMODACH'),
	--new assessment values
	(2023, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWOACC', 'ADVASMTWOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWACC', 'ADVASMTWACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWOACC', 'IADAPLASMTWOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWACC', 'IADAPLASMTWACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWOACC', 'HSREGASMTIWOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWACC', 'HSREGASMTIWACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WOACC', 'HSREGASMT2WOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WACC', 'HSREGASMT2WACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WOACC', 'HSREGASMT3WOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WACC', 'HSREGASMT3WACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWOACC', 'LSNRHSASMTWOACC'),
	(2023, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWACC', 'LSNRHSASMTWACC')
end		
else --assessment type administered mappings exist for 2023 in SSRD
begin
	--new assessment ADVASMTWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'ADVASMTWOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWOACC', 'ADVASMTWOACC')
	end

	--new assessment ADVASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'ADVASMTWACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWACC', 'ADVASMTWACC')
	end

	--new assessment IADAPLASMTWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'IADAPLASMTWOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWOACC', 'IADAPLASMTWOACC')
	end

	--new assessment IADAPLASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'IADAPLASMTWACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWACC', 'IADAPLASMTWACC')
	end

	--new assessment HSREGASMTIWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMTIWOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWOACC', 'HSREGASMTIWOACC')
	end

	--new assessment HSREGASMTIWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMTIWACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWACC', 'HSREGASMTIWACC')
	end

	--new assessment HSREGASMT2WOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMT2WOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WOACC', 'HSREGASMT2WOACC')
	end

	--new assessment HSREGASMT2WACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMT2WACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WACC', 'HSREGASMT2WACC')
	end

	--new assessment HSREGASMT3WOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMT3WOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WOACC', 'HSREGASMT3WOACC')
	end

	--new assessment HSREGASMT3WACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'HSREGASMT3WACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WACC', 'HSREGASMT3WACC')
	end

	--new assessment LSNRHSASMTWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'LSNRHSASMTWOACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWOACC', 'LSNRHSASMTWOACC')
	end

	--new assessment LSNRHSASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2023
		and OutputCode = 'LSNRHSASMTWACC'
	) = 0
	begin 
		insert into staging.SourceSystemReferenceData (
			SchoolYear
			, TableName
			, TableFilter
			, InputCode
			, OutputCode
		)
		values 
		(2023, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWACC', 'LSNRHSASMTWACC')
	end

end

-------------------------------------------------------------
--Add new mappings for Assessment Reason Not Tested
-------------------------------------------------------------

--check for existing 2023 assessment reason not tested mappings in SSRD
set @ssrdCount = (select count(*) 
					from staging.SourceSystemReferencedata 
					where tablename = 'RefAssessmentReasonNotTested'
					and schoolyear = 2023
				)

--add the necessary assessment type reason not tested rows for SSRD 
if isnull(@ssrdCount, 0) = 0
begin
	insert into staging.SourceSystemReferenceData (
		SchoolYear
		, TableName
		, TableFilter
		, InputCode
		, OutputCode
	)
	values 
	(2023, 'RefAssessmentReasonNotTested', NULL, '03451', '03451'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '03455', '03455'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '03454', '03454'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '03456', '03456'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '03452', '03452'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '03453', '03453'),
	(2023, 'RefAssessmentReasonNotTested', NULL, '09999', '09999')    
end 