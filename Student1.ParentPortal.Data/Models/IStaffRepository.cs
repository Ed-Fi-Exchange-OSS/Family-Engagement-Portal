// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface IStaffRepository
    {
        Task<List<PersonIdentityModel>> GetStaffIdentityByEmailAsync(string email);
        Task<List<PersonIdentityModel>> GetStaffIdentityByProfileEmailAsync(string email);
        bool HasAccessToStudent(int staffUsi, int studentUsi);
    }
}
