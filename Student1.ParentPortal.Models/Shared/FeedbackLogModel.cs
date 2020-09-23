// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;

namespace Student1.ParentPortal.Models.Shared
{
    public class FeedbackLogModel
    {
        public string Subject { get; set; }
        public string Issue { get; set; }
        public string Description { get; set; }
        public string CurrentUrl { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string PersonUniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
