using Student1.ParentPortal.Models.Alert;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Alerts
{
    public interface IAlertService
    {
        Task SendAlerts();
        Task<ParentAlertTypeModel> GetParentAlertTypes(int usi);
        Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi);
        Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId);
        Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId);
    }
}