// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Resources.ExtensionMethods;
using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public class DateProvider : IDateProvider
    {
        public DateTime Today()
        {
            return DateTime.Now;
        }

        public DateTime Monday()
        {
            return Today().FirstHourOfTheDay().GetMonday();
        }

        public DateTime Friday()
        {
            return Today().LastHourOfTheDay().GetFriday();
        }
    }
}
