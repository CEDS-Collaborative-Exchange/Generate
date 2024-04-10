--add relationships for Staging.IdeaDisabilityType table to the XREF table

--143
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 9 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (9, 13)
end

--089
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 12 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (12, 13)
end

--088
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 14 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (14, 13)
end

--009
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 15 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (15, 13)
end

--007
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 16 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (16, 13)
end

--006
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 17 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (17, 13)
end

--005
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 18 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (18, 13)
end

--002
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 19 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (19, 13)
end

--Add the new relational table for GenerateReports and DimFactTypes
IF OBJECT_ID('App.GenerateReport_FactType') IS NOT NULL
	DROP TABLE App.GenerateReport_FactType
		
CREATE TABLE App.GenerateReport_FactType (
	GenerateReportId int not null
	, FactTypeId int not null
)

INSERT INTO App.GenerateReport_FactType
VALUES 
(19,3),
(18,24),
(17,24),
(16,24),
(15,4),
(39,21),
(40,7),
(41,6),
(115,21),
(42,99),
(43,12),
(44,21),
(45,8),
(58,10),
(59,99),
(46,6),
(47,13),
(48,26),
(49,26),
(60,26),
(26,26),
(86,5),
(87,5),
(61,24),
(14,24),
(12,3),
(11,26),
(10,26),
(63,25),
(64,10),
(65,16),
(66,15),
(50,13),
(67,25),
(68,25),
(69,15),
(52,21),
(95,21),
(70,21),
(71,5),
(53,12),
(72,25),
(73,25),
(74,25),
(54,9),
(88,25),
(9,24),
(8,24),
(55,13),
(75,9),
(76,9),
(89,5),
(90,5),
(91,5),
(92,99),
(93,5),
(77,19),
(78,21),
(56,14),
(79,99),
(94,5),
(80,21),
(7,25),
(6,25),
(81,25),
(5,25),
(4,25),
(84,25),
(96,21),
(85,99),
(57,21),
(100,16),
(101,17),
(97,21),
(98,21),
(99,21),
(102,22),
(103,99),
(104,99),
(105,99),
(106,26),
(107,99),
(108,21),
(109,21),
(118,99),
(119,99),
(126,99),
(120,23),
(122,99),
(123,99),
(121,99),
(124,99),
(125,99),
(32,8),
(35,2),
(37,20),
(38,20),
(31,4),
(27,11),
(3,2),
(2,2),
(13,11),
(36,2),
(21,1),
(23,1),
(22,1),
(33,20),
(34,20),
(25,1),
(1,1),
(113,3),
(24,1),
(20,1),
(117,2),
(110,3),
(111,3),
(112,4),
(116,2),
(114,3)
