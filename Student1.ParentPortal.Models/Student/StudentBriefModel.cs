// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Shared;
using System.Collections.Generic;

namespace Student1.ParentPortal.Models.Student
{
    public class StudentBriefModel
    {
        public StudentBriefModel()
        {
            CourseAverage = new StudentCurrentGradeAverage();
            ExternalLinks = new List<StudentExternalLink>();
        }
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string SexType { get; set; }
        public string ImageUrl { get; set; }
        public string GradeLevel { get; set; }
        public string CurrentSchool { get; set; }

        public int YTDAbsences { get; set; }
        public int AbsenceThresholdDays { get; set; }
        public int ExcusedAbsences { get; set; }
        public string ExcusedInterpretation { get; set; }
        public int UnexcusedAbsences { get; set; }
        public string UnexcusedInterpretation { get; set; }
        public int TardyAbsences { get; set; }
        public string TardyInterpretation { get; set; }

        public int AdaAbsences { get; set; }
        public string AdaAbsentInterpretation { get; set; }

        public int YTDDisciplineIncidentCount { get; set; }
        public string YTDDisciplineInterpretation { get; set; }

        public decimal? YTDGPA { get; set; }
        public string GPAInterpretation { get; set; }

        
        public int MissingAssignments { get; set; }
        public string MissingAssignmentsInterpretation { get; set; }
        public decimal? CourseAvg { get; set; }
        public StudentCurrentGradeAverage CourseAverage { get; set; }
        public IEnumerable<StudentExternalLink> ExternalLinks { get; set; }
        public IEnumerable<ParentStudentAlertLogModel> Alerts { get; set; } 
        public int UnreadMessageCount { get; set; }
    }
}
