namespace Student1.ParentPortal.Models.Shared
{
    public class ElectronicMailModel
    {
        ///<summary>
        /// The type of email listed for an individual or organization. For example: Home/Personal, Work, etc.)
        ///</summary>
        public int ElectronicMailTypeId { get; set; } // ElectronicMailTypeId (Primary key)

        ///<summary>
        /// The electronic mail (e-mail) address listed for an individual or organization.
        ///</summary>
        public string ElectronicMailAddress { get; set; } // ElectronicMailAddress (length: 128)

        ///<summary>
        /// An indication that the electronic mail address should be used as the principal electronic mail address for an individual or organization.
        ///</summary>
        public bool? PrimaryEmailAddressIndicator { get; set; } // PrimaryEmailAddressIndicator
    }
}
