using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public class GradeSortExtensionMethods : IComparer<GradeModel>
    {
        public int Compare(GradeModel x, GradeModel y)
        {
            var grades = GradeTypeEnum.GetAll();
            
            int integerX = 0;
            int integerY = 0;
            var xSplit = x.Name.Split(' ');
            var ySplit = y.Name.Split(' ');
            var xNumber = Regex.Match(xSplit[0], @"\d+").Value;
            var yNumber = Regex.Match(ySplit[0], @"\d+").Value;

            if (int.TryParse(xNumber, out integerX) && int.TryParse(yNumber, out integerY))
            {
                var gradesNumberX = grades.FirstOrDefault(g => g.Value.Equals(integerX));
                var gradesNumberY = grades.FirstOrDefault(g => g.Value.Equals(integerY));

                return gradesNumberX.Value.CompareTo(gradesNumberY.Value);
            }
            
           
            var gradesStringX = grades.FirstOrDefault(g => g.DisplayName.ToUpper().Equals(x.Name.ToUpper()));
            var gradesStringy = grades.FirstOrDefault(g => g.DisplayName.ToUpper().Equals(y.Name.ToUpper()));

            return gradesStringX.Value.CompareTo(gradesStringy.Value);
        }
    }
}
