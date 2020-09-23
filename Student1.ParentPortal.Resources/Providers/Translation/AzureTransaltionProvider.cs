// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Student1.ParentPortal.Resources.Providers.Configuration;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Translation
{
    public class AzureTransaltionProvider : ITranslationProvider
    {
        private readonly Uri _apiUrl;
        private readonly string _key;
        private const string _translationRoute = "/translate?api-version=3.0";
        private const string _supportedLanguagesRoute = "/languages?api-version=3.0";
        private readonly ICustomParametersProvider _customParametersProvider;

        public AzureTransaltionProvider(ICustomParametersProvider customParametersProvider)
        {
            _apiUrl = new Uri(ConfigurationManager.AppSettings["translation.ApiUrl"]);
            _key = ConfigurationManager.AppSettings["translation.Key"];
            _customParametersProvider = customParametersProvider;
        }

        public async Task<List<Language>> GetAvailableLanguagesAsync()
        {
            var languages = new List<Language>();

            // Go to the api endpoint and get the languages.
            using (var client = new HttpClient())
            using (var request = new HttpRequestMessage())
            {
                request.Method = HttpMethod.Get;
                request.RequestUri = new Uri(_apiUrl,$"{_supportedLanguagesRoute}&scope=translation");

                // Add the authorization header
                request.Headers.Add("Ocp-Apim-Subscription-Key", _key);

                // Send request and get response
                var response = await client.SendAsync(request);
                var jsonResponse = await response.Content.ReadAsStringAsync();

                dynamic jObject = JObject.Parse(jsonResponse);

                foreach (var lang in jObject.translation.Properties())
                    languages.Add(new Language {
                        Code = lang.Name,
                        Name = lang.Value.name,
                        NativeName = lang.Value.nativeName
                    });

                var reorderedLanguages = new List<Language>();
                var mostCommonLanguages = _customParametersProvider.GetParameters().mostCommonLanguageCodes;

                reorderedLanguages.AddRange(languages.Where(x => mostCommonLanguages.Contains(x.Code)));
                reorderedLanguages.AddRange(languages.Where(x => !mostCommonLanguages.Contains(x.Code)));

                return reorderedLanguages;
            }
        }

        public async Task<string> AutoDetectTranslateAsync(TranslateRequest request)
        {
            // Get the request in the format that the provider requires.
            var requestContent = JsonConvert.SerializeObject(new System.Object[] { new { Text = request.TextToTranslate } });

            using (var client = new HttpClient())
            using (var translationRequest = new HttpRequestMessage())
            {
                translationRequest.Method = HttpMethod.Post;
                translationRequest.RequestUri = new Uri(_apiUrl, $"{_translationRoute}&to={request.ToLangCode}");
                translationRequest.Content = new StringContent(requestContent, Encoding.UTF8, "application/json");

                // Add the authorization header
                translationRequest.Headers.Add("Ocp-Apim-Subscription-Key", _key);

                // Send request, get response
                var response = await client.SendAsync(translationRequest);
                var jsonResponse = await response.Content.ReadAsStringAsync();

                var resObj = JsonConvert.DeserializeObject<List<Response>>(jsonResponse);

                return resObj.First().Translations.First().Text;
            }
        }

        public async Task<string> TranslateAsync(TranslateRequest request)
        {
            // Get the request in the format that the provider requires.
            var requestContent = JsonConvert.SerializeObject(new System.Object[] { new { Text = request.TextToTranslate } });

            using (var client = new HttpClient())
            using (var translationRequest = new HttpRequestMessage())
            {
                translationRequest.Method = HttpMethod.Post;
                translationRequest.RequestUri = new Uri(_apiUrl, $"{_translationRoute}&to={request.ToLangCode}");
                translationRequest.Content = new StringContent(requestContent, Encoding.UTF8, "application/json");

                // Add the authorization header
                translationRequest.Headers.Add("Ocp-Apim-Subscription-Key", _key);

                // Send request, get response
                var response = await client.SendAsync(translationRequest);
                var jsonResponse = await response.Content.ReadAsStringAsync();

                var resObj = JsonConvert.DeserializeObject<List<Response>>(jsonResponse);

                return resObj.First().Translations.First().Text;
            }
        }

        private class Response
        {
            public DetectedLanguage DetectedLanguage { get; set; }
            public List<Translation> Translations { get; set; }
        }

        private class DetectedLanguage
        {
            public string Language { get; set; }
            public double Score { get; set; }
        }

        public class Translation
        {
            public string Text { get; set; }
            public string To { get; set; }
        }
    }
}
