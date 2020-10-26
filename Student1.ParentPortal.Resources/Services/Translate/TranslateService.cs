using Newtonsoft.Json;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Translation;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Student1.ParentPortal.Resources.Services.Translate
{
    public interface ITranslateService
    {
        Task<TranslatedPackagesModel> CreatePackagesLanguages(TranslatePackageModelRequest model, string baseLangPath, string folderFile);
        bool AddElementToPackageLanguage(TranslateElementRequest model, string baseLangPath);
    }

    public class TranslateService : ITranslateService
    {
        private readonly ITranslationProvider _translationProvider;
        public TranslateService(ITranslationProvider translationProvider)
        {
            _translationProvider = translationProvider;
        }

        public bool AddElementToPackageLanguage(TranslateElementRequest model, string baseLangPath)
        {
            bool translateText = false;
            Dictionary<string, string> packageLanguage = new Dictionary<string, string>();
            var langFile = File.ReadLines(baseLangPath);

            foreach (var line in langFile)
            {
                if (line.Contains("Global level translations"))
                {
                    translateText = true;
                }

                if (line.Contains("});") || line.Contains("}]);"))
                {
                    translateText = false;
                }

                if (translateText)
                {
                    if (!line.Contains("//") && !line.Contains("/*") && !string.IsNullOrWhiteSpace(line)) 
                    {
                        string[] KeyValue = line.Split(':');
                        KeyValue[0] = CleanValue(KeyValue[0]);
                        KeyValue[1] = CleanValue(KeyValue[1]);

                        packageLanguage.Add(KeyValue[0].TrimStart().TrimEnd(), KeyValue[1].TrimStart().TrimEnd());
                    }
                }
            }

            var existElement = packageLanguage.Any(x => x.Key.Equals(model.Key));

            if(!existElement) 
            {
                //We delete the two final lines
                List<string> lines = File.ReadAllLines(baseLangPath).ToList();
                File.WriteAllLines(baseLangPath, lines.GetRange(0, lines.Count - 2).ToArray());

                using (StreamWriter sw = File.AppendText(baseLangPath))
                {
                    sw.WriteLine($", \"{model.Key}\":\"{model.Value}\"");
                    sw.WriteLine("});");
                    sw.WriteLine("}]);");
                }
            }
            return true;
        }

       

        public async Task<TranslatedPackagesModel> CreatePackagesLanguages(TranslatePackageModelRequest model, string baseLangPath, string folderFile)
        {
            var languageAvailable = await _translationProvider.GetAvailableLanguagesAsync();
            TranslatedPackagesModel tranlatedPackages = new TranslatedPackagesModel();
            if (model.AllLanguages)
            {
                foreach (var language in languageAvailable.Where(x => x.Code != "en" && x.Code != "es"))
                {
                    model.Code = language.Code;
                    tranlatedPackages.translatedPackages.Add(await GenerateFile(model, baseLangPath, folderFile, language.Name));
                }
            }
            else
            {
                var languageName = languageAvailable.FirstOrDefault(x => x.Code == model.Code).Name;
                tranlatedPackages.translatedPackages.Add(await GenerateFile(model, baseLangPath, folderFile, languageName));
            }
            return tranlatedPackages;
        }

        private async Task<TranslatedPackageModel> GenerateFile(TranslatePackageModelRequest model, string baseLangPath, string folderFile, string languageName)
        {
            string langTraslated = string.Empty;
            bool translateText = false;
            Dictionary<string, string> translateTextJson = new Dictionary<string, string>();

            var langFile = File.ReadLines(baseLangPath);

            var fileName = $"{model.Code}-{languageName}";

            foreach (var line in langFile)
            {
                if (line.Contains("Global level translations"))
                {
                    translateText = true;
                }

                if (line.Contains("});") || line.Contains("}]);"))
                {
                    translateText = false;
                }

                if (translateText)
                {
                    if (!line.Contains("//") && !line.Contains("/*") && !string.IsNullOrWhiteSpace(line))
                    {
                        try
                        {
                            string[] KeyValue = line.Split(':');
                            KeyValue[1] = CleanValue(KeyValue[1]);
                            KeyValue[0] = CleanValue(KeyValue[0]);

                            string translatedText = string.Empty;
                            string exist = existKey(folderFile, model.Code, KeyValue[0]);
                            if (!string.IsNullOrEmpty(exist))
                            {
                                translatedText = exist;
                            } 
                            else 
                            {
                                var transRequest = new TranslateRequest
                                {
                                    FromLangCode = "en",
                                    ToLangCode = model.Code,
                                    TextToTranslate = KeyValue[1]
                                };
                                translatedText = await _translationProvider.TranslateAsync(transRequest);
                            }
                            

                            //Type logic: True = Web format language package, False = Movile format language package
                            if (model.Type)
                            {
                                KeyValue[0] = '"' + KeyValue[0] + '"';
                                KeyValue[1] = '"' + translatedText + '"';
                                string KeyValueTranslated = string.Join(":", KeyValue);
                                langTraslated += $"{KeyValueTranslated}," + Environment.NewLine;
                            }
                            else
                            {
                                KeyValue[0] = KeyValue[0].Replace("'", "");
                                KeyValue[0] = KeyValue[0].Replace('"', ' ');
                                KeyValue[1] = translatedText.Replace('"', ' ');
                                KeyValue[1] = translatedText.Replace("\"", "");
                                KeyValue[1] = translatedText.Replace("'", "");
                                translateTextJson.Add(KeyValue[0], KeyValue[1]);
                            }
                        }
                        catch (Exception ex)
                        {
                            throw;
                        }
                    }
                }
                else
                {
                    var lang = line.Replace("en-us", fileName);
                    langTraslated += $"{lang}" + Environment.NewLine;
                }
            }
            if (!model.Type)
            {
                langTraslated = JsonConvert.SerializeObject(translateTextJson);
            }

            var response = new TranslatedPackageModel
            {
                FileName = fileName,
                FileContent = langTraslated
            };

            return response;
        }

        private string CleanValue(string value)
        {
            value = value.Replace(",", "");
            value = value.Replace('"', ' ');
            value = value.Replace("\"", "");
            value = value.Replace("'", "");
            value = value.TrimStart().TrimEnd();
            return value;
        }

        private string existKey(string folderFile, string languageCode, string key)
        {
            string fileName = string.Empty;
            var paths = Directory.GetFiles(folderFile).ToList();
            foreach (var path in paths)
            {
                var name = Path.GetFileNameWithoutExtension(path);
                string[] nameSplit = name.Split('-');
                if (nameSplit[0] == languageCode)
                {
                    fileName = path;
                    break;
                } else
                {
                    continue;
                }
            }
            bool translateText = false;

            if (string.IsNullOrEmpty(fileName)) {
                return null;
            }
            
            Dictionary<string, string> packageLanguage = new Dictionary<string, string>();
            var langFile = File.ReadLines(fileName);

            foreach (var line in langFile)
            {
                if (line.Contains("$translateProvider.translations"))
                {
                    translateText = true;
                    continue;
                }

                if (line.Contains("});") || line.Contains("}]);"))
                {
                    translateText = false;
                }

                if (translateText)
                {
                    if (!line.Contains("//") && !line.Contains("/*") && !string.IsNullOrWhiteSpace(line))
                    {
                        string[] KeyValue = line.Split(':');
                        KeyValue[0] = CleanValue(KeyValue[0]);
                        KeyValue[1] = CleanValue(KeyValue[1]);

                        packageLanguage.Add(KeyValue[0].TrimStart().TrimEnd(), KeyValue[1].TrimStart().TrimEnd());
                    }
                }
            }

            var existElement = packageLanguage.FirstOrDefault(x => x.Key.Equals(key)).Value;

            return existElement;
        }
    }
}
