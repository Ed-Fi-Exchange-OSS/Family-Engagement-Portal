// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface IMethodOfContactTypesService
    {
        Task<List<MethodOfContactTypeModel>> GetMethodOfContactTypes();
    }

    public class MethodOfContactTypesService : IMethodOfContactTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public MethodOfContactTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<MethodOfContactTypeModel>> GetMethodOfContactTypes()
        {
            return await _typesRepository.GetMethodOfContactTypes();
        }
    }
}
