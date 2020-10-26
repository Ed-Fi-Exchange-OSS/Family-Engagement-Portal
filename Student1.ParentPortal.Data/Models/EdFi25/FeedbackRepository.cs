using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class FeedbackRepository : IFeedbackRepository
    {
        private readonly EdFi25Context _edFiDb;

        public FeedbackRepository(EdFi25Context edFiDb)
        {
            _edFiDb = edFiDb;
        }


        public async Task<FeedbackLogModel> SaveFeedback(string uniqueId, int personTypeId, string name, string email, FeedbackRequestModel model)
        {
            var newFeedback = new FeedbackLog
            {
                PersonUniqueId = uniqueId,
                Name = name,
                Email = email,
                PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                Subject = model.Subject,
                Issue = model.Issue,
                Description = model.Description,
                CurrentUrl = model.CurrentUrl
            };

            _edFiDb.FeedbackLogs.Add(newFeedback);


            await _edFiDb.SaveChangesAsync();

            return new FeedbackLogModel {
                PersonUniqueId = newFeedback.PersonUniqueId,
                Name = newFeedback.Name,
                Email = newFeedback.Email,
                PersonTypeId = newFeedback.PersonTypeId,
                Subject = newFeedback.Subject,
                Issue = newFeedback.Issue,
                Description = newFeedback.Description,
                CurrentUrl = newFeedback.CurrentUrl,
                CreatedDate = newFeedback.CreateDate
            };
        }
    }
}
