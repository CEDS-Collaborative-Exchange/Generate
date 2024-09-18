using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResourcePeerRating
    {
        public int LearningResourcePeerRatingId { get; set; }
        public int LearningResourceId { get; set; }
        public int PersonId { get; set; }
        public int PeerRatingSystemId { get; set; }
        public decimal? Value { get; set; }
        public DateTime? Date { get; set; }

        public virtual LearningResource LearningResource { get; set; }
        public virtual PeerRatingSystem PeerRatingSystem { get; set; }
        public virtual Person Person { get; set; }
    }
}
