using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Messaging;

namespace Student1.ParentPortal.Resources.Providers.Message
{
    public class SmsMessageProvider : IMessageProvider
    {
        private readonly ISMSProvider _smsProvider;
        public SmsMessageProvider(ISMSProvider smsProvider) 
        {
            _smsProvider = smsProvider;
        }
        public int DeliveryMethod => MethodOfContactTypeEnum.SMS.Value;

        public async Task SendMessage(MessageAbstractionModel model)
        {
            if (model.RecipientTelephone != null) 
            {
                //We remove the html properties
                model.BodyMessage = model.BodyMessage.Replace("<br/>", "\n\n");

                string to = model.RecipientTelephone;
                await _smsProvider.SendMessageAsync(to, $"{model.AboutStudent.StudentName}: {model.Subject}", model.BodyMessage);
            }
        }
    }
}
