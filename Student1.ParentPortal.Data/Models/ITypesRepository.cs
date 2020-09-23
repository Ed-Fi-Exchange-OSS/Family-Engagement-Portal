// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.


using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.User;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface ITypesRepository
    {
        Task<List<AddressTypeModel>> GetAddressTypes();
        Task<List<ElectronicMailTypeModel>> GetElectronicMailTypes();
        Task<List<StateAbbreviationTypeModel>> GetStateAbbreviationTypes();
        Task<List<TelephoneNumberTypeModel>> GetTelephoneNumberTypes();
        Task<List<TextMessageCarrierTypeModel>> GetTextMessageCarrierTypes();
        Task<List<MethodOfContactTypeModel>> GetMethodOfContactTypes();
        Task<List<AlertTypeModel>> GetAlertTypes();
    }
}
