using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Student1.ParentPortal.Web.Controllers.OAuth.Admin
{
    public class OAuthAdminResponse
    {
        public string impersonatingRole { get; set; }
        public string token { get; set; }
    }
}