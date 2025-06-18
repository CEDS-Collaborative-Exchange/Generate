USE [generate]
GO

ALTER TABLE [App].[CategorySets] 
ALTER COLUMN CategorySetCode NVARCHAR(2500) NOT NULL
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c211','Title III English Learner Exited','c211',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c218','N or D in Program Outcomes – State Agency','c218',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c219','N or D in Program Outcomes – LEA','c218',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c220','N or D Exit Outcomes – State Agency','c220',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c221','N or D Exit Outcomes – LEA','c221',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c222','Foster Care Enrolled','c222',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c223','Title I School Status','c223',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c226','Economically Disadvantaged Students','c226',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c224','N or D Assessment Proficiency – State Agency','c224',1,1,0,0,0,0,1)
 
INSERT INTO [App].[GenerateReports]
           ([GenerateReportControlTypeId]
           ,[GenerateReportTypeId]
           ,[IsActive]
           ,[ReportCode]
           ,[ReportName]
           ,[ReportShortName]
           ,[ShowCategorySetControl]
           ,[ShowData]
           ,[ShowFilterControl]
           ,[ShowGraph]
           ,[ShowSubFilterControl]
           ,[IsLocked]
           ,[UseLegacyReportMigration])
VALUES(2,3,1,'c225','N or D Assessment Proficiency – LEA','c225',1,1,0,0,0,0,1)
GO
 