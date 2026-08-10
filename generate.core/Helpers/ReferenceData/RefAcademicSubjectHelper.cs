using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAcademicSubjectHelper
    {

        public static List<RefAcademicSubject> GetData()
        {
            /*
            select 'data.Add(new RefAcademicSubject() { 
            RefAcademicSubjectId = ' + convert(varchar(20), RefAcademicSubjectId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAcademicSubject
            */

            var data = new List<RefAcademicSubject>();

            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 1,
                Code = "13371",
                Description = "Arts"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 2,
                Code = "73065",
                Description = "Career and Technical Education"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 3,
                Code = "13372",
                Description = "English"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 4,
                Code = "00256",
                Description = "English as a second language (ESL)"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 5,
                Code = "00546",
                Description = "Foreign Languages"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 6,
                Code = "73088",
                Description = "History Government - US"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 7,
                Code = "73089",
                Description = "History Government - World"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 8,
                Code = "00554",
                Description = "Language arts"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 9,
                Code = "01166",
                Description = "Mathematics"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 10,
                Code = "00560",
                Description = "Reading"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 11,
                Code = "13373",
                Description = "Reading/Language Arts"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 12,
                Code = "00562",
                Description = "Science"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 13,
                Code = "73086",
                Description = "Science - Life"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 14,
                Code = "73087",
                Description = "Science - Physical"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 15,
                Code = "13374",
                Description = "Social Sciences (History, Geography, Economics, Civics and Government)"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 16,
                Code = "02043",
                Description = "Special education"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 17,
                Code = "01287",
                Description = "Writing"
            });
            data.Add(new RefAcademicSubject()
            {
                RefAcademicSubjectId = 18,
                Code = "09999",
                Description = "Other"
            });

            return data;
        }
    }
}
