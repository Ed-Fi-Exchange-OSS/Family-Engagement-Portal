using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Cors;
using Newtonsoft.Json.Serialization;
using SimpleInjector;
using Student1.ParentPortal.Web.Filters;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config, Container container)
        {
            // Configuring to serialize JSON to camel case
            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();

            // Enable CORS. This API will be accessed by both a client side Web app and a mobile app.
            var cors = new EnableCorsAttribute(origins: "*", headers: "*", methods: "*");
            config.EnableCors(cors);

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            // Filters
            // Add default filter to secure all endpoints
            config.Filters.Add(new AuthorizeAttribute());
            //config.Filters.Add(container.GetInstance<AuthorizationFilterAttribute>());
            // Web API registers filters as singletons so to create instances of the EF DbContext we need to send the container all the way down.
            config.Filters.Add(new AuthorizationFilterAttribute(container));
            config.Filters.Add(new ActionExecutionTimerFilter());
        }
    }
}
