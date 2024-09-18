using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class UpdatePackageDto
    {
        public string FileName { get; set; }
        public string Description { get; set; }
        public int MajorVersion { get; set; }
        public int MinorVersion { get; set; }
        public string PrerequisiteVersion { get; set; }
        public DateTime ReleaseDate { get; set; }
        public bool DatabaseBackupSuggested { get; set; }
        public string ReleaseNotesUrl { get; set; }

    }
}
