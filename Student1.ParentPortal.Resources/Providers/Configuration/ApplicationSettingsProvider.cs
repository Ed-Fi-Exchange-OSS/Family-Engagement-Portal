// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Configuration;

namespace Student1.ParentPortal.Resources.Providers.Configuration
{
    public interface IApplicationSettingsProvider
    {
        string GetSetting(string key);
    }

    public class ApplicationSettingsProvider : IApplicationSettingsProvider
    {
        public string GetSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }
}
