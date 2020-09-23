// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface ICommunicationsRepository
    {
        Task<ChatLogHistoryModel> GetThreadByParticipantsAsync(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount, int rowsToRetrieve = 15);
        Task<ChatLogItemModel> PersistMessage(ChatLogItemModel model);
        Task<List<UnreadMessageModel>> RecipientUnreadMessages(string recipientUniqueId, int recipientTypeId);
        Task<int> UnreadMessageCount(int studentUsi, string recipientUniqueId, int recipientTypeId, string senderUniqueid, int? senderTypeId);
        Task SetRecipientRead(ChatLogItemModel model);
        Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
        Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve);
    }
}
