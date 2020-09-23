// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Configuration;
using System.Net;
using Student1.ParentPortal.Resources.ExtensionMethods;

namespace Student1.ParentPortal.Resources.Providers.Messaging
{
    public class EmailMessagingProvider : IMessagingProvider
    {
        private readonly string _defaultFromAddress;
        private readonly string _defaultFromDisplayName;
        private readonly string _mailServer;
        private readonly string _mailPort;
        private readonly string _mailUser;
        private readonly string _mailPassword;

        public EmailMessagingProvider()
        {
            // Initialize with parameters set in the Web.Config
            _defaultFromAddress = ConfigurationManager.AppSettings["messaging.email.defaultFromEmail"];
            _defaultFromDisplayName = ConfigurationManager.AppSettings["messaging.email.defaultFromDisplayName"];
            _mailServer = ConfigurationManager.AppSettings["messaging.email.server"];
            _mailPort = ConfigurationManager.AppSettings["messaging.email.port"];
            _mailUser = ConfigurationManager.AppSettings["messaging.email.user"];
            _mailPassword = ConfigurationManager.AppSettings["messaging.email.pass"];
        }

        public async Task SendMessageAsync(string to, string[] cc, string[] bcc, string subject, string body)
        {
            await SendMessageAsync(new string[] { to }, cc, bcc, subject, body);
        }

        public async Task SendMessageAsync(string[] to, string[] cc, string[] bcc, string subject, string body)
        {
            var defaultFrom = new MailAddress(_defaultFromAddress,_defaultFromDisplayName);
            await SendEmailAsync(defaultFrom, to, cc, bcc,null, subject, body);
        }

        public async Task SendMessageAsync(string from, string[] to, string[] cc, string[] bcc, string subject, string body) {
            var fromAddress = new MailAddress(from);
            await SendEmailAsync(fromAddress, to, cc, bcc, null, subject, body);
        }

        public async Task SendMessageAsync(string[] to, string[] cc, string[] bcc, string[] replyTo, string subject, string body)
        {
            var defaultFrom = new MailAddress(_defaultFromAddress, _defaultFromDisplayName);
            await SendEmailAsync(defaultFrom, to, cc, bcc, replyTo, subject, body);
        }

        private async Task SendEmailAsync(MailAddress from, string[] to, string[] cc, string[] bcc, string[] replyTo, string subject, string body)
        {
            // Create mail credentials and client
            var credentials = new NetworkCredential(_mailUser, _mailPassword);
            var smtpClient = new SmtpClient(_mailServer, Convert.ToInt32(_mailPort)) { Credentials = credentials };

            // Create mail message
            var mailMessage = new MailMessage()
            {
                From = from,
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };

            // Allow for multiple To, CC and BCC
            if (!to.IsNullOrEmpty())
                to.ToList().ForEach(x => mailMessage.To.Add(new MailAddress(x)));

            if (!cc.IsNullOrEmpty())
                cc.ToList().ForEach(x => mailMessage.CC.Add(new MailAddress(x)));

            if (!bcc.IsNullOrEmpty())
                bcc.ToList().ForEach(x => mailMessage.Bcc.Add(new MailAddress(x)));

            if (!replyTo.IsNullOrEmpty())
                replyTo.ToList().ForEach(x => mailMessage.ReplyToList.Add(new MailAddress(x)));

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}
