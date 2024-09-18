using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class FileSubmission_FileColumn
    {
        public int FileSubmissionId { get; set; }
        public FileSubmission FileSubmission { get; set; }
        public int FileColumnId { get; set; }
        public FileColumn FileColumn { get; set; }
        public bool IsOptional { get; set; }
        public int StartPosition { get; set; }
        public int EndPosition { get; set; }
        public int SequenceNumber { get; set; }
  
    }
}
