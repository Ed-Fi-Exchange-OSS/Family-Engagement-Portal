using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public static class TypeExtensionMethods
    {
        public static double Truncate(this double num, int decimalPlaces)
        {
            var power = Convert.ToDouble(Math.Pow(10, decimalPlaces));
            return Math.Floor(num * power) / power;
        }
    }
}
