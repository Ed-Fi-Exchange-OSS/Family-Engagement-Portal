// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

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
