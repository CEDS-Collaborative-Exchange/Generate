using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
        public partial class DimCharterSchoolManagementOrganization
         {
            public int DimCharterSchoolManagementOrganizationId { get; set; }

            public string Name { get; set; }

            public string StateIdentifier { get; set; }
            public string State { get; set; }
            public string StateCode { get; set; }
            public string StateANSICode { get; set; }

            public string CharterSchoolManagementOrganizationCode { get; set; }
            public string CharterSchoolManagementOrganizationTypeDescription { get; set; }
            public string CharterSchoolManagementOrganizationTypeEdfactsCode { get; set; }
            public string Website { get; set; }
            public string Telephone { get; set; }

            public string MailingAddressStreet { get; set; }
            public string MailingAddressCity { get; set; }
            public string MailingAddressState { get; set; }
            public string MailingAddressPostalCode { get; set; }

            public string PhysicalAddressStreet { get; set; }
            public string PhysicalAddressCity { get; set; }
            public string PhysicalAddressState { get; set; }
            public string PhysicalAddressPostalCode { get; set; }
            public DateTime RecordStartDateTime { get; set; }
            public DateTime? RecordEndDateTime { get; set; }            
            public bool OutOfStateIndicator { get; set; }

            public List<FactOrganizationCount> FactOrganizationCounts_CharterSchoolManagementOrganization { get; set; }
            public List<FactOrganizationCount> FactOrganizationCounts_CharterSchoolUpdatedManagementOrganization { get; set; }

    }

}
