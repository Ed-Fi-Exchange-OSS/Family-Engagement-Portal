using Student1.ParentPortal.Resources.ExtensionMethods;
using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public class DateProvider : IDateProvider
    {
        public DateTime Today()
        {
            return DateTime.Now;
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
