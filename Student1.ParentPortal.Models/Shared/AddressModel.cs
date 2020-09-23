// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

namespace Student1.ParentPortal.Models.Shared
{
    public class AddressModel
    {
        ///<summary>
        /// The type of address listed for an individual or organization.    For example:  Physical Address, Mailing Address, Home Address, etc.)
        ///</summary>
        public int AddressTypeId { get; set; }

        ///<summary>
        /// The street number and street name or post office box number of an address.
        ///</summary>
        public string StreetNumberName { get; set; }

        ///<summary>
        /// The apartment, room, or suite number of an address.
        ///</summary>
        public string ApartmentRoomSuiteNumber { get; set; }

        ///<summary>
        /// The name of the city in which an address is located.
        ///</summary>
        public string City { get; set; }

        ///<summary>
        /// The abbreviation for the state (within the United States) or outlying area in which an address is located.
        ///</summary>
        public int StateAbbreviationTypeId { get; set; }

        ///<summary>
        /// The five or nine digit zip code or overseas postal code portion of an address.
        ///</summary>
        public string PostalCode { get; set; }

        ///<summary>
        /// The name of the county, parish, borough, or comparable unit (within a state) in which an address is located.
        ///</summary>
        public string NameOfCounty { get; set; }
    }
}
