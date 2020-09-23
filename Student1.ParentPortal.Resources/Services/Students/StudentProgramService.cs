// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentProgramService
    {
        Task<List<StudentProgram>> GetStudentProgramsAsync(int studentUsi);
    }

    public class StudentProgramService : IStudentProgramService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentProgramService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<List<StudentProgram>> GetStudentProgramsAsync(int studentUsi)
        {

            return await _studentRepository.GetStudentProgramsAsync(studentUsi);
        }
    }
}
