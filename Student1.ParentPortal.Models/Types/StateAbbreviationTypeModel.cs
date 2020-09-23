// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

namespace Student1.ParentPortal.Models.Types
{
    public class StateAbbreviationTypeModel
    {
        ///<summary>
        /// Key for StateAbbreviation
        ///</summary>
        public int StateAbbreviationTypeId { get; set; }

        ///<summary>
        /// The value for the StateAbbreviation type.
        ///</summary>
        public string ShortDescription { get; set; }
    }
}
