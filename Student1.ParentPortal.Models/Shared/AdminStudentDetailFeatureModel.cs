using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class AdminStudentDetailFeatureModel
    {
        public int AdminStudentDetailFeaturesId { get; set; } // AdminStudentDetailFeaturesId (Primary key)
        public bool Profile { get; set; } // Profile
        public bool AttendanceIndicator { get; set; } // AttendanceIndicator
        public bool CourseAverageIndicator { get; set; } // CourseAverageIndicator
        public bool BehaviorIndicator { get; set; } // BehaviorIndicator
        public bool MissingAssignmentsIndicator { get; set; } // MissingAssignmentsIndicator
        public bool AllAboutMe { get; set; } // AllAboutMe
        public bool Goals { get; set; } // Goals
        public bool AttendanceLog { get; set; } // AttendanceLog
        public bool BehaviorLog { get; set; } // BehaviorLog
        public bool CourseGrades { get; set; } // CourseGrades
        public bool MissingAssignments { get; set; } // MissingAssignments
        public bool Calendar { get; set; } // Calendar
        public bool SuccessTeam { get; set; } // SuccessTeam
        public bool CollegeInitiativeCorner { get; set; } // CollegeInitiativeCorner
        public bool Arc { get; set; } // ARC
        public bool StaarAssessment { get; set; } // STAARAssessment
        public bool Assessment { get; set; } // Assessment
        public System.DateTime DateCreated { get; set; } // DateCreated
        public System.DateTime DateUpdated { get; set; } // DateUpdated

        public AdminStudentDetailFeatureModel()
        {
            this.Profile = true;
            this.StaarAssessment = true;
            this.AllAboutMe = true;
            this.Arc = true;
            this.Assessment = true;
            this.AttendanceIndicator = true;
            this.AttendanceLog = true;
            this.BehaviorIndicator = true;
            this.BehaviorLog = true;
            this.Calendar = true;
            this.CollegeInitiativeCorner = true;
            this.CourseAverageIndicator = true;
            this.CourseGrades = true;
            this.Goals = true;
            this.MissingAssignments = true;
            this.MissingAssignmentsIndicator = true;
            this.SuccessTeam = true;
        }
    }
}
