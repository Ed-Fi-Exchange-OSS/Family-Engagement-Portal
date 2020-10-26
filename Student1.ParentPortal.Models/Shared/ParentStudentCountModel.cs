using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class ParentStudentCountModel
    {
        public string CampusName { get; set; }
        public int StudentsCount { get; set; }
        public int FamilyMembersCount{ get; set; }
    }

    public class FamilyCalculateItem 
    {
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string StudentName => $"{FirstNameStudent} {MiddleNameStudent} {LastSurnameStudent}";
        public string FirstNameStudent { get; set; }
        public string MiddleNameStudent { get; set; }
        public string LastSurnameStudent { get; set; }
        public int ParentUsi { get; set; }
        public string ParentUniqueId { get; set; }
        public string ParentName => $"{FirstNameParent} {LastSurnameParent}";
        public string FirstNameParent { get; set; }
        public string LastSurnameParent { get; set; }
        public string CampusName { get; set; }

    }
}

