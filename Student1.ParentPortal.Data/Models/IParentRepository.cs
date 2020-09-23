// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface IParentRepository
    {
        Task<List<StudentBriefModel>> GetStudentsAssociatedWithParent(int parentUsi, string recipientUniqueId, int recipientTypeId);
        Task<UserProfileModel> GetParentProfileAsync(int parentUsi);
        Task<UserProfileModel> GetParentProfileAsync(string parentUniqueId);
        Task<BriefProfileModel> GetBriefParentProfileAsync(int parentUsi);
        Task<UserProfileModel> SaveParentProfileAsync(int parentUsi, UserProfileModel model);
        Task<List<PersonIdentityModel>> GetParentIdentityByEmailAsync(string email, string[] validParentDescriptors);
        bool HasAccessToStudent(int parentUsi, int studentUsi);
        bool HasAccessToStudent(int parentUsi, string studentUniqueId);
        Task<List<PersonIdentityModel>> GetParentIdentityByProfileEmailAsync(string email, string[] validParentDescriptors);
    }
}
