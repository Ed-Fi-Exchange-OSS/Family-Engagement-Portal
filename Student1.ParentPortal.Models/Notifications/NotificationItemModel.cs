using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Notifications
{
    public class NotificationsIdentifierModel
    {
        public string Token { get; set; }
        public string PersonUniqueId { get; set; }
        public string PersonType { get; set; }
        public string DeviceUUID { get; set; }
    }
    public class NotificationItemModel
    {
        public string[] registration_ids { get; set; }
        public Notification notification { get; set; }
        public NotificationData data { get; set; }
        public string personUniqueId { get; set; }
        public string personType {get; set;}
    }

    public class Notification 
    {
        public string title { get; set; }
        public string body { get; set; }
        public string icon { get; set; }
    }

    public class NotificationData 
    {
        public string studentUsi { get; set; }
        public string uniqueId { get; set; }
        public string personTypeId { get; set; }
        public int unreadMessageCount { get; set; }
    }
}
