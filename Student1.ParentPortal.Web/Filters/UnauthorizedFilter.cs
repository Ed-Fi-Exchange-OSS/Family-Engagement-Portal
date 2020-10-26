using System;
using System.Web.Http;
using System.Web.Http.Controllers;

namespace Student1.ParentPortal.Web.Filters
{
    /// <summary>
    /// Used to log execution time requests to server
    /// </summary>
    public class UnauthorizedFilterAttribute : AuthorizeAttribute
    {
        public override void OnAuthorization(HttpActionContext context)
        {
            base.OnAuthorization(context);
            
        }


        protected override void HandleUnauthorizedRequest(HttpActionContext actionContext)
        {
            //Write Your Response Body ,Now I  Throw a Custom ValidateException;
            throw new UnauthorizedAccessException("Credentials did not match any parent or teacher.");
            //base.HandleUnauthorizedRequest(actionContext);
        }

        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            return base.IsAuthorized(actionContext);
        }
    }
}