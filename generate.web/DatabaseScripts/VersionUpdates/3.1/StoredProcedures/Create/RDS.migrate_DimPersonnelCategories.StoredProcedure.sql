CREATE PROCEDURE [RDS].[migrate_DimPersonnelCategories]
	@personnelDates as PersonnelDateTableType  READONLY
AS
BEGIN

	declare @k12PersonnelRoleId as int
	select @k12PersonnelRoleId = RoleId from ods.[Role] where Name = 'K12 Personnel'
	
	select 
		p.DimPersonnelId,
		sch.DimSchoolId,
		r.PersonId,
		d.DimCountDateId,		
		isnull(staffCat.Code, 'MISSING') as StaffCategorySpecialCode,
		isnull(classif.Code, 'MISSING') as StaffCategoryCCD,
		ISNULL (sTitle.Code, 'MISSING') as StaffCategoryTitle1Code,
		staff.FullTimeEquivalency
	from @personnelDates d
	inner join rds.DimPersonnel p on d.DimPersonnelId = p.DimPersonnelId
	inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId
		and r.RoleId = @k12PersonnelRoleId
	inner join ods.K12staffAssignment staff on r.OrganizationPersonRoleId = staff.OrganizationPersonRoleId
		and d.SubmissionYearDate between ISNULL(staff.RecordStartDateTime, d.SubmissionYearDate) and ISNULL(staff.RecordEndDateTime, GETDATE())	
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = r.OrganizationId
	left outer join ods.RefSpecialEducationStaffCategory staffCat on staff.RefSpecialEducationStaffCategoryId = staffCat.RefSpecialEducationStaffCategoryId
	left outer join ods.RefK12StaffClassification classif on staff.RefK12StaffClassificationId = classif.RefEducationStaffClassificationId
	left outer join ods.RefTitleIProgramStaffCategory sTitle on staff.RefTitleIProgramStaffCategoryId = sTitle.RefTitleIProgramStaffCategoryId
	
	where p.DimPersonnelId <> -1
	and r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)	
	order by p.DimPersonnelId	

END