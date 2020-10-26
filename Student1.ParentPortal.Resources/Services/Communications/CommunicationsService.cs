using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Notifications;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;
using Student1.ParentPortal.Resources.Cache;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Messaging;
using Student1.ParentPortal.Resources.Providers.Notifications;
using Student1.ParentPortal.Resources.Providers.Translation;
using Student1.ParentPortal.Resources.Providers.Date;
using Newtonsoft.Json;
using Student1.ParentPortal.Resources.Providers.Message;
using System.Text.RegularExpressions;

namespace Student1.ParentPortal.Resources.Services.Communications
{
    public interface ICommunicationsService
    {
        [NoCache]
        Task<ChatModel> GetConversationAsync(int studentUSI, string senderUniqueId, int senderTypeId, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount);
        [NoCache]
        Task<ChatLogItemModel> PersistMessage(ChatLogItemModel model);
        Task SetRecipientRead(ChatLogItemModel model);
        [NoCache]
        Task<int> UnreadMessageCount(int studentUsi, string recipientUniqueId, int recipientTypeId, string senderUniqueId, int? senderTypeId);
        [NoCache]
        Task<RecipientUnreadMessagesModel> RecipientUnreadMessages(string recipientUiqueId, int recipientTypeId);
        [NoCache]
        Task<RecipientMessagesModel> PrincipalRecipientMessages(string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrive, string searchTerm, bool onlyUnreadMessages);
        [NoCache]
        Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
        [NoCache]
        Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
        [NoCache]
        Task SendSectionGroupMessage(GroupMessageSectionModel sectionModel, int personUsi, string personUniqueId);
        [NoCache]
        Task SendPrincipalGroupMessage(GroupMessagePrincipalModel groupPrincipalModel, int personalUsi, string personUniqueId);
        [NoCache]
        Task SendPrincipalIndividualGroupMessage(IndividualMessagePrincipalModel model, int personalUsi, string personUniqueId);
        [NoCache]
        Task<ParentStudentCountModel> GetFamilyMemberCountByCampusGradeLevelAndProgram(int staffUsi, ParentStudentCountFilterModel model);
        [NoCache]
        Task<List<ParentStudentsModel>> GetParentStudentByTermAndGradeLevel(string personUniqueId, string term, GradesLevelModel model);
        [NoCache]
        Task<int> GetParentStudentByTermAndGradeLevelCount(string personUniqueId, string term, GradesLevelModel model);
        [NoCache]
        Task SendGroupMessages();
        [NoCache]
        Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueues(string personUniqueId, int schoolId, QueuesFilterModel model);
        [NoCache]
        Task<ParentStudentCountModel> GetFamilyMemberCountBySection(int staffUsi, TeacherStudentsRequestModel sectionModel);
    }

    public class CommunicationsService : ICommunicationsService
    {
        private readonly ICommunicationsRepository _communicationsRepository;
        private readonly IImageProvider _imageProvider;
        // We had to inject the student, parent and teacher repositories instead of the services because of cyclical dependencies.
        private readonly IStudentRepository _studentRepository;
        private readonly IParentRepository _parentRepository;
        private readonly ITeacherRepository _teacherRepository;
        private readonly IPushNotificationProvider _pushNotificationProvider;
        private readonly IMessagingProvider _messagingProvider;
        private readonly ISMSProvider _smsProvider;
        private readonly ITranslationProvider _translationProvider;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly IDateProvider _dateProvider;
        private readonly ICollection<IMessageProvider> _messageProviders;
        private readonly IStaffRepository _staffRepository;

        public CommunicationsService(ICommunicationsRepository communicationsRepository,
                                     IStudentRepository studentRepository,
                                     IParentRepository parentRepository,
                                     ITeacherRepository teacherRepository,
                                     IImageProvider imageProvider,
                                     IPushNotificationProvider pushNotificationProvider,
                                     IMessagingProvider messagingProvider,
                                     ISMSProvider smsProvider,
                                     ITranslationProvider translationProvider,
                                     ICustomParametersProvider customParametersProvider,
                                     IDateProvider dateProvider,
                                     ICollection<IMessageProvider> messageProviders,
                                     IStaffRepository staffRepository)
        {
            _communicationsRepository = communicationsRepository;
            _studentRepository = studentRepository;
            _parentRepository = parentRepository;
            _teacherRepository = teacherRepository;
            _imageProvider = imageProvider;
            _pushNotificationProvider = pushNotificationProvider;
            _messagingProvider = messagingProvider;
            _smsProvider = smsProvider;
            _translationProvider = translationProvider;
            _customParametersProvider = customParametersProvider;
            _dateProvider = dateProvider;
            _messageProviders = messageProviders;
            _staffRepository = staffRepository;
        }

