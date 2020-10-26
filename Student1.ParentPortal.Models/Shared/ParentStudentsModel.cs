using Student1.ParentPortal.Models.Student;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class ParentStudentsModel
    {
        public int ParentUsi { get; set; }
        public string ParentUniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string ParentFirstName { get; set; }
        public string ParentMiddleName { get; set; }
        public string ParentLastSurname { get; set; }
        public string ParentName => $"{ParentFirstName} {ParentMiddleName} {ParentLastSurname}";
        public int PreferredMethodOfContactTypeId { get; set; }
        public string EdFiEmail { get; set; }
        public string ProfileEmail { get; set; }
        public string LanguageCode { get; set; }
        public string ParentRelation { get; set; }
        // Student data.
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string StudentFirstName { get; set; }
        public string StudentMiddleName { get; set; }
        public string StudentLastSurname { get; set; }
        public string StaffFirstName { get; set; }
        public string StaffLastSurname { get; set; }
        public string StudentName => $"{StudentFirstName} {StudentMiddleName} {StudentLastSurname}";
        public string ProfileTelephone { get; set; }
        public string ProfileTelephoneSMSSuffixDomain { get; set; }
        public string GradeLevel { get; set; }
    }
}
