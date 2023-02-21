/********************************************************************
*
*	Updated on 01/07/2021
*
*********************************************************************/

set nocount on
begin try
 
	begin transaction
 
	DECLARE @recordIds TABLE
	(
	  Id int
	)
		declare @TableTypeId as int
		declare @GenerateReportId as varchar(500)
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
 
		----------------------
		-- c002
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (19)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 19)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(19, 'IDEADISAB', 'Children with Disabilities (IDEA) School Age Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEADISAB', [TableTypeName] = 'Children with Disabilities (IDEA) School Age Tables' where EdFactsTableTypeId = 19
		END
 
 
		----------------------
		-- c005
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c005' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (20)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 20)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(20, 'CHDISDSPL', 'Children with Disabilities (IDEA) Removal Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHDISDSPL', [TableTypeName] = 'Children with Disabilities (IDEA) Removal Table' where EdFactsTableTypeId = 20
		END
 
 
		----------------------
		-- c006
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c006' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (23)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 23)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(23, 'IDEASUSEXPL', 'Children with Disabilities (IDEA) Suspensions/Expulsions Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEASUSEXPL', [TableTypeName] = 'Children with Disabilities (IDEA) Suspensions/Expulsions Table' where EdFactsTableTypeId = 23
		END
 
 
		----------------------
		-- c007
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c007' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (22)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 22)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(22, 'IDEAREMOV', 'Children with Disabilities (IDEA) Reasons for Unilateral Removal Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEAREMOV', [TableTypeName] = 'Children with Disabilities (IDEA) Reasons for Unilateral Removal Table' where EdFactsTableTypeId = 22
		END
 
 
		----------------------
		-- c009
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c009' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (21)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 21)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(21, 'IDEAEXITSPED', 'Children with Disabilities (IDEA) Exiting Special Education Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEAEXITSPED', [TableTypeName] = 'Children with Disabilities (IDEA) Exiting Special Education Tables' where EdFactsTableTypeId = 21
		END
 
 
		----------------------
		-- c032
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c032' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (6)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 6)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(6, 'DROPOUTCNT', 'Dropouts Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'DROPOUTCNT', [TableTypeName] = 'Dropouts Table' where EdFactsTableTypeId = 6
		END
 
 
		----------------------
		-- c033
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (250)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 250)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(250, 'DIRECTCERT', 'Direct Certification' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'DIRECTCERT', [TableTypeName] = 'Direct Certification' where EdFactsTableTypeId = 250
		END
 
		insert into @recordIds (Id) values (32)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 32)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(32, 'LUNCHFREERED', 'Free and Reduced Price Lunch Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LUNCHFREERED', [TableTypeName] = 'Free and Reduced Price Lunch Table' where EdFactsTableTypeId = 32
		END
 
 
		----------------------
		-- c037
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c037' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (71)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 71)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(71, 'TITLEIPART', 'Title I  Participation Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TITLEIPART', [TableTypeName] = 'Title I  Participation Tables' where EdFactsTableTypeId = 71
		END
 
 
		----------------------
		-- c040
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c040' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (12)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 12)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(12, 'GRADCNT', 'Graduates/Completers Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCNT', [TableTypeName] = 'Graduates/Completers Tables' where EdFactsTableTypeId = 12
		END
 
 
		----------------------
		-- c045
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c045' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (25)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 25)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(25, 'IMMIGRNT', 'Immigrant Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMMIGRNT', [TableTypeName] = 'Immigrant Table' where EdFactsTableTypeId = 25
		END
 
 
		----------------------
		-- c050
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c050' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (29)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 29)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(29, 'LEPENGPROFTST', 'Title III LEP English language proficiency results table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENGPROFTST', [TableTypeName] = 'Title III LEP English language proficiency results table' where EdFactsTableTypeId = 29
		END
 
 
		----------------------
		-- c052
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (33)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 33)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(33, 'MEMBER', 'Student Membership Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEMBER', [TableTypeName] = 'Student Membership Table' where EdFactsTableTypeId = 33
		END
 
 
		----------------------
		-- c054
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c054' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (36)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 36)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(36, 'MIGRNTSERV', 'Migrant Students Served Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MIGRNTSERV', [TableTypeName] = 'Migrant Students Served Tables' where EdFactsTableTypeId = 36
		END
 
 
		----------------------
		-- c059
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (131)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 131)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(131, 'CLASSTEACHFTE', 'Classroom Teachers (FTE)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CLASSTEACHFTE', [TableTypeName] = 'Classroom Teachers (FTE)' where EdFactsTableTypeId = 131
		END
 
		insert into @recordIds (Id) values (10)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 10)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(10, 'FTESTAFF', 'Staff FTE Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'FTESTAFF', [TableTypeName] = 'Staff FTE Tables' where EdFactsTableTypeId = 10
		END
 
 
		----------------------
		-- c067
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c067' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (60)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 60)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(60, 'TEACHCERTLEP', 'Title III Teachers Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHCERTLEP', [TableTypeName] = 'Title III Teachers Table' where EdFactsTableTypeId = 60
		END
 
		insert into @recordIds (Id) values (63)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 63)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(63, 'TEACHLEPNCERT', 'Teachers in LEP Programs Not Certified or Endorsed' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHLEPNCERT', [TableTypeName] = 'Teachers in LEP Programs Not Certified or Endorsed' where EdFactsTableTypeId = 63
		END
 
 
		----------------------
		-- c070
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c070' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (65)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 65)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(65, 'TEACHSPED', 'Special Education Teachers (FTE) Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHSPED', [TableTypeName] = 'Special Education Teachers (FTE) Table' where EdFactsTableTypeId = 65
		END
 
 
		----------------------
		-- c086
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c086' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (102)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 102)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(102, 'CHLINVWFRARM', 'Students involved with firearms table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHLINVWFRARM', [TableTypeName] = 'Students involved with firearms table' where EdFactsTableTypeId = 102
		END
 
 
		----------------------
		-- c088
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c088' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (104)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 104)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(104, 'CHWDSBDSPACT', 'Children with Disabilities (IDEA) Disciplinary Removals Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHWDSBDSPACT', [TableTypeName] = 'Children with Disabilities (IDEA) Disciplinary Removals Table' where EdFactsTableTypeId = 104
		END
 
 
		----------------------
		-- c089
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (110)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 110)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(110, 'CHWDSBERLCHD', 'Children with Disabilities (IDEA) Early Childhood Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHWDSBERLCHD', [TableTypeName] = 'Children with Disabilities (IDEA) Early Childhood Tables' where EdFactsTableTypeId = 110
		END
 
 
		----------------------
		-- c099
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c099' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (108)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 108)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(108, 'SPEDUPERSNL', 'Special Education Personnel Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SPEDUPERSNL', [TableTypeName] = 'Special Education Personnel Tables' where EdFactsTableTypeId = 108
		END
 
 
		----------------------
		-- c112
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c112' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (132)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 132)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(132, 'SPEDPARAPROF', 'Special Education Paraprofessionals Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SPEDPARAPROF', [TableTypeName] = 'Special Education Paraprofessionals Tables' where EdFactsTableTypeId = 132
		END
 
 
		----------------------
		-- c113
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c113' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (136)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 136)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(136, 'NDACADOCOMESEA', 'Neglected or Delinquent Academic Outcomes (SEA)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NDACADOCOMESEA', [TableTypeName] = 'Neglected or Delinquent Academic Outcomes (SEA)' where EdFactsTableTypeId = 136
		END
 
 
		----------------------
		-- c116
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c116' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (143)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 143)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(143, 'TTLIIILEPSTDSRV', 'Title III LEP Students Served' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TTLIIILEPSTDSRV', [TableTypeName] = 'Title III LEP Students Served' where EdFactsTableTypeId = 143
		END
 
		insert into @recordIds (Id) values (266)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 266)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(266, 'TTLIIILIEPSTDSRV', 'Title III students served in English language instruction program table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TTLIIILIEPSTDSRV', [TableTypeName] = 'Title III students served in English language instruction program table' where EdFactsTableTypeId = 266
		END
 
 
		----------------------
		-- c118
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c118' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (145)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 145)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(145, 'HOMLESENROLCNT', 'Homeless Students Enrolled - School Year Count' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HOMLESENROLCNT', [TableTypeName] = 'Homeless Students Enrolled - School Year Count' where EdFactsTableTypeId = 145
		END
 
 
		----------------------
		-- c119
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c119' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (141)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 141)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(141, 'NDPARTICSEA', 'Neglected or Delinquent Participation (SEA)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NDPARTICSEA', [TableTypeName] = 'Neglected or Delinquent Participation (SEA)' where EdFactsTableTypeId = 141
		END
 
 
		----------------------
		-- c121
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c121' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (147)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 147)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(147, 'MEPSTUDELIG', 'MEP Students Eligible' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEPSTUDELIG', [TableTypeName] = 'MEP Students Eligible' where EdFactsTableTypeId = 147
		END
 
 
		----------------------
		-- c122
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c122' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (148)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 148)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(148, 'MEPSTUDELIGSERV', 'MEP Students Eligible and Served' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEPSTUDELIGSERV', [TableTypeName] = 'MEP Students Eligible and Served' where EdFactsTableTypeId = 148
		END
 
 
		----------------------
		-- c125
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c125' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (137)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 137)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(137, 'NDACADOCOMELEA', 'Neglected or Delinquent Academic Outcomes (LEA)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NDACADOCOMELEA', [TableTypeName] = 'Neglected or Delinquent Academic Outcomes (LEA)' where EdFactsTableTypeId = 137
		END
 
 
		----------------------
		-- c126
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c126' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (144)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 144)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(144, 'LEPFORSTU', 'Title III Former Students Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPFORSTU', [TableTypeName] = 'Title III Former Students Tables' where EdFactsTableTypeId = 144
		END
 
 
		----------------------
		-- c127
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c127' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (142)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 142)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(142, 'NDPARTICLEA', 'Neglected or Delinquent Participation (LEA)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NDPARTICLEA', [TableTypeName] = 'Neglected or Delinquent Participation (LEA)' where EdFactsTableTypeId = 142
		END
 
 
		----------------------
		-- c132
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c132' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (8)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 8)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(8, 'ECOCIRCUM ', 'Students Economic Circumstance' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'ECOCIRCUM ', [TableTypeName] = 'Students Economic Circumstance' where EdFactsTableTypeId = 8
		END
 
		insert into @recordIds (Id) values (167)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 167)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(167, 'IMPFUNDALLOCA', 'School Improvement Funds Allocation - 1003(a)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMPFUNDALLOCA', [TableTypeName] = 'School Improvement Funds Allocation - 1003(a)' where EdFactsTableTypeId = 167
		END
 
		insert into @recordIds (Id) values (173)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 173)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(173, 'IMPFUNDALLOCG', 'School Improvement Funds Allocation - 1003(g)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMPFUNDALLOCG', [TableTypeName] = 'School Improvement Funds Allocation - 1003(g)' where EdFactsTableTypeId = 173
		END
 
		insert into @recordIds (Id) values (271)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 271)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(271, 'NCLBEND', 'GFSA reporting status' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NCLBEND', [TableTypeName] = 'GFSA reporting status' where EdFactsTableTypeId = 271
		END
 
		insert into @recordIds (Id) values (86)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 86)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(86, 'POVERTYPER', 'Poverty Percent' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'POVERTYPER', [TableTypeName] = 'Poverty Percent' where EdFactsTableTypeId = 86
		END
 
 
		----------------------
		-- c134
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c134' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (153)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 153)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(153, 'PARTTITLEI', 'Title I Participation Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'PARTTITLEI', [TableTypeName] = 'Title I Participation Tables' where EdFactsTableTypeId = 153
		END
 
 
		----------------------
		-- c137
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c137' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (160)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 160)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(160, 'LEPENGLANGTST', 'LEP English Language' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENGLANGTST', [TableTypeName] = 'LEP English Language' where EdFactsTableTypeId = 160
		END
 
 
		----------------------
		-- c138
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c138' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (161)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 161)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(161, 'TITLEIIILEPTST', 'Title III LEP English Language Testing File Specification' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TITLEIIILEPTST', [TableTypeName] = 'Title III LEP English Language Testing File Specification' where EdFactsTableTypeId = 161
		END
 
 
		----------------------
		-- c139
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c139' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (168)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 168)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(168, 'LEPSTUENGPROF', 'LEP - English Language Proficiency Results Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPSTUENGPROF', [TableTypeName] = 'LEP - English Language Proficiency Results Table' where EdFactsTableTypeId = 168
		END
 
 
		----------------------
		-- c141
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c141' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (163)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 163)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(163, 'LEPENROLLED', 'LEP Enrolled File Specifications' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENROLLED', [TableTypeName] = 'LEP Enrolled File Specifications' where EdFactsTableTypeId = 163
		END
 
 
		----------------------
		-- c142
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c142' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (164)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 164)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(164, 'CTECONACAD', 'Concentrators Academic Attainment Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONACAD', [TableTypeName] = 'Concentrators Academic Attainment Table' where EdFactsTableTypeId = 164
		END
 
 
		----------------------
		-- c143
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c143' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (165)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 165)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(165, 'CWDTOTDISREM', 'Children with Disabilities (IDEA) Total Disciplinary Removals Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CWDTOTDISREM', [TableTypeName] = 'Children with Disabilities (IDEA) Total Disciplinary Removals Table' where EdFactsTableTypeId = 165
		END
 
 
		----------------------
		-- c144
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c144' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (156)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 156)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(156, 'EDUSERVICES', 'Educational Services Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'EDUSERVICES', [TableTypeName] = 'Educational Services Table' where EdFactsTableTypeId = 156
		END
 
 
		----------------------
		-- c145
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c145' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (166)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 166)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(166, 'MEPSERVICES', 'MEP Services' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEPSERVICES', [TableTypeName] = 'MEP Services' where EdFactsTableTypeId = 166
		END
 
 
		----------------------
		-- c150
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c150' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (277)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 277)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(277, 'GRADRT10YRADJ', 'Ten-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT10YRADJ', [TableTypeName] = 'Ten-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 277
		END
 
		insert into @recordIds (Id) values (174)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 174)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(174, 'GRADRT4YRADJ', 'Four-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT4YRADJ', [TableTypeName] = 'Four-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 174
		END
 
		insert into @recordIds (Id) values (175)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 175)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(175, 'GRADRT5YRADJ', 'Five-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT5YRADJ', [TableTypeName] = 'Five-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 175
		END
 
		insert into @recordIds (Id) values (204)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 204)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(204, 'GRADRT6YRADJ', 'Six-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT6YRADJ', [TableTypeName] = 'Six-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 204
		END
 
		insert into @recordIds (Id) values (274)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 274)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(274, 'GRADRT7YRADJ', 'Seven-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT7YRADJ', [TableTypeName] = 'Seven-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 274
		END
 
		insert into @recordIds (Id) values (275)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 275)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(275, 'GRADRT8YRADJ', 'Eight-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT8YRADJ', [TableTypeName] = 'Eight-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 275
		END
 
		insert into @recordIds (Id) values (276)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 276)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(276, 'GRADRT9YRADJ', 'Nine-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRT9YRADJ', [TableTypeName] = 'Nine-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 276
		END
 
 
		----------------------
		-- c151
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c151' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (281)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 281)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(281, 'GRADCOHORT10YR', 'Cohorts for regulatory ten-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT10YR', [TableTypeName] = 'Cohorts for regulatory ten-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 281
		END
 
		insert into @recordIds (Id) values (176)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 176)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(176, 'GRADCOHORT4YR', 'Cohorts for regulatory four-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT4YR', [TableTypeName] = 'Cohorts for regulatory four-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 176
		END
 
		insert into @recordIds (Id) values (177)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 177)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(177, 'GRADCOHORT5YR', 'Cohorts for regulatory extended year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT5YR', [TableTypeName] = 'Cohorts for regulatory extended year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 177
		END
 
		insert into @recordIds (Id) values (205)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 205)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(205, 'GRADCOHORT6YR', 'Cohorts for regulatory six-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT6YR', [TableTypeName] = 'Cohorts for regulatory six-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 205
		END
 
		insert into @recordIds (Id) values (278)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 278)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(278, 'GRADCOHORT7YR', 'Cohorts for regulatory seven-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT7YR', [TableTypeName] = 'Cohorts for regulatory seven-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 278
		END
 
		insert into @recordIds (Id) values (279)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 279)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(279, 'GRADCOHORT8YR', 'Cohorts for regulatory eight-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT8YR', [TableTypeName] = 'Cohorts for regulatory eight-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 279
		END
 
		insert into @recordIds (Id) values (280)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 280)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(280, 'GRADCOHORT9YR', 'Cohorts for regulatory nine-year adjusted-cohort graduation rate table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADCOHORT9YR', [TableTypeName] = 'Cohorts for regulatory nine-year adjusted-cohort graduation rate table' where EdFactsTableTypeId = 280
		END
 
 
		----------------------
		-- c154
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c154' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (180)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 180)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(180, 'CTECONGR', 'CTE Concentrators in Graduation Rate Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONGR', [TableTypeName] = 'CTE Concentrators in Graduation Rate Table' where EdFactsTableTypeId = 180
		END
 
 
		----------------------
		-- c156
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c156' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (182)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 182)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(182, 'CTECONPRGNT', 'CTE Concentrators in Programs for Non-Traditional Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONPRGNT', [TableTypeName] = 'CTE Concentrators in Programs for Non-Traditional Table' where EdFactsTableTypeId = 182
		END
 
 
		----------------------
		-- c158
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c158' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (203)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 203)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(203, 'CTECONP', 'CTE Concentrators Placement Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONP', [TableTypeName] = 'CTE Concentrators Placement Table' where EdFactsTableTypeId = 203
		END
 
 
		----------------------
		-- c160
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c160' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (186)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 186)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(186, 'HSGRDPSENROLL', 'HS graduates postsecondary enrollment table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HSGRDPSENROLL', [TableTypeName] = 'HS graduates postsecondary enrollment table' where EdFactsTableTypeId = 186
		END
 
 
		----------------------
		-- c165
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c165' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (271)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 271)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(271, 'NCLBEND', 'GFSA reporting status' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'NCLBEND', [TableTypeName] = 'GFSA reporting status' where EdFactsTableTypeId = 271
		END
 
 
		----------------------
		-- c169
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c169' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (202)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 202)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(202, 'CTEPLACETYPE', 'CTE concentrators placement type table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTEPLACETYPE', [TableTypeName] = 'CTE concentrators placement type table' where EdFactsTableTypeId = 202
		END
 
 
		----------------------
		-- c175
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c175' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (50)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 50)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(50, 'STUDPERFM', 'Student Performance Table - Math' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFM', [TableTypeName] = 'Student Performance Table - Math' where EdFactsTableTypeId = 50
		END
 
 
		----------------------
		-- c178
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c178' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (49)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 49)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(49, 'STUDPERFLANG', 'Student Performance Table - Language Arts' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFLANG', [TableTypeName] = 'Student Performance Table - Language Arts' where EdFactsTableTypeId = 49
		END
 
		insert into @recordIds (Id) values (51)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 51)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(51, 'STUDPERFREAD', 'Student Performance Table - Reading ' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFREAD', [TableTypeName] = 'Student Performance Table - Reading ' where EdFactsTableTypeId = 51
		END
 
		insert into @recordIds (Id) values (52)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 52)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(52, 'STUDPERFRLA', 'Student Performance Table - Reading/Language Arts' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFRLA', [TableTypeName] = 'Student Performance Table - Reading/Language Arts' where EdFactsTableTypeId = 52
		END
 
 
		----------------------
		-- c179
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c179' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (53)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 53)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(53, 'STUDPERFS', 'Student Performance Table - Science' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFS', [TableTypeName] = 'Student Performance Table - Science' where EdFactsTableTypeId = 53
		END
 
 
		----------------------
		-- c180
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c180' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (228)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 228)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(228, 'LEANDINPROG', 'N or D academic and vocational outcomes in programs table- LEA' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEANDINPROG', [TableTypeName] = 'N or D academic and vocational outcomes in programs table- LEA' where EdFactsTableTypeId = 228
		END
 
		insert into @recordIds (Id) values (229)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 229)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(229, 'SEANDINPROG', 'N or D academic and vocational outcomes in programs table- State Agency' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SEANDINPROG', [TableTypeName] = 'N or D academic and vocational outcomes in programs table- State Agency' where EdFactsTableTypeId = 229
		END
 
 
		----------------------
		-- c181
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c181' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (231)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 231)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(231, 'LEANDEXIT', 'N or D academic and vocational outcomes exited programs - LEA' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEANDEXIT', [TableTypeName] = 'N or D academic and vocational outcomes exited programs - LEA' where EdFactsTableTypeId = 231
		END
 
		insert into @recordIds (Id) values (232)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 232)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(232, 'SEANDEXIT', 'N or D academic and vocational outcomes exited programs û state agency' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SEANDEXIT', [TableTypeName] = 'N or D academic and vocational outcomes exited programs û state agency' where EdFactsTableTypeId = 232
		END
 
 
		----------------------
		-- c185
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c185' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (201)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 201)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(201, 'STUPARTMATH', 'Assessment participation in mathematics table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTMATH', [TableTypeName] = 'Assessment participation in mathematics table' where EdFactsTableTypeId = 201
		END
 
 
		----------------------
		-- c188
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c188' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (200)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 200)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(200, 'STUPARTRLA', 'Assessment participation in reading/language arts table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTRLA', [TableTypeName] = 'Assessment participation in reading/language arts table' where EdFactsTableTypeId = 200
		END
 
 
		----------------------
		-- c189
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c189' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (246)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 246)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(246, 'STUPARTSCI', 'STUPARTSCI' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTSCI', [TableTypeName] = 'STUPARTSCI' where EdFactsTableTypeId = 246
		END
 
 
		----------------------
		-- c193
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c193' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (249)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 249)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(249, 'PARINRES', 'Parental involvement reservation' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'PARINRES', [TableTypeName] = 'Parental involvement reservation' where EdFactsTableTypeId = 249
		END
 
		insert into @recordIds (Id) values (248)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 248)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(248, 'TITLEIPALL', 'Title I, Part A Allocation' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TITLEIPALL', [TableTypeName] = 'Title I, Part A Allocation' where EdFactsTableTypeId = 248
		END
 
 
		----------------------
		-- c194
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c194' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (251)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 251)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(251, 'HOMEMVENTOPKS', 'Young homeless children served (McKinney-Vento) table ' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HOMEMVENTOPKS', [TableTypeName] = 'Young homeless children served (McKinney-Vento) table ' where EdFactsTableTypeId = 251
		END
 
 
		----------------------
		-- c195
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c195' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (252)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 252)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(252, 'CHRONABSENT', 'Chronic absenteeism table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHRONABSENT', [TableTypeName] = 'Chronic absenteeism table' where EdFactsTableTypeId = 252
		END
 
 
		----------------------
		-- c199
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c199' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (253)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 253)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(253, 'GRADRATESTATUS', 'Graduation rate indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRATESTATUS', [TableTypeName] = 'Graduation rate indicator status table' where EdFactsTableTypeId = 253
		END
 
 
		----------------------
		-- c200
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c200' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (258)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 258)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(258, 'ACADACHSTATUS', 'Academic achievement indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'ACADACHSTATUS', [TableTypeName] = 'Academic achievement indicator status table' where EdFactsTableTypeId = 258
		END
 
 
		----------------------
		-- c201
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c201' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (254)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 254)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(254, 'OTHACADSTATUS', 'Other academic indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'OTHACADSTATUS', [TableTypeName] = 'Other academic indicator status table' where EdFactsTableTypeId = 254
		END
 
 
		----------------------
		-- c202
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c202' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (255)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 255)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(255, 'SCHQUALSTAT', 'School quality or student success indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SCHQUALSTAT', [TableTypeName] = 'School quality or student success indicator status table' where EdFactsTableTypeId = 255
		END
 
 
		----------------------
		-- c203
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c203' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (260)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 260)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(260, 'TEACHER', 'Teachers table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHER', [TableTypeName] = 'Teachers table' where EdFactsTableTypeId = 260
		END
 
 
		----------------------
		-- c205
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c205' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (259)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 259)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(259, 'PROGENGLANSTATUS', 'Progress achieving English language proficiency indicator status' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'PROGENGLANSTATUS', [TableTypeName] = 'Progress achieving English language proficiency indicator status' where EdFactsTableTypeId = 259
		END
 
 
		----------------------
		-- c212
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (261)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 261)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(261, 'CSIREASONS', 'Comprehensive support identification table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CSIREASONS', [TableTypeName] = 'Comprehensive support identification table' where EdFactsTableTypeId = 261
		END
 
		insert into @recordIds (Id) values (262)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 262)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(262, 'TSIREASONS', 'Targeted support identification table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TSIREASONS', [TableTypeName] = 'Targeted support identification table' where EdFactsTableTypeId = 262
		END
 
----------------------
-- c206
----------------------
declare @TableTypeName nvarchar(50) = 'School Support and Improvement'
declare @TableTypeAbbrv nvarchar(50) = 'SCHOOLSUPIMPV'
select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206'
--insert into @recordIds (Id) values (259)
If Not exists (Select 1 from App.TableTypes where TableTypeAbbrv = @TableTypeAbbrv)
BEGIN
	INSERT INTO App.TableTypes
	([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
	VALUES
	(0, @TableTypeAbbrv, @TableTypeName)
	SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
	INSERT INTO App.GenerateReport_TableType
	([GenerateReportId], [TableTypeId])
	VALUES
	(@GenerateReportId, @TableTypeId)
END
ELSE
BEGIN
	UPDATE App.TableTypes Set [TableTypeAbbrv] = @TableTypeAbbrv, [TableTypeName] = @TableTypeName where TableTypeAbbrv = @TableTypeAbbrv
END
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