        public async Task<int> UnreadMessageCount(int studentUsi, string recipientUniqueId,int recipientTypeId, string senderUniqueId, int? senderTypeId)
        {
            return await _communicationsRepository.UnreadMessageCount(studentUsi, recipientUniqueId,recipientTypeId, senderUniqueId, senderTypeId);
        }

        public async Task<RecipientUnreadMessagesModel> RecipientUnreadMessages(string recipientUniqueId, int recipientTypeId)
        {
            var unreadmessages = await _communicationsRepository.RecipientUnreadMessages(recipientUniqueId, recipientTypeId);


            foreach(var um in unreadmessages)
            {
                um.ImageUrl = await _imageProvider.GetStudentImageUrlAsync(um.StudentUniqueId);
            }


            var model = new RecipientUnreadMessagesModel {
                UnreadMessages = unreadmessages,
                UnreadMessagesCount = unreadmessages.Sum(x => x.UnreadMessageCount)
            };

            return model;
        }

        public async Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {
            var validLeadersDescriptors = _customParametersProvider.GetParameters().descriptors.validCampusLeaderDescriptors;
            var model = await _communicationsRepository.GetAllParentRecipients(studentUsi, recipientUniqueId, recipientTypeId, rowsToSkip, rowsToRetrieve, validLeadersDescriptors, _dateProvider.Today());
            return model;
        }

        public async Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {
            
            var model = await _communicationsRepository.GetAllStaffRecipients(studentUsi, recipientUniqueId, recipientTypeId, rowsToSkip, rowsToRetrieve, _dateProvider.Today());
            return model;
        }

        public async Task<ChatModel> GetConversationAsync(int studentUSI, string senderUniqueId, int senderTypeId, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount)
        {
            var model = new ChatModel
            {
                Student = await GetPersonBriefModelByUsiAndPersonTypeAsync(studentUSI),
                Sender = await GetPersonBriefModelByUsiAndPersonTypeAsync(senderUniqueId, senderTypeId),
                Recipient = await GetPersonBriefModelByUsiAndPersonTypeAsync(recipientUniqueId, recipientTypeId),
            };

            model.Conversation = await _communicationsRepository.GetThreadByParticipantsAsync(model.Student.UniqueId, senderUniqueId, senderTypeId, recipientUniqueId, recipientTypeId,rowsToSkip, unreadMessageCount);
            await _communicationsRepository.SetRecipientsRead(model.Student.UniqueId, senderUniqueId, senderTypeId, recipientUniqueId, recipientTypeId);
            return model;
        }

        public async Task SetRecipientRead(ChatLogItemModel model)
        {
            await _communicationsRepository.SetRecipientRead(model);
        }

        public async Task<ChatLogItemModel> PersistMessage(ChatLogItemModel model)
        {
            return await _communicationsRepository.PersistMessage(model);
        }

