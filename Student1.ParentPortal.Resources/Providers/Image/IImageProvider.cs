// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Net.Http;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Image
{
    public interface IImageProvider
    {
        Task<string> GetStudentImageUrlAsync(string studentUniqueId);
        Task<string> GetStaffImageUrlAsync(string staffUniqueId);
        Task<string> GetParentImageUrlAsync(string parentUniqueId);
        Task<string> GetStudentImageUrlForAlertsAsync(string studentUniqueId);
        Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType);
        Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType);
    }
}
