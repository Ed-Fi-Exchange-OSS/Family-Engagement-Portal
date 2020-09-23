// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public static class TypeExtensionMethods
    {
        public static double Truncate(this double num, int decimalPlaces)
        {
            var power = Convert.ToDouble(Math.Pow(10, decimalPlaces));
            return Math.Floor(num * power) / power;
        }
    }
}
