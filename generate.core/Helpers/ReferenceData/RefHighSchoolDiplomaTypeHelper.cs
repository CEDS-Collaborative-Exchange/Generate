using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefHighSchoolDiplomaTypeHelper
    {

        public static List<RefHighSchoolDiplomaType> GetData()
        {
            /*
            select 'data.Add(new RefHighSchoolDiplomaType() { 
            RefHighSchoolDiplomaTypeId = ' + convert(varchar(20), RefHighSchoolDiplomaTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefHighSchoolDiplomaType
            */

            var data = new List<RefHighSchoolDiplomaType>();

            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 1, Code = "00806", Description = "Regular diploma" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 2, Code = "00807", Description = "Endorsed/advanced diploma" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 3, Code = "00808", Description = "Regents diploma" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 4, Code = "00809", Description = "International Baccalaureate" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 5, Code = "00810", Description = "Modified diploma" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 6, Code = "00811", Description = "Other diploma" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 7, Code = "00812", Description = "Alternative credential" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 8, Code = "00813", Description = "Certificate of attendance" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 9, Code = "00814", Description = "Certificate of completion" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 10, Code = "00815", Description = "High school equivalency credential, other than GED" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 11, Code = "00816", Description = "General Educational Development (GED) credential" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 12, Code = "00818", Description = "Post graduate certificate (grade 13)" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 13, Code = "00819", Description = "Career and Technical Education certificate" });
            data.Add(new RefHighSchoolDiplomaType() { RefHighSchoolDiplomaTypeId = 14, Code = "09999", Description = "Other" });

            return data;
        }
    }
}
