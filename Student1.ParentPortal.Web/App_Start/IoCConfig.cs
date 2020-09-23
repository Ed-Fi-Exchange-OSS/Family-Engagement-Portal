// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Configuration;
using System.Linq;
using System.Web.Http;
using SimpleInjector;
using SimpleInjector.Lifestyles;
using Student1.ParentPortal.Data;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Data.Models.EdFi31;
using Student1.ParentPortal.Resources;
using Student1.ParentPortal.Resources.Azure.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Alerts;
using Student1.ParentPortal.Resources.Providers.Cache;
using Student1.ParentPortal.Resources.Providers.ClassPeriodName;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Messaging;
using Student1.ParentPortal.Resources.Providers.Security;
using Student1.ParentPortal.Resources.Providers.Security.Access;
using Student1.ParentPortal.Resources.Providers.Date;
using Student1.ParentPortal.Resources.Providers.Translation;
using Student1.ParentPortal.Resources.Providers.Url;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Web.Infrastructure.Cache;
using IApplicationSettingsProvider = Student1.ParentPortal.Resources.Providers.Configuration.IApplicationSettingsProvider;

namespace Student1.ParentPortal.Web.App_Start
{
    public class IoCConfig
    {
        public Container GetContainer()
        {
            var container = new Container();
            container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            RegisterProviders(container);

            // Register all repositories from our Data project.
            var databaseVersion = ConfigurationManager.AppSettings["application.ed-fi.version"];
            RegisterRepositoriesByConvention<Data_Marker>(container, databaseVersion);

            // Register all services from our Resources project.
            RegisterServicesByConvention<Resources_Marker>(container);
            

            // This is an extension method from the integration package.
            container.RegisterWebApiControllers(GlobalConfiguration.Configuration);

            // Register the Cache Interceptor
            RegisterCacheInterceptor(container);

            container.Verify();

            return container;
        }

        private static void RegisterServicesByConvention<TMarker>(Container container)
        {
            var types = typeof(TMarker).Assembly.ExportedTypes;

            var servicesToRegister = (
                from interfaceType in types.Where(t => t.Name.StartsWith("I") && t.Name.EndsWith("Service"))
                from serviceType in types.Where(t => t.Name == interfaceType.Name.Substring(1))
                select new
                {
                    InterfaceType = interfaceType,
                    ServiceType = serviceType
                }
            );

            foreach (var pair in servicesToRegister)
                container.Register(pair.InterfaceType, pair.ServiceType);
        }

        private static void RegisterRepositoriesByConvention<TMarker>(Container container, string databaseVersion)
        {
            //if(databaseVersion == "EdFi25")
                container.Register<EdFi25Context, EdFi25Context>(Lifestyle.Scoped);
            //else
                container.Register<EdFi31Context, EdFi31Context>(Lifestyle.Scoped);

            var types = typeof(TMarker).Assembly.ExportedTypes;

            var repositoriesToRegister = (
                from interfaceType in types.Where(t => t.Name.StartsWith("I") && t.Name.EndsWith("Repository"))
                from repositoryType in types.Where(t => t.Name == interfaceType.Name.Substring(1) && t.Namespace.Contains(databaseVersion))
                select new
                {
                    InterfaceType = interfaceType,
                    ServiceType = repositoryType
                }
            );

            foreach (var pair in repositoriesToRegister)
                container.Register(pair.InterfaceType, pair.ServiceType);
        }

        private static void RegisterProviders(Container container)
        {
            container.Register<IApplicationSettingsProvider, ApplicationSettingsProvider>();
            container.Register<IDatabaseIdentityProvider, DatabaseIdentityProvider>();
            container.Register<IMessagingProvider, EmailMessagingProvider>();
            container.Register<ISMSProvider, SMSMessagingProvider>();
            container.Register<ICustomParametersProvider, CustomParametersProvider>();
            container.Register<IUrlProvider, UrlProvider>();

            // Caching
            container.Register<ICacheProvider,InMemoryCacheProvider>();

            // Image Provider
            RegisterImageProviders(container);

            var applicationMode = ConfigurationManager.AppSettings["application.mode"];

            switch (applicationMode)
            {
                case "Demo":
                    //container.Register<IClassPeriodNameProvider, CoreClassPeriodNameProvider>();
                    container.Register<IClassPeriodNameProvider, YesPrepClassPeriodNameProvider>();
                    container.Register<IDateProvider, DemoDateProvider>();
                    break;
                case "Local":
                    container.Register<IClassPeriodNameProvider, CoreClassPeriodNameProvider>();
                    container.Register<IDateProvider, DemoDateProvider>();
                    //container.Register<IDateProvider, DateProvider>();
                    break;
                case "Production":
                    container.Register<IClassPeriodNameProvider, YesPrepClassPeriodNameProvider>();
                    container.Register<IDateProvider, DateProvider>();
                    break;
                default:
                    container.Register<IClassPeriodNameProvider, CoreClassPeriodNameProvider>();
                    container.Register<IDateProvider, DemoDateProvider>();
                    break;
            }

            // Alert Providers
            var assemblies = new[] { typeof(IAlertProvider).Assembly };
            container.Collection.Register(typeof(IAlertProvider), assemblies);

            // Translation Provider
            container.Register<ITranslationProvider, AzureTransaltionProvider>();

            // Identity Providers
            container.Collection.Register(typeof(IIdentityProvider), new[]
            {
                typeof(ParentIdeintityProvider),
                typeof(StaffIdeintityProvider)
            });

            container.Collection.Register(typeof(IRoleResourceAccessValidator), assemblies);
            container.Register<IRoleResourceValidator, RoleResourceValidator>();
        }

        private static void RegisterCacheInterceptor(Container container)
        {
            container.Register<ICacheKeyProvider,CacheKeyProvider>();
            container.Register<CacheInterceptor>();

            // Add the CacheInterceptor on every service.
            container.InterceptWith<CacheInterceptor>(serviceType => serviceType.Name.EndsWith("Service"));

            // Add Cache to Images Provider
            container.InterceptWith<CacheInterceptor>(serviceType => serviceType.Name.EndsWith("BlobImageProvider"));

        }

        private static void RegisterImageProviders(Container container)
        {
            var imageProvider = ConfigurationManager.AppSettings["image.provider"];

            // TODO: Refactor into using a more elegant solution. (Due to time restrictions going with the quick approach.)
            switch (imageProvider)
            {
                case "DemoImageProvider":
                    container.Register<IImageProvider, DemoImageProvider>();
                    break;
                case "ConventionBasedImageProvider":
                    container.Register<IImageProvider, ConventionBasedImageProvider>();
                    break;
                case "BlobImageProvider":
                    container.Register<IImageProvider, BlobImageProvider>();
                    break;
                default:
                    container.Register<IImageProvider, DemoImageProvider>();
                    break;
            }
        }
    }
}