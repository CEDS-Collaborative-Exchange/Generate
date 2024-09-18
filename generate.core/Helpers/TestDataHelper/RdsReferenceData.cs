using generate.core.Helpers.ReferenceData;
using generate.core.Models.IDS;
using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class RdsReferenceData
    {
        #region Data

        public List<DimFactType> DimFactTypes { get; private set; }


        public List<DimDate> DimDates { get; private set; }
        public List<DimAge> DimAges { get; private set; }
        public List<DimK12Demographic> DimDemographics { get; private set; }
        public List<DimLanguage> DimLanguages { get; private set; }
        public List<DimProgramStatus> DimProgramStatuses { get; private set; }
        public List<DimGradeLevel> DimGradeLevels { get; private set; }


        public List<DimMigrant> DimMigrants { get; private set; }
        public List<DimAttendance> DimAttendances { get; private set; }
        public List<DimCohortStatus> DimCohortStatuses { get; private set; }
        public List<DimIdeaStatus> DimIdeaStatuses { get; private set; }
        public List<DimNorDProgramStatus> DimNorDProgramStatuses { get; private set; }
        public List<DimK12StudentStatus> DimStudentStatuses { get; private set; }
        public List<DimTitleIStatus> DimTitleIStatuses { get; private set; }
        public List<DimTitleIIIStatus> DimTitleIIIStatuses { get; private set; }
        public List<DimFirearms> DimFirearms { get; private set; }
        public List<DimRace> DimRaces { get; private set; }
        public List<DimFirearmDiscipline> DimFirearmsDisciplines { get; private set; }
        public List<DimAssessmentStatus> DimAssessmentStatuses { get; private set; }
        public List<DimK12StaffCategory> DimPersonnelCategories { get; private set; }

        public List<string> FederalFundAllocationTypes { get; private set; }
        public List<RefStateAnsicode> RefStateAnsicodes { get; private set; }
        public List<RefState> RefStates { get; private set; }

        public List<DimK12OrganizationStatus> DimOrganizationStatuses { get; private set; }
        public List<DimK12SchoolStateStatus> DimSchoolStateStatuses { get; private set; }
        public List<DimStateDefinedStatus> DimStateDefinedStatuses { get; private set; }
        public List<DimStateDefinedCustomIndicator> DimStateDefinedCustomIndicators { get; private set; }
        public List<DimIndicatorStatus> DimIndicatorStatuses { get; private set; }
        public List<DimIndicatorStatusType> DimIndicatorStatusTypes { get; private set; }

        public List<RefOrganizationType> RefOrganizationTypes { get; private set; }
        public List<RefOrganizationElementType> RefOrganizationElementTypes { get; private set; }

        public List<RefLeaType> RefLeaTypes { get; private set; }
        public List<RefSchoolType> RefSchoolTypes { get; private set; }
        public List<RefOperationalStatus> RefLeaOperationalStatuses { get; private set; }
        public List<RefOperationalStatus> RefSchoolOperationalStatuses { get; private set; }

        #endregion

        public RdsReferenceData()
        {
            #region Data


            this.DimFactTypes = DimFactTypeHelper.GetData();
            this.DimDates = DimDateHelper.GetData();
            this.DimAges = DimAgeHelper.GetData();
            this.DimDemographics = DimDemographicHelper.GetData();
            this.DimLanguages = DimLanguageHelper.GetData();
            this.DimProgramStatuses = DimProgramStatusHelper.GetData();
            this.DimGradeLevels = DimGradeLevelHelper.GetData();

            this.DimMigrants = DimMigrantHelper.GetData();
            this.DimAttendances = DimAttendanceHelper.GetData();
            this.DimCohortStatuses = DimCohortStatusHelper.GetData();
            this.DimIdeaStatuses = DimIdeaStatusHelper.GetData();
            this.DimNorDProgramStatuses = DimNorDProgramStatusHelper.GetData();
            this.DimTitleIStatuses = DimTitle1StatusHelper.GetData();
            this.DimTitleIIIStatuses = DimTitleIIIStatusHelper.GetData();
            this.DimFirearms = DimFirearmsHelper.GetData();
            this.DimRaces = DimRaceHelper.GetData();
            this.DimFirearmsDisciplines = DimFirearmsDisciplineHelper.GetData();
            this.DimAssessmentStatuses = DimAssessmentStatusHelper.GetData();
            this.DimPersonnelCategories = DimPersonnelCategoryHelper.GetData();
            
            this.RefStateAnsicodes = RefStateAnsiCodeHelper.GetData();
            this.RefStates = RefStateHelper.GetData();

            this.FederalFundAllocationTypes = FederalFundAllocationTypeHelper.GetData();

            this.DimOrganizationStatuses = DimOrganizationStatusHelper.GetData();
            this.DimSchoolStateStatuses = DimSchoolStateStatusHelper.GetData();
            this.DimStateDefinedStatuses = DimStateDefinedStatusHelper.GetData();
            this.DimStateDefinedCustomIndicators = DimStateDefinedCustomIndicatorHelper.GetData();
            this.DimIndicatorStatuses = DimIndicatorStatusHelper.GetData();
            this.DimIndicatorStatusTypes = DimIndicatorStatusTypeHelper.GetData();
            this.DimStudentStatuses = DimStudentStatusHelper.GetData();

            this.RefOrganizationTypes = RefOrganizationTypeHelper.GetData();
            this.RefOrganizationElementTypes = RefOrganizationElementTypeHelper.GetData();

            this.RefLeaTypes = RefLeaTypeHelper.GetData();
            this.RefSchoolTypes = RefSchoolTypeHelper.GetData();
           
            this.RefLeaOperationalStatuses = RefOperationalStatusHelper.GetData().Where(s => s.RefOperationalStatusTypeId == 1).ToList();
            this.RefSchoolOperationalStatuses = RefOperationalStatusHelper.GetData().Where(s => s.RefOperationalStatusTypeId == 2).ToList();

            #endregion

        }

    }
}
