namespace generate.core.Models.RDS
{
	public class FactOrganizationStatusCount
	{
		public int FactOrganizationStatusCountId { get; set; }
		public int FactTypeId { get; set; }
		public int K12SchoolId { get; set; }
		public int CountDateId { get; set; }
		public int RaceId { get; set; }
		public int IdeaStatusId { get; set; }
		public int K12DemographicId { get; set; }
		public int EcoDisStatusId { get; set; }
		public int IndicatorStatusId { get; set; }
		public int StateDefinedStatusId { get; set; }
		public int OrganizationStatusCount { get; set; }
		public int StateDefinedCustomIndicatorId { get; set; }
		public int IndicatorStatusTypeId { get; set; }

		public DimFactType DimFactType { get; set; }
		public DimDate DimCountDate { get; set; }
		public DimK12School DimSchool { get; set; }
		public DimRace DimRace { get; set; }
		public DimK12Demographic DimDemographic { get; set; }
		public DimIdeaStatus DimIdeaStatus { get; set; }
		public DimK12Demographic DimEcoDisStatus { get; set; }
		public DimIndicatorStatus DimIndicatorStatus { get; set; }
		public DimStateDefinedStatus DimStateDefinedStatus { get; set; }
		public DimStateDefinedCustomIndicator DimStateDefinedCustomIndicator { get; set; }
		public DimIndicatorStatusType DimIndicatorStatusType { get; set; }
	}
}
