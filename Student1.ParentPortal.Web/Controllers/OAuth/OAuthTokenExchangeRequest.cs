using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Student1.ParentPortal.Web.Controllers.OAuth
{
    public class OAuthTokenExchangeRequest
    {
        public string Id_token { get; set; }
        public string Grant_type { get; set; }
    }
}