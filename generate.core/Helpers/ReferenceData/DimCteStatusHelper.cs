using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimCteStatusHelper
    {
        public static List<DimCteStatus> GetData()
        {


            var data = new List<DimCteStatus>();

            /*
             select 'data.Add(new DimCteStatus() { 
            DimCteStatusId = ' + convert(varchar(20), DimCteStatusId) + ',
            CteProgramId = ' + convert(varchar(20), CteProgramId) + ',
            CteProgramEdFactsCode = "' + CteProgramEdFactsCode + '",
            CteAeDisplacedHomemakerIndicatorId = ' + convert(varchar(20), CteAeDisplacedHomemakerIndicatorId) + ',
            CteAeDisplacedHomemakerIndicatorEdFactsCode = "' + CteAeDisplacedHomemakerIndicatorEdFactsCode + '",
            CteNontraditionalGenderStatusId = ' + convert(varchar(20), CteNontraditionalGenderStatusId) + ',
            CteNontraditionalGenderStatusEdFactsCode = "' + CteNontraditionalGenderStatusEdFactsCode + '",
            RepresentationStatusId = ' + convert(varchar(20), RepresentationStatusId) + ',
            RepresentationStatusEdFactsCode = "' + RepresentationStatusEdFactsCode + '",
            SingleParentOrSinglePregnantWomanId = ' + convert(varchar(20), SingleParentOrSinglePregnantWomanId) + ',
            SingleParentOrSinglePregnantWomanEdFactsCode = "' + SingleParentOrSinglePregnantWomanEdFactsCode + '",
            CteGraduationRateInclusionId = ' + convert(varchar(20), CteGraduationRateInclusionId) + ',
            CteGraduationRateInclusionEdFactsCode = "' + CteGraduationRateInclusionEdFactsCode + '",
            LepPerkinsStatusId = ' + convert(varchar(20), LepPerkinsStatusId) + ',
            LepPerkinsStatusEdFactsCode = "' + LepPerkinsStatusEdFactsCode + '"
            });'
            from rds.DimCteStatuses


            */

            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 1,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 2,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 3,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 4,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 5,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 6,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 7,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 8,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 9,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 10,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 11,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 12,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 13,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 14,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 15,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 16,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 17,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 18,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 19,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 20,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 21,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 22,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 23,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 24,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 25,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 26,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 27,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 28,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 29,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 30,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 31,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 32,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 33,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 34,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 35,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 36,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 37,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 38,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 39,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 40,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 41,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 42,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 43,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 44,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 45,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 46,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 47,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 48,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 49,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 50,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 51,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 52,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 53,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 54,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 55,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 56,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 57,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 58,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 59,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 60,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 61,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 62,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 63,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 64,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 65,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 66,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 67,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 68,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 69,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 70,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 71,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 72,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 73,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 74,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 75,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 76,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 77,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 78,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 79,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 80,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 81,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 82,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 83,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 84,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 85,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 86,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 87,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 88,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 89,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 90,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 91,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 92,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 93,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 94,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 95,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 96,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 97,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 98,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 99,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 100,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 101,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 102,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 103,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 104,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 105,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 106,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 107,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 108,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 109,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 110,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 111,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 112,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 113,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 114,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 115,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 116,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 117,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 118,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 119,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 120,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 121,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 122,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 123,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 124,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 125,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 126,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 127,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 128,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 129,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 130,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 131,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 132,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 133,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 134,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 135,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 136,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 137,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 138,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 139,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 140,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 141,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 142,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 143,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 144,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 145,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 146,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 147,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 148,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 149,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 150,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 151,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 152,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 153,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 154,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 155,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 156,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 157,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 158,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 159,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 160,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 161,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 162,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 163,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 164,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 165,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 166,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 167,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 168,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 169,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 170,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 171,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 172,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 173,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 174,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 175,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 176,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 177,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 178,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 179,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 180,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 181,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 182,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 183,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 184,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 185,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 186,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 187,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 188,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 189,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 190,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 191,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 192,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 193,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 194,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 195,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 196,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 197,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 198,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 199,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 200,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 201,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 202,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 203,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 204,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 205,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 206,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 207,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 208,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 209,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 210,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 211,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 212,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 213,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 214,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 215,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 216,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 217,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 218,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 219,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 220,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 221,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 222,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 223,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 224,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 225,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 226,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 227,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 228,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 229,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 230,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 231,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 232,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 233,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 234,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 235,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 236,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 237,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 238,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 239,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 240,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 241,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 242,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 243,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 244,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 245,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 246,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 247,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 248,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 249,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 250,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 251,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 252,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 253,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 254,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 255,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 256,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 257,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 258,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 259,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 260,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 261,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 262,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 263,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 264,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 265,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 266,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 267,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 268,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 269,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 270,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 271,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 272,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 273,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 274,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 275,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 276,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 277,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 278,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 279,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 280,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 281,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 282,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 283,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 284,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 285,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 286,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 287,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 288,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = -1,
                LepPerkinsStatusEdFactsCode = "MISSING"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 289,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 290,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 291,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 292,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 293,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 294,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 295,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 296,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 297,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 298,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 299,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 300,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 301,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 302,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 303,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 304,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 305,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 306,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 307,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 308,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 309,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 310,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 311,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 312,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 313,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 314,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 315,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 316,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 317,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 318,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 319,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 320,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 321,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 322,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 323,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 324,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 325,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 326,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 327,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 328,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 329,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 330,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 331,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 332,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 333,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 334,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 335,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 336,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 337,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 338,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 339,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 340,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 341,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 342,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 343,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 344,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 345,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 346,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 347,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 348,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 349,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 350,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 351,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 352,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 353,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 354,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 355,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 356,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 357,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 358,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 359,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 360,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 361,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 362,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 363,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 364,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 365,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 366,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 367,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 368,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 369,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 370,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 371,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 372,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 373,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 374,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 375,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 376,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 377,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 378,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 379,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 380,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 381,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 382,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 383,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 384,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 385,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 386,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 387,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 388,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 389,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 390,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 391,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 392,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 393,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 394,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 395,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 396,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 397,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 398,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 399,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 400,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 401,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 402,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 403,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 404,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 405,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 406,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 407,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 408,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 409,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 410,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 411,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 412,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 413,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 414,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 415,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 416,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 417,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 418,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 419,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 420,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 421,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 422,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 423,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 424,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 425,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 426,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 427,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 428,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 429,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 430,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 431,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 432,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = -1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "MISSING",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 433,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 434,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 435,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 436,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 437,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 438,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 439,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 440,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 441,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 442,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 443,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 444,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 445,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 446,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 447,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 448,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 449,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 450,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 451,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 452,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 453,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 454,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 455,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 456,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 457,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 458,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 459,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 460,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 461,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 462,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 463,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 464,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 465,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 466,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 467,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 468,
                CteProgramId = -1,
                CteProgramEdFactsCode = "MISSING",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 469,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 470,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 471,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 472,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 473,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 474,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 475,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 476,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 477,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 478,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 479,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 480,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 481,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 482,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 483,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 484,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 485,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 486,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 487,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 488,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 489,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 490,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 491,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 492,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 493,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 494,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 495,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 496,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 497,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 498,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 499,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 500,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 501,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 502,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 503,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 504,
                CteProgramId = 1,
                CteProgramEdFactsCode = "CTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 505,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 506,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 507,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 508,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 509,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 510,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 511,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 512,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 513,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 514,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 515,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 516,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 517,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 518,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 519,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 520,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 521,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 522,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 523,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 524,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 525,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 526,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 527,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 528,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 529,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 530,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 531,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 532,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 533,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 534,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 535,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 536,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 537,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 538,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 539,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 540,
                CteProgramId = 2,
                CteProgramEdFactsCode = "NONCTEPART",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 541,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 542,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 543,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 544,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 545,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 546,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 547,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 548,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 549,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 550,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 551,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 552,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = -1,
                CteGraduationRateInclusionEdFactsCode = "MISSING",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 553,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 554,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 555,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 556,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 557,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 558,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 559,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 560,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 561,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 562,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 563,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 564,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "GRAD",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 565,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 566,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 567,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 568,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 569,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 570,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = -1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "MISSING",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 571,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 572,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = -1,
                RepresentationStatusEdFactsCode = "MISSING",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 573,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 574,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "MEM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 575,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = -1,
                CteNontraditionalGenderStatusEdFactsCode = "MISSING",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });
            data.Add(new DimCteStatus()
            {
                DimCteStatusId = 576,
                CteProgramId = 3,
                CteProgramEdFactsCode = "CTECONC",
                CteAeDisplacedHomemakerIndicatorId = 1,
                CteAeDisplacedHomemakerIndicatorEdFactsCode = "DH",
                CteNontraditionalGenderStatusId = 1,
                CteNontraditionalGenderStatusEdFactsCode = "NTE",
                RepresentationStatusId = 1,
                RepresentationStatusEdFactsCode = "NM",
                SingleParentOrSinglePregnantWomanId = 1,
                SingleParentOrSinglePregnantWomanEdFactsCode = "SPPT",
                CteGraduationRateInclusionId = 1,
                CteGraduationRateInclusionEdFactsCode = "NOTG",
                LepPerkinsStatusId = 1,
                LepPerkinsStatusEdFactsCode = "LEPP"
            });


            return data;

        }
    }
}
