﻿using Student1.ParentPortal.Resources.ExtensionMethods;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Messaging
{
    public class SMSMessagingProvider : ISMSProvider
    {
        private readonly string _defaultFromAddress;
        private readonly string _defaultFromDisplayName;
        private readonly string _mailServer;
        private readonly string _mailPort;
        private readonly string _mailUser;
        private readonly string _mailPassword;

        public SMSMessagingProvider()
        {
            _defaultFromAddress = ConfigurationManager.AppSettings["messaging.email.defaultFromEmail"];
            _defaultFromDisplayName = ConfigurationManager.AppSettings["messaging.email.defaultFromDisplayName"];
            _mailServer = ConfigurationManager.AppSettings["messaging.email.server"];
            _mailPort = ConfigurationManager.AppSettings["messaging.email.port"];
            _mailUser = ConfigurationManager.AppSettings["messaging.email.user"];
            _mailPassword = ConfigurationManager.AppSettings["messaging.email.pass"];
        }

        public async Task SendMessageAsync(string from, string[] to, string subject, string body)
        {
            var fromAddress = new MailAddress(from);
            await SendSMSAsync(fromAddress, to, subject, body);
        }

        public async Task SendMessageAsync(string[] to, string subject, string body)
        {
            var defaultFrom = new MailAddress(_defaultFromAddress, _defaultFromDisplayName);
            await SendSMSAsync(defaultFrom, to, subject, body);
        }

        public async Task SendMessageAsync(string to, string subject, string body)
        {
            await SendMessageAsync(new string[] { to }, subject, body);
        }

        private async Task SendSMSAsync(MailAddress from, string[] to, string subject, string body)
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
                IsBodyHtml = false
            };

            // Allow for multiple To, CC and BCC
            if (!to.IsNullOrEmpty())
                to.ToList().ForEach(x => mailMessage.To.Add(new MailAddress(x)));

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}
