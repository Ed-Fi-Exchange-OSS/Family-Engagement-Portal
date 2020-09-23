// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class AlertTypeEnum : Enumeration<AlertTypeEnum>
    {
        public static readonly AlertTypeEnum Absence = new AlertTypeEnum(1, "Absence");
        public static readonly AlertTypeEnum Behavior = new AlertTypeEnum(2, "Behavior");
        public static readonly AlertTypeEnum Assignment = new AlertTypeEnum(3, "Assignment");
        public static readonly AlertTypeEnum Course = new AlertTypeEnum(4, "Course");
        public static readonly AlertTypeEnum Message = new AlertTypeEnum(5, "Message");

        private AlertTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
