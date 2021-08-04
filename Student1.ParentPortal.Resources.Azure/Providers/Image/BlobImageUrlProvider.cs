using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Specialized;
using Azure.Storage.Sas;
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
                blobReference = GetDefaultBlobReference(blobClient);

            //Set the expiry time and permissions for the container.
            //In this case no start time is specified, so the shared access signature becomes valid immediately.

            // we generate SAS builder
            var sasBuilder = new BlobSasBuilder()
            {
                BlobContainerName = containerName,
                Resource = "c",
                ExpiresOn = DateTimeOffset.UtcNow.AddDays(1)
            };

            // we specify permissions to only read
            sasBuilder.SetPermissions(BlobContainerSasPermissions.Read);

            //Generate the shared access signature on the container, setting the constraints directly on the signature.
            //var sasContainerToken = container.GetSharedAccessSignature(sasConstraints);

            var sasBlobToken = blobReference.GenerateSasUri(sasBuilder);

            //Return the URI string for the container, including the SAS token.
            return blobReference.Uri + sasBlobToken.AbsoluteUri;
        }

        private BlobServiceClient GetCloudBlobClient()
        {
            //Parse the connection string and return a reference to the storage account.
            //Return the blob client object.
            // can't create without the BlobContainerName Azure SDK
            // reference 
            return new BlobServiceClient(_applicationSettingsProvider.GetSetting("azure.storage.connectionString"));
        }

        private BlockBlobClient GetBlobReference(BlobServiceClient blobClient, string containerName, string filename)
        {
            //Get a reference to a container to use for the sample code, and create it if it does not exist.
            var container = blobClient.GetBlobContainerClient(containerName);

            container.CreateIfNotExists();

            return container.GetBlobs(prefix: filename + ".")
                .OfType<BlockBlobClient>()
                .FirstOrDefault();
        }

        private BlockBlobClient GetDefaultBlobReference(BlobServiceClient blobClient)
        {
            var container = blobClient.GetBlobContainerClient(_applicationSettingsProvider.GetSetting("azure.default.image.container"));
            return container.GetBlockBlobClient(_applicationSettingsProvider.GetSetting("azure.default.image.file"));
        }



        public async Task UploadParentImageAsync(string parentUniqueid, byte[] image, string contentType)
        {
            var filename = parentUniqueid.Trim();
            var blobClient = GetCloudBlobClient();
            var containerName = _applicationSettingsProvider.GetSetting("azure.parent.container");

            var oldBlobReference = GetBlobReference(blobClient, containerName, filename);

            if (oldBlobReference != null)
                await oldBlobReference.DeleteAsync();

            var container = blobClient.GetBlobContainerClient(containerName);

            var blobReference = container.GetBlockBlobClient(filename + GetFileExtension(contentType));

            using (var stream = new MemoryStream(image, writable: false))
            {
                blobReference.Upload(stream);
            }
        }


        public async Task UploadStaffImageAsync(string staffUniqueid, byte[] image, string contentType)
        {
            var filename = staffUniqueid.Trim();

            var blobClient = GetCloudBlobClient();
            var containerName = _applicationSettingsProvider.GetSetting("azure.staff.container");

            var oldBlobReference = GetBlobReference(blobClient, containerName, filename);

            if (oldBlobReference != null)
                await oldBlobReference.DeleteAsync();

            var container = blobClient.GetBlobContainerClient(containerName);

            var blobReference = container.GetBlockBlobClient(filename + GetFileExtension(contentType));

            using (var stream = new MemoryStream(image, writable: false))
            {
                blobReference.Upload(stream);
            }
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
