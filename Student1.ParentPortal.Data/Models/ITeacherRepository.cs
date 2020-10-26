
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface ITeacherRepository
    {
        Task<List<StaffSectionModel>> GetStaffSectionsAsync(int staffUsi, DateTime today);
        Task<List<StudentBriefModel>> GetTeacherStudents(int staffUsi, TeacherStudentsRequestModel model, string recipientUniqueId, int recipientTypeId);
        Task<UserProfileModel> GetStaffProfileAsync(int staffUsi);
        Task<UserProfileModel> GetStaffProfileAsync(string staffUniqueId);
        Task<BriefProfileModel> GetBriefStaffProfileAsync(int staffUsi);
        Task<UserProfileModel> SaveStaffProfileAsync(int staffUsi, UserProfileModel model);
        Task<UserProfileModel> AddNewProfileAsync(string staffUniqueId, UserProfileModel model);
        bool HasAccessToStudent(int staffUsi, int studentUsi);
        bool HasAccessToStudent(int staffUsi, string studentUniqueId);

        Task SaveStaffLanguage(string staffUniqueId, string languageCode);
    }
}
