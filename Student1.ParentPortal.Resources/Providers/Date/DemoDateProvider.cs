using Student1.ParentPortal.Resources.ExtensionMethods;
using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public class DemoDateProvider : IDateProvider
    {
        public DateTime Today()
        {
            return DateTime.Parse("2019-05-01");
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
