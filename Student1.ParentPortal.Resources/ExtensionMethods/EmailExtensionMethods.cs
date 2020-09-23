// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Linq;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public static class EmailExtensionMethods
    {
        /// <summary>Gets the .</summary>
        /// <param name="emails">The list of emails.</param>
        /// <returns>The primary email. If none marked as primary then a default existing one.</returns>
        public static string GetPrimaryOrDefaultEmail(this List<ElectronicMailModel> emails)
        {
            if (emails.Any(x => x.PrimaryEmailAddressIndicator == true))
                return emails.Single(x => x.PrimaryEmailAddressIndicator == true).ElectronicMailAddress;

            return emails.Any() ? emails.First().ElectronicMailAddress : null;
        }
    }
}
