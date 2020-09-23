// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class ImageRepository : IImageRepository
    { 
        private readonly EdFi31Context _edFiDb;

        public ImageRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<StaffImageModel> GetStaffImageModel(string staffUniqueId)
        {
            var staffData = await _edFiDb.Staffs
                                   .Where(x => x.StaffUniqueId == staffUniqueId)
                                   .Include(x => x.StaffRaces.Select(r => r.RaceDescriptor.Descriptor))
                                   .Include(x => x.SexDescriptor.Descriptor)
                                   .ToListAsync();

            var result = staffData.Select(x => new StaffImageModel
            {
                FirstName = x.FirstName,
                LastSurname = x.LastSurname,
                MiddleName = x.MiddleName,
                MaidenName = x.MaidenName,
                SexTypeId = x.SexDescriptorId,
                SexType = MapSexType(x.SexDescriptor),
                StaffUsi = x.StaffUsi,
                StaffRaces = x.StaffRaces.Select(sr => new StaffRaceModel
                {
                    StaffUsi = x.StaffUsi,
                    RaceTypeId = sr.RaceDescriptorId,
                    RaceType = MapRaceType(sr.RaceDescriptor)
                }).ToList()
            }).First();

            return result;

        }

        public async Task<StaffImageModel> GetParentImageModel(string parentUniqueId)
        {
            var parentData = await _edFiDb.Parents
                                      .Where(x => x.ParentUniqueId == parentUniqueId)
                                      .Include(x => x.SexDescriptor.Descriptor)
                                      .ToListAsync();


            var result = parentData.Select(x => new StaffImageModel
            {
                FirstName = x.FirstName,
                LastSurname = x.LastSurname,
                MiddleName = x.MiddleName,
                MaidenName = x.MaidenName,
                SexTypeId = x.SexDescriptorId,
                StaffUsi = x.ParentUsi,
                SexType = MapSexType(x.SexDescriptor)
            }).First();

            return result;

        }

        public async Task<StaffImageModel> GetStudentImageModel(string studentUniqueId)
        {
            var studentData = await(from s in _edFiDb.Students
                                            .Include(x => x.SexDescriptor.Descriptor)
                                            where s.StudentUniqueId == studentUniqueId
                                    join seor in _edFiDb.StudentEducationOrganizationAssociationRaces
                                            .Include(x => x.RaceDescriptor.Descriptor)
                                            on s.StudentUsi equals seor.StudentUsi
                                    group new {s, seor} by new {s.StudentUsi, s.FirstName, s.LastSurname, s.MiddleName, s.MaidenName, s.BirthSexDescriptorId} into g
                                    select new
                                    {
                                        g.Key.FirstName,
                                        g.Key.LastSurname,
                                        g.Key.MiddleName,
                                        g.Key.MaidenName,
                                        g.Key.BirthSexDescriptorId,
                                        SexDescriptor = g.Select(x => x.s.SexDescriptor).FirstOrDefault(),
                                        g.Key.StudentUsi,
                                        Races = g.Select(x => x.seor.RaceDescriptor)
                                    })
                                    .FirstOrDefaultAsync();

            var result = new StaffImageModel
            {
                FirstName = studentData.FirstName,
                LastSurname = studentData.LastSurname,
                MiddleName = studentData.MiddleName,
                MaidenName = studentData.MaidenName,
                SexTypeId = studentData.BirthSexDescriptorId,
                SexType = MapSexType(studentData.SexDescriptor),
                StaffUsi = studentData.StudentUsi,
                StaffRaces = studentData.Races.Select(r => new StaffRaceModel
                {
                    StaffUsi = studentData.StudentUsi,
                    RaceTypeId = r.RaceDescriptorId,
                    RaceType = MapRaceType(r)
                }).ToList()
            };



            return result;
        }
        private RaceTypeModel MapRaceType(RaceDescriptor raceDescriptor)
        {
            if (raceDescriptor == null)
                return null;
            var raceTypeModel = new RaceTypeModel();
            raceTypeModel.RaceTypeId = raceDescriptor.RaceDescriptorId;
            raceTypeModel.ShortDescription = raceDescriptor.Descriptor.ShortDescription;
            raceTypeModel.Description = raceDescriptor.Descriptor.Description;
            raceTypeModel.CodeValue = raceDescriptor.Descriptor.CodeValue;

            return raceTypeModel;
        }

        private SexTypeModel MapSexType(SexDescriptor sexDescriptor)
        {
            if (sexDescriptor == null)
                return null;

            var sexTypeModel = new SexTypeModel();
            sexTypeModel.SexTypeId = sexDescriptor.SexDescriptorId;
            sexTypeModel.ShortDescription = sexDescriptor.Descriptor.ShortDescription;
            sexTypeModel.Description = sexDescriptor.Descriptor.Description;
            sexTypeModel.CodeValue = sexDescriptor.Descriptor.CodeValue;

            return sexTypeModel;
        }

    }
}
