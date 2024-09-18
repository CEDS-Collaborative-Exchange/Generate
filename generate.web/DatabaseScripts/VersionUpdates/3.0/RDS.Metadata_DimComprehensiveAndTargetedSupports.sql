-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------
set nocount on
begin try
	begin transaction
		declare @ComprehensiveAndTargetedSupportId as int
		declare @ComprehensiveAndTargetedSupportCode as varchar(50)
		declare @ComprehensiveAndTargetedSupportDescription as varchar(200)

		declare @ComprehensiveSupportId as int
		declare @ComprehensiveSupportCode as varchar(50)
		declare @ComprehensiveSupportDescription as varchar(200)

		declare @TargetedSupportId as int
		declare @TargetedSupportCode as varchar(50)
		declare @TargetedSupportDescription as varchar(200)

		declare @ComprehensiveAndTargetedSupportsTable table(
				ComprehensiveAndTargetedSupportId int,
				ComprehensiveAndTargetedSupportCode varchar(50),
				ComprehensiveAndTargetedSupportDescription varchar(200),
				ComprehensiveAndTargetedSupportEdFactsCode varchar(50),

				ComprehensiveSupportId int,
				ComprehensiveSupportCode varchar(50),
				ComprehensiveSupportDescription varchar(200),
				ComprehensiveSupportEdFactsCode varchar(50),

				TargetedSupportId int,
				TargetedSupportCode varchar(50),
				TargetedSupportDescription varchar(200),
				TargetedSupportEdFactsCode varchar(50)
			); 

		-- =================================================================================================================================
		-- CSI
		-- CSI/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSI/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSI/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSI/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSI/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSI/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSI/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSI/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSI/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSI/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		4, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSI/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		4, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSI/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(1, 'CSI', 'Comprehensive Support and Improvement', 'CSI', 
		4, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSI
		-- TSI/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF',
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSI/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSI/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF',
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSI/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSI/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSI/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSI/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSI/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSI/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER',
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSI/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSI/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')

		-- TSI/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(2, 'TSI', 'Targeted Support and Improvement', 'TSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSIEXIT
		-- CSIEXIT/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSIEXIT/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSIEXIT/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSIEXIT/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSIEXIT/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSIEXIT/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- CSIEXIT/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSIEXIT/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSIEXIT/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================

		-- CSIEXIT/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- CSIEXIT/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- CSIEXIT/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(3, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 'CSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSIEXIT
		-- TSIEXIT/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSIEXIT/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSIEXIT/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSIEXIT/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSIEXIT/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSIEXIT/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSIEXIT/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- TSIEXIT/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- TSIEXIT/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- TSIEXIT/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')

		-- TSIEXIT/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')

		-- TSIEXIT/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(4, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 'TSIEXIT', 
		-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- NOTCSITSI
		-- NOTCSITSI/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- NOTCSITSI/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- NOTCSITSI/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- NOTCSITSI/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- NOTCSITSI/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- NOTCSITSI/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- NOTCSITSI/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- NOTCSITSI/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- NOTCSITSI/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- NOTCSITSI/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- NOTCSITSI/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- NOTCSITSI/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(5, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 'NOTCSITSI', 
		-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- MISSING
		-- MISSING/CSILOWPERF/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- MISSING/CSILOWPERF/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- MISSING/CSILOWPERF/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		1, 'CSILOWPERF', 'Lowest-performing school', 'CSILOWPERF', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- MISSING/CSILOWGR/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- MISSING/CSILOWGR/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- MISSING/CSILOWGR/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		2, 'CSILOWGR', 'Low graduation rate high school', 'CSILOWGR', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- MISSING/CSIOTHER/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- MISSING/CSIOTHER/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- MISSING/CSIOTHER/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		3, 'CSIOTHER', 'Additional targeted support school not exiting such status', 'CSIOTHER', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- MISSING/MISSING/TSIUNDER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing', 
		1, 'TSIUNDER', 'Consistently underperforming subgroups school', 'TSIUNDER')
		-- MISSING/MISSING/TSIOTHER
		insert into @ComprehensiveAndTargetedSupportsTable ( ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing', 
		2, 'TSIOTHER', 'Additional targeted support and improvement school', 'TSIOTHER')
		-- MISSING/MISSING/MISSING
		insert into @ComprehensiveAndTargetedSupportsTable ( 
			ComprehensiveAndTargetedSupportId, ComprehensiveAndTargetedSupportCode, ComprehensiveAndTargetedSupportDescription, ComprehensiveAndTargetedSupportEdFactsCode,
			ComprehensiveSupportId, ComprehensiveSupportCode, ComprehensiveSupportDescription, ComprehensiveSupportEdFactsCode,
			TargetedSupportId, TargetedSupportCode, TargetedSupportDescription, TargetedSupportEdFactsCode) 
		values 
		(-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing', 
		-1, 'Missing', 'Missing', 'Missing')
		-- =================================================================================================================================
		-- cursor to add data
		DECLARE status_cursor CURSOR FOR 
		SELECT 
			ComprehensiveAndTargetedSupportId, 
			ComprehensiveAndTargetedSupportCode, 
			ComprehensiveAndTargetedSupportDescription,

			ComprehensiveSupportId, 
			ComprehensiveSupportCode, 
			ComprehensiveSupportDescription, 

			TargetedSupportId, 
			TargetedSupportCode, 
			TargetedSupportDescription
		FROM @ComprehensiveAndTargetedSupportsTable

		OPEN status_cursor

		FETCH NEXT FROM status_cursor INTO 
			@ComprehensiveAndTargetedSupportId , @ComprehensiveAndTargetedSupportCode , @ComprehensiveAndTargetedSupportDescription ,
			@ComprehensiveSupportId , @ComprehensiveSupportCode , @ComprehensiveSupportDescription ,
			@TargetedSupportId , @TargetedSupportCode, @TargetedSupportDescription 

		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @ComprehensiveAndTargetedSupportCode = 'MISSING' and @ComprehensiveSupportCode='MISSING' and @TargetedSupportCode='MISSING'
			begin
				if not exists(select 1 from RDS.DimComprehensiveAndTargetedSupports 
					where ComprehensiveAndTargetedSupportCode = @ComprehensiveAndTargetedSupportCode
						and ComprehensiveSupportCode=@ComprehensiveSupportCode and TargetedSupportCode=@TargetedSupportCode)
				begin
					set identity_insert RDS.DimComprehensiveAndTargetedSupports on
					INSERT INTO RDS.DimComprehensiveAndTargetedSupports
					(
						DimComprehensiveAndTargetedSupportId,

						ComprehensiveAndTargetedSupportId, 
						ComprehensiveAndTargetedSupportCode, 
						ComprehensiveAndTargetedSupportDescription, 
						ComprehensiveAndTargetedSupportEdFactsCode,

						ComprehensiveSupportId, 
						ComprehensiveSupportCode, 
						ComprehensiveSupportDescription, 
						ComprehensiveSupportEdFactsCode,

						TargetedSupportId, 
						TargetedSupportCode, 
						TargetedSupportDescription, 
						TargetedSupportEdFactsCode
					)
					VALUES
					(
						-1,
						@ComprehensiveAndTargetedSupportId, 
						@ComprehensiveAndTargetedSupportCode, 
						@ComprehensiveAndTargetedSupportDescription,
						@ComprehensiveAndTargetedSupportCode,

						@ComprehensiveSupportId, 
						@ComprehensiveSupportCode, 
						@ComprehensiveSupportDescription,
						@ComprehensiveSupportCode,

						@TargetedSupportId, 
						@TargetedSupportCode, 
						@TargetedSupportDescription,
						@TargetedSupportCode
					)						

					set identity_insert RDS.DimComprehensiveAndTargetedSupports off
				end
			end
			else
			begin
				if not exists(select 1 from RDS.DimComprehensiveAndTargetedSupports 
					where ComprehensiveAndTargetedSupportCode = @ComprehensiveAndTargetedSupportCode
					and ComprehensiveSupportCode = @ComprehensiveSupportCode 
					and TargetedSupportCode = @TargetedSupportCode
					)
				begin
					INSERT INTO RDS.DimComprehensiveAndTargetedSupports
					(
						ComprehensiveAndTargetedSupportId, 
						ComprehensiveAndTargetedSupportCode, 
						ComprehensiveAndTargetedSupportDescription, 
						ComprehensiveAndTargetedSupportEdFactsCode,

						ComprehensiveSupportId, 
						ComprehensiveSupportCode, 
						ComprehensiveSupportDescription, 
						ComprehensiveSupportEdFactsCode,

						TargetedSupportId, 
						TargetedSupportCode, 
						TargetedSupportDescription, 
						TargetedSupportEdFactsCode
					)
					VALUES
					(
						@ComprehensiveAndTargetedSupportId, 
						@ComprehensiveAndTargetedSupportCode, 
						@ComprehensiveAndTargetedSupportDescription,
						@ComprehensiveAndTargetedSupportCode,

						@ComprehensiveSupportId, 
						@ComprehensiveSupportCode, 
						@ComprehensiveSupportDescription,
						@ComprehensiveSupportCode,

						@TargetedSupportId, 
						@TargetedSupportCode, 
						@TargetedSupportDescription,
						@TargetedSupportCode
					)
				end
			end
		FETCH NEXT FROM status_cursor INTO 
			@ComprehensiveAndTargetedSupportId , @ComprehensiveAndTargetedSupportCode , @ComprehensiveAndTargetedSupportDescription ,
			@ComprehensiveSupportId , @ComprehensiveSupportCode , @ComprehensiveSupportDescription ,
			@TargetedSupportId , @TargetedSupportCode, @TargetedSupportDescription 
		END
		CLOSE status_cursor
		DEALLOCATE status_cursor
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
