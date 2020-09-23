// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Reflection;
using Student1.ParentPortal.Resources.Cache;
using Student1.ParentPortal.Resources.Providers.Cache;
using Student1.ParentPortal.Resources.Providers.Configuration;

namespace Student1.ParentPortal.Web.Infrastructure.Cache
{
    public class CacheInterceptor : IInterceptor
    {
        private readonly ICacheProvider _cacheProvider;
        private readonly ICacheKeyProvider _cacheKeyProvider;
        private readonly IApplicationSettingsProvider _applicationSettingsProvider;

        public CacheInterceptor(ICacheProvider cacheProvider, ICacheKeyProvider cacheKeyProvider, IApplicationSettingsProvider applicationSettingsProvider)
        {
            _cacheProvider = cacheProvider;
            _cacheKeyProvider = cacheKeyProvider;
            _applicationSettingsProvider = applicationSettingsProvider;
        }

        public void Intercept(IInvocation invocation)
        {
            var cacheOn = Convert.ToBoolean(_applicationSettingsProvider.GetSetting("cache.on"));

            if(cacheOn)
            { 
                var noCacheAttribute = invocation.GetConcreteMethod().GetCustomAttribute<NoCacheAttribute>();

                // Should we cache this call?
                if(noCacheAttribute!=null)
                    invocation.Proceed();
                else
                    CacheTheCall(invocation);
            }
            else
                invocation.Proceed();
        }

        private void CacheTheCall(IInvocation invocation)
        {
            var cacheKey = _cacheKeyProvider.GenerateCacheKey(invocation.GetConcreteMethod(), invocation.Arguments);

            var result = _cacheProvider.Get(cacheKey);

            // If found in cache return it.
            if (result != null)
                invocation.ReturnValue = result;
            else
            {
                // If not found in cache let the invocation proceed and cache result for next time around.
                invocation.Proceed();
                var response = invocation.ReturnValue;
                _cacheProvider.Set(cacheKey, response);
            }
        }
    }
}