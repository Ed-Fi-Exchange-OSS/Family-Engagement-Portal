
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.Shared;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Alert;

namespace Student1.ParentPortal.Data.Models
{
    public interface ILogRepository
    {
        Task AddLogEntryAsync(string message, string logType);
        void AddLogEntry(string message, string logType);
    }
}
