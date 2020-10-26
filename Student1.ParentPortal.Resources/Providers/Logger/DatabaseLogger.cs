using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Logger
{
    public class DatabaseLogger : ILogger
    {
        private readonly ILogRepository _logRepository;

        public DatabaseLogger(ILogRepository logRepository){
            _logRepository = logRepository;
        }

        public async Task LogErrorAsync(string message)
        {
            await _logRepository.AddLogEntryAsync(message, LogTypeEnum.Error.DisplayName);
        }

        public async Task LogInformationAsync(string message)
        {
            await _logRepository.AddLogEntryAsync(message, LogTypeEnum.Info.DisplayName);
        }

        public async Task LogWarningAsync(string message)
        {
            await _logRepository.AddLogEntryAsync(message, LogTypeEnum.Warning.DisplayName);
        }

        public void LogError(string message)
        {
            _logRepository.AddLogEntry(message, LogTypeEnum.Error.DisplayName);
        }

        public void LogInformation(string message)
        {
            _logRepository.AddLogEntry(message, LogTypeEnum.Info.DisplayName);
        }

        public void LogWarning(string message)
        {
            _logRepository.AddLogEntry(message, LogTypeEnum.Warning.DisplayName);
        }
    }
}
