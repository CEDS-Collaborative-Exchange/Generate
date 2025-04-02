	--set the new DimFactTypes column's value
	IF COL_LENGTH('RDS.DimFactTypes', 'FactTypeLabel') IS NOT NULL
	BEGIN

		update rds.dimFactTypes
		set FactTypeLabel = 'Child Count'
		where FactTypeCode = 'childcount';

		update rds.dimFactTypes
		set FactTypeLabel = 'Exiting'
		where FactTypeCode = 'exiting';

		update rds.dimFactTypes
		set FactTypeLabel = 'Membership'
		where FactTypeCode = 'membership';

		update rds.dimFactTypes
		set FactTypeLabel = 'Dropout'
		where FactTypeCode = 'dropout';

		update rds.dimFactTypes
		set FactTypeLabel = 'Graduates/Completers'
		where FactTypeCode = 'graduatescompleters';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title III English Learner Students - October'
		where FactTypeCode = 'titleIIIELOct';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title III English Learner Students - School Year'
		where FactTypeCode = 'titleIIIELSY';

		update rds.dimFactTypes
		set FactTypeLabel = 'Title I'
		where FactTypeCode = 'titleI';

		update rds.dimFactTypes
		set FactTypeLabel = 'Migrant Education Program'
		where FactTypeCode = 'migranteducationprogram';

		update rds.dimFactTypes
		set FactTypeLabel = 'Immigrant'
		where FactTypeCode = 'immigrant';

		update rds.dimFactTypes
		set FactTypeLabel = 'Neglected or Delinquent'
		where FactTypeCode = 'neglectedordelinquent';

		update rds.dimFactTypes
		set FactTypeLabel = 'Chronic Absenteeism'
		where FactTypeCode = 'chronic';

		update rds.dimFactTypes
		set FactTypeLabel = 'Graduation Rate'
		where FactTypeCode = 'graduationrate';

		update rds.dimFactTypes
		set FactTypeLabel = 'High School Graduates Postsecondary Enrollment'
		where FactTypeCode = 'hsgradpsenroll';

		update rds.dimFactTypes
		set FactTypeLabel = 'Assessment'
		where FactTypeCode = 'assessment';

		update rds.dimFactTypes
		set FactTypeLabel = 'Staff'
		where FactTypeCode = 'staff';

		update rds.dimFactTypes
		set FactTypeLabel = 'Directory'
		where FactTypeCode = 'directory';

		update rds.dimFactTypes
		set FactTypeLabel = 'Discipline'
		where FactTypeCode = 'discipline';

		update rds.dimFactTypes
		set FactTypeLabel = 'Comprehensive Support and Targeted Support Identification'
		where FactTypeCode = 'compsupport';

	END