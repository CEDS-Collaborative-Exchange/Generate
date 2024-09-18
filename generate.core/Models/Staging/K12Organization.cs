using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12Organization
    {
        public  int Id { get; set; }                                                                              
        public  string IeuIdentifierSea { get; set; }                                                         
        public  string IEU_OrganizationName { get; set; }                                                                     
        public  DateTime? IEU_OperationalStatusEffectiveDate { get; set; }
        public string IEU_OrganizationOperationalStatus { get; set; }
        public string IEU_WebSiteAddress { get; set; }                                                           
        public  DateTime? IEU_RecordStartDateTime { get; set; }                                                   
        public  DateTime? IEU_RecordEndDateTime { get; set; }
        public string LeaIdentifierSea { get; set; }
        public string PriorLeaIdentifierSea { get; set; }
        public string LeaIdentifierNCES { get; set; }                                                          
        public  string LEA_SupervisoryUnionIdentificationNumber { get; set; }                                     
        public  string LeaOrganizationName { get; set; }                                                                     
        public  string LEA_WebSiteAddress { get; set; }                                                           
        public  string LEA_OperationalStatus { get; set; }                                                        
        public  DateTime? LEA_OperationalStatusEffectiveDate { get; set; }                                        
        public  string LEA_CharterLeaStatus { get; set; }                                                         
        public  bool? LEA_CharterSchoolIndicator { get; set; }                                                    
        public  string LEA_Type { get; set; }                                                                     
        public  bool? LEA_McKinneyVentoSubgrantRecipient { get; set; }                                            
        public  string LEA_GunFreeSchoolsActReportingStatus { get; set; }                                         
        public  string LEA_TitleIinstructionalService { get; set; }                                               
        public  string LEA_TitleIProgramType { get; set; }                                                        
        public  string LEA_K12LeaTitleISupportService { get; set; }                                               
        public  string LEA_MepProjectType { get; set; }                                                           
        public  bool? LEA_IsReportedFederally { get; set; }                                                       
        public  DateTime? LEA_RecordStartDateTime { get; set; }                                                   
        public  DateTime? LEA_RecordEndDateTime { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string PriorSchoolIdentifierSea { get; set; }
        public string School_PriorLeaIdentifierSea { get; set; }

        public string SchoolIdentifierNCES { get; set; }                                                       
        public  string SchoolOrganizationName { get; set; }                                                                  
        public  string School_WebSiteAddress { get; set; }                                                        
        public  string School_OperationalStatus { get; set; }                                                     
        public  DateTime? School_OperationalStatusEffectiveDate { get; set; }                                     
        public  string School_Type { get; set; }                                                                  
        public  string School_MagnetOrSpecialProgramEmphasisSchool { get; set; }                                  
        public  string School_SharedTimeIndicator { get; set; }                                                   
        public  string School_VirtualSchoolStatus { get; set; }                                                   
        public  string School_NationalSchoolLunchProgramStatus { get; set; }                                      
        public  string School_ReconstitutedStatus { get; set; }                                                   
        public  bool? School_CharterSchoolIndicator { get; set; }                                                 
        public  bool? School_CharterSchoolOpenEnrollmentIndicator { get; set; }                                   
        public  string School_CharterSchoolFEIN { get; set; }                                                     
        public  string School_CharterSchoolFEIN_Update { get; set; }                                              
        public  string School_CharterContractIDNumber { get; set; }                                               
        public  DateTime? School_CharterContractApprovalDate { get; set; }                                        
        public  DateTime? School_CharterContractRenewalDate { get; set; }                                         
        public  string School_CharterPrimaryAuthorizer { get; set; }                                              
        public  string School_CharterSecondaryAuthorizer { get; set; }
        public string School_StatePovertyDesignation { get; set; }
        public decimal? School_SchoolImprovementAllocation { get; set; }
        public string School_IndicatorStatusType { get; set; }
        public string School_GunFreeSchoolsActReportingStatus { get; set; }
        public string School_ProgressAchievingEnglishLanguageProficiencyIndicatorType { get; set; }
        public string School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus { get; set; }
        public string School_SchoolDangerousStatus { get; set; }
        public string School_ComprehensiveAndTargetedSupport { get; set; }
        public string School_ComprehensiveSupport { get; set; }
        public string School_TargetedSupport { get; set; }
        public bool? School_ConsolidatedMigrantEducationProgramFundsStatus { get; set; }
        public string School_MigrantEducationProgramProjectType { get; set; }
        public string School_TitleISchoolStatus { get; set; }
        public  string School_AdministrativeFundingControl { get; set; }                                                 
        public  bool? School_IsReportedFederally { get; set; }                                                    
        public  DateTime? School_RecordStartDateTime { get; set; }                                                
        public  DateTime? School_RecordEndDateTime { get; set; }                                                  
        public  string SchoolYear { get; set; }                                                                   
        public  string DataCollectionName { get; set; }                                                           
        //public  int? DataCollectionId { get; set; }                                                               
        //public  int? OrganizationId_SEA { get; set; }                                                             
        //public  int? OrganizationId_IEU { get; set; }                                                             
        //public  int? OrganizationId_LEA { get; set; }                                                             
        //public  int? OrganizationId_School { get; set; }                                                          
        //public  int? K12ProgramOrServiceId_LEA { get; set; }                                                      
        //public  int? K12LeaTitleISupportServiceId { get; set; }                                                   
        //public  int? K12ProgramOrServiceId_School { get; set; }                                                   
        public  bool? NewIEU { get; set; }                                                                        
        public  bool? NewLEA { get; set; }                                                                        
        public  bool? NewSchool { get; set; }                                                                     
        //public  bool? IEU_Identifier_State_ChangedIdentifier { get; set; }                                        
        //public  string IEU_Identifier_State_Identifier_Old { get; set; }                                          
        //public  bool? LEA_Identifier_State_ChangedIdentifier { get; set; }                                        
        //public  string LEA_Identifier_State_Identifier_Old { get; set; }                                          
        //public  bool? School_Identifier_State_ChangedIdentifier { get; set; }                                     
        //public  string School_Identifier_State_Identifier_Old { get; set; }                                       
        //public  int? OrganizationRelationshipId_SEAToIEU { get; set; }                                            
        //public  int? OrganizationRelationshipId_IEUToLEA { get; set; }                                            
        //public  int? OrganizationRelationshipId_SEAToLEA { get; set; }                                            
        //public  int? OrganizationRelationshipId_LEAToSchool { get; set; }                                         
        //public int? OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer { get; set; }
        //public int? OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer { get; set; }
        //public int? OrganizationWebsiteId_LEA { get; set; }                                                      
        //public  int? OrganizationWebsiteId_School { get; set; }                                                   
        //public  int? OrganizationOperationalStatusId_IEU { get; set; }                                            
        //public  int? OrganizationOperationalStatusId_LEA { get; set; }                                            
        //public  int? OrganizationOperationalStatusId_School { get; set; }                                         
        public  DateTime? RunDateTime { get; set; }                                                               
    }                                                                                                             
}                                                                                                                 

































































































