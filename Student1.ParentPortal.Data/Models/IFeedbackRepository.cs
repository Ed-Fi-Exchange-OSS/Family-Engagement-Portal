using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface IFeedbackRepository
    {
        Task<FeedbackLogModel> SaveFeedback(string uniqueId, int personTypeId, string name, string email, FeedbackRequestModel model);
    }
}
