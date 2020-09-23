// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Resources.Providers.Configuration;
using System;

namespace Student1.ParentPortal.Resources.Providers.Date
{
    public class DemoDateProvider : IDateProvider
    {
        private readonly IApplicationSettingsProvider _appSettingsProvider;
        
        public DemoDateProvider(IApplicationSettingsProvider appSettingsProvider)
        {
            _appSettingsProvider = appSettingsProvider;
        }
        public DateTime Today()
        {
            return DateTime.Parse(_appSettingsProvider.GetSetting("demo.date"));
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
