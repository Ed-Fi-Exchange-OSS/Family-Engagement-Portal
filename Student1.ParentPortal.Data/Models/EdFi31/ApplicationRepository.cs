// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Data.Entity;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class ApplicationRepository : IApplicationRepository
    {
        private readonly EdFi31Context _edFiDb;

        public ApplicationRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<bool> IsApplicationOffline()
        {
            var data = await _edFiDb.AppOfflines.SingleOrDefaultAsync();
            return data != null && data.IsAppOffline;
        }
    }
}
