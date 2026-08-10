using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefGradeLevelHelper
    {

        public static List<RefGradeLevel> GetData()
        {
            /*
            select 'data.Add(new RefGradeLevel() { 
            RefGradeLevelId = ' + convert(varchar(20), RefGradeLevelId) + ',
            RefGradeLevelTypeId = ' + convert(varchar(20), RefGradeLevelTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefGradeLevel
            */

            var data = new List<RefGradeLevel>();

            data.Add(new RefGradeLevel() { RefGradeLevelId = 1, RefGradeLevelTypeId = 1, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 2, RefGradeLevelTypeId = 1, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 3, RefGradeLevelTypeId = 1, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 4, RefGradeLevelTypeId = 1, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 5, RefGradeLevelTypeId = 1, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 6, RefGradeLevelTypeId = 1, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 7, RefGradeLevelTypeId = 1, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 8, RefGradeLevelTypeId = 1, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 9, RefGradeLevelTypeId = 1, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 10, RefGradeLevelTypeId = 1, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 11, RefGradeLevelTypeId = 1, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 12, RefGradeLevelTypeId = 1, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 13, RefGradeLevelTypeId = 1, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 14, RefGradeLevelTypeId = 1, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 15, RefGradeLevelTypeId = 1, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 16, RefGradeLevelTypeId = 1, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 17, RefGradeLevelTypeId = 1, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 18, RefGradeLevelTypeId = 1, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 19, RefGradeLevelTypeId = 1, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 20, RefGradeLevelTypeId = 1, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 21, RefGradeLevelTypeId = 1, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 22, RefGradeLevelTypeId = 2, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 23, RefGradeLevelTypeId = 2, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 24, RefGradeLevelTypeId = 2, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 25, RefGradeLevelTypeId = 2, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 26, RefGradeLevelTypeId = 2, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 27, RefGradeLevelTypeId = 2, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 28, RefGradeLevelTypeId = 2, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 29, RefGradeLevelTypeId = 2, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 30, RefGradeLevelTypeId = 2, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 31, RefGradeLevelTypeId = 2, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 32, RefGradeLevelTypeId = 2, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 33, RefGradeLevelTypeId = 2, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 34, RefGradeLevelTypeId = 2, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 35, RefGradeLevelTypeId = 2, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 36, RefGradeLevelTypeId = 2, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 37, RefGradeLevelTypeId = 2, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 38, RefGradeLevelTypeId = 2, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 39, RefGradeLevelTypeId = 2, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 40, RefGradeLevelTypeId = 2, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 41, RefGradeLevelTypeId = 2, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 42, RefGradeLevelTypeId = 2, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 43, RefGradeLevelTypeId = 3, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 44, RefGradeLevelTypeId = 3, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 45, RefGradeLevelTypeId = 3, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 46, RefGradeLevelTypeId = 3, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 47, RefGradeLevelTypeId = 3, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 48, RefGradeLevelTypeId = 3, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 49, RefGradeLevelTypeId = 3, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 50, RefGradeLevelTypeId = 3, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 51, RefGradeLevelTypeId = 3, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 52, RefGradeLevelTypeId = 3, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 53, RefGradeLevelTypeId = 3, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 54, RefGradeLevelTypeId = 3, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 55, RefGradeLevelTypeId = 3, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 56, RefGradeLevelTypeId = 3, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 57, RefGradeLevelTypeId = 3, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 58, RefGradeLevelTypeId = 3, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 59, RefGradeLevelTypeId = 3, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 60, RefGradeLevelTypeId = 3, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 61, RefGradeLevelTypeId = 3, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 62, RefGradeLevelTypeId = 3, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 63, RefGradeLevelTypeId = 3, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 64, RefGradeLevelTypeId = 3, Code = "OutOfSchool", Description = "Out of school" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 65, RefGradeLevelTypeId = 4, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 66, RefGradeLevelTypeId = 4, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 67, RefGradeLevelTypeId = 4, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 68, RefGradeLevelTypeId = 4, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 69, RefGradeLevelTypeId = 4, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 70, RefGradeLevelTypeId = 4, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 71, RefGradeLevelTypeId = 4, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 72, RefGradeLevelTypeId = 4, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 73, RefGradeLevelTypeId = 4, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 74, RefGradeLevelTypeId = 4, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 75, RefGradeLevelTypeId = 4, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 76, RefGradeLevelTypeId = 4, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 77, RefGradeLevelTypeId = 4, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 78, RefGradeLevelTypeId = 4, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 79, RefGradeLevelTypeId = 4, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 80, RefGradeLevelTypeId = 4, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 81, RefGradeLevelTypeId = 4, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 82, RefGradeLevelTypeId = 4, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 83, RefGradeLevelTypeId = 4, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 84, RefGradeLevelTypeId = 4, Code = "ABE", Description = "Adult Basic Education" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 85, RefGradeLevelTypeId = 4, Code = "ASE", Description = "Adult Secondary Education" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 86, RefGradeLevelTypeId = 4, Code = "AdultESL", Description = "Adult English as a Second Language" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 87, RefGradeLevelTypeId = 4, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 88, RefGradeLevelTypeId = 4, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 89, RefGradeLevelTypeId = 5, Code = "Birth", Description = "Birth" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 90, RefGradeLevelTypeId = 5, Code = "Prenatal", Description = "Prenatal" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 91, RefGradeLevelTypeId = 5, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 92, RefGradeLevelTypeId = 5, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 93, RefGradeLevelTypeId = 5, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 94, RefGradeLevelTypeId = 5, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 95, RefGradeLevelTypeId = 5, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 96, RefGradeLevelTypeId = 5, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 97, RefGradeLevelTypeId = 5, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 98, RefGradeLevelTypeId = 5, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 99, RefGradeLevelTypeId = 5, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 100, RefGradeLevelTypeId = 5, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 101, RefGradeLevelTypeId = 5, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 102, RefGradeLevelTypeId = 5, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 103, RefGradeLevelTypeId = 5, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 104, RefGradeLevelTypeId = 5, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 105, RefGradeLevelTypeId = 5, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 106, RefGradeLevelTypeId = 5, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 107, RefGradeLevelTypeId = 5, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 108, RefGradeLevelTypeId = 5, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 109, RefGradeLevelTypeId = 5, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 110, RefGradeLevelTypeId = 5, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 111, RefGradeLevelTypeId = 5, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 112, RefGradeLevelTypeId = 6, Code = "01043", Description = "No school completed " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 113, RefGradeLevelTypeId = 6, Code = "00788", Description = "Preschool " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 114, RefGradeLevelTypeId = 6, Code = "00805", Description = "Kindergarten " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 115, RefGradeLevelTypeId = 6, Code = "00790", Description = "First grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 116, RefGradeLevelTypeId = 6, Code = "00791", Description = "Second grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 117, RefGradeLevelTypeId = 6, Code = "00792", Description = "Third grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 118, RefGradeLevelTypeId = 6, Code = "00793", Description = "Fourth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 119, RefGradeLevelTypeId = 6, Code = "00794", Description = "Fifth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 120, RefGradeLevelTypeId = 6, Code = "00795", Description = "Sixth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 121, RefGradeLevelTypeId = 6, Code = "00796", Description = "Seventh grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 122, RefGradeLevelTypeId = 6, Code = "00798", Description = "Eighth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 123, RefGradeLevelTypeId = 6, Code = "00799", Description = "Ninth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 124, RefGradeLevelTypeId = 6, Code = "00800", Description = "Tenth grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 125, RefGradeLevelTypeId = 6, Code = "00801", Description = "Eleventh Grade " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 126, RefGradeLevelTypeId = 6, Code = "01809", Description = "12th grade, no diploma " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 127, RefGradeLevelTypeId = 6, Code = "01044", Description = "High school diploma " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 128, RefGradeLevelTypeId = 6, Code = "02408", Description = "High school completers (e.g., certificate of attendance) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 129, RefGradeLevelTypeId = 6, Code = "02409", Description = "High school equivalency (e.g., GED) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 130, RefGradeLevelTypeId = 6, Code = "00803", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 131, RefGradeLevelTypeId = 6, Code = "00819", Description = "Career and Technical Education certificate" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 132, RefGradeLevelTypeId = 6, Code = "01049", Description = "Some college but no degree " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 133, RefGradeLevelTypeId = 6, Code = "01047", Description = "Formal award, certificate or diploma (less than one year) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 134, RefGradeLevelTypeId = 6, Code = "01048", Description = "Formal award, certificate or diploma (more than or equal to one year) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 135, RefGradeLevelTypeId = 6, Code = "01050", Description = "Associate's degree (two years or more) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 136, RefGradeLevelTypeId = 6, Code = "73063", Description = "Adult education certification, endorsement, or degree" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 137, RefGradeLevelTypeId = 6, Code = "01051", Description = "Bachelor's (Baccalaureate) degree " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 138, RefGradeLevelTypeId = 6, Code = "01054", Description = "Master's degree (e.g., M.A., M.S., M. Eng., M.Ed., M.S.W., M.B.A., M.L.S.) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 139, RefGradeLevelTypeId = 6, Code = "01055", Description = "Specialist's degree (e.g., Ed.S.) " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 140, RefGradeLevelTypeId = 6, Code = "73081", Description = "Post-master?s certificate" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 141, RefGradeLevelTypeId = 6, Code = "01052", Description = "Graduate certificate " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 142, RefGradeLevelTypeId = 6, Code = "01057", Description = "Doctoral (Doctor's) degree " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 143, RefGradeLevelTypeId = 6, Code = "01053", Description = "First-professional degree " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 144, RefGradeLevelTypeId = 6, Code = "01056", Description = "Post-professional degree " });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 145, RefGradeLevelTypeId = 6, Code = "73082", Description = "Doctor?s degree-research/scholarship" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 146, RefGradeLevelTypeId = 6, Code = "73083", Description = "Doctor?s degree-professional practice" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 147, RefGradeLevelTypeId = 6, Code = "73084", Description = "Doctor?s degree-other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 148, RefGradeLevelTypeId = 6, Code = "73085", Description = "Doctor?s degree-research/scholarship" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 149, RefGradeLevelTypeId = 6, Code = "09999", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 150, RefGradeLevelTypeId = 7, Code = "IT", Description = "Infant/toddler" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 151, RefGradeLevelTypeId = 7, Code = "PR", Description = "Preschool" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 152, RefGradeLevelTypeId = 7, Code = "PK", Description = "Prekindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 153, RefGradeLevelTypeId = 7, Code = "TK", Description = "Transitional Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 154, RefGradeLevelTypeId = 7, Code = "KG", Description = "Kindergarten" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 155, RefGradeLevelTypeId = 7, Code = "01", Description = "First grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 156, RefGradeLevelTypeId = 7, Code = "02", Description = "Second grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 157, RefGradeLevelTypeId = 7, Code = "03", Description = "Third grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 158, RefGradeLevelTypeId = 7, Code = "04", Description = "Fourth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 159, RefGradeLevelTypeId = 7, Code = "05", Description = "Fifth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 160, RefGradeLevelTypeId = 7, Code = "06", Description = "Sixth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 161, RefGradeLevelTypeId = 7, Code = "07", Description = "Seventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 162, RefGradeLevelTypeId = 7, Code = "08", Description = "Eighth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 163, RefGradeLevelTypeId = 7, Code = "09", Description = "Ninth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 164, RefGradeLevelTypeId = 7, Code = "10", Description = "Tenth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 165, RefGradeLevelTypeId = 7, Code = "11", Description = "Eleventh grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 166, RefGradeLevelTypeId = 7, Code = "12", Description = "Twelfth grade" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 167, RefGradeLevelTypeId = 7, Code = "13", Description = "Grade 13" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 168, RefGradeLevelTypeId = 7, Code = "PS", Description = "Postsecondary" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 169, RefGradeLevelTypeId = 7, Code = "UG", Description = "Ungraded" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 170, RefGradeLevelTypeId = 7, Code = "Other", Description = "Other" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 171, RefGradeLevelTypeId = 1, Code = "ABE", Description = "Adult Basic Education" });
            data.Add(new RefGradeLevel() { RefGradeLevelId = 172, RefGradeLevelTypeId = 7, Code = "ABE", Description = "Adult Basic Education" });


            return data;
        }
    }
}
