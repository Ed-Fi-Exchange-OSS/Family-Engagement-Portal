using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Staff
{
    public class StaffImageModel
    {
        public int StaffUsi { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string MaidenName { get; set; }
        public int? SexTypeId { get; set; }  
        public virtual ICollection<StaffRaceModel> StaffRaces { get; set; }   
        public virtual SexTypeModel SexType { get; set; }
    }

    public class StaffRaceModel
    {
        public int StaffUsi { get; set; } 
        public int RaceTypeId { get; set; }
        public virtual RaceTypeModel RaceType { get; set; }
    }

    public class RaceTypeModel
    {
        public int RaceTypeId { get; set; }
        public string CodeValue { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
    }

    public class SexTypeModel
    {
        public int SexTypeId { get; set; }
        public string CodeValue { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
    }
}
