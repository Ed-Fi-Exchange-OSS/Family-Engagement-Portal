// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

namespace Student1.ParentPortal.Models.Shared
{
    public class TelephoneModel
    {
        ///<summary>
        /// The type of communication number listed for an individual or organization.
        ///</summary>
        public int TelephoneNumberTypeId { get; set; }

        ///<summary>
        /// The telephone number including the area code, and extension, if applicable.
        ///</summary>
        public string TelephoneNumber { get; set; } // TelephoneNumber (length: 24)

        ///<summary>
        /// An indication that the telephone number is technically capable of sending and receiving Short Message Service (SMS) text messages.
        ///</summary>
        public bool? TextMessageCapabilityIndicator { get; set; }

        ///<summary>
        /// An indication that the telephone number is the primary method of contact.
        ///</summary>
        public bool? PrimaryMethodOfContact { get; set; }

        public int? TelephoneCarrierTypeId { get; set; }
    }
}
