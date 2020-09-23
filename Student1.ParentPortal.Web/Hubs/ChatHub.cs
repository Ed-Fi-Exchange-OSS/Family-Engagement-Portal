// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Resources.Services.Communications;
using Student1.ParentPortal.Web.Controllers;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Hubs
{
    public class ChatHub : Hub
    {
        // We use the SignalR hub only for the real time aspects of a chat.
        // The rest of the persistence is being done through the Api services.

        public override Task OnConnected()
        {
            var userId = Context.QueryString["data"];
            var connectionId = Context.ConnectionId;
            Groups.Add(connectionId, userId);

            return Task.Run(()=> true);
        }

        public static bool UpdateClients(ChatLogItemModel model)
        {
            var hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            var camelcase = JsonConvert.SerializeObject(model, new JsonSerializerSettings{ ContractResolver = new CamelCasePropertyNamesContractResolver()});


            hubContext.Clients.Group(model.RecipientUniqueId).messageReceived(camelcase);
            //hubContext.Clients.Group(model.SenderUniqueId).messageReceived(camelcase);
            //hubContext.Clients.All.messageReceived(camelcase);

            return true;
        }

    }

}