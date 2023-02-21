/*
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30

print 'set nocount on'
print 'begin try'
print ''
print '	begin transaction'
print ''

print '	DECLARE @recordIds TABLE'
print '	('
print '	  Id int'
print '	)'

declare @CategoryId as int
declare @CategoryCode as varchar(500)
declare @CategoryName as varchar(500)

declare @rowCntr as int
set @rowCntr = 0

DECLARE _cursor CURSOR FOR 
select c.CategoryId, c.CategoryAbbrv, 
case
    when c.CategoryPurpose is not null then rtrim(c.CategoryName) + ' (' + c.CategoryPurpose + ')'
    else c.CategoryName
end
FROM Category c
where c.CategoryId <> -100
order by c.CategoryId

OPEN _cursor
FETCH NEXT FROM _cursor INTO @CategoryId, @CategoryCode, @CategoryName

WHILE @@FETCH_STATUS = 0
BEGIN

	print '	insert into @recordIds (Id) values (' + convert(varchar(20), @CategoryId) + ')'

	set @CategoryName = rtrim(ltrim(replace(replace(replace(@CategoryName, '"', '\"'), char(13), ' '), char(10), ' ')));

    print '	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = '  + convert(varchar(20), @CategoryId) + ')'
	print '	BEGIN'
	print '		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) '
	print '		VALUES ('  + convert(varchar(20), @CategoryId) +', ''' + @CategoryCode + ''', ''' + @CategoryName + ''')'
	print '	END'
	print '	ELSE'
	print '	BEGIN'
	print '		UPDATE app.categories SET CategoryCode = ''' + @CategoryCode + ''', CategoryName = ''' + @CategoryName + ''''
	print '		where EdFactsCategoryId = '  + convert(varchar(20), @CategoryId) 
	print '	END'
	print''
    FETCH NEXT FROM _cursor INTO @CategoryId, @CategoryCode, @CategoryName
END

CLOSE _cursor
DEALLOCATE _cursor

-- Do not include this delete, since there may be some non-EDFacts data in there and we are also not including all school years
--print '	delete from app.categories where EdFactsCategoryId not in (select Id from @recordIds)'
--print ''

print '	commit transaction'

print ''

print 'end try'
print ''
print 'begin catch'
print '	IF @@TRANCOUNT > 0'
print '	begin'
print '		rollback transaction'
print '	end'

print '	declare @msg as nvarchar(max)'
print '	set @msg = ERROR_MESSAGE()'

print '	declare @sev as int'
print '	set @sev = ERROR_SEVERITY()'

print '	RAISERROR(@msg, @sev, 1)'

print 'end catch'

print ''
print 'set nocount off' 
*/

/*********************************************************************************
	Updated on 11/20/2020
**********************************************************************************/

