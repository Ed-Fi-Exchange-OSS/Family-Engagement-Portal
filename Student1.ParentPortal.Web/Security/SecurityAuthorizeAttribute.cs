using SimpleInjector;
using Student1.ParentPortal.Resources.Providers.Security.Access;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace Student1.ParentPortal.Web.Security
{
    public class AuthorizationFilterAttribute : ActionFilterAttribute
    {
        private readonly Container _container;

        public AuthorizationFilterAttribute(Container container)
        {
            _container = container;
        }

        public override void OnActionExecuting(HttpActionContext actionContext)
        {

            if (isAllowedAnonymous(actionContext))
                return;

            var validationRequest = new SecurityContext
            {
                UserUSIAccessingResource = SecurityPrincipal.Current.PersonUSI,
                UserRoleAccessingResource = SecurityPrincipal.Current.Claims.Single(x => x.Type.Equals("role", StringComparison.InvariantCultureIgnoreCase)).Value,
                ResourceName = actionContext.ControllerContext.ControllerDescriptor.ControllerName,
                ActionName = actionContext.ActionDescriptor.ActionName,
                ActionParameters = actionContext.ActionArguments
            };

            var roleValidator = _container.GetInstance<IRoleResourceValidator>();
                
            var isRequestValid = roleValidator.ValidateRequest(validationRequest);

            if (!isRequestValid)
                throw new UnauthorizedAccessException("You don't have access to that resource.");
        }

        private bool isAllowedAnonymous(HttpActionContext actionContext)
        {
            return actionContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any()
                       || actionContext.ControllerContext.ControllerDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any();
        }
    }
}