using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Resources.Cache;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Alerts
{
    public interface IAlertService
    {
        [NoCache]
        Task SendAlerts();
        [NoCache]
        Task<ParentAlertTypeModel> GetParentAlertTypes(int usi);
        [NoCache]
        Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi);
        [NoCache]
        Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId);
        Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId);
    }
}