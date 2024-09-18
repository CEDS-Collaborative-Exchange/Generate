using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12Staff
    {
        public int DimK12StaffId { get; set; }

        //public int? PersonnelPersonId { get; set; }
        public string StaffMemberIdentifierState { get; set; }

        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastOrSurname { get; set; }

        public DateTime? BirthDate { get; set; }

        public string PositionTitle { get; set; }
        public string TelephoneNumber { get; set; }

        public string ElectronicMailAddress { get; set; }

        public string K12StaffRole { get; set; }

        public List<FactK12StaffCount> FactPersonnelCounts { get; set; }
        public List <FactOrganizationCount> FactOrganizationCounts { get; set; }
       

    }
}
