// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Translation
{
    public interface ITranslationProvider
    {
        Task<List<Language>> GetAvailableLanguagesAsync();
        Task<string> AutoDetectTranslateAsync(TranslateRequest request);
        Task<string> TranslateAsync(TranslateRequest request);
    }

    public class Language
    {
        public string Code { get; set; }
        public string Name { get; set; }
        public string NativeName { get; set; }
    }

    public class TranslateRequest
    {
        public string TextToTranslate { get; set; }
        public string FromLangCode { get; set; }
        public string ToLangCode { get; set; }
    }
}
