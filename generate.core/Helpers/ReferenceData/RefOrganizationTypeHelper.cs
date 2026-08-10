using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationTypeHelper
    {

        public static List<RefOrganizationType> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationType() { 
            RefOrganizationTypeId = ' + convert(varchar(20), RefOrganizationTypeId) + ',
            RefOrganizationElementTypeId = ' + convert(varchar(20), RefOrganizationElementTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationType
            */

            var data = new List<RefOrganizationType>();

            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 1, RefOrganizationElementTypeId = 1, Code = "LEA", Description = "Local Education Agency" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 2, RefOrganizationElementTypeId = 1, Code = "PostsecondaryInstitution", Description = "Postsecondary Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 3, RefOrganizationElementTypeId = 1, Code = "CommunityBasedOrganization", Description = "Community-Based Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 4, RefOrganizationElementTypeId = 1, Code = "Library", Description = "Library" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 5, RefOrganizationElementTypeId = 1, Code = "CorrectionalInstitution", Description = "Correctional Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 6, RefOrganizationElementTypeId = 1, Code = "OtherInstitution", Description = "Other Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 7, RefOrganizationElementTypeId = 1, Code = "OtherAgency", Description = "Other state or local government agency" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 8, RefOrganizationElementTypeId = 1, Code = "Other", Description = "Other" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 9, RefOrganizationElementTypeId = 2, Code = "Employer", Description = "Employer" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 10, RefOrganizationElementTypeId = 2, Code = "K12School", Description = "K12 School" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 11, RefOrganizationElementTypeId = 2, Code = "LEA", Description = "Local Education Agency (LEA)" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 12, RefOrganizationElementTypeId = 2, Code = "IEU", Description = "Intermediate Educational Unit (IEU)" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 13, RefOrganizationElementTypeId = 2, Code = "SEA", Description = "State Education Agency (SEA)" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 14, RefOrganizationElementTypeId = 2, Code = "Recruiter", Description = "Recruiter" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 15, RefOrganizationElementTypeId = 2, Code = "EmployeeBenefitCarrier", Description = "Employee Benefit Carrier" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 16, RefOrganizationElementTypeId = 2, Code = "EmployeeBenefitContributor", Description = "Employee Benefit Contributor" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 17, RefOrganizationElementTypeId = 2, Code = "ProfessionalMembershipOrganization", Description = "Professional Membership Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 18, RefOrganizationElementTypeId = 2, Code = "EducationInstitution", Description = "Education Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 19, RefOrganizationElementTypeId = 2, Code = "StaffDevelopmentProvider", Description = "Staff Development Provider" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 20, RefOrganizationElementTypeId = 2, Code = "Facility", Description = "Facility" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 21, RefOrganizationElementTypeId = 2, Code = "Program", Description = "Program" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 22, RefOrganizationElementTypeId = 2, Code = "PostsecondaryInstitution", Description = "Postsecondary Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 23, RefOrganizationElementTypeId = 2, Code = "ServiceProvider", Description = "Service Provider" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 24, RefOrganizationElementTypeId = 2, Code = "AffiliatedInstitution", Description = "Affiliated Institution" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 25, RefOrganizationElementTypeId = 2, Code = "GoverningBoard", Description = "Governing Board" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 26, RefOrganizationElementTypeId = 2, Code = "CredentialingOrganization", Description = "Credentialing Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 27, RefOrganizationElementTypeId = 2, Code = "AccreditingOrganization", Description = "Accrediting Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 28, RefOrganizationElementTypeId = 2, Code = "EducationOrganizationNetwork", Description = "Education Organization Network" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 29, RefOrganizationElementTypeId = 2, Code = "IDEAPartCLeadAgency", Description = " IDEA Part C Lead Agency" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 30, RefOrganizationElementTypeId = 2, Code = "CharterSchoolManagementOrganization", Description = "Charter School Management Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 31, RefOrganizationElementTypeId = 2, Code = "CharterSchoolAuthorizingOrganization", Description = "Charter School Authorizing Organization" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 32, RefOrganizationElementTypeId = 2, Code = "LEANotFederal", Description = "Local Education Agency (LEA) Not Reported Federally" });
            data.Add(new RefOrganizationType() { RefOrganizationTypeId = 33, RefOrganizationElementTypeId = 2, Code = "K12SchoolNotFederal", Description = "K12 School Not Reported Federally" });

            return data;
        }
    }
}
