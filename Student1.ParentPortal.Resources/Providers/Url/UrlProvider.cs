using System;
using System.IO;
using System.Web;

namespace Student1.ParentPortal.Resources.Providers.Url
{
    public interface IUrlProvider
    {
        string GetApplicationBasePath();
        string GetStudentDetailUrl(int studentUsi);
        string GetLoginUrl();
    }

    public class UrlProvider : IUrlProvider
    {
        public string GetApplicationBasePath()
        {
            String strUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + HttpContext.Current.Request.ApplicationPath + "/";

            return strUrl;
        }

        public string GetStudentDetailUrl(int studentUsi)
        {
            return Path.Combine(GetApplicationBasePath(),$"#/studentdetail/{studentUsi}");
        }

        public string GetLoginUrl()
        {
            return Path.Combine(GetApplicationBasePath(), $"#/login");
        }

    }
}
