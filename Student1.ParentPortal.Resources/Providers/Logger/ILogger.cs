using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Logger
{
    public interface ILogger
    {
        Task LogInformationAsync(string message);
        Task LogWarningAsync(string message);
        Task LogErrorAsync(string message);
        void LogInformation(string message);
        void LogWarning(string message);
        void LogError(string message);
    }
}