        public async Task SendSectionGroupMessage(GroupMessageSectionModel sectionModel, int personUsi, string personUniqueId)
        {
            var validEmailTypeDescriptors = _customParametersProvider.GetParameters().descriptors.validEmailTypeDescriptors;

            // Get a list of all parents associated with the students in the section.
            var parents = await _studentRepository.GetParentsBySection(personUsi, sectionModel.Section, validEmailTypeDescriptors, _dateProvider.Today());

            // Optimization: Hashtable cache to store the translations and not call the translation API n times.
            var languageHashSubject = new Hashtable();
            var languageHashMessage = new Hashtable();

            //Translate the message to the preferred language for parent
            foreach (var parent in parents)
            {
                string englishMessage = sectionModel.Subject;
                string englishSubject = sectionModel.Message;
                //Check the language code of the parent if is null asign english like default
                if (string.IsNullOrEmpty(parent.LanguageCode))
                    parent.LanguageCode = "en";

                // Check to see if we have translated already.
                if (!languageHashSubject.ContainsKey(parent.LanguageCode))
                {
                    var subjectTrans = await TranslateText(sectionModel.Subject, parent.LanguageCode);
                    languageHashSubject.Add(parent.LanguageCode, subjectTrans);
                }

                sectionModel.Subject = languageHashSubject[parent.LanguageCode].ToString();

                if (!languageHashMessage.ContainsKey(parent.LanguageCode))
                {
                    var messageTrans = await TranslateText(sectionModel.Message, parent.LanguageCode);
                    languageHashMessage.Add(parent.LanguageCode, messageTrans);
                }

                sectionModel.Message = languageHashMessage[parent.LanguageCode].ToString();

                await SendGroupMessageHandler(new StudentParentAssociationModel
                {
                    ParentUsi = parent.ParentUsi,
                    Parent = new ParentModel
                    {
                        Email = !string.IsNullOrEmpty(parent.ProfileEmail) ? parent.ProfileEmail : parent.EdFiEmail,
                        ParentUniqueId = parent.ParentUniqueId,
                        Telephone = parent.ProfileTelephone,
                        SMSDomain = parent.ProfileTelephoneSMSSuffixDomain,
                        ParentAlert = new ParentAlertModel { PreferredMethodOfContactTypeId = parent.PreferredMethodOfContactTypeId },
                        LanguageCode = parent.LanguageCode
                    }
                }, personUniqueId, sectionModel.Message, sectionModel.Subject, englishSubject, englishMessage,  parent.StudentName,  parent.StudentUniqueId, $"{parent.StaffFirstName} {parent.StaffLastSurname}", parent.LanguageCode);

            }
        }

        public async Task SendPrincipalGroupMessage(GroupMessagePrincipalModel groupPrincipalModel, int personalUsi, string personUniqueId)
        {
            var model = new GroupMessagesQueueLogModel();
            model.Type = GroupMessagesQueueTypeEnum.Group.DisplayName;
            model.QueuedDateTime = DateTime.Now;
            model.StaffUniqueId = personUniqueId;
            model.SchoolId = groupPrincipalModel.SchoolId;
            model.Audience = groupPrincipalModel.Audience;

            //This new object is only whit the propurse to get the filter parameters
            var objectToSerialize = new { gradeLevels = groupPrincipalModel.GradeLevels, programs = groupPrincipalModel.Programs };
            model.FilterParams = JsonConvert.SerializeObject(objectToSerialize);
            model.Subject = groupPrincipalModel.Subject;
            model.BodyMessage = groupPrincipalModel.Message;
            model.SentStatus = GroupMessagesStatusEnum.Queued.Value;
            model.Data = JsonConvert.SerializeObject(model);

            var result = await _communicationsRepository.PersistQueueGroupMessage(model);
            model.Id = result.Id;
            model.Data = JsonConvert.SerializeObject(model);

            await _communicationsRepository.UpdateGroupMessagesQueue(model);
        }

        public async Task SendPrincipalIndividualGroupMessage(IndividualMessagePrincipalModel individualPrincipalModel, int personalUsi, string personUniqueId)
        {
            var model = new GroupMessagesQueueLogModel();
            model.Type = GroupMessagesQueueTypeEnum.IndividualGroup.DisplayName;
            model.QueuedDateTime = DateTime.Now;
            model.StaffUniqueId = personUniqueId;
            model.SchoolId = individualPrincipalModel.SchoolId;
            model.Audience = individualPrincipalModel.Audience;

            //This new object is only whit the propurse to get the filter parameters
            var objectToSerialize = new { gradeLevels = individualPrincipalModel.GradeLevels, parentsUsis = individualPrincipalModel.ParentsUsis };

            model.FilterParams = JsonConvert.SerializeObject(objectToSerialize);
            model.Subject = individualPrincipalModel.Subject;
            model.BodyMessage = individualPrincipalModel.Message;
            model.SentStatus = GroupMessagesStatusEnum.Queued.Value;
            model.Data = JsonConvert.SerializeObject(model);

            var result = await _communicationsRepository.PersistQueueGroupMessage(model);
            model.Id = result.Id;
            model.Data = JsonConvert.SerializeObject(model);

            await _communicationsRepository.UpdateGroupMessagesQueue(model);
        }

