// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;

namespace Student1.ParentPortal.Models.Shared
{
    public class PersonIdentityModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public string Email { get; set; }
        public string PersonType { get; set; }
        public int PersonTypeId { get; set; }
    }
}
