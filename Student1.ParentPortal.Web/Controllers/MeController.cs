using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.User;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Resources.Services.Admin;
using Student1.ParentPortal.Resources.Services.Parents;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/me")]
    public class MeController : ApiController
    {
        private readonly IParentsService _parentsService;
        private readonly ITeachersService _teachersService;
        private readonly IAdminService _adminService;

        public MeController(IParentsService parentsService, ITeachersService teachersService, IAdminService adminService)
        {
            _parentsService = parentsService;
            _teachersService = teachersService;
            _adminService = adminService;
        }

        [HttpGet]
        [Route("profile")]
        public async Task<IHttpActionResult> GetProfile()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            // TODO: If this application grows into something bigger it is important to 
            // refactor this into a more extensible pattern like a chain of responsibility.
            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _parentsService.GetParentProfileAsync(person.PersonUSI));

            return Ok(await _teachersService.GetStaffProfileAsync(person.PersonUSI));
        }

        [HttpGet]
        [Route("briefProfile")]
        public async Task<IHttpActionResult> GetBriefProfile()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            // TODO: If this application grows into something bigger it is important to 
            // refactor this into a more extensible pattern like a chain of responsibility.
            BriefProfileModel response = null;
            if (role.Equals("Admin", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _teachersService.GetBriefStaffProfileAsync(person.PersonUSI));

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _parentsService.GetBriefParentProfileAsync(person.PersonUSI));

            return Ok(await _teachersService.GetBriefStaffProfileAsync(person.PersonUSI));
        }

        [HttpPost]
        [Route("profile")]
        public async Task<IHttpActionResult> SaveProfile(UserProfileModel model)
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            // TODO: If this application grows into something bigger it is important to 
            // refactor this into a more extensible pattern like a chain of responsibility.
            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _parentsService.SaveParentProfileAsync(person.PersonUSI, model));

            return Ok(await _teachersService.SaveStaffProfileAsync(person.PersonUSI, model));
        }


        [Route("role")]
        [HttpGet]
        public IHttpActionResult Get()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;
            return Ok(role);
        }

        [Route("school")]
        [HttpGet]
        public IHttpActionResult GetSchool()
        {
            var person = SecurityPrincipal.Current;
            var school = person.Claims.FirstOrDefault(x => x.Type == "schoolId").Value;
            return Ok(school);
        }

        [Route("image")]
        [HttpPost]
        public async Task<IHttpActionResult> UploadImage()
        {
            if (!Request.Content.IsMimeMultipartContent())
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);

            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;
            var file = HttpContext.Current.Request.Files[0];
            var fileLength = file.ContentLength;
            byte[] filebytes = new byte[fileLength];

            var stream = file.InputStream;
            stream.Read(filebytes, 0, fileLength);

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                await _parentsService.UploadParentImageAsync(person.PersonUniqueId, filebytes, file.ContentType);
            else
                await _teachersService.UploadStaffImageAsync(person.PersonUniqueId, filebytes, file.ContentType);

            return Ok();

        }

        [HttpPost]
        [Route("language")]
        public async Task<IHttpActionResult> ProfileLanguage(ProfileLanguageModel model) 
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;
            // TODO: If this application grows into something bigger it is important to 
            // refactor this into a more extensible pattern like a chain of responsibility.
            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase)) 
            {
                await _parentsService.UpdateParentLanguage(person.PersonUniqueId, model.LanguageCode);
                return Ok();
            }

            await _teachersService.UpdateStaffLanguage(person.PersonUniqueId, model.LanguageCode);
            return Ok();
        }
    }

}