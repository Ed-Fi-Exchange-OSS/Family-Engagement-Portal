using Student1.ParentPortal.Models.Notifications;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Notifications
{
    public interface IPushNotificationProvider
    {
        Task SendNotificationAsync(NotificationItemModel model);
    }
}
