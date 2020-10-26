using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;

namespace Student1.ParentPortal.Resources.Azure.Providers.Image
{
    public class BlobImageProvider : IImageProvider
    {
        private readonly IApplicationSettingsProvider _applicationSettingsProvider;

        public BlobImageProvider(IApplicationSettingsProvider applicationSettingsProvider)
        {
            _applicationSettingsProvider = applicationSettingsProvider;
        }

        public async Task<string> GetStudentImageUrlAsync(string studentUniqueId)
        {

            var uri = await GetContainerSasUri(_applicationSettingsProvider.GetSetting("azure.student.container"), studentUniqueId.Trim());
            return uri;
        }

        public async Task<string> GetStaffImageUrlAsync(string staffUniqueId)
        {
            var uri = await GetContainerSasUri(_applicationSettingsProvider.GetSetting("azure.staff.container"), staffUniqueId.Trim());
            return uri;
        }

        public async Task<string> GetParentImageUrlAsync(string parentUniqueId)
        {
            var uri = await GetContainerSasUri(_applicationSettingsProvider.GetSetting("azure.parent.container"), parentUniqueId.Trim());
            return uri;
        }

        public async Task<string> GetStudentImageUrlForAlertsAsync(string studentUniqueId)
        {
            var uri = await GetContainerSasUri(_applicationSettingsProvider.GetSetting("azure.student.container"), studentUniqueId.Trim());
            return uri;
        }

        private async Task<string> GetContainerSasUri(string containerName, string filename)
        {
           
            var blobClient = GetCloudBlobClient();

            var blobReference = GetBlobReference(blobClient, containerName, filename);
            if (blobReference == null)
                blobReference = await GetDefaultBlobReference(blobClient);
           
            //Set the expiry time and permissions for the container.
            //In this case no start time is specified, so the shared access signature becomes valid immediately.
            var sasConstraints = new SharedAccessBlobPolicy
            {
                SharedAccessExpiryTime = DateTimeOffset.UtcNow.AddDays(1),
                Permissions = SharedAccessBlobPermissions.Read
            };

            //Generate the shared access signature on the container, setting the constraints directly on the signature.
            //var sasContainerToken = container.GetSharedAccessSignature(sasConstraints);

            var sasBlobToken = blobReference.GetSharedAccessSignature(sasConstraints);

            //Return the URI string for the container, including the SAS token.
            return blobReference.Uri + sasBlobToken;
        }

        private CloudBlobClient GetCloudBlobClient()
        {
            //Parse the connection string and return a reference to the storage account.
            var storageAccount = CloudStorageAccount.Parse(_applicationSettingsProvider.GetSetting("azure.storage.connectionString"));
            //Return the blob client object.
            return storageAccount.CreateCloudBlobClient();
        } 

        private ICloudBlob GetBlobReference(CloudBlobClient blobClient, string containerName, string filename)
        {
            //Get a reference to a container to use for the sample code, and create it if it does not exist.
            var container = blobClient.GetContainerReference(containerName);

            var bloblist = container.ListBlobs(prefix: filename + ".").OfType<ICloudBlob>();
            return bloblist.FirstOrDefault();
        }

        private async Task<ICloudBlob> GetDefaultBlobReference(CloudBlobClient blobClient)
        {
            var container = blobClient.GetContainerReference(_applicationSettingsProvider.GetSetting("azure.default.image.container"));
            return await container.GetBlobReferenceFromServerAsync(_applicationSettingsProvider.GetSetting("azure.default.image.file"));
        }



        public async Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType)
        {
            var filename = parentUniqueid.Trim();
            var blobClient = GetCloudBlobClient();
            var containerName = _applicationSettingsProvider.GetSetting("azure.parent.container");

            var oldBlobReference = GetBlobReference(blobClient, containerName, filename);

            if (oldBlobReference != null)
                await oldBlobReference.DeleteAsync();

            var container = blobClient.GetContainerReference(containerName);

            var blobReference = container.GetBlockBlobReference(filename + GetFileExtension(contentType));

            await blobReference.UploadFromByteArrayAsync(image, 0, image.Length);
        }


        public async Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType)
        {
            var filename = staffUniqueid.Trim();

            var blobClient = GetCloudBlobClient();
            var containerName = _applicationSettingsProvider.GetSetting("azure.staff.container");

            var oldBlobReference = GetBlobReference(blobClient, containerName, filename);

            if (oldBlobReference != null)
                await oldBlobReference.DeleteAsync();

            var container = blobClient.GetContainerReference(containerName);

            var blobReference = container.GetBlockBlobReference(filename + GetFileExtension(contentType));

            await blobReference.UploadFromByteArrayAsync(image, 0, image.Length);
        }

        private string GetFileExtension(string contentType)
        {

            switch (contentType)
            {
                case "image/jpeg":
                    return ".jpg";
                case "image/png":
                    return ".png";
                default:
                    throw new NotImplementedException($"ContentType {contentType} not Implemented.");
            }
        }
}
}
