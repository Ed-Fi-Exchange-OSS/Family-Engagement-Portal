using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Services.Types;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/image")]
    public class ImageController : ApiController
    {
        private readonly IImageProvider _imageProvider;
       
        public ImageController(IImageProvider imageProvider)
        {
            _imageProvider = imageProvider;     
        }

        [HttpGet]
        [Route("student/{studentUniqueId}")]
        public async Task<IHttpActionResult> GetStudentImage(string studentUniqueId)
        {
            return Ok(await _imageProvider.GetStudentImageUrlAsync(studentUniqueId));
        }

        
    }
}