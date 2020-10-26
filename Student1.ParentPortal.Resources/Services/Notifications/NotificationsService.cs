using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Notifications;
using Student1.ParentPortal.Resources.Providers.Notifications;
using Student1.ParentPortal.Resources.Providers.Translation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Notifications
{

    public interface INotificationsService 
    {
        Task PersistNotificationToken(NotificationsIdentifierModel model);
        Task SendNotificationAsync(ChatLogItemModel model);
    }

    public class NotificationsService : INotificationsService
    {
        private readonly INotificationsRepository _notificationsRepository;
        private readonly IPushNotificationProvider _pushNotificationProvider;
        private readonly IStaffRepository _staffRepository;
        private readonly IStudentRepository _studentRepository;
        private readonly ITranslationProvider _translationProvider;


        public NotificationsService(INotificationsRepository notificationsRepository, 
                                    IPushNotificationProvider pushNotificationProvider, 
                                    IStaffRepository staffRepository,
                                    IStudentRepository studentRepository,
                                    ITranslationProvider translationProvider)
        {
            _notificationsRepository = notificationsRepository;
            _pushNotificationProvider = pushNotificationProvider;
            _studentRepository = studentRepository;
            _staffRepository = staffRepository;
            _translationProvider = translationProvider;
        }

        public async Task PersistNotificationToken(NotificationsIdentifierModel model)
        {
           await _notificationsRepository.SaveNotificationIdentifier(model);
        }

        public async Task SendNotificationAsync(ChatLogItemModel model)
        {
            var staff = await _staffRepository.GetStaffIdentityByUniqueId(model.SenderUniqueId);
            if (staff != null)
            {
                string titleTemplate = "New Message from";
                string bodyTemplate = "About";

                if(!string.IsNullOrEmpty(model.TranslatedLanguageCode) && model.TranslatedLanguageCode != "en") {
                    titleTemplate = await _translationProvider.TranslateAsync(new TranslateRequest { 
                        FromLangCode = "en", 
                        ToLangCode = model.TranslatedLanguageCode, 
                        TextToTranslate = titleTemplate });

                    bodyTemplate = await _translationProvider.TranslateAsync(new TranslateRequest
                    {
                        FromLangCode = "en",
                        ToLangCode = model.TranslatedLanguageCode,
                        TextToTranslate = bodyTemplate
                    });
                }

                var student = await _studentRepository.GetStudentBriefModelAsyncByUniqueId(model.StudentUniqueId);
                var messageBody = model.TranslatedMessage != null ? model.TranslatedMessage : model.EnglishMessage;
                var notification = new NotificationItemModel
                {
                    personUniqueId = model.RecipientUniqueId,
                    personType = "Parent",
                    notification = new Notification
                    {
                        title = $"{titleTemplate}: {staff.FirstName} {staff.LastSurname}",
                        body = $"{bodyTemplate}: {student.FirstName} - {messageBody}",
                        icon = "ic_yes_prep"
                    },
                    data = new NotificationData
                    {
                        studentUsi = model.StudentUniqueId,
                        personTypeId = model.RecipientTypeId.ToString(),
                        uniqueId = model.RecipientUniqueId,
                        unreadMessageCount = 1
                    }
                };
                await _pushNotificationProvider.SendNotificationAsync(notification);
            }
        }
    }
}
