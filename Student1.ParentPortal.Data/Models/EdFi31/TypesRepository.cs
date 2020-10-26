using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class TypesRepository : ITypesRepository
    { 
        private readonly EdFi31Context _edFiDb;

        public TypesRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<AddressTypeModel>> GetAddressTypes()
        {
            var model = await (from t in _edFiDb.AddressTypeDescriptors
                               .Include(x => x.Descriptor)
                               select new AddressTypeModel
                               {
                                   AddressTypeId = t.AddressTypeDescriptorId,
                                   ShortDescription = t.Descriptor.ShortDescription
                               }).ToListAsync();

            return model;
        }

        public async Task<List<ElectronicMailTypeModel>> GetElectronicMailTypes()
        {
            var model = await (from t in _edFiDb.ElectronicMailTypeDescriptors
                                .Include(x => x.Descriptor)
                               select new ElectronicMailTypeModel
                               {
                                   ElectronicMailTypeId = t.ElectronicMailTypeDescriptorId,
                                   ShortDescription = t.Descriptor.ShortDescription
                               }).ToListAsync();

            return model;
        }

        public async Task<List<StateAbbreviationTypeModel>> GetStateAbbreviationTypes()
        {
            var model = await (from t in _edFiDb.StateAbbreviationDescriptors
                               .Include(x => x.Descriptor)
                               select new StateAbbreviationTypeModel
                               {
                                   StateAbbreviationTypeId = t.StateAbbreviationDescriptorId,
                                   ShortDescription = t.Descriptor.ShortDescription
                               }).ToListAsync();

            return model;
        }

        public async Task<List<TelephoneNumberTypeModel>> GetTelephoneNumberTypes()
        {
            var model = await (from t in _edFiDb.TelephoneNumberTypeDescriptors
                               .Include(x => x.Descriptor)
                               select new TelephoneNumberTypeModel
                               {
                                   TelephoneNumberTypeId = t.TelephoneNumberTypeDescriptorId,
                                   ShortDescription = t.Descriptor.Description
                               }).ToListAsync();

            return model;
        }

        public async Task<List<TextMessageCarrierTypeModel>> GetTextMessageCarrierTypes()
        {
            var model = await (from t in _edFiDb.TextMessageCarrierTypes
                               select new TextMessageCarrierTypeModel
                               {
                                   TextMessageCarrierTypeId = t.TextMessageCarrierTypeId,
                                   ShortDescription = t.ShortDescription
                               }).ToListAsync();

            return model;
        }

        public async Task<List<MethodOfContactTypeModel>> GetMethodOfContactTypes()
        {
            var model = await (from t in _edFiDb.MethodOfContactTypes
                               select new MethodOfContactTypeModel
                               {
                                   MethodOfContactTypeId = t.MethodOfContactTypeId,
                                   ShortDescription = t.ShortDescription,
                                   Description = t.Description
                               }).ToListAsync();

            return model;
        }

        public async Task<List<AlertTypeModel>> GetAlertTypes()
        {
            var model = await (from at in _edFiDb.AlertTypes
                               .Include(x => x.ThresholdTypes)
                               select new AlertTypeModel
                               {
                                   AlertTypeId = at.AlertTypeId,
                                   Description = at.Description,
                                   ShortDescription = at.ShortDescription,
                                   Enabled = true,
                                   Thresholds = at.ThresholdTypes.Select(tt => new ThresholdTypeModel()
                                   {
                                       ThresholdTypeId = tt.ThresholdTypeId,
                                       Description = tt.Description,
                                       ShortDescription = tt.ShortDescription,
                                       ThresholdValue = tt.ThresholdValue,
                                       WhatCanParentDo = tt.WhatCanParentDo,
                                   }).ToList()
                               }).ToListAsync();

            return model;
        }
    }
}
