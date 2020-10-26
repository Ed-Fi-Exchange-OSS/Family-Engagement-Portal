using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class GroupMessagesQueueLogModel
    {
        public Guid Id { get; set; }
        public string Type { get; set; }
        public DateTime QueuedDateTime { get; set; }
        public string StaffUniqueId { get; set; }
        public int SchoolId { get; set; }
        public string Audience { get; set; }
        public string FilterParams { get; set; }
        public string Subject { get; set; }
        public string BodyMessage { get; set; }
        public int SentStatus { get; set; }
        public string Data { get; set; }
        public DateTime? DateSent { get; set; }
        public int RetryCount { get; set; }
    }
}
