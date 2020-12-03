using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Services.Admin;
using System;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/Admin")]
    public class AdminController : ApiController
    {
        private readonly IAdminService _adminService;

        public AdminController(IAdminService adminService)
        {
            _adminService = adminService;
        }

        [HttpGet, Route("GetStudentDetailFeatures")]
        public async Task<IHttpActionResult> GetStudentDetailFeatures()
        {
            AdminStudentDetailFeatureModel result = await _adminService.GetStudentDetailFeatures();
            return Ok(result);
        }

        [HttpPost, Route("SaveStudentDetailFeatures")]
        public async Task<IHttpActionResult> SaveStudentDetailFeatures(AdminStudentDetailFeatureModel entity)
        {
            AdminStudentDetailFeatureModel result = await _adminService.SaveStudentDetailFeatures(entity);
            return Ok(result);
        }
    }
}