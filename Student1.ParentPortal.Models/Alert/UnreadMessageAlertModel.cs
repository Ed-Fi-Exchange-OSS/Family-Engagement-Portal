// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Models.Student;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Alert
{
    public class UnreadMessageAlertModel
    {
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public int UnreadMessageCount { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public string SMSDomain { get; set; }
        public int? PreferredMethodOfContactTypeId { get; set; }
        public ICollection<int> AlertTypeIds { get; set; }
    }
}
