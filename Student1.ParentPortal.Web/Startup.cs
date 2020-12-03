using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Http;
using Microsoft.AspNet.SignalR;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Owin.Security.ActiveDirectory;
using Owin;
using SimpleInjector;
using SimpleInjector.Integration.WebApi;
using SimpleInjector.Lifestyles;
using Student1.ParentPortal.Web.App_Start;
using Student1.ParentPortal.Web.Security;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Student1.ParentPortal.Web.Hubs;
using System.Text;
using Microsoft.Owin.Security.OAuth;
using Microsoft.Owin.Security.Jwt;

namespace Student1.ParentPortal.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // IoC Configuration
            var ioCContainer = new IoCConfig().GetContainer();
            app.Use(async (context, next) => {
                using (AsyncScopedLifestyle.BeginScope(ioCContainer))
                {
                    await next();
                }
            });

            var config = new HttpConfiguration
            {
                DependencyResolver = new SimpleInjectorWebApiDependencyResolver(ioCContainer)
            };

            // Authentication Configuration
            ConfigureAuth(app, ioCContainer);

            // WebApi Configuration
            WebApiConfig.Register(config, ioCContainer);
            app.UseWebApi(config);

            // Enable SignalR
            var signalrEnvironment = ConfigurationManager.AppSettings["signalr.env"];

            if(signalrEnvironment=="local")
                app.MapSignalR(new HubConfiguration{ EnableDetailedErrors = true });
            else // It has to be azure
                app.MapAzureSignalR(this.GetType().FullName);
        }

        private void ConfigureAuth(IAppBuilder app, Container ioCContainer)
        {
            using (AsyncScopedLifestyle.BeginScope(ioCContainer))
            {
                var jwtAudience = ConfigurationManager.AppSettings["Jwt:Audience"];
                var jwtKey = ConfigurationManager.AppSettings["Jwt:Key"];
                var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
                var jwtIssuer = ConfigurationManager.AppSettings["Jwt:Issuer"];
                var customJwtOAuthBearerAuthenticationProvider = ioCContainer.GetInstance<IOAuthBearerAuthenticationProvider>();

                app.UseJwtBearerAuthentication(new JwtBearerAuthenticationOptions
                {
                    TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidIssuer = jwtIssuer,

                        ValidateAudience = true,
                        ValidAudience = jwtAudience,

                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = key
                    },
                    Provider = customJwtOAuthBearerAuthenticationProvider
                });
            }
        }
    }
}