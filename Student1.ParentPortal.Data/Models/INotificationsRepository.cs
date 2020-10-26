using Student1.ParentPortal.Models.Notifications;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface INotificationsRepository
    {
        Task SaveNotificationIdentifier(NotificationsIdentifierModel model);

        Task<List<NotificationsIdentifierModel>> GetNotificationModel(string personUniqueId, string personType);
    }
}
