using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Student1.ParentPortal.Resources.Providers.Url;
using Student1.ParentPortal.Resources.Providers.Configuration;
using System.Net.Http;

namespace Student1.ParentPortal.Resources.Providers.Image
{
    public class DemoImageProvider : IImageProvider
    {
        // This paths are statically defined for the DemoImageUrlProvider.

        private readonly IImageRepository _imageRepository;
        private readonly IUrlProvider _urlProvider;
        private readonly IApplicationSettingsProvider _applicationSettingsProvider;

        public DemoImageProvider(IImageRepository imageRepository, IUrlProvider urlProvider, IApplicationSettingsProvider applicationSettingsProvider)
        {
            _imageRepository = imageRepository;
            _urlProvider = urlProvider;
            _applicationSettingsProvider = applicationSettingsProvider;
        }

        public async Task<string> GetStaffImageUrlAsync(string staffUniqueId)
        {
            var data = await _imageRepository.GetStaffImageModel(staffUniqueId);

            // Seed with Usi to always get the same img if the same Usi is requested.
            var random = new Random(Int32.Parse(staffUniqueId.Trim().Replace("-","")));

            var race =  data.StaffRaces?.FirstOrDefault()?.RaceType.ShortDescription.Replace(" ", "_");
            var demoImageConventionName = $"{data.SexType.ShortDescription}-{race}-{random.Next(1, 3)}.png";
            var imageUrl = Path.Combine(_applicationSettingsProvider.GetSetting("parent.image.path"), demoImageConventionName);

            return ImageExistsOrDefault(imageUrl);
        }

        public async Task<string> GetParentImageUrlAsync(string parentUniqueId)
        {
            var data = await _imageRepository.GetParentImageModel(parentUniqueId);

            // Seed with Usi to always get the same img if the same Usi is requested.
            var random = new Random(Int32.Parse(parentUniqueId));

            // There is no parent Race
            // If SexType is not defined then return default image.
            if(data.SexType==null)
                return _applicationSettingsProvider.GetSetting("default.image.path");

            var demoImageConventionName = $"{data.SexType.ShortDescription}-White-{random.Next(1, 3)}.png";
            var imageUrl = Path.Combine(_applicationSettingsProvider.GetSetting("staff.image.path"), demoImageConventionName);

            return ImageExistsOrDefault(imageUrl);
        }

        public async Task<string> GetStudentImageUrlAsync(string studentUniqueId)
        {
            var data = await _imageRepository.GetStudentImageModel(studentUniqueId);
            
            // Seed with Usi to always get the same img if the same Usi is requested.
            var random = new Random(Int32.Parse(studentUniqueId));

            var demoImageConventionName = $"{data.SexType.ShortDescription}-{data.StaffRaces.FirstOrDefault().RaceType.ShortDescription.Replace(" ", "_")}-{random.Next(1, 3)}.png";
            var imageUrl = Path.Combine(_applicationSettingsProvider.GetSetting("student.image.path"), demoImageConventionName);

            return ImageExistsOrDefault(imageUrl);
        }

        private string ImageExistsOrDefault(string relativeImagePath)
        {
            var physicalFilePath = HttpContext.Current.Server.MapPath(Path.Combine("~/", relativeImagePath));

            if (File.Exists(physicalFilePath))
                return relativeImagePath;

            return _applicationSettingsProvider.GetSetting("default.image.path");
        }

        public async Task<string> GetStudentImageUrlForAlertsAsync(string studentUniqueId)
        {
            return _urlProvider.GetApplicationBasePath() + (await GetStudentImageUrlAsync(studentUniqueId));
        }

        public Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType)
        {
            throw new NotImplementedException();
        }

        public Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType)
        {
            throw new NotImplementedException();
        }
    }
}
