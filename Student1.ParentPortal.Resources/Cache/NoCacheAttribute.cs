// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;

namespace Student1.ParentPortal.Resources.Cache
{
    [AttributeUsage(AttributeTargets.All)]
    public class NoCacheAttribute : Attribute
    {
        // Placeholder attribute to indicate that this class or method should not be cached.
    }
}
