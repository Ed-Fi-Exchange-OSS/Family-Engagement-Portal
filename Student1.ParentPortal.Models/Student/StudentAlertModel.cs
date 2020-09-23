// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Student
{
    public class StudentAlertModel
    {
        public ICollection<StudentParentAssociationModel> StudentParentAssociations { get; set; }
        public int StudentUSI { get; set; }
        public string StudentUniqueId { get; set; }
        public int ValueCount { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public ICollection<ParentAlertCourseModel> Courses { get; set; }
        public int ExcusedCount { get; set; }
        public int UnexcusedCount { get; set; }
        public int TardyCount { get; set; }
        public int AbsenceCount => ExcusedCount + UnexcusedCount + TardyCount;
    }

    public class StudentParentAssociationModel
    {
        public int ParentUsi { get; set; }
        public virtual ParentModel Parent { get; set; }
    }

    public class ParentModel
    {
        public ParentModel()
        {
            ParentAlert = new ParentAlertModel();
        }
        public virtual ParentAlertModel ParentAlert { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public string SMSDomain { get; set; }
        public string ParentUniqueId { get; set; }
    }

    public class ParentAlertModel
    {
        public int? PreferredMethodOfContactTypeId { get; set; }
        public ICollection<int> AlertTypeIds { get; set; }
    }

    public class ParentAlertCourseModel {
        public string CourseTitle { get; set; }
        public decimal? GradeNumber { get; set; }
    }

}
