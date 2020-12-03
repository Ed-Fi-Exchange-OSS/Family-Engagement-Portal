using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Notifications;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class NotificationsRepository : INotificationsRepository
    {
        private readonly EdFi26Context _edFiDb;
        public NotificationsRepository(EdFi26Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public Task<List<NotificationsIdentifierModel>> GetNotificationModel(string personUniqueId, string personType)
        {
            throw new NotImplementedException();
        }

        public Task SaveNotificationIdentifier(NotificationsIdentifierModel model)
        {
            throw new NotImplementedException();
        }

        //public async Task<List<NotificationsIdentifierModel>> GetNotificationModel(string personUniqueId, string personType)
        //{
        //    return await _edFiDb.NotificationsTokens.Where(n => n.PersonUniqueId.Equals(personUniqueId) && n.PersonType.Equals(personType))
        //                                            .Select(n => new NotificationsIdentifierModel
        //                                            {
        //                                                PersonUniqueId = n.PersonUniqueId,
        //                                                PersonType = n.PersonType,
        //                                                Token = n.Token,
        //                                                DeviceUUID = n.DeviceUuid
        //                                            }).ToListAsync();
        //}

        //public async Task SaveNotificationIdentifier(NotificationsIdentifierModel model)
        //{
        //    var fieldExist = _edFiDb.NotificationsTokens.FirstOrDefault(n => n.PersonUniqueId.Equals(model.PersonUniqueId) && n.DeviceUuid.Equals(model.DeviceUUID));
        //    if(fieldExist != null && fieldExist.Token != model.Token) 
        //    {
        //        fieldExist.Token = model.Token;
        //        fieldExist.LastModifiedDate = DateTime.Now;
        //    }
        //    else 
        //    {
        //        _edFiDb.NotificationsTokens.Add(new NotificationsToken()
        //        {
        //            PersonUniqueId = model.PersonUniqueId,
        //            Token = model.Token,
        //            PersonType = model.PersonType,
        //            DeviceUuid = model.DeviceUUID
        //        });
        //    }
        //    await _edFiDb.SaveChangesAsync();
        //}
    }
}
