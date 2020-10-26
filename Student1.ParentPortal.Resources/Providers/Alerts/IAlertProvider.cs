using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Alerts
{
    public interface IAlertProvider
    {
        Task<int> SendAlerts();
    }
}
