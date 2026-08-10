using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefDisciplineLengthDifferenceReasonHelper
    {

        public static List<RefDisciplineLengthDifferenceReason> GetData()
        {
            /*
            select 'data.Add(new RefDisciplineLengthDifferenceReason() { 
            RefDisciplineLengthDifferenceReasonId = ' + convert(varchar(20), RefDisciplineLengthDifferenceReasonId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisciplineLengthDifferenceReason
            */

            var data = new List<RefDisciplineLengthDifferenceReason>();

            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 1,
                Code = "01",
                Description = "No Difference"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 2,
                Code = "02",
                Description = "Term Modified By District"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 3,
                Code = "03",
                Description = "Term Modified By Court Order"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 4,
                Code = "04",
                Description = "Term Modified By Mutual Agreement"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 5,
                Code = "05",
                Description = "Student Completed Term Requirements Sooner Than Expected"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 6,
                Code = "06",
                Description = "Student Incarcerated"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 7,
                Code = "07",
                Description = "Term Decreased Due To Extenuating Health-Related Circumstances"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 8,
                Code = "08",
                Description = "Student Withdrew From School"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 9,
                Code = "09",
                Description = "School Year Ended"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 10,
                Code = "10",
                Description = "Continuation Of Previous Year's Disciplinary Action Assignment"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 11,
                Code = "11",
                Description = "Term Modified By Placement Program Due To Student Behavior While In The Placement"
            });
            data.Add(new RefDisciplineLengthDifferenceReason()
            {
                RefDisciplineLengthDifferenceReasonId = 12,
                Code = "12",
                Description = "Other"
            });
            return data;
        }
    }
}
