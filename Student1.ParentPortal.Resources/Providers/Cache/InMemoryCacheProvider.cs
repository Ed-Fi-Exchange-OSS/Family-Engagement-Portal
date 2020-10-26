using System;
using System.Collections.Generic;
using System.Linq;
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

        public void Clear()
        {
            ObjectCache cache = MemoryCache.Default;
            List<string> cacheKeys = cache.Select(kvp => kvp.Key).ToList();
            foreach (string cacheKey in cacheKeys)
            {
                cache.Remove(cacheKey);
            }
        }

    }
}