set nocount on
begin try
 
	begin transaction
 
	DECLARE @recordIds TABLE
	(
	  Id int
	)
	insert into @recordIds (Id) values (1)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 1)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (1, 'ACADSUBAP', 'Academic Subject (AP Participation)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBAP', CategoryName = 'Academic Subject (AP Participation)'
		where EdFactsCategoryId = 1
	END
 
	insert into @recordIds (Id) values (2)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 2)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (2, 'ACADSUBASSES', 'Academic Subject (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBASSES', CategoryName = 'Academic Subject (Assessment)'
		where EdFactsCategoryId = 2
	END
 
	insert into @recordIds (Id) values (3)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 3)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (3, 'ACADSUBSECD', 'Academic Subject (Secondary)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBSECD', CategoryName = 'Academic Subject (Secondary)'
		where EdFactsCategoryId = 3
	END
 
	insert into @recordIds (Id) values (4)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 4)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (4, 'AGEEXITSPED', 'Age (Exiting)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEEXITSPED', CategoryName = 'Age (Exiting)'
		where EdFactsCategoryId = 4
	END
 
	insert into @recordIds (Id) values (5)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 5)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (5, 'AGEGRDMGRNT', 'Age/Grade (Migrant)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDMGRNT', CategoryName = 'Age/Grade (Migrant)'
		where EdFactsCategoryId = 5
	END
 
	insert into @recordIds (Id) values (6)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 6)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (6, 'AGEGRDTITLEI', 'Age/Grade (Title I)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDTITLEI', CategoryName = 'Age/Grade (Title I)'
		where EdFactsCategoryId = 6
	END
 
	insert into @recordIds (Id) values (7)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 7)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (7, 'AGEGRPDISCP', 'Age Group (Discipline)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRPDISCP', CategoryName = 'Age Group (Discipline)'
		where EdFactsCategoryId = 7
	END
 
	insert into @recordIds (Id) values (8)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 8)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (8, 'AGEGRPEXIT', 'Age Group (Exiting)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRPEXIT', CategoryName = 'Age Group (Exiting)'
		where EdFactsCategoryId = 8
	END
 
	insert into @recordIds (Id) values (9)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 9)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (9, 'AGEGRPIDEATCH', 'Age Group (IDEA Teachers)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRPIDEATCH', CategoryName = 'Age Group (IDEA Teachers)'
		where EdFactsCategoryId = 9
	END
 
	insert into @recordIds (Id) values (10)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 10)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (10, 'AGEGRPPLACE', 'Age Group (Placement)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRPPLACE', CategoryName = 'Age Group (Placement)'
		where EdFactsCategoryId = 10
	END
 
	insert into @recordIds (Id) values (11)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 11)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (11, 'AGEIDEAEC', 'Age (IDEA-EC)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEIDEAEC', CategoryName = 'Age (IDEA-EC)'
		where EdFactsCategoryId = 11
	END
 
	insert into @recordIds (Id) values (12)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 12)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (12, 'AGEIDEASA', 'Age (IDEA-SA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEIDEASA', CategoryName = 'Age (IDEA-SA)'
		where EdFactsCategoryId = 12
	END
 
	insert into @recordIds (Id) values (13)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 13)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (13, 'ASSESSADMIN', 'Assessment Administered (Participation)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASSESSADMIN', CategoryName = 'Assessment Administered (Participation)'
		where EdFactsCategoryId = 13
	END
 
	insert into @recordIds (Id) values (14)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 14)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (14, 'ASSESSINCL', 'Assessment Inclusion')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASSESSINCL', CategoryName = 'Assessment Inclusion'
		where EdFactsCategoryId = 14
	END
 
	insert into @recordIds (Id) values (15)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 15)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (15, 'BASISEXIT', 'Basis of Exit')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'BASISEXIT', CategoryName = 'Basis of Exit'
		where EdFactsCategoryId = 15
	END
 
	insert into @recordIds (Id) values (16)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 16)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (16, 'CERTSTATUS', 'Certification Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'CERTSTATUS', CategoryName = 'Certification Status'
		where EdFactsCategoryId = 16
	END
 
	insert into @recordIds (Id) values (17)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 17)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (17, 'COUNTRY', 'Country of Origin')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'COUNTRY', CategoryName = 'Country of Origin'
		where EdFactsCategoryId = 17
	END
 
	insert into @recordIds (Id) values (18)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 18)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (18, 'DIPLCREDTYPE', 'Diploma/Credential')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DIPLCREDTYPE', CategoryName = 'Diploma/Credential'
		where EdFactsCategoryId = 18
	END
 
	insert into @recordIds (Id) values (19)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 19)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (19, 'DISABCATIDEA', 'Disability Category (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABCATIDEA', CategoryName = 'Disability Category (IDEA)'
		where EdFactsCategoryId = 19
	END
 
	insert into @recordIds (Id) values (20)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 20)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (20, 'DISABOCRA', 'Disability Category (OCR Group A)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABOCRA', CategoryName = 'Disability Category (OCR Group A)'
		where EdFactsCategoryId = 20
	END
 
	insert into @recordIds (Id) values (21)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 21)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (21, 'DISABOCRB', 'Disability Category (OCR Group B)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABOCRB', CategoryName = 'Disability Category (OCR Group B)'
		where EdFactsCategoryId = 21
	END
 
	insert into @recordIds (Id) values (22)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 22)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (22, 'DISABSTATIDEA', 'Disability Status (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATIDEA', CategoryName = 'Disability Status (IDEA)'
		where EdFactsCategoryId = 22
	END
 
	insert into @recordIds (Id) values (23)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 23)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (23, 'DSCLPMNONDISAB', 'Discipline Method (Non-Disabled)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCLPMNONDISAB', CategoryName = 'Discipline Method (Non-Disabled)'
		where EdFactsCategoryId = 23
	END
 
	insert into @recordIds (Id) values (24)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 24)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (24, 'DSCLPR', 'Discipline Reason')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCLPR', CategoryName = 'Discipline Reason'
		where EdFactsCategoryId = 24
	END
 
	insert into @recordIds (Id) values (25)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 25)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (25, 'DSCPLIDEA', 'Discipline Reason (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCPLIDEA', CategoryName = 'Discipline Reason (IDEA)'
		where EdFactsCategoryId = 25
	END
 
	insert into @recordIds (Id) values (26)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 26)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (26, 'DSCPLMIDEA504', 'Discipline Method (IDEA/504)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCPLMIDEA504', CategoryName = 'Discipline Method (IDEA/504)'
		where EdFactsCategoryId = 26
	END
 
	insert into @recordIds (Id) values (27)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 27)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (27, 'DSCPLSDF', 'Discipline Reason (Safe and Drug-Free)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCPLSDF', CategoryName = 'Discipline Reason (Safe and Drug-Free)'
		where EdFactsCategoryId = 27
	END
 
	insert into @recordIds (Id) values (28)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 28)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (28, 'ECODIS', 'Economically Disadvantaged Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ECODIS', CategoryName = 'Economically Disadvantaged Status'
		where EdFactsCategoryId = 28
	END
 
	insert into @recordIds (Id) values (29)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 29)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (29, 'EDENVIREC', 'Educational Environment (Early Childhood)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIREC', CategoryName = 'Educational Environment (Early Childhood)'
		where EdFactsCategoryId = 29
	END
 
	insert into @recordIds (Id) values (30)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 30)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (30, 'EDENVIRIDEA', 'Educational Environment (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIRIDEA', CategoryName = 'Educational Environment (IDEA)'
		where EdFactsCategoryId = 30
	END
 
	insert into @recordIds (Id) values (31)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 31)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (31, 'EDENVIROCRSE60', 'Educational Environment (OCR SE60)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIROCRSE60', CategoryName = 'Educational Environment (OCR SE60)'
		where EdFactsCategoryId = 31
	END
 
	insert into @recordIds (Id) values (32)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 32)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (32, 'EDENVIROCRSPEC', 'Educational Environment (OCR Specific)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIROCRSPEC', CategoryName = 'Educational Environment (OCR Specific)'
		where EdFactsCategoryId = 32
	END
 
	insert into @recordIds (Id) values (33)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 33)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (33, 'ENGPROFLVL', 'English Proficiency Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ENGPROFLVL', CategoryName = 'English Proficiency Level'
		where EdFactsCategoryId = 33
	END
 
	insert into @recordIds (Id) values (34)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 34)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (34, 'FYRSTATUS', 'Full Academic Year Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FYRSTATUS', CategoryName = 'Full Academic Year Status'
		where EdFactsCategoryId = 34
	END
 
	insert into @recordIds (Id) values (35)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 35)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (35, 'GENDER', 'Gender')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GENDER', CategoryName = 'Gender'
		where EdFactsCategoryId = 35
	END
 
	insert into @recordIds (Id) values (36)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 36)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (36, 'GRADELDROP', 'Grade Level (Dropout)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELDROP', CategoryName = 'Grade Level (Dropout)'
		where EdFactsCategoryId = 36
	END
 
	insert into @recordIds (Id) values (37)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 37)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (37, 'GRADELVLASS', 'Grade Level (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVLASS', CategoryName = 'Grade Level (Assessment)'
		where EdFactsCategoryId = 37
	END
 
	insert into @recordIds (Id) values (38)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 38)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (38, 'GRADELVMEM', 'Grade Level (Membership)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVMEM', CategoryName = 'Grade Level (Membership)'
		where EdFactsCategoryId = 38
	END
 
	insert into @recordIds (Id) values (39)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 39)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (39, 'GRADELVPROM', 'Grade Level (Promotion)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVPROM', CategoryName = 'Grade Level (Promotion)'
		where EdFactsCategoryId = 39
	END
 
	insert into @recordIds (Id) values (40)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 40)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (40, 'GRADERGELIG', 'Grade Range (Eligible)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADERGELIG', CategoryName = 'Grade Range (Eligible)'
		where EdFactsCategoryId = 40
	END
 
	insert into @recordIds (Id) values (41)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 41)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (41, 'GRADERGSERV', 'Grade Range (Served)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADERGSERV', CategoryName = 'Grade Range (Served)'
		where EdFactsCategoryId = 41
	END
 
	insert into @recordIds (Id) values (42)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 42)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (42, 'HOMELESSUNAC', 'Homeless Unaccompanied Youth Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELESSUNAC', CategoryName = 'Homeless Unaccompanied Youth Status'
		where EdFactsCategoryId = 42
	END
 
	insert into @recordIds (Id) values (43)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 43)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (43, 'HOMELSPRMRES', 'Homeless Primary Nighttime Residence')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELSPRMRES', CategoryName = 'Homeless Primary Nighttime Residence'
		where EdFactsCategoryId = 43
	END
 
	insert into @recordIds (Id) values (44)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 44)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (44, 'HOMELSSRV', 'Homeless Served Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELSSRV', CategoryName = 'Homeless Served Status'
		where EdFactsCategoryId = 44
	END
 
	insert into @recordIds (Id) values (45)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 45)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (45, 'HOMELSSTATUS', 'Homeless Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELSSTATUS', CategoryName = 'Homeless Status'
		where EdFactsCategoryId = 45
	END
 
	insert into @recordIds (Id) values (47)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 47)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (47, 'IMGRNTSTATUS', 'Immigrant Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'IMGRNTSTATUS', CategoryName = 'Immigrant Status'
		where EdFactsCategoryId = 47
	END
 
	insert into @recordIds (Id) values (48)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 48)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (48, 'INSTRASEC', 'Instructional Assignment (Secondary)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INSTRASEC', CategoryName = 'Instructional Assignment (Secondary)'
		where EdFactsCategoryId = 48
	END
 
	insert into @recordIds (Id) values (49)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 49)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (49, 'INSTRASSG', 'Instructional Assignment')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INSTRASSG', CategoryName = 'Instructional Assignment'
		where EdFactsCategoryId = 49
	END
 
	insert into @recordIds (Id) values (50)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 50)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (50, 'INSTRLEPCRED', 'LEP Instructor Credential')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INSTRLEPCRED', CategoryName = 'LEP Instructor Credential'
		where EdFactsCategoryId = 50
	END
 
	insert into @recordIds (Id) values (51)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 51)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (51, 'INSTRSET', 'Instructional Setting')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INSTRSET', CategoryName = 'Instructional Setting'
		where EdFactsCategoryId = 51
	END
 
	insert into @recordIds (Id) values (52)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 52)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (52, 'INTERNETACC', 'Internet Access (Internet Access Type)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INTERNETACC', CategoryName = 'Internet Access (Internet Access Type)'
		where EdFactsCategoryId = 52
	END
 
	insert into @recordIds (Id) values (53)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 53)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (53, 'LANGASSES', 'Language (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LANGASSES', CategoryName = 'Language (Assessment)'
		where EdFactsCategoryId = 53
	END
 
	insert into @recordIds (Id) values (54)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 54)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (54, 'LANGHOME', 'Language (Home)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LANGHOME', CategoryName = 'Language (Home)'
		where EdFactsCategoryId = 54
	END
 
	insert into @recordIds (Id) values (55)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 55)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (55, 'LANGINSTRLEP', 'Type of Language Instruction for LEP Students')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LANGINSTRLEP', CategoryName = 'Type of Language Instruction for LEP Students'
		where EdFactsCategoryId = 55
	END
 
	insert into @recordIds (Id) values (56)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 56)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (56, 'LEPASSES', 'LEP Status (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPASSES', CategoryName = 'LEP Status (Assessment)'
		where EdFactsCategoryId = 56
	END
 
	insert into @recordIds (Id) values (57)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 57)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (57, 'LEPIMGRNT', 'LEP Status (Immigrant)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPIMGRNT', CategoryName = 'LEP Status (Immigrant)'
		where EdFactsCategoryId = 57
	END
 
	insert into @recordIds (Id) values (58)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 58)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (58, 'LEPOELA', 'LEP Status (OELA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPOELA', CategoryName = 'LEP Status (OELA)'
		where EdFactsCategoryId = 58
	END
 
	insert into @recordIds (Id) values (59)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 59)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (59, 'LEPPROGTIME', 'Time in Program for LEP Students')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPPROGTIME', CategoryName = 'Time in Program for LEP Students'
		where EdFactsCategoryId = 59
	END
 
	insert into @recordIds (Id) values (60)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 60)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (60, 'LEPTERMREASON', 'Reason for LEP Program Termination')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPTERMREASON', CategoryName = 'Reason for LEP Program Termination'
		where EdFactsCategoryId = 60
	END
 
	insert into @recordIds (Id) values (61)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 61)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (61, 'LUNCHPROG', 'Lunch Program Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LUNCHPROG', CategoryName = 'Lunch Program Status'
		where EdFactsCategoryId = 61
	END
 
	insert into @recordIds (Id) values (62)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 62)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (62, 'MEPPOS', 'Migrant Priority for Services Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPPOS', CategoryName = 'Migrant Priority for Services Status'
		where EdFactsCategoryId = 62
	END
 
	insert into @recordIds (Id) values (63)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 63)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (63, 'MEPSESSENROL', 'MEP Session Type (Enrollment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPSESSENROL', CategoryName = 'MEP Session Type (Enrollment)'
		where EdFactsCategoryId = 63
	END
 
	insert into @recordIds (Id) values (64)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 64)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (64, 'MEPSESSSERV', 'MEP Session Type (Services)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPSESSSERV', CategoryName = 'MEP Session Type (Services)'
		where EdFactsCategoryId = 64
	END
 
	insert into @recordIds (Id) values (65)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 65)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (65, 'MEPSESSSTF', 'MEP Session Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPSESSSTF', CategoryName = 'MEP Session Type'
		where EdFactsCategoryId = 65
	END
 
	insert into @recordIds (Id) values (66)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 66)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (66, 'MGRNTSERV', 'Migrant Service Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MGRNTSERV', CategoryName = 'Migrant Service Type'
		where EdFactsCategoryId = 66
	END
 
	insert into @recordIds (Id) values (67)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 67)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (67, 'MIGRNTSTATUS', 'Migratory Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MIGRNTSTATUS', CategoryName = 'Migratory Status'
		where EdFactsCategoryId = 67
	END
 
	insert into @recordIds (Id) values (68)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 68)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (68, 'MOBILITYSTATUS', 'Mobility Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MOBILITYSTATUS', CategoryName = 'Mobility Status'
		where EdFactsCategoryId = 68
	END
 
	insert into @recordIds (Id) values (69)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 69)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (69, 'NCLBSCHIMP', 'NCLB School Improvement Options')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NCLBSCHIMP', CategoryName = 'NCLB School Improvement Options'
		where EdFactsCategoryId = 69
	END
 
	insert into @recordIds (Id) values (70)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 70)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (70, 'NEGDELINSERV', 'Neglected or Delinquent Services Received')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NEGDELINSERV', CategoryName = 'Neglected or Delinquent Services Received'
		where EdFactsCategoryId = 70
	END
 
	insert into @recordIds (Id) values (71)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 71)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (71, 'NEGDELINSTATUS', 'Neglected or Delinquent Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NEGDELINSTATUS', CategoryName = 'Neglected or Delinquent Status'
		where EdFactsCategoryId = 71
	END
 
	insert into @recordIds (Id) values (72)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 72)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (72, 'PARAPROFQUAL', 'Paraprofessional Qualification')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARAPROFQUAL', CategoryName = 'Paraprofessional Qualification'
		where EdFactsCategoryId = 72
	END
 
	insert into @recordIds (Id) values (73)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 73)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (73, 'PARAPROFTYPE', 'Staff Category (Paraprofessionals)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARAPROFTYPE', CategoryName = 'Staff Category (Paraprofessionals)'
		where EdFactsCategoryId = 73
	END
 
	insert into @recordIds (Id) values (74)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 74)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (74, 'PERFLVL', 'Performance Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PERFLVL', CategoryName = 'Performance Level'
		where EdFactsCategoryId = 74
	END
 
	insert into @recordIds (Id) values (75)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 75)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (75, 'QUAL', 'Qualification Presence')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'QUAL', CategoryName = 'Qualification Presence'
		where EdFactsCategoryId = 75
	END
 
	insert into @recordIds (Id) values (76)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 76)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (76, 'RACEETHNIC', 'Racial Ethnic')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'RACEETHNIC', CategoryName = 'Racial Ethnic'
		where EdFactsCategoryId = 76
	END
 
	insert into @recordIds (Id) values (77)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 77)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (77, 'REMOVALTYPE', 'Removal Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALTYPE', CategoryName = 'Removal Type'
		where EdFactsCategoryId = 77
	END
 
	insert into @recordIds (Id) values (78)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 78)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (78, 'SEC504STATUS', 'Section 504 Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SEC504STATUS', CategoryName = 'Section 504 Status'
		where EdFactsCategoryId = 78
	END
 
	insert into @recordIds (Id) values (79)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 79)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (79, 'SERVICETYPE', 'Type of Services Received')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SERVICETYPE', CategoryName = 'Type of Services Received'
		where EdFactsCategoryId = 79
	END
 
	insert into @recordIds (Id) values (80)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 80)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (80, 'SNGPARPREG', 'Single Parents Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SNGPARPREG', CategoryName = 'Single Parents Status'
		where EdFactsCategoryId = 80
	END
 
	insert into @recordIds (Id) values (81)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 81)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (81, 'STAFFCATGCCD', 'Staff Category (CCD)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFCATGCCD', CategoryName = 'Staff Category (CCD)'
		where EdFactsCategoryId = 81
	END
 
	insert into @recordIds (Id) values (82)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 82)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (82, 'STAFFCATGMEP', 'Staff Category (MEP)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFCATGMEP', CategoryName = 'Staff Category (MEP)'
		where EdFactsCategoryId = 82
	END
 
	insert into @recordIds (Id) values (83)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 83)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (83, 'STAFFCATGSCH', 'Staff Category (School)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFCATGSCH', CategoryName = 'Staff Category (School)'
		where EdFactsCategoryId = 83
	END
 
	insert into @recordIds (Id) values (84)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 84)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (84, 'STAFFCATTECH', 'Staff Category (Technology)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFCATTECH', CategoryName = 'Staff Category (Technology)'
		where EdFactsCategoryId = 84
	END
 
	insert into @recordIds (Id) values (85)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 85)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (85, 'STAFFTITLEI', 'Staff Category (Title I)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFTITLEI', CategoryName = 'Staff Category (Title I)'
		where EdFactsCategoryId = 85
	END
 
	insert into @recordIds (Id) values (86)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 86)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (86, 'TEACHCRED', 'Teaching Credential Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TEACHCRED', CategoryName = 'Teaching Credential Type'
		where EdFactsCategoryId = 86
	END
 
	insert into @recordIds (Id) values (87)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 87)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (87, 'TECHPROFDEV', 'Technology Professional Development Hours')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TECHPROFDEV', CategoryName = 'Technology Professional Development Hours'
		where EdFactsCategoryId = 87
	END
 
	insert into @recordIds (Id) values (88)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 88)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (88, 'TESTSTATUS', 'Testing Status (OCR)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TESTSTATUS', CategoryName = 'Testing Status (OCR)'
		where EdFactsCategoryId = 88
	END
 
	insert into @recordIds (Id) values (89)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 89)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (89, 'TITLEIINSTSERV', 'Title I Instructional Services')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TITLEIINSTSERV', CategoryName = 'Title I Instructional Services'
		where EdFactsCategoryId = 89
	END
 
	insert into @recordIds (Id) values (90)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 90)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (90, 'TITLEIPROG', 'Title I Program Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TITLEIPROG', CategoryName = 'Title I Program Type'
		where EdFactsCategoryId = 90
	END
 
	insert into @recordIds (Id) values (91)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 91)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (91, 'TITLEISUPP', 'Title I Support Services')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TITLEISUPP', CategoryName = 'Title I Support Services'
		where EdFactsCategoryId = 91
	END
 
	insert into @recordIds (Id) values (92)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 92)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (92, 'USSCHATTEND', 'Years Attending US Schools')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'USSCHATTEND', CategoryName = 'Years Attending US Schools'
		where EdFactsCategoryId = 92
	END
 
	insert into @recordIds (Id) values (93)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 93)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (93, 'REASNOASSESS', 'Reason for Not Participating in Assessment')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REASNOASSESS', CategoryName = 'Reason for Not Participating in Assessment'
		where EdFactsCategoryId = 93
	END
 
	insert into @recordIds (Id) values (94)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 94)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (94, 'FEDPROG', 'Federal Program Code')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FEDPROG', CategoryName = 'Federal Program Code'
		where EdFactsCategoryId = 94
	END
 
	insert into @recordIds (Id) values (96)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 96)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (96, 'ECODISAD', 'Economic Circumstance')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ECODISAD', CategoryName = 'Economic Circumstance'
		where EdFactsCategoryId = 96
	END
 
	insert into @recordIds (Id) values (97)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 97)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (97, 'TESTED', 'Tested')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TESTED', CategoryName = 'Tested'
		where EdFactsCategoryId = 97
	END
 
	insert into @recordIds (Id) values (98)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 98)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (98, 'RESULT', 'Result')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'RESULT', CategoryName = 'Result'
		where EdFactsCategoryId = 98
	END
 
	insert into @recordIds (Id) values (99)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 99)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (99, 'ACCOMMOD', 'Accommodations')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACCOMMOD', CategoryName = 'Accommodations'
		where EdFactsCategoryId = 99
	END
 
	insert into @recordIds (Id) values (100)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 100)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (100, 'DSCPLMDRGFREE', 'Discipline Method (Safe and Drug-Free)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCPLMDRGFREE', CategoryName = 'Discipline Method (Safe and Drug-Free)'
		where EdFactsCategoryId = 100
	END
 
	insert into @recordIds (Id) values (101)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 101)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (101, 'FIREARMINC', 'Discipline Method (Firearms)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FIREARMINC', CategoryName = 'Discipline Method (Firearms)'
		where EdFactsCategoryId = 101
	END
 
	insert into @recordIds (Id) values (103)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 103)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (103, 'INVALIDATION', 'Invalidation')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INVALIDATION', CategoryName = 'Invalidation'
		where EdFactsCategoryId = 103
	END
 
	insert into @recordIds (Id) values (104)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 104)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (104, 'LENGTHPLCMT', 'Length of Placement')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LENGTHPLCMT', CategoryName = 'Length of Placement'
		where EdFactsCategoryId = 104
	END
 
	insert into @recordIds (Id) values (105)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 105)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (105, 'LEPACCOMMOD', 'LEP Accommodation')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPACCOMMOD', CategoryName = 'LEP Accommodation'
		where EdFactsCategoryId = 105
	END
 
	insert into @recordIds (Id) values (106)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 106)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (106, 'NCLBCAPINCL', 'NCLB Cap Inclusion')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NCLBCAPINCL', CategoryName = 'NCLB Cap Inclusion'
		where EdFactsCategoryId = 106
	END
 
	insert into @recordIds (Id) values (107)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 107)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (107, 'NEGDELPROGTYPE', 'N or D Program (Subpart 1)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NEGDELPROGTYPE', CategoryName = 'N or D Program (Subpart 1)'
		where EdFactsCategoryId = 107
	END
 
	insert into @recordIds (Id) values (108)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 108)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (108, 'PREPOSTTEST', 'Pre-Post-Test Indicator')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PREPOSTTEST', CategoryName = 'Pre-Post-Test Indicator'
		where EdFactsCategoryId = 108
	END
 
	insert into @recordIds (Id) values (109)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 109)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (109, 'PROGRESSLEVEL', 'Progress Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PROGRESSLEVEL', CategoryName = 'Progress Level'
		where EdFactsCategoryId = 109
	END
 
	insert into @recordIds (Id) values (110)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 110)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (110, 'LEPATTAINMENT', 'Progress/Attainment')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPATTAINMENT', CategoryName = 'Progress/Attainment'
		where EdFactsCategoryId = 110
	END
 
	insert into @recordIds (Id) values (111)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 111)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (111, 'QUALSTATTCH', 'Qualification Status (Teachers)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'QUALSTATTCH', CategoryName = 'Qualification Status (Teachers)'
		where EdFactsCategoryId = 111
	END
 
	insert into @recordIds (Id) values (112)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 112)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (112, 'REMOVALLEN', 'Removal Length')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALLEN', CategoryName = 'Removal Length'
		where EdFactsCategoryId = 112
	END
 
	insert into @recordIds (Id) values (113)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 113)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (113, 'REMOVALLENDIS', 'Removal Length (Disciplinary Actions)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALLENDIS', CategoryName = 'Removal Length (Disciplinary Actions)'
		where EdFactsCategoryId = 113
	END
 
	insert into @recordIds (Id) values (114)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 114)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (114, 'REMOVALLENSUS', 'Removal Length (Suspensions/Expulsions)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALLENSUS', CategoryName = 'Removal Length (Suspensions/Expulsions)'
		where EdFactsCategoryId = 114
	END
 
	insert into @recordIds (Id) values (115)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 115)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (115, 'RLISPURPOSE', 'RLIS Purpose')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'RLISPURPOSE', CategoryName = 'RLIS Purpose'
		where EdFactsCategoryId = 115
	END
 
	insert into @recordIds (Id) values (116)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 116)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (116, 'STAFFSPED', 'Staff Category (Special Education Related Service)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFSPED', CategoryName = 'Staff Category (Special Education Related Service)'
		where EdFactsCategoryId = 116
	END
 
	insert into @recordIds (Id) values (117)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 117)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (117, 'STAFFTCH', 'Staff Category (Teacher)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFTCH', CategoryName = 'Staff Category (Teacher)'
		where EdFactsCategoryId = 117
	END
 
	insert into @recordIds (Id) values (118)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 118)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (118, 'TESTSTATUSASS', 'Testing Status (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TESTSTATUSASS', CategoryName = 'Testing Status (Assessment)'
		where EdFactsCategoryId = 118
	END
 
	insert into @recordIds (Id) values (119)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 119)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (119, 'VOCATEDU', 'Vocational Education Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'VOCATEDU', CategoryName = 'Vocational Education Status'
		where EdFactsCategoryId = 119
	END
 
	insert into @recordIds (Id) values (120)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 120)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (120, 'VOCATSTATUS', 'Vocational Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'VOCATSTATUS', CategoryName = 'Vocational Status'
		where EdFactsCategoryId = 120
	END
 
	insert into @recordIds (Id) values (121)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 121)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (121, 'WEAPONTYPE', 'Weapon')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'WEAPONTYPE', CategoryName = 'Weapon'
		where EdFactsCategoryId = 121
	END
 
	insert into @recordIds (Id) values (122)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 122)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (122, 'ATTAINSTATUS', 'Attainment Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ATTAINSTATUS', CategoryName = 'Attainment Status'
		where EdFactsCategoryId = 122
	END
 
	insert into @recordIds (Id) values (123)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 123)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (123, 'QUALSTATPARA', 'Qualification Status (Paraprofessionals)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'QUALSTATPARA', CategoryName = 'Qualification Status (Paraprofessionals)'
		where EdFactsCategoryId = 123
	END
 
	insert into @recordIds (Id) values (124)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 124)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (124, 'LEPMTPL', 'LEP Status (Multiple)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPMTPL', CategoryName = 'LEP Status (Multiple)'
		where EdFactsCategoryId = 124
	END
 
	insert into @recordIds (Id) values (125)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 125)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (125, 'LEPONLY', 'English Learner Status (Only)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPONLY', CategoryName = 'English Learner Status (Only)'
		where EdFactsCategoryId = 125
	END
 
	insert into @recordIds (Id) values (126)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 126)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (126, 'LEPBOTH', 'English Learner Status (Both)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPBOTH', CategoryName = 'English Learner Status (Both)'
		where EdFactsCategoryId = 126
	END
 
	insert into @recordIds (Id) values (127)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 127)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (127, 'GRADELVLPROG', 'Grade Level (Program Services)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVLPROG', CategoryName = 'Grade Level (Program Services)'
		where EdFactsCategoryId = 127
	END
 
	insert into @recordIds (Id) values (138)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 138)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (138, 'SEX', 'Sex (Membership)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SEX', CategoryName = 'Sex (Membership)'
		where EdFactsCategoryId = 138
	END
 
	insert into @recordIds (Id) values (139)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 139)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (139, 'AGESA', 'Age (School Age)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGESA', CategoryName = 'Age (School Age)'
		where EdFactsCategoryId = 139
	END
 
	insert into @recordIds (Id) values (141)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 141)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (141, 'AGEGRPIDEASTAFF', 'Age Group (IDEA Staff)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRPIDEASTAFF', CategoryName = 'Age Group (IDEA Staff)'
		where EdFactsCategoryId = 141
	END
 
	insert into @recordIds (Id) values (143)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 143)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (143, 'DISABSTATUS', 'Disability Status (Only)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATUS', CategoryName = 'Disability Status (Only)'
		where EdFactsCategoryId = 143
	END
 
	insert into @recordIds (Id) values (144)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 144)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (144, 'AGEEC', 'Age (Early Childhood)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEEC', CategoryName = 'Age (Early Childhood)'
		where EdFactsCategoryId = 144
	END
 
	insert into @recordIds (Id) values (145)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 145)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (145, 'EDENVIDEAEC', 'Educational Environment (IDEA) EC')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIDEAEC', CategoryName = 'Educational Environment (IDEA) EC'
		where EdFactsCategoryId = 145
	END
 
	insert into @recordIds (Id) values (146)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 146)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (146, 'PRIORLEAID', 'Prior State LEA ID (LEA ID)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PRIORLEAID', CategoryName = 'Prior State LEA ID (LEA ID)'
		where EdFactsCategoryId = 146
	END
 
	insert into @recordIds (Id) values (147)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 147)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (147, 'PRIORSCHOOLID', 'Prior State School ID (School ID)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PRIORSCHOOLID', CategoryName = 'Prior State School ID (School ID)'
		where EdFactsCategoryId = 147
	END
 
	insert into @recordIds (Id) values (148)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 148)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (148, 'REMOVALLENIDEA', 'Removal Length (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALLENIDEA', CategoryName = 'Removal Length (IDEA)'
		where EdFactsCategoryId = 148
	END
 
	insert into @recordIds (Id) values (151)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 151)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (151, 'LEPFORMER', 'LEP Status (Former)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPFORMER', CategoryName = 'LEP Status (Former)'
		where EdFactsCategoryId = 151
	END
 
	insert into @recordIds (Id) values (152)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 152)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (152, 'EDENVIRIDEASA', 'Educational Environment (IDEA) SA')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDENVIRIDEASA', CategoryName = 'Educational Environment (IDEA) SA'
		where EdFactsCategoryId = 152
	END
 
	insert into @recordIds (Id) values (153)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 153)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (153, 'REMOVALTYPE', 'Interim Removal (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVALTYPE', CategoryName = 'Interim Removal (IDEA)'
		where EdFactsCategoryId = 153
	END
 
	insert into @recordIds (Id) values (154)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 154)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (154, 'DSCPLMETHOD', 'Discipline Method (Suspension/Expulsion)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DSCPLMETHOD', CategoryName = 'Discipline Method (Suspension/Expulsion)'
		where EdFactsCategoryId = 154
	END
 
	insert into @recordIds (Id) values (155)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 155)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (155, 'REMOVEREASON', 'Interim Removal Reason (IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REMOVEREASON', CategoryName = 'Interim Removal Reason (IDEA)'
		where EdFactsCategoryId = 155
	END
 
	insert into @recordIds (Id) values (156)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 156)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (156, 'AMAOASSESS', 'AMAO (Assessment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AMAOASSESS', CategoryName = 'AMAO (Assessment)'
		where EdFactsCategoryId = 156
	END
 
	insert into @recordIds (Id) values (157)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 157)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (157, 'IDEAMODEXP', 'IDEA Modified Expulsions')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'IDEAMODEXP', CategoryName = 'IDEA Modified Expulsions'
		where EdFactsCategoryId = 157
	END
 
	insert into @recordIds (Id) values (158)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 158)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (158, 'GRADE8TECHSTAT', 'Technology Literacy Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADE8TECHSTAT', CategoryName = 'Technology Literacy Status'
		where EdFactsCategoryId = 158
	END
 
	insert into @recordIds (Id) values (159)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 159)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (159, 'FEDPROGTRANS', 'Federal Program Code (Transferability)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FEDPROGTRANS', CategoryName = 'Federal Program Code (Transferability)'
		where EdFactsCategoryId = 159
	END
 
	insert into @recordIds (Id) values (160)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 160)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (160, 'SEXGRADUATE', 'Sex (Graduates)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SEXGRADUATE', CategoryName = 'Sex (Graduates)'
		where EdFactsCategoryId = 160
	END
 
	insert into @recordIds (Id) values (161)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 161)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (161, 'ACADSUBTESTED', 'Academic Subject (Tested)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBTESTED', CategoryName = 'Academic Subject (Tested)'
		where EdFactsCategoryId = 161
	END
 
	insert into @recordIds (Id) values (162)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 162)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (162, 'MOBILSTATUSMNTH', 'Mobility Status (Qualifying Moves)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MOBILSTATUSMNTH', CategoryName = 'Mobility Status (Qualifying Moves)'
		where EdFactsCategoryId = 162
	END
 
	insert into @recordIds (Id) values (163)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 163)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (163, 'MOBILSTATUSSY', 'Mobility Status (Regular School Year)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MOBILSTATUSSY', CategoryName = 'Mobility Status (Regular School Year)'
		where EdFactsCategoryId = 163
	END
 
	insert into @recordIds (Id) values (164)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 164)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (164, 'IMGRNTPROGPART', 'Program Participation (Immigrant)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'IMGRNTPROGPART', CategoryName = 'Program Participation (Immigrant)'
		where EdFactsCategoryId = 164
	END
 
	insert into @recordIds (Id) values (166)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 166)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (166, 'STAFFTECHSKILL', 'Technology Skills')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFTECHSKILL', CategoryName = 'Technology Skills'
		where EdFactsCategoryId = 166
	END
 
	insert into @recordIds (Id) values (167)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 167)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (167, 'AGEGROUP', 'Age Group')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGROUP', CategoryName = 'Age Group'
		where EdFactsCategoryId = 167
	END
 
	insert into @recordIds (Id) values (169)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 169)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (169, 'GRADELVBASIC', 'Grade Level (Basic)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVBASIC', CategoryName = 'Grade Level (Basic)'
		where EdFactsCategoryId = 169
	END
 
	insert into @recordIds (Id) values (170)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 170)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (170, 'HOMELESS', 'Homeless Status (Only)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELESS', CategoryName = 'Homeless Status (Only)'
		where EdFactsCategoryId = 170
	END
 
	insert into @recordIds (Id) values (171)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 171)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (171, 'AGEGRDHMLS', 'Age/Grade (w/o Out of School)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDHMLS', CategoryName = 'Age/Grade (w/o Out of School)'
		where EdFactsCategoryId = 171
	END
 
	insert into @recordIds (Id) values (172)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 172)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (172, 'FAINCIDEA', 'Discipline Method (Firearms-IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FAINCIDEA', CategoryName = 'Discipline Method (Firearms-IDEA)'
		where EdFactsCategoryId = 172
	END
 
	insert into @recordIds (Id) values (173)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 173)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (173, 'FAINCNOTIDEA', 'Discipline Method (Firearms-not IDEA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FAINCNOTIDEA', CategoryName = 'Discipline Method (Firearms-not IDEA)'
		where EdFactsCategoryId = 173
	END
 
	insert into @recordIds (Id) values (174)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 174)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (174, 'AGE3TOGRADE12', 'Age/Grade (3-5/K-12)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGE3TOGRADE12', CategoryName = 'Age/Grade (3-5/K-12)'
		where EdFactsCategoryId = 174
	END
 
	insert into @recordIds (Id) values (175)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 175)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (175, 'MONLEPFORMER', 'Former English Learner Year')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MONLEPFORMER', CategoryName = 'Former English Learner Year'
		where EdFactsCategoryId = 175
	END
 
	insert into @recordIds (Id) values (176)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 176)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (176, 'AGE3TOGRADE12UG', 'Age/Grade (w/out Under 3 or Out of School)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGE3TOGRADE12UG', CategoryName = 'Age/Grade (w/out Under 3 or Out of School)'
		where EdFactsCategoryId = 176
	END
 
	insert into @recordIds (Id) values (178)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 178)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (178, 'NEGDELPROGTYPE2', 'N or D Program (Subpart 2)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NEGDELPROGTYPE2', CategoryName = 'N or D Program (Subpart 2)'
		where EdFactsCategoryId = 178
	END
 
	insert into @recordIds (Id) values (179)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 179)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (179, 'PRETESTRESULT', 'Pretest Results')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PRETESTRESULT', CategoryName = 'Pretest Results'
		where EdFactsCategoryId = 179
	END
 
	insert into @recordIds (Id) values (181)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 181)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (181, 'FIRSTASSESS', 'First Assessment')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FIRSTASSESS', CategoryName = 'First Assessment'
		where EdFactsCategoryId = 181
	END
 
	insert into @recordIds (Id) values (186)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 186)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (186, 'EDUSERVICES', 'Educational Services')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EDUSERVICES', CategoryName = 'Educational Services'
		where EdFactsCategoryId = 186
	END
 
	insert into @recordIds (Id) values (187)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 187)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (187, 'AGEGRDALL', 'Age/Grade (All)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDALL', CategoryName = 'Age/Grade (All)'
		where EdFactsCategoryId = 187
	END
 
	insert into @recordIds (Id) values (188)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 188)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (188, 'AGEGRDWOU3', 'Age/Grade (w/o Under 3)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDWOU3', CategoryName = 'Age/Grade (w/o Under 3)'
		where EdFactsCategoryId = 188
	END
 
	insert into @recordIds (Id) values (189)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 189)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (189, 'MEPPOSONLY', 'Priority for Services (Only)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPPOSONLY', CategoryName = 'Priority for Services (Only)'
		where EdFactsCategoryId = 189
	END
 
	insert into @recordIds (Id) values (190)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 190)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (190, 'MEPCONTINUE', 'Continuation (Only)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPCONTINUE', CategoryName = 'Continuation (Only)'
		where EdFactsCategoryId = 190
	END
 
	insert into @recordIds (Id) values (191)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 191)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (191, 'LEPACCOUNT', 'LEP Status (Accountability)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPACCOUNT', CategoryName = 'LEP Status (Accountability)'
		where EdFactsCategoryId = 191
	END
 
	insert into @recordIds (Id) values (193)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 193)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (193, 'STAFFTITLEI', 'Staff Category (Title I)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFTITLEI', CategoryName = 'Staff Category (Title I)'
		where EdFactsCategoryId = 193
	END
 
	insert into @recordIds (Id) values (196)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 196)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (196, 'MEPSERVICES', 'MEP Services')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MEPSERVICES', CategoryName = 'MEP Services'
		where EdFactsCategoryId = 196
	END
 
	insert into @recordIds (Id) values (197)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 197)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (197, 'AGEALL', 'Age (All)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEALL', CategoryName = 'Age (All)'
		where EdFactsCategoryId = 197
	END
 
	insert into @recordIds (Id) values (198)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 198)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (198, 'AGEU3TOGR12UG', 'Age/Grade (w/o Out of School)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEU3TOGR12UG', CategoryName = 'Age/Grade (w/o Out of School)'
		where EdFactsCategoryId = 198
	END
 
	insert into @recordIds (Id) values (199)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 199)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (199, 'ALLOCTYPE', 'Funding Allocation Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ALLOCTYPE', CategoryName = 'Funding Allocation Type'
		where EdFactsCategoryId = 199
	END
 
	insert into @recordIds (Id) values (200)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 200)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (200, 'TITLEACT', 'English Learner Accountability')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TITLEACT', CategoryName = 'English Learner Accountability'
		where EdFactsCategoryId = 200
	END
 
	insert into @recordIds (Id) values (201)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 201)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (201, 'MAJORREG', 'Major Racial and Ethnic Groups')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MAJORREG', CategoryName = 'Major Racial and Ethnic Groups'
		where EdFactsCategoryId = 201
	END
 
	insert into @recordIds (Id) values (202)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 202)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (202, 'PROFSTATUS', 'Proficiency Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PROFSTATUS', CategoryName = 'Proficiency Status'
		where EdFactsCategoryId = 202
	END
 
	insert into @recordIds (Id) values (203)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 203)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (203, 'AASTANDARD', 'Assessment Achievement Standard')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AASTANDARD', CategoryName = 'Assessment Achievement Standard'
		where EdFactsCategoryId = 203
	END
 
	insert into @recordIds (Id) values (204)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 204)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (204, 'PARTSTATUS', 'Participation Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARTSTATUS', CategoryName = 'Participation Status'
		where EdFactsCategoryId = 204
	END
 
	insert into @recordIds (Id) values (205)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 205)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (205, 'COHSTATUS', 'Cohort Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'COHSTATUS', CategoryName = 'Cohort Status'
		where EdFactsCategoryId = 205
	END
 
	insert into @recordIds (Id) values (206)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 206)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (206, 'CORRECTACT', 'Corrective Action')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'CORRECTACT', CategoryName = 'Corrective Action'
		where EdFactsCategoryId = 206
	END
 
	insert into @recordIds (Id) values (207)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 207)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (207, 'RESTRUCTACT', 'Restructuring Action')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'RESTRUCTACT', CategoryName = 'Restructuring Action'
		where EdFactsCategoryId = 207
	END
 
	insert into @recordIds (Id) values (208)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 208)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (208, 'DISABSTATADA', 'Disability Status (ADA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATADA', CategoryName = 'Disability Status (ADA)'
		where EdFactsCategoryId = 208
	END
 
	insert into @recordIds (Id) values (209)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 209)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (209, 'SPECPOPUL', 'Special Population (Perkins)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SPECPOPUL', CategoryName = 'Special Population (Perkins)'
		where EdFactsCategoryId = 209
	END
 
	insert into @recordIds (Id) values (210)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 210)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (210, 'INCLUTYP', 'Inclusion Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INCLUTYP', CategoryName = 'Inclusion Type'
		where EdFactsCategoryId = 210
	END
 
	insert into @recordIds (Id) values (211)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 211)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (211, 'REPSENTSTAT', 'Representation Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REPSENTSTAT', CategoryName = 'Representation Status'
		where EdFactsCategoryId = 211
	END
 
	insert into @recordIds (Id) values (212)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 212)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (212, 'TESRES', 'Test Result')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TESRES', CategoryName = 'Test Result'
		where EdFactsCategoryId = 212
	END
 
	insert into @recordIds (Id) values (213)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 213)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (213, 'DISPHOMEMAK', 'Displaced Homemaker')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISPHOMEMAK', CategoryName = 'Displaced Homemaker'
		where EdFactsCategoryId = 213
	END
 
	insert into @recordIds (Id) values (214)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 214)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (214, 'LEPPERKINS', 'English Learner Status (Perkins)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPPERKINS', CategoryName = 'English Learner Status (Perkins)'
		where EdFactsCategoryId = 214
	END
 
	insert into @recordIds (Id) values (215)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 215)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (215, 'TECHPREP', 'Tech prep')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TECHPREP', CategoryName = 'Tech prep'
		where EdFactsCategoryId = 215
	END
 
	insert into @recordIds (Id) values (216)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 216)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (216, 'NONTENR', 'Non-Traditional Enrollees')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NONTENR', CategoryName = 'Non-Traditional Enrollees'
		where EdFactsCategoryId = 216
	END
 
	insert into @recordIds (Id) values (217)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 217)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (217, 'DIPLCREDTYPEX', 'Diploma/Credential (Expanded)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DIPLCREDTYPEX', CategoryName = 'Diploma/Credential (Expanded)'
		where EdFactsCategoryId = 217
	END
 
	insert into @recordIds (Id) values (218)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 218)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (218, 'PROFSTATUS', 'Proficiency Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PROFSTATUS', CategoryName = 'Proficiency Status'
		where EdFactsCategoryId = 218
	END
 
	insert into @recordIds (Id) values (219)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 219)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (219, 'DISABSTATADA', 'Disability Status (IDEA or ADA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATADA', CategoryName = 'Disability Status (IDEA or ADA)'
		where EdFactsCategoryId = 219
	END
 
	insert into @recordIds (Id) values (220)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 220)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (220, 'FIRSTASSESS', 'Assessed First Time')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FIRSTASSESS', CategoryName = 'Assessed First Time'
		where EdFactsCategoryId = 220
	END
 
	insert into @recordIds (Id) values (221)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 221)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (221, 'EQUIPMENT', 'Equipment (Internet Access Equipment)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EQUIPMENT', CategoryName = 'Equipment (Internet Access Equipment)'
		where EdFactsCategoryId = 221
	END
 
	insert into @recordIds (Id) values (222)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 222)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (222, 'HOMELSENRLSTAT', 'Homeless Enrolled Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HOMELSENRLSTAT', CategoryName = 'Homeless Enrolled Status'
		where EdFactsCategoryId = 222
	END
 
	insert into @recordIds (Id) values (223)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 223)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (223, 'LEPSTATRLA', 'English Learner Status (RLA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LEPSTATRLA', CategoryName = 'English Learner Status (RLA)'
		where EdFactsCategoryId = 223
	END
 
	insert into @recordIds (Id) values (225)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 225)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (225, 'DISABSTATACCT', 'Disability Status (Accountability)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATACCT', CategoryName = 'Disability Status (Accountability)'
		where EdFactsCategoryId = 225
	END
 
	insert into @recordIds (Id) values (227)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 227)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (227, 'ASSESSADMIN', 'Assessment Administered (Achievement)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASSESSADMIN', CategoryName = 'Assessment Administered (Achievement)'
		where EdFactsCategoryId = 227
	END
 
	insert into @recordIds (Id) values (228)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 228)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (228, 'PSECENRACTION', 'Postsecondary Enrollment Action')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PSECENRACTION', CategoryName = 'Postsecondary Enrollment Action'
		where EdFactsCategoryId = 228
	END
 
	insert into @recordIds (Id) values (229)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 229)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (229, 'ASSESSADMINSS', 'Assessment Administered (Scale Score)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASSESSADMINSS', CategoryName = 'Assessment Administered (Scale Score)'
		where EdFactsCategoryId = 229
	END
 
	insert into @recordIds (Id) values (230)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 230)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (230, 'ACHPERCENTILE', 'Achievement Percentile')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACHPERCENTILE', CategoryName = 'Achievement Percentile'
		where EdFactsCategoryId = 230
	END
 
	insert into @recordIds (Id) values (231)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 231)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (231, 'FACADMPERFLVL', 'Faculty/Admin Performance Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FACADMPERFLVL', CategoryName = 'Faculty/Admin Performance Level'
		where EdFactsCategoryId = 231
	END
 
	insert into @recordIds (Id) values (232)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 232)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (232, 'PARTSTATUSMS', 'Participation Status (MS)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARTSTATUSMS', CategoryName = 'Participation Status (MS)'
		where EdFactsCategoryId = 232
	END
 
	insert into @recordIds (Id) values (233)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 233)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (233, 'ASMTADMNSTRD', 'Assessment Administered')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASMTADMNSTRD', CategoryName = 'Assessment Administered'
		where EdFactsCategoryId = 233
	END
 
	insert into @recordIds (Id) values (234)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 234)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (234, 'PARTSTATUSRLA', 'Participation Status (RLA)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARTSTATUSRLA', CategoryName = 'Participation Status (RLA)'
		where EdFactsCategoryId = 234
	END
 
	insert into @recordIds (Id) values (235)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 235)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (235, 'PLACEMENTTYPE', 'Placement Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PLACEMENTTYPE', CategoryName = 'Placement Type'
		where EdFactsCategoryId = 235
	END
 
	insert into @recordIds (Id) values (236)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 236)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (236, 'PLACEMENTSTATUS', 'Placement Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PLACEMENTSTATUS', CategoryName = 'Placement Status'
		where EdFactsCategoryId = 236
	END
 
	insert into @recordIds (Id) values (237)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 237)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (237, 'FLEXSUBG', 'Flexibility Subgroups')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FLEXSUBG', CategoryName = 'Flexibility Subgroups'
		where EdFactsCategoryId = 237
	END
 
	insert into @recordIds (Id) values (238)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 238)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (238, 'PSECCREDIT', 'Postsecondary Credit')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PSECCREDIT', CategoryName = 'Postsecondary Credit'
		where EdFactsCategoryId = 238
	END
 
	insert into @recordIds (Id) values (239)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 239)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (239, 'ACADSUBSCALE', 'Academic Subject (Scale Score)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBSCALE', CategoryName = 'Academic Subject (Scale Score)'
		where EdFactsCategoryId = 239
	END
 
	insert into @recordIds (Id) values (240)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 240)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (240, 'ACADVOCOUTCOME', 'Academic / Career and Technical Outcomes')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADVOCOUTCOME', CategoryName = 'Academic / Career and Technical Outcomes'
		where EdFactsCategoryId = 240
	END
 
	insert into @recordIds (Id) values (241)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 241)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (241, 'LANGHOME', 'Language (Native)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LANGHOME', CategoryName = 'Language (Native)'
		where EdFactsCategoryId = 241
	END
 
	insert into @recordIds (Id) values (244)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 244)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (244, 'HQTALT', 'Alternative Route Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'HQTALT', CategoryName = 'Alternative Route Status'
		where EdFactsCategoryId = 244
	END
 
	insert into @recordIds (Id) values (245)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 245)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (245, 'AGE3TOGRADE13', 'Age/Grade (Basic)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGE3TOGRADE13', CategoryName = 'Age/Grade (Basic)'
		where EdFactsCategoryId = 245
	END
 
	insert into @recordIds (Id) values (246)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 246)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (246, 'AGEGRDWO13', 'Age/Grade (w/o 13)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDWO13', CategoryName = 'Age/Grade (w/o 13)'
		where EdFactsCategoryId = 246
	END
 
	insert into @recordIds (Id) values (247)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 247)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (247, 'GRADELVBASICW13', 'Grade Level (Basic w/13)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVBASICW13', CategoryName = 'Grade Level (Basic w/13)'
		where EdFactsCategoryId = 247
	END
 
	insert into @recordIds (Id) values (248)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 248)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (248, 'AGEGRDWO13BT3', 'Age/Grade (w/o 13 and BT2)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEGRDWO13BT3', CategoryName = 'Age/Grade (w/o 13 and BT2)'
		where EdFactsCategoryId = 248
	END
 
	insert into @recordIds (Id) values (249)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 249)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (249, 'MOBILSTAT12MNTH', 'Mobility Status (12 months)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MOBILSTAT12MNTH', CategoryName = 'Mobility Status (12 months)'
		where EdFactsCategoryId = 249
	END
 
	insert into @recordIds (Id) values (254)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 254)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (254, 'REFERRALSTATUS', 'Referral Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'REFERRALSTATUS', CategoryName = 'Referral Status'
		where EdFactsCategoryId = 254
	END
 
	insert into @recordIds (Id) values (571)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 571)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (571, 'NORDLONGTERM', 'N or D Status (Long Term)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'NORDLONGTERM', CategoryName = 'N or D Status (Long Term)'
		where EdFactsCategoryId = 571
	END
 
	insert into @recordIds (Id) values (572)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 572)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (572, 'PROFSTATUS', 'Proficiency Status (Field Testing)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PROFSTATUS', CategoryName = 'Proficiency Status (Field Testing)'
		where EdFactsCategoryId = 572
	END
 
	insert into @recordIds (Id) values (573)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 573)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (573, 'DISABCATIDEAEXIT', 'Disability Category (IDEA) Exiting')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABCATIDEAEXIT', CategoryName = 'Disability Category (IDEA) Exiting'
		where EdFactsCategoryId = 573
	END
 
	insert into @recordIds (Id) values (578)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 578)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (578, 'ACADSUBASSESNOSCI', 'Academic Subject (Assessment - no science)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADSUBASSESNOSCI', CategoryName = 'Academic Subject (Assessment - no science)'
		where EdFactsCategoryId = 578
	END
 
	insert into @recordIds (Id) values (579)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 579)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (579, 'ACADVOCOUTCOMEX', 'Academic / Career and Technical Outcomes (Exit)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACADVOCOUTCOMEX', CategoryName = 'Academic / Career and Technical Outcomes (Exit)'
		where EdFactsCategoryId = 579
	END
 
	insert into @recordIds (Id) values (580)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 580)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (580, 'AGEPK', 'Age (PK)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEPK', CategoryName = 'Age (PK)'
		where EdFactsCategoryId = 580
	END
 
	insert into @recordIds (Id) values (581)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 581)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (581, 'DISABSTATUS504', 'Disability Status (504)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'DISABSTATUS504', CategoryName = 'Disability Status (504)'
		where EdFactsCategoryId = 581
	END
 
	insert into @recordIds (Id) values (582)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 582)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (582, 'FSTRCRSTS', 'Foster Care Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'FSTRCRSTS', CategoryName = 'Foster Care Status'
		where EdFactsCategoryId = 582
	END
 
	insert into @recordIds (Id) values (583)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 583)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (583, 'MILCNCTDSTDNTSTS', 'Military Connected Student Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'MILCNCTDSTDNTSTS', CategoryName = 'Military Connected Student Status'
		where EdFactsCategoryId = 583
	END
 
	insert into @recordIds (Id) values (584)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 584)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (584, 'ALLOCAREA', 'Allocation Areas (EMAPS Survey on the Use of Funds Under Title II, Part A)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ALLOCAREA', CategoryName = 'Allocation Areas (EMAPS Survey on the Use of Funds Under Title II, Part A)'
		where EdFactsCategoryId = 584
	END
 
	insert into @recordIds (Id) values (585)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 585)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (585, 'EVALCAT', 'Evaluation Categories (EMAPS Survey on the Use of Funds Under Title II, Part A)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EVALCAT', CategoryName = 'Evaluation Categories (EMAPS Survey on the Use of Funds Under Title II, Part A)'
		where EdFactsCategoryId = 585
	END
 
	insert into @recordIds (Id) values (586)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 586)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (586, 'STAFFCATTII', 'Staff Category (Title II) (EMAPS Survey on the Use of Funds Under Title II, Part A)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'STAFFCATTII', CategoryName = 'Staff Category (Title II) (EMAPS Survey on the Use of Funds Under Title II, Part A)'
		where EdFactsCategoryId = 586
	END
 
	insert into @recordIds (Id) values (587)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 587)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (587, 'RETENCAT', 'RETENTION CATEGORIES (EMAPS Survey on the Use of Funds Under Title II, Part A)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'RETENCAT', CategoryName = 'RETENTION CATEGORIES (EMAPS Survey on the Use of Funds Under Title II, Part A)'
		where EdFactsCategoryId = 587
	END
 
	insert into @recordIds (Id) values (588)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 588)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (588, 'INDTYPE', 'Indicator Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'INDTYPE', CategoryName = 'Indicator Type'
		where EdFactsCategoryId = 588
	END
 
	insert into @recordIds (Id) values (589)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 589)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (589, 'TCHEXPRNCDSTS', 'Inexperienced Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TCHEXPRNCDSTS', CategoryName = 'Inexperienced Status'
		where EdFactsCategoryId = 589
	END
 
	insert into @recordIds (Id) values (590)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 590)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (590, 'TCHEMRPRVCRDSTS', 'Emergency or Provisional Credential Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TCHEMRPRVCRDSTS', CategoryName = 'Emergency or Provisional Credential Status'
		where EdFactsCategoryId = 590
	END
 
	insert into @recordIds (Id) values (591)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 591)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (591, 'TCHFLDSTS', 'Out of Field Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TCHFLDSTS', CategoryName = 'Out of Field Status'
		where EdFactsCategoryId = 591
	END
 
	insert into @recordIds (Id) values (592)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 592)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (592, 'QUALSTATSPEDTCH', 'Qualification Status (Special Education Teacher)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'QUALSTATSPEDTCH', CategoryName = 'Qualification Status (Special Education Teacher)'
		where EdFactsCategoryId = 592
	END
 
	insert into @recordIds (Id) values (593)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 593)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (593, 'ENGLRNACCOUBL', 'English Learner Accountability')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ENGLRNACCOUBL', CategoryName = 'English Learner Accountability'
		where EdFactsCategoryId = 593
	END
 
	insert into @recordIds (Id) values (594)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 594)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (594, 'LNGINSTPRGTYPE', 'Language Instruction Educational Program Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'LNGINSTPRGTYPE', CategoryName = 'Language Instruction Educational Program Type'
		where EdFactsCategoryId = 594
	END
 
	insert into @recordIds (Id) values (595)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 595)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (595, 'AGEDD', 'Age (Developmental Delay)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'AGEDD', CategoryName = 'Age (Developmental Delay)'
		where EdFactsCategoryId = 595
	END
 
	insert into @recordIds (Id) values (596)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 596)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (596, 'SOPINCLN', 'SOP Inclusion')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SOPINCLN', CategoryName = 'SOP Inclusion'
		where EdFactsCategoryId = 596
	END
 
	insert into @recordIds (Id) values (597)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 597)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (597, 'SOPRPTNGLVL', 'SOP Reporting Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'SOPRPTNGLVL', CategoryName = 'SOP Reporting Level'
		where EdFactsCategoryId = 597
	END
 
	insert into @recordIds (Id) values (598)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 598)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (598, 'ASMNTCHGFRMPY', 'Assessment change from Prior Year')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ASMNTCHGFRMPY', CategoryName = 'Assessment change from Prior Year'
		where EdFactsCategoryId = 598
	END
 
	insert into @recordIds (Id) values (599)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 599)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (599, 'GRADELVASMTGRP', 'Grade Level (Assessment) Group')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'GRADELVASMTGRP', CategoryName = 'Grade Level (Assessment) Group'
		where EdFactsCategoryId = 599
	END
 
	insert into @recordIds (Id) values (600)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 600)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (600, 'PERFLVL', 'Performance Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PERFLVL', CategoryName = 'Performance Level'
		where EdFactsCategoryId = 600
	END
 
	insert into @recordIds (Id) values (601)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 601)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (601, 'PROFLVL', 'Proficiency Level')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PROFLVL', CategoryName = 'Proficiency Level'
		where EdFactsCategoryId = 601
	END
 
	insert into @recordIds (Id) values (602)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 602)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (602, 'EOGORCRS', 'End of Grade or Course')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'EOGORCRS', CategoryName = 'End of Grade or Course'
		where EdFactsCategoryId = 602
	END
 
	insert into @recordIds (Id) values (603)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 603)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (603, 'QUALSTATSPEDTCH', 'Qualification Status (Special Education Teacher)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'QUALSTATSPEDTCH', CategoryName = 'Qualification Status (Special Education Teacher)'
		where EdFactsCategoryId = 603
	END
 
	insert into @recordIds (Id) values (604)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 604)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (604, 'IPBDISCP', 'IDEA Part B discipline metadata')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'IPBDISCP', CategoryName = 'IDEA Part B discipline metadata'
		where EdFactsCategoryId = 604
	END
 
	insert into @recordIds (Id) values (605)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 605)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (605, 'COMPSUPIDFNTYP', 'Comprehensive Support Identification Type')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'COMPSUPIDFNTYP', CategoryName = 'Comprehensive Support Identification Type'
		where EdFactsCategoryId = 605
	END
 
	insert into @recordIds (Id) values (606)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 606)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (606, 'TRGTIDFNSBGRPS', 'Target Identification Subgroups')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'TRGTIDFNSBGRPS', CategoryName = 'Target Identification Subgroups'
		where EdFactsCategoryId = 606
	END
 
	insert into @recordIds (Id) values (607)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 607)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (607, 'OUTWRKFRCSTS', 'Out of Workforce Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'OUTWRKFRCSTS', CategoryName = 'Out of Workforce Status'
		where EdFactsCategoryId = 607
	END
 
	insert into @recordIds (Id) values (608)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 608)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (608, 'CAREERCLSTRS', 'Career Clusters')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'CAREERCLSTRS', CategoryName = 'Career Clusters'
		where EdFactsCategoryId = 608
	END
 
	insert into @recordIds (Id) values (609)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 609)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (609, 'PSECCRDTRCPT', 'Postsecondary Credits')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PSECCRDTRCPT', CategoryName = 'Postsecondary Credits'
		where EdFactsCategoryId = 609
	END
 
	insert into @recordIds (Id) values (610)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 610)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (610, 'PSECCREDRCPT', 'Postsecondary Credential')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PSECCREDRCPT', CategoryName = 'Postsecondary Credential'
		where EdFactsCategoryId = 610
	END
 
	insert into @recordIds (Id) values (611)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 611)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (611, 'PARTSTSWBL', 'Participation Status (WBL)')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'PARTSTSWBL', CategoryName = 'Participation Status (WBL)'
		where EdFactsCategoryId = 611
	END
 
	insert into @recordIds (Id) values (612)
	IF NOT EXISTS (select 1 from app.categories where EdFactsCategoryId = 612)
	BEGIN
		INSERT INTO app.categories ( EdFactsCategoryId, CategoryCode, CategoryName) 
		VALUES (612, 'ACHSTSCTE', 'Achievement Status')
	END
	ELSE
	BEGIN
		UPDATE app.categories SET CategoryCode = 'ACHSTSCTE', CategoryName = 'Achievement Status'
		where EdFactsCategoryId = 612
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
