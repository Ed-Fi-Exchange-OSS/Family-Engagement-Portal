using Newtonsoft.Json;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi31;
using Student1.ParentPortal.Models.Notifications;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Notifications
{
    public class PushNotificationProvider : IPushNotificationProvider
    {
        private readonly INotificationsRepository _notificationsRepository;
        public PushNotificationProvider(INotificationsRepository notificationsRepository)
        {
            _notificationsRepository = notificationsRepository;
        }
        public async Task SendNotificationAsync(NotificationItemModel model)
        {
            
            var notificationsModels = await _notificationsRepository.GetNotificationModel(model.personUniqueId, model.personType);
            var tokenModel = notificationsModels.Select(n => n.Token).ToArray();
            if(tokenModel.Any()) 
            {
                model.registration_ids = tokenModel;
                await InvokePushNotification(model);
            }
                
        }

        private async Task<bool> InvokePushNotification(NotificationItemModel model)
        {
            // Get the server key from FCM console
            var serverKey = $"Key={ConfigurationManager.AppSettings["notifications.Key"]}";
            var jsonData = JsonConvert.SerializeObject(model);
            var httpRequest = new HttpRequestMessage(HttpMethod.Post, ConfigurationManager.AppSettings["notifications.ApiUrl"]);
            httpRequest.Headers.TryAddWithoutValidation("Authorization", serverKey);
            httpRequest.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            var httpClient = new HttpClient();
            var result = await httpClient.SendAsync(httpRequest);
            if (result.IsSuccessStatusCode) 
            {
                return true;
            } else 
            {
                return false;
            }
        }
    }
}
