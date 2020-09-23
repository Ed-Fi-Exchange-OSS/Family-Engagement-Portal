// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Runtime.Caching;
using Student1.ParentPortal.Resources.Providers.Configuration;

namespace Student1.ParentPortal.Resources.Providers.Cache
{
    public class InMemoryCacheProvider : ICacheProvider
    {
        private readonly IApplicationSettingsProvider _settingsProvider;

        public InMemoryCacheProvider(IApplicationSettingsProvider settingsProvider)
        {
            _settingsProvider = settingsProvider;
        }

        public object Get(string key)
        {
            return MemoryCache.Default.Get(key);
        }

        public T Get<T>(string key) where T : class
        {
            return MemoryCache.Default.Get(key) as T;
        }

        public void Set<T>(string key, T result) where T : class
        {
            var cacheTime = Convert.ToInt32(_settingsProvider.GetSetting("cache.timeInMinutes"));
            MemoryCache.Default.Add(key, result, DateTime.Now.AddMinutes(cacheTime));
        }
    }
}
