using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Staff
{
    public class StaffProfileModel
    {
        public int StaffUsi { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string NickName { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public virtual ICollection<AddressModel> StaffProfileAddresses { get; set; }
        public virtual ICollection<ElectronicMailModel> StaffProfileElectronicMails { get; set; }
        public virtual ICollection<TelephoneModel> StaffProfileTelephones { get; set; }

        public StaffProfileModel()
        {
            CreateDate = DateTime.Now;
            LastModifiedDate = DateTime.Now;
            StaffProfileAddresses = new List<AddressModel>();
            StaffProfileElectronicMails = new List<ElectronicMailModel>();
            StaffProfileTelephones = new List<TelephoneModel>();
        }
    }
}