        public async Task<RecipientMessagesModel> PrincipalRecipientMessages(string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrive, string searchTerm, bool onlyUnreadMessages)
        {
            var messages = await _communicationsRepository.PrincipalRecipientMessages(recipientUniqueId, recipientTypeId, rowsToSkip, rowsToRetrive, searchTerm, onlyUnreadMessages);
            var recipientCount = await _communicationsRepository.PrincipalRecipientMessagesCount(recipientUniqueId, recipientTypeId, searchTerm, onlyUnreadMessages);
            return new RecipientMessagesModel { Messages = messages, UnreadMessagesCount = messages.Sum(x => x.UnreadMessageCount), RecipientCount = recipientCount };
        }

        public async Task<ParentStudentCountModel> GetFamilyMemberCountByCampusGradeLevelAndProgram(int staffUsi, ParentStudentCountFilterModel model)
        {
            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;
            var students = await _communicationsRepository.GetFamilyMembersByGradesAndPrograms(staffUsi, model, validParentDescriptors, _dateProvider.Today());
            return students;
        }

        public async Task<ParentStudentCountModel> GetFamilyMemberCountBySection(int staffUsi, TeacherStudentsRequestModel sectionModel) 
        {
            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;
            return await _studentRepository.GetFamilyMembersBySection(staffUsi, sectionModel.Section, validParentDescriptors, _dateProvider.Today());
        }

        public async Task SendGroupMessages()
        {
            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;
            var validEmailTypeDescriptors = _customParametersProvider.GetParameters().descriptors.validEmailTypeDescriptors;

            var queues = await _communicationsRepository.GetGroupMessagesQueuesQueued();
            

            foreach (var queue in queues)
            {
                var staffInfo = await _staffRepository.GetStaffIdentityByUniqueId(queue.StaffUniqueId);
                //Verify if the queue is retry again
                if (queue.SentStatus == GroupMessagesStatusEnum.Error.Value)
                    queue.RetryCount = queue.RetryCount + 1;

                //This call to database is to broken the previews scheme in entity framework,
                //In case of a news petitions to the enpoint this validate the actual status of the queue.
                var queueVerification = await _communicationsRepository.GetGroupMessagesQueue(queue.Id);
                if (queueVerification.SentStatus == GroupMessagesStatusEnum.Processing.Value)
                    continue;

                // We mark the queue item so that we dont process many at the same time.
                queue.SentStatus = GroupMessagesStatusEnum.Processing.Value;
                await _communicationsRepository.UpdateGroupMessagesQueue(queue);

                var parents = await GetParentsStudentsByQueueParams(validParentDescriptors, validEmailTypeDescriptors, queue.StaffUniqueId, queue.Type, queue.FilterParams);

                try
                {
                    //We send the message for all the parents
                    await SendMessagesToParents(parents, queue.Subject, queue.BodyMessage, $"{staffInfo.FirstName} {staffInfo.LastSurname}", queue.StaffUniqueId, queue.Id);
                }
                catch (Exception ex)
                {
                    queue.SentStatus = GroupMessagesStatusEnum.Error.Value;
                    await _communicationsRepository.UpdateGroupMessagesQueue(queue);
                    throw ex;
                }

                //We assign the sent status to the queue when finish 
                queue.SentStatus = GroupMessagesStatusEnum.Sent.Value;
                queue.DateSent = DateTime.Now;
                await _communicationsRepository.UpdateGroupMessagesQueue(queue);
            }


        }

        public async Task<List<ParentStudentsModel>> GetParentStudentByTermAndGradeLevel(string personUniqueId, string term, GradesLevelModel model)
        {
            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;
            return await _communicationsRepository.GetParentsByGradeLevelsAndSearchTerm(personUniqueId, term, model, validParentDescriptors, _dateProvider.Today());
        }

        public async Task<int> GetParentStudentByTermAndGradeLevelCount(string personUniqueId, string term, GradesLevelModel model)
        {
            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;
            return await _communicationsRepository.GetParentsByGradeLevelsAndSearchTermCount(personUniqueId, term, model, validParentDescriptors, _dateProvider.Today());
        }

        public async Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueues(string personUniqueId, int schoolId, QueuesFilterModel model)
        {
            var queues = await _communicationsRepository.GetGroupMessagesQueuesQueued(personUniqueId, schoolId, model);
            return queues;
        }

