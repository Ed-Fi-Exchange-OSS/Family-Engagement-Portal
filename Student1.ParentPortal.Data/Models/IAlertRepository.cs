
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.Shared;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Alert;

namespace Student1.ParentPortal.Data.Models
{
    public interface IAlertRepository
    {
        Task<SchoolYearTypeModel> getCurrentSchoolYear();
        Task<List<StudentAlertModel>> studentsOverThresholdAbsence(decimal excusedThreshold, decimal unexcusedThreshold, decimal tardyThreshold, string excusedDescriptor, string unexcusedDescriptor, string tardyDescriptor);
        Task<List<StudentAlertModel>> studentsOverThresholdAdaAbsence(decimal unexcusedThreshold, string absentDescriptor);
        Task<List<StudentAlertModel>> studentsOverThresholdBehavior(decimal behaviorThreshold, string disciplineIncidentDescriptor);
        Task<List<StudentAlertModel>> studentsOverThresholdAssignment(decimal assignmentThreshold, string[] gradeBookMissingAssignmentTypeDescriptors);
        Task<List<StudentAlertModel>> studentsOverThresholdCourse(decimal courseThreshold, string gradeTypeGradingPeriodDescriptor);
        Task<bool> wasSentBefore(string parentUniqueId, string studentUniqueId, string valueCount, SchoolYearTypeModel currentSchoolYear, int alertType);
        Task AddAlertLog(SchoolYearTypeModel currentSchoolYear, int alertTypeId, string parentUniqueId, string studentUniqueId, string absencesCount);
        Task SaveChanges();
        Task<ParentAlertTypeModel> GetParentAlertTypes(int usi);
        Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi);
        Task<List<UnreadMessageAlertModel>> ParentsAndStaffWithUnreadMessages();
        Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId);
        Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId);
    }
}
