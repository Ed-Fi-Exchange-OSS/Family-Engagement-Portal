using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public interface IDateProvider
    {
        DateTime Today();
        DateTime Monday();
        DateTime Friday();
    }
}
