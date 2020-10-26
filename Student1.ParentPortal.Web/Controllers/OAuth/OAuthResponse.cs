using Student1.ParentPortal.Web.Controllers.OAuth.Admin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Student1.ParentPortal.Web.Controllers.OAuth
{
    public class OAuthResponse
    {
        public string Access_token { get; set; }
        public string Token_type { get; set; }
        public int Expires_in { get; set; }
        public string Refresh_token { get; set; }
        public string Example_parameter { get; set; }
    }
}