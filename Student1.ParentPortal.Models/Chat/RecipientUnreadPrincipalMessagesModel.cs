using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class RecipientUnreadPrincipalMessagesModel
    {
        public int RowsToSkip { get; set; }
        public int RowsToRetrive { get; set; }
        public string SearchTerm { get; set; }
        public bool OnlyUnreadMessages { get; set; }
    }
}
