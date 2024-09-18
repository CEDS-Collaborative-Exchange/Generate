using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public static class CategorySetHelper
    {
        public static List<CategorySet> GetData(int? generateReportId = null)
        {
            var data = new List<CategorySet>();

            /*

            	declare @categorySetId as int
	            declare @generateReportId as int
	            declare @tableTypeId as int
	            declare @organizationLevelId as int
	            declare @submissionYear as varchar(500)
	            declare @categorySetCode as varchar(500)
	            declare @categorySetName as varchar(500)

	            DECLARE categorySetCursor CURSOR FOR 
	            SELECT CategorySetId,
	            GenerateReportId, 
	            ISNULL(TableTypeId, ''),
	            CategorySetCode,
				CategorySetName,
	            SubmissionYear,
	            OrganizationLevelId
                from App.CategorySets
	            where SubmissionYear = '2018-19'
	           -- and not TableTypeId is null
	            and not CategorySetCode is null

	            OPEN categorySetCursor
	            FETCH NEXT FROM categorySetCursor INTO @categorySetId, @generateReportId, @tableTypeId, @categorySetCode, @categorySetName, @submissionYear, @organizationLevelId

	            WHILE @@FETCH_STATUS = 0
	            BEGIN


		            declare @categories as varchar(max)
		            set @categories = null

		            if exists (select '' FROM [App].[CategorySet_Categories] WHERE CategorySetId = @categorySetId)
		            begin
			            select @categories = COALESCE(@categories+', ' ,'') + 'new CategorySet_Category() { CategoryId = ' + convert(varchar(20), c.[CategoryId]) + '}' 
			            FROM [App].[CategorySet_Categories] csc
			            inner join [App].[Categories] c on csc.CategoryId = c.CategoryId
			            WHERE csc.CategorySetId = @categorySetId
			            order by c.CategoryCode
		            end

		            declare @code as varchar(max)

		            set @code = '
			            data.Add(new CategorySet() { 
				            CategorySetId = ' + convert(varchar(20), @categorySetId) + ',
				            GenerateReportId = ' + convert(varchar(20), @generateReportId) + ',
				            CategorySetCode = "' + @categorySetCode + '",
							CategorySetName = "' + @categorySetName + '",
				            SubmissionYear = "' + @submissionYear + '",
				            TableTypeId = ' + convert(varchar(20), @tableTypeId) + ',
				            OrganizationLevelId = ' + convert(varchar(20), @organizationLevelId) 

		            if @categories <> ''
		            begin

			            set @code = @code + ',
				            CategorySet_Categories = new List<CategorySet_Category>() { ' + @categories + '	}
				            '
		            end

		            set @code = @code + '});'

		            print @code

		            FETCH NEXT FROM categorySetCursor INTO @categorySetId, @generateReportId, @tableTypeId, @categorySetCode, @categorySetName, @submissionYear, @organizationLevelId
	            END
	
	            CLOSE categorySetCursor
	            DEALLOCATE categorySetCursor

            */



            data.Add(new CategorySet()
            {
                CategorySetId = 6170,
                GenerateReportId = 21,
                CategorySetCode = "studentcount",
                CategorySetName = "Student Count",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6171,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sex",
                CategorySetName = "SWD in Title I Schools, by Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6172,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1",
                CategorySetName = "SWD in Title I Schools",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6173,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sexgrade",
                CategorySetName = "SWD in Title I Schools, by Sex and Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6174,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1grade",
                CategorySetName = "SWD in Title I Schools, by Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6175,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sex",
                CategorySetName = "SWD in Title I Schools, by Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6176,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1",
                CategorySetName = "SWD in Title I Schools",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6177,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sexgrade",
                CategorySetName = "SWD in Title I Schools, by Sex and Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6178,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1grade",
                CategorySetName = "SWD in Title I Schools, by Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6179,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sex",
                CategorySetName = "SWD in Title I Schools, by Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6180,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1",
                CategorySetName = "SWD in Title I Schools",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6181,
                GenerateReportId = 24,
                CategorySetCode = "studentsubpopulation",
                CategorySetName = "Student Subpopulation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6182,
                GenerateReportId = 24,
                CategorySetCode = "studentsubpopulation",
                CategorySetName = "Student Subpopulation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6183,
                GenerateReportId = 22,
                CategorySetCode = "studentdiscipline",
                CategorySetName = "Student Discipline",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 1 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6184,
                GenerateReportId = 22,
                CategorySetCode = "studentdiscipline",
                CategorySetName = "Student Discipline",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 1 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6185,
                GenerateReportId = 23,
                CategorySetCode = "studentdisability",
                CategorySetName = "Student Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6186,
                GenerateReportId = 23,
                CategorySetCode = "studentdisability",
                CategorySetName = "Student Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6187,
                GenerateReportId = 25,
                CategorySetCode = "studentrace",
                CategorySetName = "Student Race",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6188,
                GenerateReportId = 25,
                CategorySetCode = "studentrace",
                CategorySetName = "Student Race",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6189,
                GenerateReportId = 1,
                CategorySetCode = "studentsex",
                CategorySetName = "Student Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6190,
                GenerateReportId = 1,
                CategorySetCode = "studentsex",
                CategorySetName = "Student Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6191,
                GenerateReportId = 21,
                CategorySetCode = "studentcount",
                CategorySetName = "Student Count",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6192,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1grade",
                CategorySetName = "SWD in Title I Schools, by Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6193,
                GenerateReportId = 20,
                CategorySetCode = "studentswdtitle1sexgrade",
                CategorySetName = "SWD in Title I Schools, by Sex and Grade",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 147 }, new CategorySet_Category() { CategoryId = 148 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6196,
                GenerateReportId = 27,
                CategorySetCode = "COMPARISON",
                CategorySetName = "Comparison",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6198,
                GenerateReportId = 27,
                CategorySetCode = "COMPARISON",
                CategorySetName = "Comparison",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6200,
                GenerateReportId = 27,
                CategorySetCode = "AUT",
                CategorySetName = "Disability - Autism",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6202,
                GenerateReportId = 27,
                CategorySetCode = "AUT",
                CategorySetName = "Disability - Autism",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6204,
                GenerateReportId = 27,
                CategorySetCode = "EMN",
                CategorySetName = "Disability - Emotional disturbance",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6206,
                GenerateReportId = 27,
                CategorySetCode = "EMN",
                CategorySetName = "Disability - Emotional disturbance",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6207,
                GenerateReportId = 13,
                CategorySetCode = "COMPARISON",
                CategorySetName = "Comparison",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6210,
                GenerateReportId = 27,
                CategorySetCode = "MR",
                CategorySetName = "Disability - Intellectual disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6212,
                GenerateReportId = 27,
                CategorySetCode = "OHI",
                CategorySetName = "Disability - Other health impairment",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6214,
                GenerateReportId = 27,
                CategorySetCode = "OHI",
                CategorySetName = "Disability - Other health impairment",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6216,
                GenerateReportId = 27,
                CategorySetCode = "SLI",
                CategorySetName = "Disability - Speech or language impairment",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6218,
                GenerateReportId = 27,
                CategorySetCode = "SLI",
                CategorySetName = "Disability - Speech or language impairment",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6220,
                GenerateReportId = 27,
                CategorySetCode = "SLD",
                CategorySetName = "Disability - Specific learning disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6221,
                GenerateReportId = 27,
                CategorySetCode = "MR",
                CategorySetName = "Disability - Intellectual disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6223,
                GenerateReportId = 13,
                CategorySetCode = "COMPARISON",
                CategorySetName = "Comparison",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6226,
                GenerateReportId = 3,
                CategorySetCode = "ALL",
                CategorySetName = "All",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6229,
                GenerateReportId = 2,
                CategorySetCode = "AM7",
                CategorySetName = "American Indian or Alaskan Native",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6232,
                GenerateReportId = 2,
                CategorySetCode = "AS7",
                CategorySetName = "Asian",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6235,
                GenerateReportId = 2,
                CategorySetCode = "BL7",
                CategorySetName = "Black or African American",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6238,
                GenerateReportId = 2,
                CategorySetCode = "HI7",
                CategorySetName = "Hispanic/Latino",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6241,
                GenerateReportId = 2,
                CategorySetCode = "PI7",
                CategorySetName = "Native Hawaiian or Other Pacific Islander",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6244,
                GenerateReportId = 2,
                CategorySetCode = "WH7",
                CategorySetName = "White",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6247,
                GenerateReportId = 2,
                CategorySetCode = "MU7",
                CategorySetName = "Two or more races",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6249,
                GenerateReportId = 13,
                CategorySetCode = "ALL",
                CategorySetName = "All Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6251,
                GenerateReportId = 13,
                CategorySetCode = "ALL",
                CategorySetName = "All Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 6253,
                GenerateReportId = 27,
                CategorySetCode = "SLD",
                CategorySetName = "Disability - Specific learning disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 7457,
                GenerateReportId = 80,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8592,
                GenerateReportId = 31,
                CategorySetCode = "disabilitystatus",
                CategorySetName = "Disability Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 250 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8593,
                GenerateReportId = 31,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8594,
                GenerateReportId = 31,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8595,
                GenerateReportId = 31,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8596,
                GenerateReportId = 31,
                CategorySetCode = "lepstatus",
                CategorySetName = "EL Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8597,
                GenerateReportId = 31,
                CategorySetCode = "cteparticipation",
                CategorySetName = "CTE Participation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 452 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8598,
                GenerateReportId = 31,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8599,
                GenerateReportId = 31,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8600,
                GenerateReportId = 31,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8601,
                GenerateReportId = 31,
                CategorySetCode = "homeless",
                CategorySetName = "Homeless",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 422 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8602,
                GenerateReportId = 31,
                CategorySetCode = "disabilitystatus",
                CategorySetName = "Disability Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 250 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8603,
                GenerateReportId = 31,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8604,
                GenerateReportId = 31,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8605,
                GenerateReportId = 31,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8606,
                GenerateReportId = 31,
                CategorySetCode = "lepstatus",
                CategorySetName = "EL Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8607,
                GenerateReportId = 31,
                CategorySetCode = "cteparticipation",
                CategorySetName = "CTE Participation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 452 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8608,
                GenerateReportId = 31,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8609,
                GenerateReportId = 31,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8610,
                GenerateReportId = 31,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8611,
                GenerateReportId = 31,
                CategorySetCode = "homeless",
                CategorySetName = "Homeless",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 422 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8612,
                GenerateReportId = 31,
                CategorySetCode = "disabilitystatus",
                CategorySetName = "Disability Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 250 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8613,
                GenerateReportId = 31,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8614,
                GenerateReportId = 31,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8615,
                GenerateReportId = 31,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8616,
                GenerateReportId = 31,
                CategorySetCode = "lepstatus",
                CategorySetName = "EL Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8617,
                GenerateReportId = 31,
                CategorySetCode = "cteparticipation",
                CategorySetName = "CTE Participation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 452 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8618,
                GenerateReportId = 31,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8619,
                GenerateReportId = 31,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8620,
                GenerateReportId = 31,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8621,
                GenerateReportId = 31,
                CategorySetCode = "homeless",
                CategorySetName = "Homeless",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 422 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8637,
                GenerateReportId = 33,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8638,
                GenerateReportId = 33,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8639,
                GenerateReportId = 33,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8655,
                GenerateReportId = 34,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8656,
                GenerateReportId = 34,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8657,
                GenerateReportId = 34,
                CategorySetCode = "CatSetA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 455 }, new CategorySet_Category() { CategoryId = 454 }, new CategorySet_Category() { CategoryId = 273 }, new CategorySet_Category() { CategoryId = 453 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 305 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8708,
                GenerateReportId = 35,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8709,
                GenerateReportId = 35,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8710,
                GenerateReportId = 35,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8711,
                GenerateReportId = 35,
                CategorySetCode = "cteparticipation",
                CategorySetName = "CTE Participation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8712,
                GenerateReportId = 35,
                CategorySetCode = "exitingspeceducation",
                CategorySetName = "Exiting Special Education",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8713,
                GenerateReportId = 35,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8714,
                GenerateReportId = 35,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8715,
                GenerateReportId = 35,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8716,
                GenerateReportId = 35,
                CategorySetCode = "cteparticipation",
                CategorySetName = "CTE Participation",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 452 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8717,
                GenerateReportId = 35,
                CategorySetCode = "exitingspeceducation",
                CategorySetName = "Exiting Special Education",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8748,
                GenerateReportId = 36,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8749,
                GenerateReportId = 36,
                CategorySetCode = "WDIS",
                CategorySetName = "Students With Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8750,
                GenerateReportId = 36,
                CategorySetCode = "WODIS",
                CategorySetName = "Students Without Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8751,
                GenerateReportId = 36,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8752,
                GenerateReportId = 36,
                CategorySetCode = "WDIS",
                CategorySetName = "Students With Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8753,
                GenerateReportId = 36,
                CategorySetCode = "WODIS",
                CategorySetName = "Students Without Disabilities",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 404 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8784,
                GenerateReportId = 37,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8785,
                GenerateReportId = 37,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8786,
                GenerateReportId = 37,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8787,
                GenerateReportId = 37,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8788,
                GenerateReportId = 37,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8789,
                GenerateReportId = 37,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8820,
                GenerateReportId = 38,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8821,
                GenerateReportId = 38,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8822,
                GenerateReportId = 38,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8823,
                GenerateReportId = 38,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8824,
                GenerateReportId = 38,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 8825,
                GenerateReportId = 38,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 9156,
                GenerateReportId = 78,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 9157,
                GenerateReportId = 78,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87892,
                GenerateReportId = 19,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87893,
                GenerateReportId = 19,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87894,
                GenerateReportId = 19,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87895,
                GenerateReportId = 19,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87896,
                GenerateReportId = 19,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87897,
                GenerateReportId = 19,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87898,
                GenerateReportId = 19,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87899,
                GenerateReportId = 19,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87900,
                GenerateReportId = 19,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87901,
                GenerateReportId = 19,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87902,
                GenerateReportId = 19,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87903,
                GenerateReportId = 19,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87904,
                GenerateReportId = 19,
                CategorySetCode = "ST7",
                CategorySetName = "Subtotal 7",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87905,
                GenerateReportId = 19,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87906,
                GenerateReportId = 19,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87907,
                GenerateReportId = 19,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87908,
                GenerateReportId = 19,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87909,
                GenerateReportId = 19,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87910,
                GenerateReportId = 19,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87911,
                GenerateReportId = 19,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87912,
                GenerateReportId = 19,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87913,
                GenerateReportId = 19,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87914,
                GenerateReportId = 19,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87915,
                GenerateReportId = 19,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87916,
                GenerateReportId = 19,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87917,
                GenerateReportId = 19,
                CategorySetCode = "ST7",
                CategorySetName = "Subtotal 7",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87918,
                GenerateReportId = 19,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87919,
                GenerateReportId = 19,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87920,
                GenerateReportId = 19,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87921,
                GenerateReportId = 19,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87922,
                GenerateReportId = 19,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87923,
                GenerateReportId = 19,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87924,
                GenerateReportId = 19,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87925,
                GenerateReportId = 19,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87926,
                GenerateReportId = 19,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87927,
                GenerateReportId = 19,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87928,
                GenerateReportId = 19,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87929,
                GenerateReportId = 19,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87930,
                GenerateReportId = 19,
                CategorySetCode = "ST7",
                CategorySetName = "Subtotal 7",
                SubmissionYear = "2018-19",
                TableTypeId = 275,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87931,
                GenerateReportId = 41,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 282,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 288 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87932,
                GenerateReportId = 41,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 281,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87933,
                GenerateReportId = 41,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 282,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87936,
                GenerateReportId = 46,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87937,
                GenerateReportId = 46,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87938,
                GenerateReportId = 46,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87939,
                GenerateReportId = 46,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87940,
                GenerateReportId = 46,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87941,
                GenerateReportId = 46,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87942,
                GenerateReportId = 46,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87943,
                GenerateReportId = 46,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87944,
                GenerateReportId = 46,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87945,
                GenerateReportId = 46,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87946,
                GenerateReportId = 46,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87947,
                GenerateReportId = 46,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87948,
                GenerateReportId = 46,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87949,
                GenerateReportId = 46,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87950,
                GenerateReportId = 46,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87951,
                GenerateReportId = 46,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87952,
                GenerateReportId = 46,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 266 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87953,
                GenerateReportId = 46,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 288,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87954,
                GenerateReportId = 48,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 291,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 308 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87955,
                GenerateReportId = 48,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 291,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87956,
                GenerateReportId = 48,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 291,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 308 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87957,
                GenerateReportId = 48,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 291,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87958,
                GenerateReportId = 48,
                CategorySetCode = "CategorySet?A",
                CategorySetName = "Category Set? A",
                SubmissionYear = "2018-19",
                TableTypeId = 290,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87959,
                GenerateReportId = 12,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87960,
                GenerateReportId = 12,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87961,
                GenerateReportId = 12,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87962,
                GenerateReportId = 12,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87963,
                GenerateReportId = 12,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87964,
                GenerateReportId = 12,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87965,
                GenerateReportId = 12,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87966,
                GenerateReportId = 12,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87967,
                GenerateReportId = 12,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87968,
                GenerateReportId = 12,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87969,
                GenerateReportId = 12,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87970,
                GenerateReportId = 12,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87971,
                GenerateReportId = 12,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87972,
                GenerateReportId = 12,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87973,
                GenerateReportId = 12,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87974,
                GenerateReportId = 12,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87975,
                GenerateReportId = 12,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87976,
                GenerateReportId = 12,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87977,
                GenerateReportId = 12,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87978,
                GenerateReportId = 12,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87979,
                GenerateReportId = 12,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87980,
                GenerateReportId = 12,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 299,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87981,
                GenerateReportId = 54,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87982,
                GenerateReportId = 54,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 439 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87983,
                GenerateReportId = 54,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87984,
                GenerateReportId = 54,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87985,
                GenerateReportId = 54,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87986,
                GenerateReportId = 54,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87987,
                GenerateReportId = 54,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 439 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87988,
                GenerateReportId = 54,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87989,
                GenerateReportId = 54,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87990,
                GenerateReportId = 54,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87991,
                GenerateReportId = 54,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87992,
                GenerateReportId = 54,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 439 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87993,
                GenerateReportId = 54,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87994,
                GenerateReportId = 54,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87995,
                GenerateReportId = 54,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 310,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87996,
                GenerateReportId = 77,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87997,
                GenerateReportId = 77,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87998,
                GenerateReportId = 77,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 87999,
                GenerateReportId = 77,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88000,
                GenerateReportId = 77,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88001,
                GenerateReportId = 77,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88002,
                GenerateReportId = 77,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88003,
                GenerateReportId = 77,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88004,
                GenerateReportId = 77,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88005,
                GenerateReportId = 77,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88006,
                GenerateReportId = 77,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88007,
                GenerateReportId = 77,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88008,
                GenerateReportId = 77,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88009,
                GenerateReportId = 77,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88010,
                GenerateReportId = 77,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88011,
                GenerateReportId = 77,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88012,
                GenerateReportId = 77,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88013,
                GenerateReportId = 77,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 343,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 426 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88014,
                GenerateReportId = 7,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88015,
                GenerateReportId = 7,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88016,
                GenerateReportId = 7,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88017,
                GenerateReportId = 7,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88018,
                GenerateReportId = 7,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88019,
                GenerateReportId = 7,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88020,
                GenerateReportId = 7,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88021,
                GenerateReportId = 7,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88022,
                GenerateReportId = 7,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88023,
                GenerateReportId = 7,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88024,
                GenerateReportId = 7,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88025,
                GenerateReportId = 7,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88026,
                GenerateReportId = 7,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88027,
                GenerateReportId = 7,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88028,
                GenerateReportId = 7,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88029,
                GenerateReportId = 7,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88030,
                GenerateReportId = 7,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88031,
                GenerateReportId = 7,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88032,
                GenerateReportId = 7,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88033,
                GenerateReportId = 7,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88034,
                GenerateReportId = 7,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88035,
                GenerateReportId = 7,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88036,
                GenerateReportId = 7,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88037,
                GenerateReportId = 7,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88038,
                GenerateReportId = 7,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88039,
                GenerateReportId = 7,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88040,
                GenerateReportId = 7,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88041,
                GenerateReportId = 7,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88042,
                GenerateReportId = 7,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88043,
                GenerateReportId = 7,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 315,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88044,
                GenerateReportId = 6,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88045,
                GenerateReportId = 6,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88046,
                GenerateReportId = 6,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88047,
                GenerateReportId = 6,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 423 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88048,
                GenerateReportId = 6,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88049,
                GenerateReportId = 6,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88050,
                GenerateReportId = 6,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88051,
                GenerateReportId = 6,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88052,
                GenerateReportId = 6,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88053,
                GenerateReportId = 6,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88054,
                GenerateReportId = 6,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88055,
                GenerateReportId = 6,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88056,
                GenerateReportId = 6,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88057,
                GenerateReportId = 6,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 423 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88058,
                GenerateReportId = 6,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88059,
                GenerateReportId = 6,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88060,
                GenerateReportId = 6,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88061,
                GenerateReportId = 6,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88062,
                GenerateReportId = 6,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88063,
                GenerateReportId = 6,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88064,
                GenerateReportId = 6,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88065,
                GenerateReportId = 6,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88066,
                GenerateReportId = 6,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88067,
                GenerateReportId = 6,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 423 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88068,
                GenerateReportId = 6,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88069,
                GenerateReportId = 6,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88070,
                GenerateReportId = 6,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88071,
                GenerateReportId = 6,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88072,
                GenerateReportId = 6,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88073,
                GenerateReportId = 6,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 318,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88074,
                GenerateReportId = 81,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88075,
                GenerateReportId = 81,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88076,
                GenerateReportId = 81,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88077,
                GenerateReportId = 81,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88078,
                GenerateReportId = 81,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88079,
                GenerateReportId = 81,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88080,
                GenerateReportId = 81,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88081,
                GenerateReportId = 81,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88082,
                GenerateReportId = 81,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88083,
                GenerateReportId = 81,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88084,
                GenerateReportId = 81,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88085,
                GenerateReportId = 81,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88086,
                GenerateReportId = 81,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88087,
                GenerateReportId = 81,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88088,
                GenerateReportId = 81,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88089,
                GenerateReportId = 81,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88090,
                GenerateReportId = 81,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88091,
                GenerateReportId = 81,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88092,
                GenerateReportId = 81,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88093,
                GenerateReportId = 81,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88094,
                GenerateReportId = 81,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88095,
                GenerateReportId = 81,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88096,
                GenerateReportId = 81,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88097,
                GenerateReportId = 81,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88098,
                GenerateReportId = 81,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88099,
                GenerateReportId = 81,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88100,
                GenerateReportId = 81,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88101,
                GenerateReportId = 81,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88102,
                GenerateReportId = 81,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88103,
                GenerateReportId = 81,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 319,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 431 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 301 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88104,
                GenerateReportId = 5,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88105,
                GenerateReportId = 5,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88106,
                GenerateReportId = 5,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88107,
                GenerateReportId = 5,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88108,
                GenerateReportId = 5,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88109,
                GenerateReportId = 5,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88110,
                GenerateReportId = 5,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88111,
                GenerateReportId = 5,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88112,
                GenerateReportId = 5,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88113,
                GenerateReportId = 5,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88114,
                GenerateReportId = 5,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88115,
                GenerateReportId = 5,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88116,
                GenerateReportId = 5,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88117,
                GenerateReportId = 5,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88118,
                GenerateReportId = 5,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88119,
                GenerateReportId = 5,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88120,
                GenerateReportId = 5,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88121,
                GenerateReportId = 5,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88122,
                GenerateReportId = 5,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88123,
                GenerateReportId = 5,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88124,
                GenerateReportId = 5,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88125,
                GenerateReportId = 5,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88126,
                GenerateReportId = 5,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88127,
                GenerateReportId = 5,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88128,
                GenerateReportId = 5,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88129,
                GenerateReportId = 5,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88130,
                GenerateReportId = 5,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88131,
                GenerateReportId = 5,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88132,
                GenerateReportId = 5,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88133,
                GenerateReportId = 5,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 321,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88134,
                GenerateReportId = 4,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88135,
                GenerateReportId = 4,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88136,
                GenerateReportId = 4,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88137,
                GenerateReportId = 4,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88138,
                GenerateReportId = 4,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88139,
                GenerateReportId = 4,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88140,
                GenerateReportId = 4,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88141,
                GenerateReportId = 4,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88142,
                GenerateReportId = 4,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88143,
                GenerateReportId = 4,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88144,
                GenerateReportId = 4,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88145,
                GenerateReportId = 4,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88146,
                GenerateReportId = 4,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88147,
                GenerateReportId = 4,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88148,
                GenerateReportId = 4,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88149,
                GenerateReportId = 4,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88150,
                GenerateReportId = 4,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88151,
                GenerateReportId = 4,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88152,
                GenerateReportId = 4,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88153,
                GenerateReportId = 4,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88154,
                GenerateReportId = 4,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88155,
                GenerateReportId = 4,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88156,
                GenerateReportId = 4,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88157,
                GenerateReportId = 4,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88158,
                GenerateReportId = 4,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88159,
                GenerateReportId = 4,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88160,
                GenerateReportId = 4,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88161,
                GenerateReportId = 4,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88162,
                GenerateReportId = 4,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 88163,
                GenerateReportId = 4,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 322,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 432 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 107898,
                GenerateReportId = 109,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 495 }, new CategorySet_Category() { CategoryId = 496 }, new CategorySet_Category() { CategoryId = 497 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114475,
                GenerateReportId = 39,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114476,
                GenerateReportId = 39,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114477,
                GenerateReportId = 39,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114478,
                GenerateReportId = 44,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114479,
                GenerateReportId = 44,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 114480,
                GenerateReportId = 52,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 162593,
                GenerateReportId = 95,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 162594,
                GenerateReportId = 96,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1112
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 162595,
                GenerateReportId = 97,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1182
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 162596,
                GenerateReportId = 98,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 162597,
                GenerateReportId = 99,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169249,
                GenerateReportId = 110,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169250,
                GenerateReportId = 110,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169251,
                GenerateReportId = 110,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169252,
                GenerateReportId = 110,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169253,
                GenerateReportId = 110,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169254,
                GenerateReportId = 110,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169255,
                GenerateReportId = 110,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169256,
                GenerateReportId = 110,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169257,
                GenerateReportId = 110,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169258,
                GenerateReportId = 110,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169259,
                GenerateReportId = 110,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169260,
                GenerateReportId = 110,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169261,
                GenerateReportId = 110,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169262,
                GenerateReportId = 110,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169263,
                GenerateReportId = 110,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169399,
                GenerateReportId = 111,
                CategorySetCode = "all",
                CategorySetName = "All",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169400,
                GenerateReportId = 111,
                CategorySetCode = "earlychildhood",
                CategorySetName = "Early Childhood (EC 3-5)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169401,
                GenerateReportId = 111,
                CategorySetCode = "schoolage",
                CategorySetName = "School Age (SA 6-21)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169402,
                GenerateReportId = 111,
                CategorySetCode = "all",
                CategorySetName = "All",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169403,
                GenerateReportId = 111,
                CategorySetCode = "earlychildhood",
                CategorySetName = "Early Childhood (EC 3-5)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169404,
                GenerateReportId = 111,
                CategorySetCode = "schoolage",
                CategorySetName = "School Age (SA 6-21)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169405,
                GenerateReportId = 111,
                CategorySetCode = "all",
                CategorySetName = "All",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169406,
                GenerateReportId = 111,
                CategorySetCode = "earlychildhood",
                CategorySetName = "Early Childhood (EC 3-5)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169407,
                GenerateReportId = 111,
                CategorySetCode = "schoolage",
                CategorySetName = "School Age (SA 6-21)",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169627,
                GenerateReportId = 112,
                CategorySetCode = "exitOnly",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169628,
                GenerateReportId = 112,
                CategorySetCode = "exitWithSex",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169629,
                GenerateReportId = 112,
                CategorySetCode = "exitWithDisabilityType",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169630,
                GenerateReportId = 112,
                CategorySetCode = "exitWithRaceEthnic",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169631,
                GenerateReportId = 112,
                CategorySetCode = "exitWithLEPStatus",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169632,
                GenerateReportId = 112,
                CategorySetCode = "exitWithAge",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169633,
                GenerateReportId = 112,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169634,
                GenerateReportId = 112,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169635,
                GenerateReportId = 112,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169636,
                GenerateReportId = 112,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169637,
                GenerateReportId = 112,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169638,
                GenerateReportId = 112,
                CategorySetCode = "exitOnly",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169639,
                GenerateReportId = 112,
                CategorySetCode = "exitWithSex",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169640,
                GenerateReportId = 112,
                CategorySetCode = "exitWithDisabilityType",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169641,
                GenerateReportId = 112,
                CategorySetCode = "exitWithRaceEthnic",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169642,
                GenerateReportId = 112,
                CategorySetCode = "exitWithLEPStatus",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169643,
                GenerateReportId = 112,
                CategorySetCode = "exitWithAge",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169644,
                GenerateReportId = 112,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169645,
                GenerateReportId = 112,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169646,
                GenerateReportId = 112,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169647,
                GenerateReportId = 112,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169648,
                GenerateReportId = 112,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169649,
                GenerateReportId = 112,
                CategorySetCode = "exitOnly",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169650,
                GenerateReportId = 112,
                CategorySetCode = "exitWithSex",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169651,
                GenerateReportId = 112,
                CategorySetCode = "exitWithDisabilityType",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169652,
                GenerateReportId = 112,
                CategorySetCode = "exitWithRaceEthnic",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169653,
                GenerateReportId = 112,
                CategorySetCode = "exitWithLEPStatus",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169654,
                GenerateReportId = 112,
                CategorySetCode = "exitWithAge",
                CategorySetName = "Exit Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169655,
                GenerateReportId = 112,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169656,
                GenerateReportId = 112,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169657,
                GenerateReportId = 112,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169658,
                GenerateReportId = 112,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 169659,
                GenerateReportId = 112,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 490 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170023,
                GenerateReportId = 114,
                CategorySetCode = "removaltype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170024,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithgender",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170025,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithdisabilitytype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170026,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithraceethnic",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170027,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithlepstatus",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170028,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithage",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170029,
                GenerateReportId = 114,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170030,
                GenerateReportId = 114,
                CategorySetCode = "raceethnic",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170031,
                GenerateReportId = 114,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170032,
                GenerateReportId = 114,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170033,
                GenerateReportId = 114,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170034,
                GenerateReportId = 114,
                CategorySetCode = "removaltype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170035,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithgender",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170036,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithdisabilitytype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170037,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithraceethnic",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170038,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithlepstatus",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170039,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithage",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170040,
                GenerateReportId = 114,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170041,
                GenerateReportId = 114,
                CategorySetCode = "raceethnic",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170042,
                GenerateReportId = 114,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170043,
                GenerateReportId = 114,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170044,
                GenerateReportId = 114,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170045,
                GenerateReportId = 114,
                CategorySetCode = "removaltype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170046,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithgender",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170047,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithdisabilitytype",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170048,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithraceethnic",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170049,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithlepstatus",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170050,
                GenerateReportId = 114,
                CategorySetCode = "removaltypewithage",
                CategorySetName = "Removal Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170051,
                GenerateReportId = 114,
                CategorySetCode = "disabilitytype",
                CategorySetName = "Disability Type",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170052,
                GenerateReportId = 114,
                CategorySetCode = "raceethnic",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170053,
                GenerateReportId = 114,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170054,
                GenerateReportId = 114,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170055,
                GenerateReportId = 114,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 488 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170489,
                GenerateReportId = 113,
                CategorySetCode = "disability",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170490,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithraceethnic",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170491,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithgender",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170492,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithlepstatus",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170493,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithage",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170494,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithearlychildhood",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170495,
                GenerateReportId = 113,
                CategorySetCode = "disabilitywithschoolage",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170496,
                GenerateReportId = 113,
                CategorySetCode = "age",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170497,
                GenerateReportId = 113,
                CategorySetCode = "agewithraceethnic",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170498,
                GenerateReportId = 113,
                CategorySetCode = "agewithgender",
                CategorySetName = "Disability",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170499,
                GenerateReportId = 113,
                CategorySetCode = "agewithlepstatus",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170500,
                GenerateReportId = 113,
                CategorySetCode = "agewithdisability",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170501,
                GenerateReportId = 113,
                CategorySetCode = "agewithearlychildhood",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170502,
                GenerateReportId = 113,
                CategorySetCode = "agewithschoolage",
                CategorySetName = "Age",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170503,
                GenerateReportId = 113,
                CategorySetCode = "raceethnic",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170504,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithage",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170505,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithgender",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170506,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithlepstatus",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170507,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithdisability",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170508,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithearlychildhood",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170509,
                GenerateReportId = 113,
                CategorySetCode = "raceethnicwithschoolage",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170510,
                GenerateReportId = 113,
                CategorySetCode = "gender",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170511,
                GenerateReportId = 113,
                CategorySetCode = "genderwithage",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170512,
                GenerateReportId = 113,
                CategorySetCode = "genderwithraceethnic",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170513,
                GenerateReportId = 113,
                CategorySetCode = "genderwithlepstatus",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170514,
                GenerateReportId = 113,
                CategorySetCode = "genderwithdisability",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170515,
                GenerateReportId = 113,
                CategorySetCode = "genderwithearlychildhood",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170516,
                GenerateReportId = 113,
                CategorySetCode = "genderwithschoolage",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170517,
                GenerateReportId = 113,
                CategorySetCode = "lepstatus",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170518,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithage",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170519,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithgender",
                CategorySetName = "LEP Status",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170520,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithdisability",
                CategorySetName = "Gender",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170521,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithraceethnic",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170522,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithearlychildhood",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170523,
                GenerateReportId = 113,
                CategorySetCode = "lepstatuswithschoolage",
                CategorySetName = "Race/Ethnic",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170524,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhood",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170525,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhoodwithage",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170526,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhoodwithgender",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170527,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhoodwithdisability",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 358 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170528,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhoodwithraceethnic",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170529,
                GenerateReportId = 113,
                CategorySetCode = "earlychildhoodwithlepstatus",
                CategorySetName = "Educational Environment 3-5",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 357 }, new CategorySet_Category() { CategoryId = 358 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170530,
                GenerateReportId = 113,
                CategorySetCode = "schoolage",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170531,
                GenerateReportId = 113,
                CategorySetCode = "schoolagewithage",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 489 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170532,
                GenerateReportId = 113,
                CategorySetCode = "schoolagewithgender",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170533,
                GenerateReportId = 113,
                CategorySetCode = "schoolagewithdisability",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 363 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170534,
                GenerateReportId = 113,
                CategorySetCode = "schoolagewithraceethnic",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170535,
                GenerateReportId = 113,
                CategorySetCode = "schoolagewithlepstatus",
                CategorySetName = "Educational Environment 6-21",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 354 }, new CategorySet_Category() { CategoryId = 363 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170818,
                GenerateReportId = 18,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170819,
                GenerateReportId = 18,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170820,
                GenerateReportId = 18,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170821,
                GenerateReportId = 18,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170822,
                GenerateReportId = 18,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170823,
                GenerateReportId = 18,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170824,
                GenerateReportId = 18,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170825,
                GenerateReportId = 18,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170826,
                GenerateReportId = 18,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170827,
                GenerateReportId = 18,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 276,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 364 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170828,
                GenerateReportId = 17,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170829,
                GenerateReportId = 17,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170830,
                GenerateReportId = 17,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170831,
                GenerateReportId = 17,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170832,
                GenerateReportId = 17,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170833,
                GenerateReportId = 17,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170834,
                GenerateReportId = 17,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170835,
                GenerateReportId = 17,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170836,
                GenerateReportId = 17,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170837,
                GenerateReportId = 17,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 277,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 365 }, new CategorySet_Category() { CategoryId = 339 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170838,
                GenerateReportId = 16,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170839,
                GenerateReportId = 16,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170840,
                GenerateReportId = 16,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 366 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170841,
                GenerateReportId = 16,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170842,
                GenerateReportId = 16,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170843,
                GenerateReportId = 16,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170844,
                GenerateReportId = 16,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170845,
                GenerateReportId = 16,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 366 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170846,
                GenerateReportId = 16,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170847,
                GenerateReportId = 16,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 278,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 366 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170848,
                GenerateReportId = 15,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 232 }, new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 449 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170849,
                GenerateReportId = 15,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170850,
                GenerateReportId = 15,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170851,
                GenerateReportId = 15,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170852,
                GenerateReportId = 15,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170853,
                GenerateReportId = 15,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 232 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170854,
                GenerateReportId = 15,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170855,
                GenerateReportId = 15,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170856,
                GenerateReportId = 15,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170857,
                GenerateReportId = 15,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 449 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170858,
                GenerateReportId = 15,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170859,
                GenerateReportId = 15,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 232 }, new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 449 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170860,
                GenerateReportId = 15,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170861,
                GenerateReportId = 15,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170862,
                GenerateReportId = 15,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 }, new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170863,
                GenerateReportId = 15,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 243 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170864,
                GenerateReportId = 15,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 232 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170865,
                GenerateReportId = 15,
                CategorySetCode = "ST3",
                CategorySetName = "Subtotal 3",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170866,
                GenerateReportId = 15,
                CategorySetCode = "ST4",
                CategorySetName = "Subtotal 4",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170867,
                GenerateReportId = 15,
                CategorySetCode = "ST5",
                CategorySetName = "Subtotal 5",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170868,
                GenerateReportId = 15,
                CategorySetCode = "ST6",
                CategorySetName = "Subtotal 6",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 449 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170869,
                GenerateReportId = 15,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 279,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170870,
                GenerateReportId = 58,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170871,
                GenerateReportId = 58,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 439 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170872,
                GenerateReportId = 58,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 375 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170873,
                GenerateReportId = 58,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170874,
                GenerateReportId = 58,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170875,
                GenerateReportId = 58,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 439 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170876,
                GenerateReportId = 58,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 375 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170877,
                GenerateReportId = 58,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 286,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170878,
                GenerateReportId = 59,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170879,
                GenerateReportId = 59,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170880,
                GenerateReportId = 59,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170881,
                GenerateReportId = 59,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170882,
                GenerateReportId = 59,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170883,
                GenerateReportId = 59,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 287,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 400 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170884,
                GenerateReportId = 60,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 295,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 244 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170885,
                GenerateReportId = 60,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 295,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 244 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170886,
                GenerateReportId = 26,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 }, new CategorySet_Category() { CategoryId = 474 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170887,
                GenerateReportId = 26,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170888,
                GenerateReportId = 26,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 474 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170889,
                GenerateReportId = 26,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170890,
                GenerateReportId = 26,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 }, new CategorySet_Category() { CategoryId = 474 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170891,
                GenerateReportId = 26,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170892,
                GenerateReportId = 26,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 474 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170893,
                GenerateReportId = 26,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 297,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170894,
                GenerateReportId = 86,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170895,
                GenerateReportId = 86,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170896,
                GenerateReportId = 86,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170897,
                GenerateReportId = 86,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170898,
                GenerateReportId = 86,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170899,
                GenerateReportId = 86,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170900,
                GenerateReportId = 86,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170901,
                GenerateReportId = 86,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 414 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170902,
                GenerateReportId = 86,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 416 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170903,
                GenerateReportId = 86,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 326,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170904,
                GenerateReportId = 87,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170905,
                GenerateReportId = 87,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170906,
                GenerateReportId = 87,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 419 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170907,
                GenerateReportId = 87,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170908,
                GenerateReportId = 87,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170909,
                GenerateReportId = 87,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170910,
                GenerateReportId = 87,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 413 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170911,
                GenerateReportId = 87,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 414 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170912,
                GenerateReportId = 87,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 }, new CategorySet_Category() { CategoryId = 416 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170913,
                GenerateReportId = 87,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 417 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170914,
                GenerateReportId = 87,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 327,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170915,
                GenerateReportId = 14,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170916,
                GenerateReportId = 14,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170917,
                GenerateReportId = 14,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170918,
                GenerateReportId = 14,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170919,
                GenerateReportId = 14,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170920,
                GenerateReportId = 14,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170921,
                GenerateReportId = 14,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170922,
                GenerateReportId = 14,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 361 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170923,
                GenerateReportId = 14,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170924,
                GenerateReportId = 14,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170925,
                GenerateReportId = 14,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 361 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170926,
                GenerateReportId = 14,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 298,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170927,
                GenerateReportId = 11,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 300,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 244 }, new CategorySet_Category() { CategoryId = 341 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170928,
                GenerateReportId = 11,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 300,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 341 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170929,
                GenerateReportId = 11,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 300,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 244 }, new CategorySet_Category() { CategoryId = 341 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170930,
                GenerateReportId = 11,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 300,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 341 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170931,
                GenerateReportId = 10,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 }, new CategorySet_Category() { CategoryId = 348 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170932,
                GenerateReportId = 10,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 348 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170933,
                GenerateReportId = 10,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170934,
                GenerateReportId = 10,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170935,
                GenerateReportId = 10,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 }, new CategorySet_Category() { CategoryId = 348 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170936,
                GenerateReportId = 10,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 348 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170937,
                GenerateReportId = 10,
                CategorySetCode = "ST2",
                CategorySetName = "Subtotal 2",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 377 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170938,
                GenerateReportId = 10,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 301,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170939,
                GenerateReportId = 64,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170940,
                GenerateReportId = 64,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 }, new CategorySet_Category() { CategoryId = 476 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170941,
                GenerateReportId = 64,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170942,
                GenerateReportId = 64,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170943,
                GenerateReportId = 64,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 443 }, new CategorySet_Category() { CategoryId = 476 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170944,
                GenerateReportId = 64,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 302,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170945,
                GenerateReportId = 65,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 441 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170946,
                GenerateReportId = 65,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 271 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170947,
                GenerateReportId = 65,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170948,
                GenerateReportId = 65,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170949,
                GenerateReportId = 65,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170950,
                GenerateReportId = 65,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 270 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170951,
                GenerateReportId = 65,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 270 }, new CategorySet_Category() { CategoryId = 271 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170952,
                GenerateReportId = 65,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170953,
                GenerateReportId = 65,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 441 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170954,
                GenerateReportId = 65,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 271 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170955,
                GenerateReportId = 65,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170956,
                GenerateReportId = 65,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170957,
                GenerateReportId = 65,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170958,
                GenerateReportId = 65,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 270 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170959,
                GenerateReportId = 65,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 270 }, new CategorySet_Category() { CategoryId = 271 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170960,
                GenerateReportId = 65,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 338,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170961,
                GenerateReportId = 50,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170962,
                GenerateReportId = 50,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 444 }, new CategorySet_Category() { CategoryId = 392 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170963,
                GenerateReportId = 50,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 444 }, new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170964,
                GenerateReportId = 50,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 }, new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170965,
                GenerateReportId = 50,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 }, new CategorySet_Category() { CategoryId = 445 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170966,
                GenerateReportId = 50,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 }, new CategorySet_Category() { CategoryId = 374 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170967,
                GenerateReportId = 50,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 }, new CategorySet_Category() { CategoryId = 446 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170968,
                GenerateReportId = 50,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170969,
                GenerateReportId = 50,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 303,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170970,
                GenerateReportId = 51,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 304,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 442 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170971,
                GenerateReportId = 51,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 304,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170972,
                GenerateReportId = 68,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 384 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170973,
                GenerateReportId = 68,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 230 }, new CategorySet_Category() { CategoryId = 384 }, new CategorySet_Category() { CategoryId = 418 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170974,
                GenerateReportId = 68,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 230 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 384 }, new CategorySet_Category() { CategoryId = 418 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170975,
                GenerateReportId = 68,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 384 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170976,
                GenerateReportId = 68,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 230 }, new CategorySet_Category() { CategoryId = 384 }, new CategorySet_Category() { CategoryId = 418 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170977,
                GenerateReportId = 68,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 305,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 230 }, new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 384 }, new CategorySet_Category() { CategoryId = 418 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170978,
                GenerateReportId = 71,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 340,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170979,
                GenerateReportId = 71,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 339,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170980,
                GenerateReportId = 72,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170981,
                GenerateReportId = 72,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170982,
                GenerateReportId = 72,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170983,
                GenerateReportId = 72,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170984,
                GenerateReportId = 72,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170985,
                GenerateReportId = 72,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 307,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170986,
                GenerateReportId = 73,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170987,
                GenerateReportId = 73,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170988,
                GenerateReportId = 73,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170989,
                GenerateReportId = 73,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170990,
                GenerateReportId = 73,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170991,
                GenerateReportId = 73,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170992,
                GenerateReportId = 73,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170993,
                GenerateReportId = 73,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170994,
                GenerateReportId = 73,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170995,
                GenerateReportId = 73,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170996,
                GenerateReportId = 73,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 404 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170997,
                GenerateReportId = 73,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 308,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 420 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170998,
                GenerateReportId = 74,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 309,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 475 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 170999,
                GenerateReportId = 74,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 309,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 475 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171000,
                GenerateReportId = 74,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 309,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 475 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171001,
                GenerateReportId = 88,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171002,
                GenerateReportId = 88,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171003,
                GenerateReportId = 88,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171004,
                GenerateReportId = 88,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171005,
                GenerateReportId = 88,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171006,
                GenerateReportId = 88,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171007,
                GenerateReportId = 88,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171008,
                GenerateReportId = 88,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 414 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171009,
                GenerateReportId = 88,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 416 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171010,
                GenerateReportId = 88,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 328,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 450 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171011,
                GenerateReportId = 9,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171012,
                GenerateReportId = 9,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171013,
                GenerateReportId = 9,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171014,
                GenerateReportId = 9,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171015,
                GenerateReportId = 9,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171016,
                GenerateReportId = 9,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 247 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171017,
                GenerateReportId = 9,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171018,
                GenerateReportId = 9,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171019,
                GenerateReportId = 9,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 351 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171020,
                GenerateReportId = 9,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 311,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171021,
                GenerateReportId = 8,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 312,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 389 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171022,
                GenerateReportId = 8,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 312,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 389 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171023,
                GenerateReportId = 89,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171024,
                GenerateReportId = 89,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171025,
                GenerateReportId = 89,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 410 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171026,
                GenerateReportId = 89,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 410 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171027,
                GenerateReportId = 89,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 294 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171028,
                GenerateReportId = 89,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171029,
                GenerateReportId = 89,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 410 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171030,
                GenerateReportId = 89,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 414 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171031,
                GenerateReportId = 89,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 }, new CategorySet_Category() { CategoryId = 416 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171032,
                GenerateReportId = 89,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 410 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171033,
                GenerateReportId = 89,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 329,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171034,
                GenerateReportId = 90,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171035,
                GenerateReportId = 90,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171036,
                GenerateReportId = 90,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171037,
                GenerateReportId = 90,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171038,
                GenerateReportId = 90,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171039,
                GenerateReportId = 90,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171040,
                GenerateReportId = 90,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171041,
                GenerateReportId = 90,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 414 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171042,
                GenerateReportId = 90,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171043,
                GenerateReportId = 90,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 330,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171044,
                GenerateReportId = 91,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171045,
                GenerateReportId = 91,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171046,
                GenerateReportId = 91,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171047,
                GenerateReportId = 91,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171048,
                GenerateReportId = 91,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171049,
                GenerateReportId = 91,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171050,
                GenerateReportId = 91,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171051,
                GenerateReportId = 91,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 414 }, new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171052,
                GenerateReportId = 91,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 411 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171053,
                GenerateReportId = 91,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 331,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171054,
                GenerateReportId = 92,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 353 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171055,
                GenerateReportId = 92,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171056,
                GenerateReportId = 92,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171057,
                GenerateReportId = 92,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171058,
                GenerateReportId = 92,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171059,
                GenerateReportId = 92,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 307 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171060,
                GenerateReportId = 92,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171061,
                GenerateReportId = 92,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 414 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171062,
                GenerateReportId = 92,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 416 }, new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171063,
                GenerateReportId = 92,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 412 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171064,
                GenerateReportId = 92,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 332,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171065,
                GenerateReportId = 93,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 434 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171066,
                GenerateReportId = 93,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 434 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171067,
                GenerateReportId = 93,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 419 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171068,
                GenerateReportId = 93,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171069,
                GenerateReportId = 93,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171070,
                GenerateReportId = 93,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 434 }, new CategorySet_Category() { CategoryId = 307 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171071,
                GenerateReportId = 93,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 413 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171072,
                GenerateReportId = 93,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 414 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171073,
                GenerateReportId = 93,
                CategorySetCode = "CSJ",
                CategorySetName = "Category Set J",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 416 }, new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171074,
                GenerateReportId = 93,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 434 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171075,
                GenerateReportId = 93,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 333,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171076,
                GenerateReportId = 94,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 334,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 433 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171077,
                GenerateReportId = 84,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171078,
                GenerateReportId = 84,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171079,
                GenerateReportId = 84,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171080,
                GenerateReportId = 84,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171081,
                GenerateReportId = 84,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171082,
                GenerateReportId = 84,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171083,
                GenerateReportId = 84,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171084,
                GenerateReportId = 84,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171085,
                GenerateReportId = 84,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171086,
                GenerateReportId = 84,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171087,
                GenerateReportId = 84,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171088,
                GenerateReportId = 84,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171089,
                GenerateReportId = 84,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171090,
                GenerateReportId = 84,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171091,
                GenerateReportId = 84,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171092,
                GenerateReportId = 84,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171093,
                GenerateReportId = 84,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171094,
                GenerateReportId = 84,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171095,
                GenerateReportId = 84,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171096,
                GenerateReportId = 84,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171097,
                GenerateReportId = 84,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 401 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171098,
                GenerateReportId = 84,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171099,
                GenerateReportId = 84,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171100,
                GenerateReportId = 84,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171101,
                GenerateReportId = 84,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171102,
                GenerateReportId = 84,
                CategorySetCode = "CSF",
                CategorySetName = "Category Set F",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171103,
                GenerateReportId = 84,
                CategorySetCode = "CSG",
                CategorySetName = "Category Set G",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171104,
                GenerateReportId = 84,
                CategorySetCode = "CSH",
                CategorySetName = "Category Set H",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 463 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171105,
                GenerateReportId = 84,
                CategorySetCode = "CSI",
                CategorySetName = "Category Set I",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 464 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171106,
                GenerateReportId = 84,
                CategorySetCode = "ST1",
                CategorySetName = "Subtotal 1",
                SubmissionYear = "2018-19",
                TableTypeId = 323,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 430 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171107,
                GenerateReportId = 100,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 345,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 461 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171108,
                GenerateReportId = 100,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 345,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 461 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171109,
                GenerateReportId = 101,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 303 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171110,
                GenerateReportId = 101,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171111,
                GenerateReportId = 101,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 462 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171112,
                GenerateReportId = 101,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171113,
                GenerateReportId = 101,
                CategorySetCode = "CSE",
                CategorySetName = "Category Set E",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 422 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171114,
                GenerateReportId = 101,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 346,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171115,
                GenerateReportId = 102,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 347,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171116,
                GenerateReportId = 102,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 347,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171117,
                GenerateReportId = 102,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 347,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171118,
                GenerateReportId = 102,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 347,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171119,
                GenerateReportId = 102,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 347,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171120,
                GenerateReportId = 103,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 348,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171121,
                GenerateReportId = 103,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 348,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171122,
                GenerateReportId = 103,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 348,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171123,
                GenerateReportId = 103,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 348,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171124,
                GenerateReportId = 103,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 348,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171125,
                GenerateReportId = 104,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 349,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 401 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171126,
                GenerateReportId = 104,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 349,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171127,
                GenerateReportId = 104,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 349,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171128,
                GenerateReportId = 104,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 349,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171129,
                GenerateReportId = 104,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 349,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171130,
                GenerateReportId = 105,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 350,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 470 }, new CategorySet_Category() { CategoryId = 401 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171131,
                GenerateReportId = 105,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 350,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 356 }, new CategorySet_Category() { CategoryId = 470 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171132,
                GenerateReportId = 105,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 350,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 470 }, new CategorySet_Category() { CategoryId = 350 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171133,
                GenerateReportId = 105,
                CategorySetCode = "CSD",
                CategorySetName = "Category Set D",
                SubmissionYear = "2018-19",
                TableTypeId = 350,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 470 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171134,
                GenerateReportId = 105,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 350,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 470 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171135,
                GenerateReportId = 106,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 471 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171136,
                GenerateReportId = 106,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 472 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171137,
                GenerateReportId = 106,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 473 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171138,
                GenerateReportId = 106,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171139,
                GenerateReportId = 106,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 471 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171140,
                GenerateReportId = 106,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 472 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171141,
                GenerateReportId = 106,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 473 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171142,
                GenerateReportId = 106,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171143,
                GenerateReportId = 106,
                CategorySetCode = "CSA",
                CategorySetName = "Category Set A",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 471 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171144,
                GenerateReportId = 106,
                CategorySetCode = "CSB",
                CategorySetName = "Category Set B",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 472 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171145,
                GenerateReportId = 106,
                CategorySetCode = "CSC",
                CategorySetName = "Category Set C",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 473 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171146,
                GenerateReportId = 106,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 351,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171147,
                GenerateReportId = 107,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 336,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171148,
                GenerateReportId = 107,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 335,
                OrganizationLevelId = 1
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171149,
                GenerateReportId = 107,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 335,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171150,
                GenerateReportId = 107,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 336,
                OrganizationLevelId = 2
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171151,
                GenerateReportId = 108,
                CategorySetCode = "TOT",
                CategorySetName = "Total of the Education Unit",
                SubmissionYear = "2018-19",
                TableTypeId = 337,
                OrganizationLevelId = 3
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171264,
                GenerateReportId = 116,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171265,
                GenerateReportId = 116,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171266,
                GenerateReportId = 116,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171267,
                GenerateReportId = 116,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171268,
                GenerateReportId = 116,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171269,
                GenerateReportId = 116,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171270,
                GenerateReportId = 116,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171271,
                GenerateReportId = 116,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171272,
                GenerateReportId = 116,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171273,
                GenerateReportId = 116,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171274,
                GenerateReportId = 116,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171275,
                GenerateReportId = 116,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171276,
                GenerateReportId = 116,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171277,
                GenerateReportId = 116,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171278,
                GenerateReportId = 116,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171279,
                GenerateReportId = 116,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171280,
                GenerateReportId = 116,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171281,
                GenerateReportId = 116,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171282,
                GenerateReportId = 116,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171283,
                GenerateReportId = 116,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 171284,
                GenerateReportId = 116,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172411,
                GenerateReportId = 117,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172412,
                GenerateReportId = 117,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172413,
                GenerateReportId = 117,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172414,
                GenerateReportId = 117,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172415,
                GenerateReportId = 117,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172416,
                GenerateReportId = 117,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172417,
                GenerateReportId = 117,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172418,
                GenerateReportId = 117,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172419,
                GenerateReportId = 117,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172420,
                GenerateReportId = 117,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172421,
                GenerateReportId = 117,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172422,
                GenerateReportId = 117,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172423,
                GenerateReportId = 117,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172424,
                GenerateReportId = 117,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172425,
                GenerateReportId = 117,
                CategorySetCode = "All",
                CategorySetName = "All Students",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172426,
                GenerateReportId = 117,
                CategorySetCode = "raceethnicity",
                CategorySetName = "Race/Ethnicity",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 303 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172427,
                GenerateReportId = 117,
                CategorySetCode = "sex",
                CategorySetName = "Sex",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 353 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172428,
                GenerateReportId = 117,
                CategorySetCode = "ideaindicator",
                CategorySetName = "IDEA Indicator",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 250 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172429,
                GenerateReportId = 117,
                CategorySetCode = "ecodis",
                CategorySetName = "Economically Disadvantaged",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 256 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172430,
                GenerateReportId = 117,
                CategorySetCode = "title1",
                CategorySetName = "Title 1",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 402 }, new CategorySet_Category() { CategoryId = 146 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172431,
                GenerateReportId = 117,
                CategorySetCode = "lepstatus",
                CategorySetName = "English Learner",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 351 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172470,
                GenerateReportId = 116,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172471,
                GenerateReportId = 116,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172472,
                GenerateReportId = 116,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172490,
                GenerateReportId = 117,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 1,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172491,
                GenerateReportId = 117,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 2,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });

            data.Add(new CategorySet()
            {
                CategorySetId = 172492,
                GenerateReportId = 117,
                CategorySetCode = "migrant",
                CategorySetName = "Migrant",
                SubmissionYear = "2018-19",
                TableTypeId = 0,
                OrganizationLevelId = 3,
                CategorySet_Categories = new List<CategorySet_Category>() { new CategorySet_Category() { CategoryId = 144 }, new CategorySet_Category() { CategoryId = 265 }, new CategorySet_Category() { CategoryId = 294 }, new CategorySet_Category() { CategoryId = 402 } }
            });




            return data;
        }
    }

}