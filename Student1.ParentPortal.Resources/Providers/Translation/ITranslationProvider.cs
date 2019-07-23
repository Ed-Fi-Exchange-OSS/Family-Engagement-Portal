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
