// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Resources.Providers.Translation;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/translate")]
    public class TranslateController : ApiController
    {
        private readonly ITranslationProvider _translationProvider;

        public TranslateController(ITranslationProvider translationProvider)
        {
            _translationProvider = translationProvider;
        }

        [Route("languages")]
        [HttpGet]
        public async Task<IHttpActionResult> GetAvailableLanguages()
        {
            var model = await _translationProvider.GetAvailableLanguagesAsync();

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [Route("autoDetect")]
        [HttpPost]
        public async Task<IHttpActionResult> TranslateAutoDetect(TranslateRequest request)
        {
            var model = await _translationProvider.AutoDetectTranslateAsync(request);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpPost]
        public async Task<IHttpActionResult> Translate(TranslateRequest request)
        {
            var model = await _translationProvider.TranslateAsync(request);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
