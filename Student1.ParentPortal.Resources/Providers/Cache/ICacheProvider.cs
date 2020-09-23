// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

namespace Student1.ParentPortal.Resources.Providers.Cache
{
    public interface ICacheProvider
    {
        object Get(string key);
        T Get<T>(string key) where T : class;
        void Set<T>(string key, T result) where T : class;
    }
}
