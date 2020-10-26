using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Resources.Providers.Configuration;
using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public class DemoDateProvider : IDateProvider
    {
        private readonly IApplicationSettingsProvider _appSettingsProvider;
        
        public DemoDateProvider(IApplicationSettingsProvider appSettingsProvider)
        {
            _appSettingsProvider = appSettingsProvider;
        }
        public DateTime Today()
        {
            return DateTime.Parse(_appSettingsProvider.GetSetting("demo.date"));
        }

        public DateTime Monday()
        {
            return Today().FirstHourOfTheDay().GetMonday();
        }

        public DateTime Friday()
        {
            return Today().LastHourOfTheDay().GetFriday();
        }
    }
}
