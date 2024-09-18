using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefParticipationTypeHelper
    {

        public static List<RefParticipationType> GetData()
        {
            /*
            select 'data.Add(new RefParticipationType() { 
            RefParticipationTypeId = ' + convert(varchar(20), RefParticipationTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefParticipationType
            */

            var data = new List<RefParticipationType>();

            data.Add(new RefParticipationType() { RefParticipationTypeId = 1, Code = "GEDPreparationProgramParticipation", Description = "GED Preparation Program Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 2, Code = "HomelessServiced", Description = "Homeless Serviced" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 3, Code = "MEPParticipation", Description = "Migrant Education Program Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 4, Code = "Section504", Description = "Section 504" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 5, Code = "TitleIIIImmigrantParticipation", Description = "Title III Immigrant Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 6, Code = "TitleISchoolwideProgramParticipation", Description = "Title I Schoolwide Program Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 7, Code = "TitleITargetedAssistanceParticipation", Description = "Title I Targeted Assistance Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 8, Code = "TitleIIILEPParticipation", Description = "Title III Limited English Proficient Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 9, Code = "KindergartenProgramParticipation", Description = "Kindergarten Program Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 10, Code = "CareerPathwaysProgramParticipation", Description = "Career Pathways Program Participation" });
            data.Add(new RefParticipationType() { RefParticipationTypeId = 11, Code = "CorrectionalEducationReentryServicesParticipation", Description = "Correctional Education Reentry Services Participation" });

            return data;
        }
    }
}
