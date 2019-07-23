using System;
using System.Configuration;

namespace Student1.ParentPortal.Resources.Providers.Configuration
{
    public interface IApplicationSettingsProvider
    {
        string GetSetting(string key);
    }

    public class ApplicationSettingsProvider : IApplicationSettingsProvider
    {
        public string GetSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }
}
