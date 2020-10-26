using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Message
{
    public interface IMessageProvider
    {
        int DeliveryMethod { get; }
        Task SendMessage(MessageAbstractionModel model);
    }
}
