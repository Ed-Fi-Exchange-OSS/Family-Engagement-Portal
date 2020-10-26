using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class TranslatedPackageModel
    {
        public string FileName { get; set; }
        public string FileContent { get; set; }
    }

    public class TranslatePackageModelRequest
    {
        public string Code { get; set; }
        public bool Type { get; set; }
        public bool AllLanguages { get; set; }
    }

    public class TranslateElementRequest 
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }

    public class TranslatedPackagesModel 
    {
        public TranslatedPackagesModel() 
        {
            translatedPackages = new List<TranslatedPackageModel>();
        }
        public List<TranslatedPackageModel> translatedPackages { get; set; }

    }
}
