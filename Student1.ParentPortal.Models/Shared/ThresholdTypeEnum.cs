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
    public class ThresholdTypeEnum : Enumeration<ThresholdTypeEnum>
    {
        public static readonly ThresholdTypeEnum UnexcusedAbsence = new ThresholdTypeEnum(1, "Unexcused Absence");
        public static readonly ThresholdTypeEnum ExcusedAbsence = new ThresholdTypeEnum(2, "Excused Absence");
        public static readonly ThresholdTypeEnum Tardy = new ThresholdTypeEnum(3, "Tardy");
        public static readonly ThresholdTypeEnum Behavior = new ThresholdTypeEnum(4, "Behavior");
        public static readonly ThresholdTypeEnum Assignment = new ThresholdTypeEnum(5, "Assignment");
        public static readonly ThresholdTypeEnum Course = new ThresholdTypeEnum(6, "Course");

        private ThresholdTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
