using System.Net.Http;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Image
{
    public interface IImageProvider
    {
        Task<string> GetStudentImageUrlAsync(string studentUniqueId);
        Task<string> GetStaffImageUrlAsync(string staffUniqueId);
        Task<string> GetParentImageUrlAsync(string parentUniqueId);
        Task<string> GetStudentImageUrlForAlertsAsync(string studentUniqueId);
        Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType);
        Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType);
    }
}
