// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Staff
{
    public class BriefProfileModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string Email { get; set; }
        public string Role { get; set; }
        public string LanguageCode { get; set; }
        public string ImageUrl { get; set; }
        public string FeedbackExternalUrl { get; set; }
    }
}
