// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;

namespace Student1.ParentPortal.Models.Staff
{
    public class StaffSectionModel
    {
        public int SchoolId { get; set; }
        public string ClassPeriodName { get; set; } 
        public string ClassroomIdentificationCode { get; set; } 
        public string LocalCourseCode { get; set; }
        public int TermDescriptorId { get; set; }
        public short SchoolYear { get; set; }
        public string UniqueSectionCode { get; set; }
        public int SequenceOfCourse { get; set; }
        public DateTime? BeginDate { get; set; }
        public string SessionName { get; set; }
        public string CourseTitle { get; set; }
    }
}
