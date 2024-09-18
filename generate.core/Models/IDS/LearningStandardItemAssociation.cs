using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningStandardItemAssociation
    {
        public int LearningStandardItemAssociationId { get; set; }
        public int LearningStandardItemId { get; set; }
        public int RefEntityTypeId { get; set; }
        public int AssociatedEntityId { get; set; }
        public int? RefLearningStandardItemAssociationTypeId { get; set; }
        public string LearningStandardItemAssociationIdentifierUri { get; set; }
        public string ConnectionCitation { get; set; }
        public string OriginNodeName { get; set; }
        public string OriginNodeUri { get; set; }
        public string DestinationNodeName { get; set; }
        public string DestinationNodeUri { get; set; }
        public decimal? Weight { get; set; }

        public virtual LearningStandardItem LearningStandardItem { get; set; }
        public virtual RefEntityType RefEntityType { get; set; }
        public virtual RefLearningStandardItemAssociationType RefLearningStandardItemAssociationType { get; set; }
    }
}
