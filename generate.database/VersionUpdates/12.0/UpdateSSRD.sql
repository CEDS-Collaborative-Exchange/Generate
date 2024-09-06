	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWOACC_1', 'ADVASMTWOACC')
	end

	--new assessment ADVASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'ADVASMTWACC_1', 'ADVASMTWACC')
	end

	--new assessment IADAPLASMTWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWOACC_1', 'IADAPLASMTWOACC')
	end

	--new assessment IADAPLASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'IADAPLASMTWACC_1', 'IADAPLASMTWACC')
	end

	--new assessment HSREGASMTIWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWOACC_1', 'HSREGASMTIWOACC')
	end

	--new assessment HSREGASMTIWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMTIWACC_1', 'HSREGASMTIWACC')
	end

	--new assessment HSREGASMT2WOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WOACC_1', 'HSREGASMT2WOACC')
	end

	--new assessment HSREGASMT2WACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT2WACC_1', 'HSREGASMT2WACC')
	end

	--new assessment HSREGASMT3WOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WOACC_1', 'HSREGASMT3WOACC')
	end

	--new assessment HSREGASMT3WACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'HSREGASMT3WACC_1', 'HSREGASMT3WACC')
	end

	--new assessment LSNRHSASMTWOACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWOACC_1', 'LSNRHSASMTWOACC')
	end

	--new assessment LSNRHSASMTWACC
	if (select count(*) 
		from staging.SourceSystemReferencedata 
		where tablename = 'RefAssessmentTypeAdministered'
		and schoolyear = 2024
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
		(2024, 'RefAssessmentTypeAdministered', NULL, 'LSNRHSASMTWACC_1', 'LSNRHSASMTWACC')
	end
