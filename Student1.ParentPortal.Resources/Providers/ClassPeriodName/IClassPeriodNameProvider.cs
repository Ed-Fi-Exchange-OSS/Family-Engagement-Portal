using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.ClassPeriodName
{
    public interface IClassPeriodNameProvider
    {
        string ParseClassPeriodName(string classPeriodName);
    }
}
