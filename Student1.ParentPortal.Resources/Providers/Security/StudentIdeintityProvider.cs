using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using System.Linq;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class StudentIdeintityProvider : IIdentityProvider
    {
        private readonly Container _container;

        public StudentIdeintityProvider(Container container)
        {
            _container = container;
        }

        //As of when this code was written the teacher identity provider should run after the Admin provider.
        public int Order => 100;

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve db dependency in here.
            var studentRepo = _container.GetInstance<IStudentRepository>();
            var studentIdentity = await studentRepo.GetStudentIdentityByEmailAsync(email);

            // If email doesnt exist on edfi emails or profile emails it isn't a staff, it can't handle so it returns null.
            if (studentIdentity == null || !studentIdentity.Any())
                return null;

            // TODO: handle case where there are duplicates
            var personInfo = studentIdentity.FirstOrDefault();
            personInfo.PersonType = "Student";

            return personInfo;
        }
    }
}
