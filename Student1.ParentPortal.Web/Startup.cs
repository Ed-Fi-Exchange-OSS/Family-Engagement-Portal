// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

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
                var mode = ConfigurationManager.AppSettings["authentication.azure.mode"];
                var tenant = ConfigurationManager.AppSettings["authentication.azure.tenant"];
                var audience = ConfigurationManager.AppSettings["authentication.azure.audience"];
                var instance = ConfigurationManager.AppSettings["authentication.azure.instance"];
                var policy = ConfigurationManager.AppSettings["authentication.azure.policy"];

                if (mode == "B2C")
                {
                    var stsDiscoveryEndpoint = string.Format(instance, tenant, policy);
                    var configManager = new ConfigurationManager<OpenIdConnectConfiguration>(stsDiscoveryEndpoint, new OpenIdConnectConfigurationRetriever());
                    var config = configManager.GetConfigurationAsync().Result;

                    var customAzureAdOAuthBearerAuthenticationProvider = ioCContainer.GetInstance<CustomAzureAdOAuthBearerAuthenticationProvider>();

                    app.UseWindowsAzureActiveDirectoryBearerAuthentication(
                        new WindowsAzureActiveDirectoryBearerAuthenticationOptions
                        {
                            Tenant = tenant,
                            TokenValidationParameters = new TokenValidationParameters
                            {
                                ValidAudience = audience,
                                ValidIssuer = config.Issuer,
                                IssuerSigningKeys = config.SigningKeys.ToList(),
                            },
                            Provider = customAzureAdOAuthBearerAuthenticationProvider
                        });
                }

                if (mode == "B2B")
                {
                    var customAzureAdOAuthBearerAuthenticationProvider = ioCContainer.GetInstance<CustomAzureAdOAuthBearerAuthenticationProvider>();

                    app.UseWindowsAzureActiveDirectoryBearerAuthentication(
                        new WindowsAzureActiveDirectoryBearerAuthenticationOptions
                        {
                            Tenant = tenant,
                            TokenValidationParameters = new TokenValidationParameters
                            {
                                ValidAudience = audience,
                            },
                            Provider = customAzureAdOAuthBearerAuthenticationProvider
                        });
                }
            }
        }
    }
}