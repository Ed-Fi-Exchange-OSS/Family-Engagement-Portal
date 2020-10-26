using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class FeedbackRequestModel
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Subject { get; set; }
        public string Issue { get; set; }
        public string Description { get; set; }
        public string CurrentUrl { get; set; }
        public bool IsFromLoginScreen { get; set; }
    }
}
