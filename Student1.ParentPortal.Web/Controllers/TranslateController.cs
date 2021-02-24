using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Translation;
using Student1.ParentPortal.Resources.Services.Translate;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/translate")]
    public class TranslateController : ApiController
    {
        private readonly ITranslationProvider _translationProvider;
        private readonly ITranslateService _translateService;

        public TranslateController(ITranslationProvider translationProvider, ITranslateService translateService)
        {
            _translationProvider = translationProvider;
            _translateService = translateService;
        }

        [AllowAnonymous]
        [Route("languages")]
        [HttpGet]
        public async Task<IHttpActionResult> GetAvailableLanguages()
        {
            var model = await _translationProvider.GetAvailableLanguagesAsync();

            if (model == null)
                return NotFound();

            //model = model.Where(rec => rec.Code == "en" || rec.Code == "es").ToList();

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

        [Route("package")]
        [HttpPost]
        public async Task<IHttpActionResult> CreatePackLang(TranslatePackageModelRequest request)
        {
            var baseLangFile = HttpContext.Current.Server.MapPath("~/clientapp/languages/en-us.js");
            var folderFiles = HttpContext.Current.Server.MapPath("~/clientapp/languages/");
            return Ok(await _translateService.CreatePackagesLanguages(request, baseLangFile, folderFiles));
        }

        [Route("package/add/element")]
        [HttpPost]
        public async Task<IHttpActionResult> AddElementInPackageLanguage(TranslateElementRequest request)
        {
            var baseLangFile = HttpContext.Current.Server.MapPath("~/clientapp/languages/en-us.js");
            return Ok(_translateService.AddElementToPackageLanguage(request, baseLangFile));
        }

    }
}
