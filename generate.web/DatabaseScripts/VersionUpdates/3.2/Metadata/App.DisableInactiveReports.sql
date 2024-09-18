-- Disable files specs that are not ready
-- When development of a file spec begins, comment out the respective line to activate the report
----------------------------------------------

set nocount on;

DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)

-- Release 2.5
--insert into @fileSpecs (fileSpec) values ('c103')
--insert into @fileSpecs (fileSpec) values ('c118')
--insert into @fileSpecs (fileSpec) values ('c132')
--insert into @fileSpecs (fileSpec) values ('c170')
--insert into @fileSpecs (fileSpec) values ('c194')
--insert into @fileSpecs (fileSpec) values ('c195')

-- Release 2.6
--insert into @fileSpecs (fileSpec) values ('c179')
--insert into @fileSpecs (fileSpec) values ('c189')
--insert into @fileSpecs (fileSpec) values ('c045')
--insert into @fileSpecs (fileSpec) values ('c050')
--insert into @fileSpecs (fileSpec) values ('c067')
--insert into @fileSpecs (fileSpec) values ('c116')
--insert into @fileSpecs (fileSpec) values ('c126')
--insert into @fileSpecs (fileSpec) values ('c138')
--insert into @fileSpecs (fileSpec) values ('c204')
--insert into @fileSpecs (fileSpec) values ('c205')
--insert into @fileSpecs (fileSpec) values ('c137')
--insert into @fileSpecs (fileSpec) values ('c139')

-- Release 2.7
--insert into @fileSpecs (fileSpec) values ('c150')
--insert into @fileSpecs (fileSpec) values ('c151')
--insert into @fileSpecs (fileSpec) values ('c160')
--insert into @fileSpecs (fileSpec) values ('c199')
--insert into @fileSpecs (fileSpec) values ('c131')
--insert into @fileSpecs (fileSpec) values ('c163')
--insert into @fileSpecs (fileSpec) values ('c086')

-- Release 2.8
-- disabled on 10/25/2018
--insert into @fileSpecs (fileSpec) values ('c113')
--insert into @fileSpecs (fileSpec) values ('c119')
--insert into @fileSpecs (fileSpec) values ('c125')
--insert into @fileSpecs (fileSpec) values ('c127')
--insert into @fileSpecs (fileSpec) values ('c180')
--insert into @fileSpecs (fileSpec) values ('c181')

-- Updated on November 20th, 2018
-- Release 2.9
--insert into @fileSpecs (fileSpec) values ('c200')
--insert into @fileSpecs (fileSpec) values ('c201')
--insert into @fileSpecs (fileSpec) values ('c192')
--insert into @fileSpecs (fileSpec) values ('c202')
--insert into @fileSpecs (fileSpec) values ('c203')
--insert into @fileSpecs (fileSpec) values ('c206')
--insert into @fileSpecs (fileSpec) values ('c207')

-- Retired File specs
insert into @fileSpecs (fileSpec) values ('c167')

update app.GenerateReports set IsActive = 0 where ReportCode in (select fileSpec from @fileSpecs)

set nocount off;