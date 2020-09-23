// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.User;
using Student1.ParentPortal.Resources.Cache;
using Student1.ParentPortal.Resources.Providers.Image;

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
        Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
        Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
    }

    public class CommunicationsService : ICommunicationsService
    {
        private readonly ICommunicationsRepository _communicationsRepository;
        private readonly IImageProvider _imageProvider;
        // We had to inject the student, parent and teacher repositories instead of the services because of cyclical dependencies.
        private readonly IStudentRepository _studentRepository;
        private readonly IParentRepository _parentRepository;
        private readonly ITeacherRepository _teacherRepository;
   
        public CommunicationsService(ICommunicationsRepository communicationsRepository, IStudentRepository studentRepository, IParentRepository parentRepository, ITeacherRepository teacherRepository, IImageProvider imageProvider)
        {
            _communicationsRepository = communicationsRepository;
            _studentRepository = studentRepository;
            _parentRepository = parentRepository;
            _teacherRepository = teacherRepository;
            _imageProvider = imageProvider;
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
           var model = await _communicationsRepository.GetAllParentRecipients(studentUsi, recipientUniqueId, recipientTypeId, rowsToSkip, rowsToRetrieve);

            foreach(var sr in model.StudentRecipients)
            {
                sr.ImageUrl = await _imageProvider.GetStudentImageUrlAsync(sr.StudentUniqueId);
                sr.Recipients = await GetRecipientsWithImages(sr.Recipients);
            }

            return model;
        }

        private async Task<List<RecipientModel>> GetRecipientsWithImages(IEnumerable<RecipientModel> recipients)
        {
            var result = new List<RecipientModel>();

            foreach(var r  in recipients)
            {
                if(r.PersonTypeId == ChatLogPersonTypeEnum.Staff.Value)
                    r.ImageUrl = await _imageProvider.GetStaffImageUrlAsync(r.UniqueId);
                else
                    r.ImageUrl = await _imageProvider.GetParentImageUrlAsync(r.UniqueId);

                result.Add(r);
            }
            return result.ToList();
        }

        public async Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {
            var model = await _communicationsRepository.GetAllStaffRecipients(studentUsi, recipientUniqueId, recipientTypeId, rowsToSkip, rowsToRetrieve);

            foreach (var sr in model.StudentRecipients)
            {
                sr.ImageUrl = await _imageProvider.GetStudentImageUrlAsync(sr.StudentUniqueId);
                sr.Recipients = await GetRecipientsWithImages(sr.Recipients);
            }

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
    }
}
