using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface IApplicationRepository
    {
        Task<bool> IsApplicationOffline();
    }
}
