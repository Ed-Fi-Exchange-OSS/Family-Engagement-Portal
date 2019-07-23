using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace Student1.ParentPortal.Web.Filters
{
    /// <summary>
    /// Used to log execution time requests to server
    /// </summary>
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = true)]
    public class ActionExecutionTimerFilter : ActionFilterAttribute
    {
        public static Stopwatch GetTimer(HttpRequestMessage request)
        {
            const string key = "__timer__";
            if (request.Properties.ContainsKey(key))
            {
                return (Stopwatch)request.Properties[key];
            }

            var result = new Stopwatch();
            request.Properties[key] = result;
            return result;
        }

        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            var timer = GetTimer(actionContext.Request);
            timer.Start();
            base.OnActionExecuting(actionContext);
        }

        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            base.OnActionExecuted(actionExecutedContext);
            var timer = GetTimer(actionExecutedContext.Request);
            timer.Stop();

            if (actionExecutedContext.Response != null && actionExecutedContext.Response.Content != null)
                actionExecutedContext.Response.Content.Headers.Add("X-CallExecutionTime", $"{timer.ElapsedMilliseconds}ms");
        }
    }
}