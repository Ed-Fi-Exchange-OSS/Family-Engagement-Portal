using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Messaging;
using Student1.ParentPortal.Resources.Providers.Translation;

namespace Student1.ParentPortal.Resources.Providers.Message
{
    public class EmailMessageProvider : IMessageProvider
    {
        private readonly IMessagingProvider _messagingProvider;
        private readonly ITranslationProvider _translationProvider;
        public EmailMessageProvider(IMessagingProvider messagingProvider, ITranslationProvider translationProvider) 
        {
            _messagingProvider = messagingProvider;
            _translationProvider = translationProvider;
        }
        public int DeliveryMethod => MethodOfContactTypeEnum.Email.Value;

        public async Task SendMessage(MessageAbstractionModel model)
        {
            string legendBottom = "Please do not reply to this message, as this email inbox is not monitored. To contact us, visit <a href=\"https://familyportal.yesprep.org\">https://familyportal.yesprep.org</a> .";
            string signByDefault = $"This message was sent from the YES Prep Family Portal on behalf of {model.SenderName}.";
            
            var legentBottomTranslate = new Hashtable();
            var signByDefaultTranslate = new Hashtable();

            if (string.IsNullOrEmpty(model.LanguageCode))
                model.LanguageCode = "en";


            if (!legentBottomTranslate.ContainsKey(model.LanguageCode))
            {
                var legentBottomTrans = await TranslateText(legendBottom, model.LanguageCode);
                legentBottomTranslate.Add(model.LanguageCode, legentBottomTrans);
            }

            var translatedLegentBottom = legentBottomTranslate[model.LanguageCode].ToString();

            if (!signByDefaultTranslate.ContainsKey(model.LanguageCode))
            {
                var signByDefaultTrans = await TranslateText(signByDefault, model.LanguageCode);
                signByDefaultTranslate.Add(model.LanguageCode, signByDefaultTrans);
            }

            var translatedSignByDefault = signByDefaultTranslate[model.LanguageCode].ToString();


            if (model.RecipientEmail != null) 
            {
                model.BodyMessage = $"{model.BodyMessage} <br/> <br/> {translatedLegentBottom} <br/> {translatedSignByDefault}";
                await _messagingProvider.SendMessageAsync(model.RecipientEmail, null, null, $"{model.AboutStudent.StudentName}: {model.Subject}", model.BodyMessage);
            }
        }

        private async Task<string> TranslateText(string text, string codeLanguage)
        {
            return await _translationProvider.TranslateAsync(new TranslateRequest { TextToTranslate = text, ToLangCode = codeLanguage });
        }
    }
}
