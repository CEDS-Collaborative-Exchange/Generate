using System;
using System.Collections.Generic;

namespace generate.web.Security
{
    public class ApplicationUser
    {
        public string Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string DisplayName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool isLocked { get; set; }
        public List<string> Roles { get; set; }
    }
}
