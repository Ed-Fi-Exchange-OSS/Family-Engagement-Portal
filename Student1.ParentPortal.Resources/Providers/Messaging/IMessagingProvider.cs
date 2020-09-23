// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Messaging
{
    public interface IMessagingProvider
    {
        /// <summary>
        /// Sends message asynchronously. 
        /// </summary>
        /// <param name="from">Who the message is coming from.</param>
        /// <param name="to">The recipient who will receive the message.</param>
        /// <param name="cc">Carbon Copy</param>
        /// <param name="bcc">Blind Carbon Copy</param>
        /// <param name="subject">A short description of the message.</param>
        /// <param name="body">The content of the message.</param>
        /// <returns></returns>
        Task SendMessageAsync(string from, string[] to, string[] cc, string[] bcc, string subject, string body);
        Task SendMessageAsync(string[] to, string[] cc, string[] bcc, string subject, string body);
        Task SendMessageAsync(string to, string[] cc, string[] bcc, string subject, string body);
        Task SendMessageAsync(string[] to, string[] cc, string[] bcc, string[] replyTo, string subject, string body);
    }
}