        private async Task<PersonBriefModel> GetPersonBriefModelByUsiAndPersonTypeAsync(int usi)
        {

            var stu = await _studentRepository.GetStudentBriefModelAsync(usi);
            return new PersonBriefModel
            {
                Usi = stu.Usi,
                UniqueId = stu.UniqueId,
                FirstName = stu.FirstName,
                LastSurname = stu.LastSurname,
                ImageUrl = await _imageProvider.GetStudentImageUrlAsync(stu.UniqueId)
            };
        }

        private async Task<List<ParentStudentsModel>> GetParentsStudentsByQueueParams(string[] validParentDescriptors, string[] validEmailTypeDescriptors, string personUniqueId, string gmType, string parameters) 
        {
            List<ParentStudentsModel> parents = new List<ParentStudentsModel>();
            if (GroupMessagesQueueTypeEnum.Group.DisplayName.Equals(gmType)) 
            {
                var filterParams = JsonConvert.DeserializeObject<GroupMessagesFilterParamsModel>(parameters);
                parents = await _communicationsRepository.GetParentsByGradeLevelsAndPrograms(personUniqueId, filterParams.gradeLevels, filterParams.programs, validParentDescriptors, validEmailTypeDescriptors, _dateProvider.Today());
            }

            if (GroupMessagesQueueTypeEnum.IndividualGroup.DisplayName.Equals(gmType)) 
            {
                var filterParams = JsonConvert.DeserializeObject<IndividualGroupMessagesFilterParamsModel>(parameters);
                parents = await _communicationsRepository.GetParentsByPanrentUsisAndGradeLevels(personUniqueId, filterParams.parentsUsis, filterParams.gradeLevels,  validParentDescriptors, validEmailTypeDescriptors, _dateProvider.Today());
            }
            return parents;
        }

        private async Task<PersonBriefModel> GetPersonBriefModelByUsiAndPersonTypeAsync(string uniqueId, int personTypeId)
        {

            var model = new UserProfileModel();

            if(personTypeId == ChatLogPersonTypeEnum.Parent.Value)
            {
                model = await _parentRepository.GetParentProfileAsync(uniqueId);
                model.ImageUrl = await _imageProvider.GetParentImageUrlAsync(model.UniqueId);
            }
            else
            {
                model = await _teacherRepository.GetStaffProfileAsync(uniqueId);
                model.ImageUrl = await _imageProvider.GetStaffImageUrlAsync(model.UniqueId);
            }

            return new PersonBriefModel
            {
                Usi = model.Usi,
                UniqueId = model.UniqueId,
                PersonTypeId = model.PersonTypeId,
                FirstName = model.FirstName,
                LastSurname = model.LastSurname,
                ImageUrl = model.ImageUrl
            };
        }

