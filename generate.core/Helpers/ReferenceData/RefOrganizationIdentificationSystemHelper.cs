using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationIdentificationSystemHelper
    {

        public static List<RefOrganizationIdentificationSystem> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationIdentificationSystem() { 
            RefOrganizationIdentificationSystemId = ' + convert(varchar(20), RefOrganizationIdentificationSystemId) + ',
            RefOrganizationIdentifierTypeId = ' + convert(varchar(20), RefOrganizationIdentifierTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationIdentificationSystem
            */

            var data = new List<RefOrganizationIdentificationSystem>();

            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 1,
                RefOrganizationIdentifierTypeId = 3,
                Code = "Intermediate",
                Description = "Intermediate agency course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 2,
                RefOrganizationIdentifierTypeId = 3,
                Code = "LEA",
                Description = "LEA course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 3,
                RefOrganizationIdentifierTypeId = 3,
                Code = "NCES",
                Description = "NCES Pilot Standard National Course Classification System for Secondary Education Codes"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 4,
                RefOrganizationIdentifierTypeId = 3,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 5,
                RefOrganizationIdentifierTypeId = 3,
                Code = "SCED",
                Description = "School Codes for the Exchange of Data (SCED) course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 6,
                RefOrganizationIdentifierTypeId = 3,
                Code = "School",
                Description = "School course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 7,
                RefOrganizationIdentifierTypeId = 3,
                Code = "State",
                Description = "State course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 8,
                RefOrganizationIdentifierTypeId = 3,
                Code = "University",
                Description = "University course code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 9,
                RefOrganizationIdentifierTypeId = 9,
                Code = "School",
                Description = "School-assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 10,
                RefOrganizationIdentifierTypeId = 9,
                Code = "ACT",
                Description = "College Board/ACT program code set of PK-grade 12 institutions"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 11,
                RefOrganizationIdentifierTypeId = 9,
                Code = "LEA",
                Description = "Local Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 12,
                RefOrganizationIdentifierTypeId = 9,
                Code = "SEA",
                Description = "State Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 13,
                RefOrganizationIdentifierTypeId = 9,
                Code = "NCES",
                Description = "National Center for Education Statistics assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 14,
                RefOrganizationIdentifierTypeId = 9,
                Code = "Federal",
                Description = "Federal identification number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 15,
                RefOrganizationIdentifierTypeId = 9,
                Code = "DUNS",
                Description = "Dun and Bradstreet number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 16,
                RefOrganizationIdentifierTypeId = 9,
                Code = "OtherFederal",
                Description = "Other federally assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 17,
                RefOrganizationIdentifierTypeId = 9,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 18,
                RefOrganizationIdentifierTypeId = 10,
                Code = "School",
                Description = "School-assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 19,
                RefOrganizationIdentifierTypeId = 10,
                Code = "ACT",
                Description = "College Board/ACT program code set of PK-grade 12 institutions"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 20,
                RefOrganizationIdentifierTypeId = 10,
                Code = "LEA",
                Description = "Local Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 21,
                RefOrganizationIdentifierTypeId = 10,
                Code = "SEA",
                Description = "State Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 22,
                RefOrganizationIdentifierTypeId = 10,
                Code = "NCES",
                Description = "National Center for Education Statistics assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 23,
                RefOrganizationIdentifierTypeId = 10,
                Code = "Federal",
                Description = "Federal identification number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 24,
                RefOrganizationIdentifierTypeId = 10,
                Code = "DUNS",
                Description = "Dun and Bradstreet number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 25,
                RefOrganizationIdentifierTypeId = 10,
                Code = "OtherFederal",
                Description = "Other federally assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 26,
                RefOrganizationIdentifierTypeId = 10,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 27,
                RefOrganizationIdentifierTypeId = 12,
                Code = "District",
                Description = "District-assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 28,
                RefOrganizationIdentifierTypeId = 12,
                Code = "ACT",
                Description = "College Board/ACT program code set of PK-grade 12 institutions"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 29,
                RefOrganizationIdentifierTypeId = 12,
                Code = "SEA",
                Description = "State Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 30,
                RefOrganizationIdentifierTypeId = 12,
                Code = "NCES",
                Description = "National Center for Education Statistics assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 31,
                RefOrganizationIdentifierTypeId = 12,
                Code = "Federal",
                Description = "Federal identification number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 32,
                RefOrganizationIdentifierTypeId = 12,
                Code = "DUNS",
                Description = "Dun and Bradstreet number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 33,
                RefOrganizationIdentifierTypeId = 12,
                Code = "CENSUSID",
                Description = "Census Bureau identification code"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 34,
                RefOrganizationIdentifierTypeId = 12,
                Code = "OtherFederal",
                Description = "Other federally assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 35,
                RefOrganizationIdentifierTypeId = 12,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 36,
                RefOrganizationIdentifierTypeId = 13,
                Code = "School",
                Description = "School-assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 37,
                RefOrganizationIdentifierTypeId = 13,
                Code = "ACT",
                Description = "College Board/ACT program code set of PK-grade 12 institutions"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 38,
                RefOrganizationIdentifierTypeId = 13,
                Code = "LEA",
                Description = "Local Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 39,
                RefOrganizationIdentifierTypeId = 13,
                Code = "SEA",
                Description = "State Education Agency assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 40,
                RefOrganizationIdentifierTypeId = 13,
                Code = "NCES",
                Description = "National Center for Education Statistics assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 41,
                RefOrganizationIdentifierTypeId = 13,
                Code = "Federal",
                Description = "Federal identification number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 42,
                RefOrganizationIdentifierTypeId = 13,
                Code = "DUNS",
                Description = "Dun and Bradstreet number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 43,
                RefOrganizationIdentifierTypeId = 13,
                Code = "OtherFederal",
                Description = "Other federally assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 44,
                RefOrganizationIdentifierTypeId = 13,
                Code = "StateUniversitySystem",
                Description = "State University System assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 45,
                RefOrganizationIdentifierTypeId = 13,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 46,
                RefOrganizationIdentifierTypeId = 14,
                Code = "LEA",
                Description = "Local Education Agency"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 47,
                RefOrganizationIdentifierTypeId = 14,
                Code = "PostsecondaryInstitution",
                Description = "Postsecondary Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 48,
                RefOrganizationIdentifierTypeId = 14,
                Code = "CommunityBasedOrganization",
                Description = "Community-Based Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 49,
                RefOrganizationIdentifierTypeId = 14,
                Code = "Library",
                Description = "Library"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 50,
                RefOrganizationIdentifierTypeId = 14,
                Code = "CorrectionalInstitution",
                Description = "Correctional Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 51,
                RefOrganizationIdentifierTypeId = 14,
                Code = "OtherInstitution",
                Description = "Other Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 52,
                RefOrganizationIdentifierTypeId = 14,
                Code = "OtherAgency",
                Description = "Other state or local government agency"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 53,
                RefOrganizationIdentifierTypeId = 14,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 54,
                RefOrganizationIdentifierTypeId = 15,
                Code = "Employer",
                Description = "Employer"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 55,
                RefOrganizationIdentifierTypeId = 15,
                Code = "K12School",
                Description = "K12 School"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 56,
                RefOrganizationIdentifierTypeId = 15,
                Code = "LEA",
                Description = "Local Education Agency (LEA)"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 57,
                RefOrganizationIdentifierTypeId = 15,
                Code = "IEU",
                Description = "Intermediate Educational Unit (IEU)"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 58,
                RefOrganizationIdentifierTypeId = 15,
                Code = "SEA",
                Description = "State Education Agency (SEA)"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 59,
                RefOrganizationIdentifierTypeId = 15,
                Code = "Recruiter",
                Description = "Recruiter"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 60,
                RefOrganizationIdentifierTypeId = 15,
                Code = "EmployeeBenefitCarrier",
                Description = "Employee Benefit Carrier"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 61,
                RefOrganizationIdentifierTypeId = 15,
                Code = "EmployeeBenefitContributor",
                Description = "Employee Benefit Contributor"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 62,
                RefOrganizationIdentifierTypeId = 15,
                Code = "ProfessionalMembershipOrganization",
                Description = "Professional Membership Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 63,
                RefOrganizationIdentifierTypeId = 15,
                Code = "EducationInstitution",
                Description = "Education Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 64,
                RefOrganizationIdentifierTypeId = 15,
                Code = "StaffDevelopmentProvider",
                Description = "Staff Development Provider"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 65,
                RefOrganizationIdentifierTypeId = 15,
                Code = "Facility",
                Description = "Facility"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 66,
                RefOrganizationIdentifierTypeId = 15,
                Code = "Program",
                Description = "Program"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 67,
                RefOrganizationIdentifierTypeId = 15,
                Code = "PostsecondaryInstitution",
                Description = "Postsecondary Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 68,
                RefOrganizationIdentifierTypeId = 15,
                Code = "ServiceProvider",
                Description = "Service Provider"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 69,
                RefOrganizationIdentifierTypeId = 15,
                Code = "AffiliatedInstitution",
                Description = "Affiliated Institution"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 70,
                RefOrganizationIdentifierTypeId = 15,
                Code = "GoverningBoard",
                Description = "Governing Board"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 71,
                RefOrganizationIdentifierTypeId = 15,
                Code = "CredentialingOrganization",
                Description = "Credentialing Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 72,
                RefOrganizationIdentifierTypeId = 15,
                Code = "AccreditingOrganization",
                Description = "Accrediting Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 73,
                RefOrganizationIdentifierTypeId = 15,
                Code = "EducationOrganizationNetwork",
                Description = "Education Organization Network"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 74,
                RefOrganizationIdentifierTypeId = 15,
                Code = "IDEAPartCLeadAgency",
                Description = " IDEA Part C Lead Agency"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 75,
                RefOrganizationIdentifierTypeId = 15,
                Code = "CharterSchoolManagementOrganization",
                Description = "Charter School Management Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 76,
                RefOrganizationIdentifierTypeId = 15,
                Code = "CharterSchoolAuthorizingOrganization",
                Description = "Charter School Authorizing Organization"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 77,
                RefOrganizationIdentifierTypeId = 18,
                Code = "State",
                Description = "State-assigned number"
            });
            data.Add(new RefOrganizationIdentificationSystem()
            {
                RefOrganizationIdentificationSystemId = 78,
                RefOrganizationIdentifierTypeId = 18,
                Code = "Federal",
                Description = "Federal identification number"
            });

            return data;
        }
    }
}
