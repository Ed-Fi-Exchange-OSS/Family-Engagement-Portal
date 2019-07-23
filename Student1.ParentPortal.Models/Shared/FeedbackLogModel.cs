using System;

namespace Student1.ParentPortal.Models.Shared
{
    public class FeedbackLogModel
    {
        public string Subject { get; set; }
        public string Issue { get; set; }
        public string Description { get; set; }
        public string CurrentUrl { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string PersonUniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