        private async Task SendGroupMessageHandler(StudentParentAssociationModel model, string personUniqueId, string translatedMessage, string translatedSubject,string englishMessage, string englishSubject, string staffName, string studentName, string studentUniqueId, Guid queueId, string LanguageCode)
        {
            string ErrorMessage = string.Empty;
            ChatLogItemModel resultModel = new ChatLogItemModel();
            try
            {
                // Based on current specification the message should be persisted in the chat log
                // and then to the preferred method of contact.
                // Fall back logic: Try to send to "preferred method of contact" if none is defined fall back to email.
                resultModel = await PersistMessage(new ChatLogItemModel
                {
                    SenderTypeId = ChatLogPersonTypeEnum.Staff.Value,
                    SenderUniqueId = personUniqueId,
                    RecipientUniqueId = model.Parent.ParentUniqueId,
                    RecipientTypeId = ChatLogPersonTypeEnum.Parent.Value,
                    // By default we should mark them as read in the chat log.
                    RecipientHasRead = true,
                    EnglishMessage = $"{englishSubject}: {StripHTML(englishMessage)}",
                    StudentUniqueId = studentUniqueId,
                    TranslatedMessage = LanguageCode != "en" ? $"{translatedSubject}: {StripHTML(translatedMessage)}" : null,
                    TranslatedLanguageCode = LanguageCode != "en" ? LanguageCode : null
                });

                var subjectToSend = LanguageCode != "en" ? translatedSubject : englishSubject;

                var messageMetadata = new MessageAbstractionModel
                {
                    SenderName = staffName,
                    SenderUniqueId = personUniqueId,
                    RecipientUniqueId = model.Parent.ParentUniqueId,
                    RecipientEmail = model.Parent.Email,
                    RecipientTelephone = model.Parent.Telephone,
                    RecipientTelephoneSMSDomain = model.Parent.SMSDomain,
                    Subject = subjectToSend,
                    BodyMessage = LanguageCode != "en" ? translatedMessage : englishMessage,
                    AboutStudent = new StudentMessageAbstractModel 
                    {
                        StudentUniqueId = studentUniqueId,
                        StudentName = studentName
                    },
                    DelivaryMethod = model.Parent.ParentAlert.PreferredMethodOfContactTypeId.Value,
                    LanguageCode = LanguageCode
                };

                //Should use the provider for the Preferred Method of contact by parent 
                var messageProvider = _messageProviders.SingleOrDefault(x => x.DeliveryMethod == messageMetadata.DelivaryMethod);

                await messageProvider.SendMessage(messageMetadata);
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
            }
            finally 
            {
                
                var chatLogModel = new GroupMessagesChatLogModel
                {
                    GroupMessagesLogId = queueId,
                    ChatLogId = resultModel.ChatId,
                    Status = GroupMessagesStatusEnum.Sent
                };
                
                if (!string.IsNullOrEmpty(ErrorMessage))
                {
                    chatLogModel.Status = GroupMessagesStatusEnum.Error;
                    chatLogModel.ErrorMessage = ErrorMessage;
                    await _communicationsRepository.PersistChatGroupMessage(chatLogModel);
                    throw new Exception(ErrorMessage);
                }
                
                await _communicationsRepository.PersistChatGroupMessage(chatLogModel);
            }
        }

        private async Task<ChatLogItemModel> SendGroupMessageHandler(StudentParentAssociationModel model, string personUniqueId, string messageTranslated, string subjectTranslated, string messageEnglish, string subjectEnglish, string studentName, string studentUniqueId, string staffName, string LanguageCode)
        {
            // Based on current specification the message should be persisted in the chat log
            // and then to the preferred method of contact.
            // Fall back logic: Try to send to "preferred method of contact" if none is defined fall back to email.
            var resultModel = await PersistMessage(new ChatLogItemModel
            {
                SenderTypeId = ChatLogPersonTypeEnum.Staff.Value,
                SenderUniqueId = personUniqueId,
                RecipientUniqueId = model.Parent.ParentUniqueId,
                RecipientTypeId = ChatLogPersonTypeEnum.Parent.Value,
                // By default we should mark them as read in the chat log.
                RecipientHasRead = true,
                EnglishMessage = $"{subjectEnglish}: {StripHTML(messageEnglish)}",
                StudentUniqueId = studentUniqueId,
                TranslatedMessage = LanguageCode != "en" ? $"{subjectTranslated}: {StripHTML(messageTranslated)}" : null,
                TranslatedLanguageCode = LanguageCode != "en" ? LanguageCode : null
            });

            var subjectToSend = $"{studentName}: {subjectTranslated}";
            await SendMessageToPreferredMethodOfContact(model, messageTranslated, subjectToSend, staffName);
           
            return resultModel;
        }

