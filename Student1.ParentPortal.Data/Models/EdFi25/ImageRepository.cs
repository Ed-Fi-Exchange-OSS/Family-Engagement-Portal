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

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class ImageRepository : IImageRepository
    {

        private readonly EdFi25Context _edFiDb;

        public ImageRepository(EdFi25Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<StaffImageModel> GetStaffImageModel(string staffUniqueId)
        {
            var staffData = await _edFiDb.Staffs
                                   .Where(x => x.StaffUniqueId == staffUniqueId)
                                   .Include(x => x.StaffRaces.Select(r => r.RaceType))
                                   .Include(x => x.SexType)
                                   .ToListAsync();

            var result = staffData.Select(x => new StaffImageModel
            {
                FirstName = x.FirstName,
                LastSurname = x.LastSurname,
                MiddleName = x.MiddleName,
                MaidenName = x.MaidenName,
                SexTypeId = x.SexTypeId,
                SexType = MapSexType(x.SexType),
                StaffUsi = x.StaffUsi,
                StaffRaces = x.StaffRaces.Select(sr => new StaffRaceModel
                {
                    StaffUsi = x.StaffUsi,
                    RaceTypeId = sr.RaceTypeId,
                    RaceType = MapRaceType(sr.RaceType)
                }).ToList()
            }).First();

            return result;
            
        }

        public async Task<StaffImageModel> GetParentImageModel(string parentUniqueId)
        {
            var parentData = await _edFiDb.Parents
                                      .Where(x => x.ParentUniqueId == parentUniqueId)
                                      .Include(x => x.SexType)
                                      .ToListAsync();

            var result = parentData.Select(x => new StaffImageModel
            {
                FirstName = x.FirstName,
                LastSurname = x.LastSurname,
                MiddleName = x.MiddleName,
                MaidenName = x.MaidenName,
                SexTypeId = x.SexTypeId,
                StaffUsi = x.ParentUsi,
                SexType = MapSexType(x.SexType)
            }).First();

            return result;

        }

        public async Task<StaffImageModel> GetStudentImageModel(string studentUniqueId)
        {
            var studentData = await _edFiDb.Students
                             .Where(x => x.StudentUniqueId == studentUniqueId)
                             .Include(x => x.StudentRaces.Select(r => r.RaceType))
                             .Include(x => x.SexType)
                             .ToListAsync();

            var result = studentData.Select(x => new StaffImageModel
            {
                FirstName = x.FirstName,
                LastSurname = x.LastSurname,
                MiddleName = x.MiddleName,
                MaidenName = x.MaidenName,
                SexTypeId = x.SexTypeId,
                SexType = MapSexType(x.SexType),
                StaffUsi = x.StudentUsi,
                StaffRaces = x.StudentRaces.Select(sr => new StaffRaceModel
                {
                    StaffUsi = x.StudentUsi,
                    RaceTypeId = sr.RaceTypeId,
                    RaceType = MapRaceType(sr.RaceType)
                }).ToList()
            }).First();

            return result;
        }

        private RaceTypeModel MapRaceType(RaceType raceType)
        {
            if (raceType == null)
                return null;

            var raceTypeModel = new RaceTypeModel();
            raceTypeModel.RaceTypeId = raceType.RaceTypeId;
            raceTypeModel.ShortDescription = raceType.ShortDescription;
            raceTypeModel.Description = raceType.Description;
            raceTypeModel.CodeValue = raceType.CodeValue;

            return raceTypeModel;
        }

        private SexTypeModel MapSexType(SexType sexType)
        {
            if (sexType == null)
                return null;

            var sexTypeModel = new SexTypeModel();
            sexTypeModel.SexTypeId = sexType.SexTypeId;
            sexTypeModel.ShortDescription = sexType.ShortDescription;
            sexTypeModel.Description = sexType.Description;
            sexTypeModel.CodeValue = sexType.CodeValue;

            return sexTypeModel;
        }
    }
}
