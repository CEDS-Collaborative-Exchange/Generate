using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStaffEmployment
    {
        public int StaffEmploymentId { get; set; }
        public int? RefFullTimeStatusId { get; set; }
        public bool? FacultyStatus { get; set; }
        public int? RefEmploymentContractTypeId { get; set; }
        public string StandardOccupationalClass { get; set; }
        public int? RefIpedsOccupationalCategoryId { get; set; }
        public bool? InstructionalStaffStatus { get; set; }
        public bool? MedicalSchoolStaffStatus { get; set; }
        public int? RefInstructionalStaffContractLengthId { get; set; }
        public int? RefInstructionalStaffFacultyTenureId { get; set; }
        public int? RefAcademicRankId { get; set; }
        public int? RefInstructionCreditTypeId { get; set; }
        public bool? GraduateAssistantStatus { get; set; }
        public int? RefGraduateAssistantIpedsCategoryId { get; set; }
        public decimal? AnnualBaseContractualSalary { get; set; }

        public virtual RefAcademicRank RefAcademicRank { get; set; }
        public virtual RefEmploymentContractType RefEmploymentContractType { get; set; }
        public virtual RefFullTimeStatus RefFullTimeStatus { get; set; }
        public virtual RefGraduateAssistantIpedsCategory RefGraduateAssistantIpedsCategory { get; set; }
        public virtual RefInstructionCreditType RefInstructionCreditType { get; set; }
        public virtual RefInstructionalStaffContractLength RefInstructionalStaffContractLength { get; set; }
        public virtual RefInstructionalStaffFacultyTenure RefInstructionalStaffFacultyTenure { get; set; }
        public virtual RefIpedsOccupationalCategory RefIpedsOccupationalCategory { get; set; }
        public virtual StaffEmployment StaffEmployment { get; set; }
    }
}
