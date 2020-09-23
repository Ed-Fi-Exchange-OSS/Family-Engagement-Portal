// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Url;
using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;

namespace Student1.ParentPortal.Resources.Providers.Image
{
    public class ConventionBasedImageProvider : IImageProvider
    {
        private readonly IUrlProvider _urlProvider;
        private readonly IApplicationSettingsProvider _applicationSettingsProvider;

        public ConventionBasedImageProvider(IUrlProvider urlProvider, IApplicationSettingsProvider applicationSettingsProvider)
        {
            _urlProvider = urlProvider;
            _applicationSettingsProvider = applicationSettingsProvider;
        }

        public async Task<string> GetStaffImageUrlAsync(string staffUniqueId)
        {
            var filepath = getOverridenFilePath(staffUniqueId.Trim(), _applicationSettingsProvider.GetSetting("staff.image.path"));

            return ImageExistsOrDefault(filepath);

        }

        public async Task<string> GetParentImageUrlAsync(string parentUniqueId)
        {
            var filepath = getOverridenFilePath(parentUniqueId.Trim(), _applicationSettingsProvider.GetSetting("parent.image.path"));

            return ImageExistsOrDefault(filepath);
        }


        public async Task<string> GetStudentImageUrlAsync(string studentUniqueId)
        {
            var filepath = getOverridenFilePath(studentUniqueId.Trim(), _applicationSettingsProvider.GetSetting("student.image.path"));

            return ImageExistsOrDefault(filepath);
        }

        /// <summary>
        /// Gets the overridden uploaded file path.
        /// </summary>
        /// <param name="usi"></param>
        /// <param name="path"></param>
        /// <returns>The path to the uploaded file.</returns>
        private string getOverridenFilePath(string uniqueId, string path)
        {
            // Convention based uploaded file name.
            var physicalFilePath = HttpContext.Current.Server.MapPath(Path.Combine("~/", path));

            // Get all files that match the convention no matter the extension.
            var files = Directory.GetFiles(physicalFilePath, uniqueId + ".*");

            if (files.Length > 0)
            {
                var fileName = Path.GetFileName(files.FirstOrDefault());
                var relativeImageUrl = Path.Combine(path, fileName);
                return relativeImageUrl;
            }

            return null;
        }
        
        public async Task<string> GetStudentImageUrlForAlertsAsync(string studentUniqueId)
        {
            return _urlProvider.GetApplicationBasePath() + (await GetStudentImageUrlAsync(studentUniqueId));
        }

        public async Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType)
        {
            var filename = parentUniqueid.Trim();
            var path = HttpContext.Current.Server.MapPath(Path.Combine("~/", _applicationSettingsProvider.GetSetting("parent.image.path")));
            var previousPicturePath = PathToPreviousPicture(path, filename);

            if (previousPicturePath != null)
                File.Delete(previousPicturePath);

            File.WriteAllBytes(path + filename + GetFileExtension(contentType), image);
        }

        public async Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType)
        {
            var filename = staffUniqueid.Trim();
            var path = HttpContext.Current.Server.MapPath(Path.Combine("~/", _applicationSettingsProvider.GetSetting("staff.image.path")));
            var previousPicturePath = PathToPreviousPicture(path, filename);

            if (previousPicturePath != null)
                File.Delete(previousPicturePath);

            File.WriteAllBytes(path + filename + GetFileExtension(contentType), image);
        }

        private string ImageExistsOrDefault(string relativeImagePath)
        {
            var defaultImagePath = _applicationSettingsProvider.GetSetting("default.image.path");

            if (relativeImagePath == null)
                return defaultImagePath;
            else
                return relativeImagePath;
        }

        private string PathToPreviousPicture(string root, string filename)
        {
            var files = Directory.GetFiles(root, filename + ".*");
            if (files.Length > 0)
                return files.FirstOrDefault();
            return null;
        }

        private string GetFileExtension(string contentType)
        {
            switch (contentType)
            {
                case "image/jpeg":
                    return ".jpg";
                case "image/png":
                    return ".png";
                default:
                    throw new NotImplementedException($"ContentType {contentType} not Implemented.");
            }
        }
    }
}