using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PeerRatingSystem
    {
        public PeerRatingSystem()
        {
            LearningResourcePeerRating = new HashSet<LearningResourcePeerRating>();
        }

        public int PeerRatingSystemId { get; set; }
        public string Name { get; set; }
        public decimal? MaximumValue { get; set; }
        public decimal MinimumValue { get; set; }
        public decimal? OptimumValue { get; set; }

        public virtual ICollection<LearningResourcePeerRating> LearningResourcePeerRating { get; set; }
    }
}
