// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Models.Chat
{
    public class ChatModel
    {
        public ChatModel()
        {
            Conversation = new ChatLogHistoryModel();
        }

        public PersonBriefModel Student { get; set; }
        public PersonBriefModel Sender { get; set; }
        public PersonBriefModel Recipient { get; set; }
        public ChatLogHistoryModel Conversation { get; set; }
    }

    public class ChatLogItemModel
    {
        public string StudentUniqueId { get; set; }
        public string SenderUniqueId { get; set; }
        public string RecipientUniqueId { get; set; }
        public string OriginalMessage { get; set; }
        public string EnglishMessage { get; set; }
        public int RecipientTypeId { get; set; }
        public int SenderTypeId { get; set; }
        public DateTime DateSent { get; set; }
        public bool RecipientHasRead { get; set; }
    }
    
    public class ChatLogHistoryModel
    {
        public List<ChatLogItemModel> Messages { get; set; }

        public bool EndOfMessageHistory { get; set; }
    }
}
