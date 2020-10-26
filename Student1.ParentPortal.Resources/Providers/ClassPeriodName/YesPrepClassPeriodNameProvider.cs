using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.ClassPeriodName
{
    public class YesPrepClassPeriodNameProvider : IClassPeriodNameProvider
    {
        public string ParseClassPeriodName(string classPeriodName)
        {
            var classParts = classPeriodName.Split('_');

            return classParts[classParts.Length - 1];
        }
    }
}
