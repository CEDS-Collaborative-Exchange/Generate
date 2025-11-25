--Add default SSRD values to convert PostSecondary Enrollment Status for FS160
	if not exists (select 1 
					from staging.SourceSystemReferenceData 
					where tablename = 'RefPostsecondaryEnrollmentStatus'
					and SchoolYear = '2025')
	begin
		insert into staging.SourceSystemReferenceData 
		values ('2025', 'RefPostsecondaryEnrollmentStatus', NULL, '01','01'),
			('2025', 'RefPostsecondaryEnrollmentStatus', NULL, '02','02'),
			('2025', 'RefPostsecondaryEnrollmentStatus', NULL, '03','03'),
			('2025', 'RefPostsecondaryEnrollmentStatus', NULL, '04','04'),
			('2025', 'RefPostsecondaryEnrollmentStatus', NULL, '05','05')
	end
