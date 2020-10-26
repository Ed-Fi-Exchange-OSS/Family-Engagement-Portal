using Student1.ParentPortal.Resources.ExtensionMethods;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace Student1.ParentPortal.Resources.Providers.Messaging
{
    public class SMSMessagingProvider : ISMSProvider
    {
        private readonly string _defaultFromPhone;
        private readonly string _accountKey;
        private readonly string _accountAuthKey;

        public SMSMessagingProvider()
        {
            _defaultFromPhone = ConfigurationManager.AppSettings["messaging.sms.sender"];
            _accountKey = ConfigurationManager.AppSettings["messaging.sms.account"];
            _accountAuthKey = ConfigurationManager.AppSettings["messaging.sms.key"];
        }

        public async Task SendMessageAsync(string from, string to, string subject, string body)
        {
            await SendSMSAsync(from, to, subject, body);
        }

        public async Task SendMessageAsync(string to, string subject, string body)
        {
            await SendSMSAsync(_defaultFromPhone, to, subject, body);
        }

        private async Task SendSMSAsync(string from, string to, string subject, string body)
        {
            // Create sms credentials and client
            TwilioClient.Init(_accountKey, _accountAuthKey);

            await MessageResource.CreateAsync(
                body: $"{subject}\n\n{body}",
                from: new Twilio.Types.PhoneNumber(from),
                to: new Twilio.Types.PhoneNumber(to)
            );
        }
    }
}