        private async Task SendMessageToPreferredMethodOfContact(StudentParentAssociationModel parent, string message, string subject, string staffName)
        {
            string to = string.Empty;
            // If SMS is the preferred method of contact
            if (parent.Parent.ParentAlert.PreferredMethodOfContactTypeId.Value == MethodOfContactTypeEnum.SMS.Value && parent.Parent.Telephone != null)
            {
                to = parent.Parent.Telephone + parent.Parent.SMSDomain;
                await _smsProvider.SendMessageAsync(to, subject, message);
            }
            // If Push Notification is the preferred method of contact
            if (parent.Parent.ParentAlert.PreferredMethodOfContactTypeId.Value == MethodOfContactTypeEnum.Notification.Value)
            {
                await _pushNotificationProvider.SendNotificationAsync(new NotificationItemModel
                {
                    personUniqueId = parent.Parent.ParentUniqueId,
                    personType = "Parent",
                    notification = new Notification
                    {
                        title = subject,
                        body = message
                    }
                });
            }
            //If the parent doesn't have a preferred method of contact configured fall back to sending an email
            else if ((parent.Parent.ParentAlert.PreferredMethodOfContactTypeId.Value == MethodOfContactTypeEnum.Email.Value
                    || parent.Parent.ParentAlert.PreferredMethodOfContactTypeId == null
                    || parent.Parent.ParentAlert.PreferredMethodOfContactTypeId == 0) && parent.Parent.Email != null)
            {
                string legendBottom = "Please do not reply to this message, as this email inbox is not monitored. To contact us, visit <a href=\"https://familyportal.yesprep.org\">https://familyportal.yesprep.org</a>";
                string signByDefault = $"This message was sent from the YES Prep Family Portal on behalf of {staffName}";

                var legentBottomTranslate = new Hashtable();
                var signByDefaultTranslate = new Hashtable();

                if (string.IsNullOrEmpty(parent.Parent.LanguageCode))
                    parent.Parent.LanguageCode = "en";


                if (!legentBottomTranslate.ContainsKey(parent.Parent.LanguageCode))
                {
                    var legentBottomTrans = await TranslateText(legendBottom, parent.Parent.LanguageCode);
                    legentBottomTranslate.Add(parent.Parent.LanguageCode, legentBottomTrans);
                }

                var translatedLegentBottom = legentBottomTranslate[parent.Parent.LanguageCode].ToString();

                if (!signByDefaultTranslate.ContainsKey(parent.Parent.LanguageCode))
                {
                    var signByDefaultTrans = await TranslateText(signByDefault, parent.Parent.LanguageCode);
                    signByDefaultTranslate.Add(parent.Parent.LanguageCode, signByDefaultTrans);
                }

                var translatedSignByDefault = signByDefaultTranslate[parent.Parent.LanguageCode].ToString();


                message = $"{message} <br/> <br/> {translatedLegentBottom} <br/> {translatedSignByDefault}";
                to = parent.Parent.Email;
                await _messagingProvider.SendMessageAsync(to, null, null, subject, message);
            }
        }

        private async Task<string> TranslateText(string text, string codeLanguage) 
        {
            return await _translationProvider.TranslateAsync(new TranslateRequest { TextToTranslate = text, ToLangCode = codeLanguage });
        }
        
        private async Task SendMessagesToParents(List<ParentStudentsModel> parents, string subject, string bodyMessage,string personName, string personUniqueId, Guid queueId) 
        {
            var languageHashSubject = new Hashtable();
            var languageHashMessage = new Hashtable();
            try
            {
                foreach (var parent in parents)
                {
                    string englishSubject = subject;
                    string englishMessage = bodyMessage;

                    if (string.IsNullOrEmpty(parent.LanguageCode)) 
                        parent.LanguageCode = "en";
                    
                    // Check to see if we have translated already.
                    if (!languageHashSubject.ContainsKey(parent.LanguageCode))
                    {
                        var subjectTrans = await TranslateText(subject, parent.LanguageCode);
                        languageHashSubject.Add(parent.LanguageCode, subjectTrans);
                    }

                    var translatedSubject = languageHashSubject[parent.LanguageCode].ToString();

                    if (!languageHashMessage.ContainsKey(parent.LanguageCode))
                    {
                        var messageTrans = await TranslateText(bodyMessage, parent.LanguageCode);
                        languageHashMessage.Add(parent.LanguageCode, messageTrans);
                    }

                    var translatedBodyMessage = languageHashMessage[parent.LanguageCode].ToString();
                   
                    await SendGroupMessageHandler(new StudentParentAssociationModel
                    {
                        ParentUsi = parent.ParentUsi,
                        Parent = new ParentModel
                        {
                            Email = !string.IsNullOrEmpty(parent.ProfileEmail) ? parent.ProfileEmail : parent.EdFiEmail,
                            ParentUniqueId = parent.ParentUniqueId,
                            Telephone = parent.ProfileTelephone,
                            SMSDomain = parent.ProfileTelephoneSMSSuffixDomain,
                            ParentAlert = new ParentAlertModel { PreferredMethodOfContactTypeId = parent.PreferredMethodOfContactTypeId }
                        }
                    }, personUniqueId, translatedBodyMessage, translatedSubject, englishMessage, englishSubject, personName, parent.StudentName, parent.StudentUniqueId, queueId, parent.LanguageCode);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private string StripHTML(string input)
        {
            return Regex.Replace(input, "<.*?>", String.Empty);
        }

    }
}
