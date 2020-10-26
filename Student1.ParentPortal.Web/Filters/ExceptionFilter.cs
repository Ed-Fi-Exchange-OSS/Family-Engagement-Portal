using SimpleInjector;
using Student1.ParentPortal.Resources.Providers.Logger;
using Student1.ParentPortal.Web.Security;
using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Filters;

namespace Student1.ParentPortal.Web.Filters
{
    /// <summary>
    /// Used to log execution time requests to server
    /// </summary>
    public class ExceptionLogFilter : ExceptionFilterAttribute
    {
        private readonly Container _container;

        public ExceptionLogFilter(Container container)
        {
            _container = container;
        }

        public async override Task OnExceptionAsync(HttpActionExecutedContext context, CancellationToken cancellationToken)
        {
            //if (context.Exception is NotImplementedException)
            //{
            //    Code by type
            //}

            //Next Line will return exception message through http response
            var person = SecurityPrincipal.Current;

            var logger = _container.GetInstance<ILogger>();

            switch (context.Exception.Message)
            {
                case "Credentials did not match any parent or teacher.": // For this specific case we are logging it in the DatabaseIdentityProvider
                    context.Response = new HttpResponseMessage(HttpStatusCode.InternalServerError) { Content = new StringContent(context.Exception.Message) };
                    break;
                default:
                    if (person.PersonUniqueId != null)
                        await logger.LogErrorAsync($"RequestUri: {context.Request?.RequestUri?.AbsolutePath }. Email:{person.Email} with Role {person.Role} and UniqueId '{person.PersonUniqueId}' had the following exception: {context.Exception.Message}. StackTrace: {context.Exception.StackTrace}");
                    else
                        await logger.LogErrorAsync($"RequestUri: {context.Request?.RequestUri?.AbsolutePath }. Server error: {context.Exception.Message}. StackTrace: {context.Exception.StackTrace}");
                    break;
            }


        }
    }
}