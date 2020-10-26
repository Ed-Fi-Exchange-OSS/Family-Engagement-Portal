using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Notifications;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Notifications;

namespace Student1.ParentPortal.Resources.Providers.Message
{
    public class PushNotificationMessageProvider : IMessageProvider
    {
        private readonly IPushNotificationProvider _pushNotificationProvider;
        public PushNotificationMessageProvider(IPushNotificationProvider pushNotificationProvider) 
        {
            _pushNotificationProvider = pushNotificationProvider;
        }
        public int DeliveryMethod => MethodOfContactTypeEnum.Notification.Value;

        public async Task SendMessage(MessageAbstractionModel model)
        {
            //We remove the html properties
            model.BodyMessage = StripHTML(model.BodyMessage);

            await _pushNotificationProvider.SendNotificationAsync(new NotificationItemModel
            {
                personUniqueId = model.RecipientUniqueId,
                personType = "Parent",
                notification = new Notification
                {
                    title = model.Subject,
                    body = model.BodyMessage
                }
            });
        }

        private string StripHTML(string input) 
        {
            return Regex.Replace(input, "<.*?>", String.Empty);
        }
    }
}
