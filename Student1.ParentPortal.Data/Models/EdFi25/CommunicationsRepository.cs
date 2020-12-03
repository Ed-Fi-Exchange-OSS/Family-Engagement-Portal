using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class CommunicationsRepository : ICommunicationsRepository
    {
        private readonly EdFi25Context _edFiDb;

        public CommunicationsRepository(EdFi25Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<ChatLogHistoryModel> GetThreadByParticipantsAsync(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount, int rowsToRetrieve = 15)
        {
            // Ensures the method returns all unread messages
            var messagesToTake = 0;
            var unreadMessages = unreadMessageCount.HasValue ? unreadMessageCount.Value : await _edFiDb.ChatLogs.CountAsync(x => x.SenderUniqueId == recipientUniqueId && x.SenderTypeId == recipientTypeId && x.RecipientTypeId == senderTypeid && x.RecipientUniqueId == senderUniqueId);

            messagesToTake = unreadMessages > rowsToRetrieve ? unreadMessages : rowsToRetrieve;

            var data = await (from c in _edFiDb.ChatLogs
                              where c.StudentUniqueId == studentUniqueId
                                    && (c.SenderUniqueId == senderUniqueId
                                    && c.RecipientUniqueId == recipientUniqueId
                                    && c.RecipientTypeId == recipientTypeId
                                    && c.SenderTypeId == senderTypeid
                                    || (c.SenderUniqueId == recipientUniqueId
                                    && c.RecipientUniqueId == senderUniqueId
                                    && c.RecipientTypeId == senderTypeid
                                    && c.SenderTypeId == recipientTypeId))
                              orderby c.DateSent descending
                              select c).ToListAsync();

            var dataNeeded = data.Skip(rowsToSkip).Take(messagesToTake).Reverse().ToList();

            dataNeeded.ForEach(x => {
                if (x.RecipientUniqueId.Equals(senderUniqueId))
                    x.RecipientHasRead = true;
            });

            await _edFiDb.SaveChangesAsync();

            var returnList = dataNeeded.Select(x => new ChatLogItemModel
            {
                StudentUniqueId = x.StudentUniqueId,
                SenderUniqueId = x.SenderUniqueId,
                RecipientUniqueId = x.RecipientUniqueId,
                TranslatedMessage = x.OriginalMessage,
                EnglishMessage = x.EnglishMessage,
                DateSent = x.DateSent,
                RecipientTypeId = x.RecipientTypeId,
                SenderTypeId = x.SenderTypeId,
                RecipientHasRead = x.RecipientHasRead
            }).ToList();

            var result = new ChatLogHistoryModel
            {
                Messages = returnList,
                EndOfMessageHistory = rowsToSkip + rowsToRetrieve >= data.Count()
            };

            return result;
        }

        public async Task<ChatLogItemModel> PersistMessage(ChatLogItemModel model)
        {
            var persistModel = new ChatLog();
            persistModel.RecipientUniqueId = model.RecipientUniqueId;
            persistModel.SenderUniqueId = model.SenderUniqueId;
            persistModel.StudentUniqueId = model.StudentUniqueId;
            persistModel.EnglishMessage = model.EnglishMessage;
            persistModel.OriginalMessage = model.TranslatedMessage;
            persistModel.SenderTypeId = model.SenderTypeId;
            persistModel.RecipientTypeId = model.RecipientTypeId;
            persistModel.RecipientHasRead = model.RecipientHasRead;

            _edFiDb.ChatLogs.Add(persistModel);

            await _edFiDb.SaveChangesAsync();

            model.DateSent = persistModel.DateSent;

            return model;
        }

        public async Task<List<UnreadMessageModel>> RecipientUnreadMessages(string recipientUniqueId, int recipientTypeId)
        {

            var result = new List<UnreadMessageModel>();

            if (recipientTypeId == ChatLogPersonTypeEnum.Staff.Value)
            {
                result = await (from ssa in _edFiDb.StudentSectionAssociations
                                join staffsa in _edFiDb.StaffSectionAssociations
                                on new { ssa.LocalCourseCode, ssa.SchoolId, ssa.SchoolYear, ssa.ClassPeriodName, ssa.ClassroomIdentificationCode, ssa.SequenceOfCourse, ssa.TermDescriptorId, ssa.UniqueSectionCode }
                                equals new { staffsa.LocalCourseCode, staffsa.SchoolId, staffsa.SchoolYear, staffsa.ClassPeriodName, staffsa.ClassroomIdentificationCode, staffsa.SequenceOfCourse, staffsa.TermDescriptorId, staffsa.UniqueSectionCode }
                                join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                                join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                                group s by s.StudentUniqueId into g
                                select new UnreadMessageModel
                                {
                                    StudentFirstName = g.FirstOrDefault().FirstName,
                                    StudentMiddleName = g.FirstOrDefault().MiddleName,
                                    StudentLastSurname = g.FirstOrDefault().LastSurname,
                                    StudentUniqueId = g.Key,
                                    StudentUsi = g.FirstOrDefault().StudentUsi,
                                    UnreadMessageCount = _edFiDb.ChatLogs.Count(x => !x.RecipientHasRead && x.RecipientUniqueId == recipientUniqueId && x.RecipientTypeId == recipientTypeId && x.StudentUniqueId == g.FirstOrDefault().StudentUniqueId)

                                }).Where(x => x.UnreadMessageCount > 0).ToListAsync();
            }
            else
            {
                result = await (from s in _edFiDb.Students
                                join spa in _edFiDb.StudentParentAssociations on s.StudentUsi equals spa.StudentUsi
                                join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                                group s by s.StudentUniqueId into g
                                select new UnreadMessageModel
                                {
                                    StudentFirstName = g.FirstOrDefault().FirstName,
                                    StudentMiddleName = g.FirstOrDefault().MiddleName,
                                    StudentLastSurname = g.FirstOrDefault().LastSurname,
                                    StudentUniqueId = g.Key,
                                    StudentUsi = g.FirstOrDefault().StudentUsi,
                                    UnreadMessageCount = _edFiDb.ChatLogs.Count(x => !x.RecipientHasRead && x.RecipientUniqueId == recipientUniqueId && x.RecipientTypeId == recipientTypeId && x.StudentUniqueId == g.FirstOrDefault().StudentUniqueId)
                                }).Where(x => x.UnreadMessageCount > 0)
                             .ToListAsync();
            }

            return result.ToList();
        }

        public async Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, DateTime today)
        {

            var parents = from staffsa in _edFiDb.StaffSectionAssociations
                          join ssa in _edFiDb.StudentSectionAssociations
                                 on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.LocalCourseCode, staffsa.SequenceOfCourse, staffsa.TermDescriptorId, staffsa.UniqueSectionCode }
                                 equals new { ssa.SchoolId, ssa.SchoolYear, ssa.LocalCourseCode, ssa.SequenceOfCourse, ssa.TermDescriptorId, ssa.UniqueSectionCode }
                          join shsa in _edFiDb.StudentSchoolAssociations on new { ssa.StudentUsi, ssa.SchoolId } equals new { shsa.StudentUsi, shsa.SchoolId }
                          join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                          join co in _edFiDb.CourseOfferings
                                    on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.TermDescriptorId, staffsa.LocalCourseCode }
                                    equals new { co.SchoolId, co.SchoolYear, co.TermDescriptorId, co.LocalCourseCode }
                          join s in _edFiDb.Students
                                      on ssa.StudentUsi equals s.StudentUsi
                          join p in _edFiDb.Parents
                                      on spa.ParentUsi equals p.ParentUsi
                          join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                          join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                          where staff.StaffUniqueId == recipientUniqueId && sy.CurrentSchoolYear
                          group new { s, p, co } by new { s.StudentUsi, p.ParentUsi } into g
                          select new
                          {
                              StudentFirstName = g.FirstOrDefault().s.FirstName,
                              StudentMiddleName = g.FirstOrDefault().s.MiddleName,
                              StudentLastSurname = g.FirstOrDefault().s.LastSurname,
                              StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                              StudentUsi = g.FirstOrDefault().s.StudentUsi,
                              Usi = g.Key.ParentUsi,
                              UniqueId = g.FirstOrDefault().p.ParentUniqueId,
                              FirstName = g.FirstOrDefault().p.FirstName,
                              MiddleName = g.FirstOrDefault().p.MiddleName,
                              LastSurname = g.FirstOrDefault().p.LastSurname,
                              PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                              CourseTitles = g.Select(x => x.co.LocalCourseTitle),
                          };

            var studentParents = await parents.GroupBy(x => x.StudentUsi).Select(x => new StudentRecipients
            {
                StudentUsi = x.Key,
                StudentUniqueId = x.FirstOrDefault().StudentUniqueId,
                FirstName = x.FirstOrDefault().FirstName,
                MiddleName = x.FirstOrDefault().MiddleName,
                LastSurname = x.FirstOrDefault().LastSurname,
                RelationsToStudent = x.FirstOrDefault().CourseTitles.ToList(),
                Recipients = x.Select(recipient => new RecipientModel
                {
                    FirstName = recipient.FirstName,
                    LastSurname = recipient.LastSurname,
                    Usi = recipient.Usi,
                    UniqueId = recipient.UniqueId,
                    PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                }).ToList()
            }).ToListAsync();

            var totalRecipients = studentParents.Count();

            List<StudentRecipients> result = new List<StudentRecipients>();


            // If they selected a Student
            if (studentUsi.HasValue)
                result.Add(studentParents.FirstOrDefault(x => x.StudentUsi == studentUsi.Value));

            var unreadMessages = studentParents.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                    _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                    && c.RecipientUniqueId == recipientUniqueId
                                                    && c.RecipientTypeId == recipientTypeId
                                                    && c.StudentUniqueId == x.StudentUniqueId
                                                    && x.Recipients
                                                            .Any(r => r.UniqueId == c.SenderUniqueId && r.PersonTypeId == c.SenderTypeId)) > 0)
                                                    .Select(x => {
                                                        foreach (var recipient in x.Recipients)
                                                        {
                                                            recipient.UnreadMessageCount = _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                                && c.RecipientUniqueId == recipientUniqueId
                                                                && c.RecipientTypeId == recipientTypeId
                                                                && c.StudentUniqueId == x.StudentUniqueId
                                                                && recipient.UniqueId == c.SenderUniqueId
                                                                && recipient.PersonTypeId == c.SenderTypeId);
                                                        }
                                                        return x;
                                                    })
                                                    .ToList();

            var recentMessages = studentParents.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                    _edFiDb.ChatLogs.Count(c =>
                                                    ((c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                    || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId))
                                                    && c.StudentUniqueId == x.StudentUniqueId
                                                    && !unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)
                                                    && x.Recipients
                                                            .Any(r => (r.UniqueId == c.SenderUniqueId && r.PersonTypeId == c.SenderTypeId)
                                                            || (r.UniqueId == c.RecipientUniqueId && r.PersonTypeId == c.RecipientTypeId))) > 0).ToList();


            var otherMessages = studentParents.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                !(unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)
                                                || recentMessages.Any(rm => rm.StudentUniqueId == x.StudentUniqueId))).ToList();

            result.AddRange(unreadMessages);
            result.AddRange(recentMessages);
            result.AddRange(otherMessages);

            var model = new AllRecipients
            {
                EndOfData = totalRecipients <= rowsToSkip + rowsToRetrieve,
                StudentRecipients = result.Skip(rowsToSkip).Take(rowsToRetrieve).ToList()
            };

            return model;
        }


        public async Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, string[] validLeadersDescriptors, DateTime today)
        {

            var teachers = await (from staffsa in _edFiDb.StaffSectionAssociations
                                  join ssa in _edFiDb.StudentSectionAssociations
                                     on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.LocalCourseCode, staffsa.SequenceOfCourse, staffsa.TermDescriptorId, staffsa.UniqueSectionCode }
                                     equals new { ssa.SchoolId, ssa.SchoolYear, ssa.LocalCourseCode, ssa.SequenceOfCourse, ssa.TermDescriptorId, ssa.UniqueSectionCode }
                                  join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                                  join co in _edFiDb.CourseOfferings
                                            on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.TermDescriptorId, staffsa.LocalCourseCode }
                                            equals new { co.SchoolId, co.SchoolYear, co.TermDescriptorId, co.LocalCourseCode }
                                  join s in _edFiDb.Students
                                              on ssa.StudentUsi equals s.StudentUsi
                                  join p in _edFiDb.Parents
                                              on spa.ParentUsi equals p.ParentUsi
                                  join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                                  join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                                  where p.ParentUniqueId == recipientUniqueId && sy.CurrentSchoolYear
                                  group new { s, staff, co } by new { s.StudentUsi, staff.StaffUsi } into g
                                  select new
                                  {
                                      StudentFirstName = g.FirstOrDefault().s.FirstName,
                                      StudentMiddleName = g.FirstOrDefault().s.MiddleName,
                                      StudentLastsurname = g.FirstOrDefault().s.LastSurname,
                                      StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                      StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                      Usi = g.Key.StaffUsi,
                                      UniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                      FirstName = g.FirstOrDefault().staff.FirstName,
                                      MiddleName = g.FirstOrDefault().staff.MiddleName,
                                      LastSurname = g.FirstOrDefault().staff.LastSurname,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      CourseTitles = g.Select(x => x.co.LocalCourseTitle)
                                  }).ToListAsync();

            var campusLeaders = await (from seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations
                                       join seoa in _edFiDb.StudentEducationOrganizationAssociations on seoaa.EducationOrganizationId equals seoa.EducationOrganizationId
                                       join s in _edFiDb.Students on seoa.StudentUsi equals s.StudentUsi
                                       join staff in _edFiDb.Staffs on seoaa.StaffUsi equals staff.StaffUsi
                                       join spa in _edFiDb.StudentParentAssociations on s.StudentUsi equals spa.StudentUsi
                                       join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                                       where validLeadersDescriptors.Contains(seoaa.PositionTitle) && p.ParentUniqueId == recipientUniqueId
                                       group new { s, staff, seoaa } by new { s.StudentUsi, staff.StaffUsi } into g
                                       select new
                                       {
                                           StudentUsi = g.Key.StudentUsi,
                                           StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                           StudentFirstName = g.FirstOrDefault().s.FirstName,
                                           StudentMiddleName = g.FirstOrDefault().s.MiddleName,
                                           StudentLastSurname = g.FirstOrDefault().s.LastSurname,
                                           FirstName = g.FirstOrDefault().staff.FirstName,
                                           LastSurname = g.FirstOrDefault().staff.LastSurname,
                                           Usi = g.FirstOrDefault().staff.StaffUsi,
                                           UniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                           PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                           RelationsToStudent = g.FirstOrDefault().seoaa.PositionTitle,
                                       }).ToListAsync();

            var studentLeaderStaff = campusLeaders.GroupBy(x => x.StudentUsi)
                .Select(x => new StudentRecipients
                {
                    StudentUsi = x.Key,
                    StudentUniqueId = x.FirstOrDefault().StudentUniqueId,
                    FirstName = x.FirstOrDefault().StudentFirstName,
                    MiddleName = x.FirstOrDefault().StudentMiddleName,
                    LastSurname = x.FirstOrDefault().StudentLastSurname,
                    Recipients = x.Select(recipient => new RecipientModel
                    {
                        FirstName = recipient.FirstName,
                        LastSurname = recipient.LastSurname,
                        Usi = recipient.Usi,
                        UniqueId = recipient.UniqueId,
                        PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                        RelationsToStudent = new List<string> { recipient.RelationsToStudent },
                    }).ToList()
                }).ToList();

            var studentStaff = teachers.GroupBy(x => x.StudentUsi).Select(x => new StudentRecipients
            {
                StudentUsi = x.Key,
                StudentUniqueId = x.FirstOrDefault().StudentUniqueId,
                FirstName = x.FirstOrDefault().FirstName,
                MiddleName = x.FirstOrDefault().MiddleName,
                LastSurname = x.FirstOrDefault().LastSurname,
                Recipients = x.Select(recipient => new RecipientModel
                {
                    FirstName = recipient.FirstName,
                    LastSurname = recipient.LastSurname,
                    Usi = recipient.Usi,
                    UniqueId = recipient.UniqueId,
                    PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                    RelationsToStudent = recipient.CourseTitles.ToList(),
                }).ToList()
            }).ToList();

            foreach (var ss in studentStaff)
            {
                var recipientsLeaders = studentLeaderStaff.FirstOrDefault(x => x.StudentUsi == ss.StudentUsi).Recipients;
                ss.Recipients = ss.Recipients.Concat(recipientsLeaders).ToList();
            }

            var totalRecipients = studentStaff.Count();

            List<StudentRecipients> result = new List<StudentRecipients>();


            // If they selected a Student
            if (studentUsi.HasValue)
                result.Add(studentStaff.FirstOrDefault(x => x.StudentUsi == studentUsi.Value));

            var unreadMessages = studentStaff.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                    _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                    && c.RecipientUniqueId == recipientUniqueId
                                                    && c.RecipientTypeId == recipientTypeId
                                                    && c.StudentUniqueId == x.StudentUniqueId
                                                    && x.Recipients
                                                            .Any(r => r.UniqueId == c.SenderUniqueId && r.PersonTypeId == c.SenderTypeId)) > 0)
                                                    .Select(x => {
                                                        foreach (var recipient in x.Recipients)
                                                        {
                                                            recipient.UnreadMessageCount = _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                                && c.RecipientUniqueId == recipientUniqueId
                                                                && c.RecipientTypeId == recipientTypeId
                                                                && c.StudentUniqueId == x.StudentUniqueId
                                                                && recipient.UniqueId == c.SenderUniqueId
                                                                && recipient.PersonTypeId == c.SenderTypeId);
                                                        }
                                                        return x;
                                                    })
                                                    .ToList();

            var recentMessages = studentStaff.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                    _edFiDb.ChatLogs.Count(c =>
                                                    ((c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                    || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId))
                                                    && c.StudentUniqueId == x.StudentUniqueId
                                                    && !unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)
                                                    && x.Recipients
                                                            .Any(r => (r.UniqueId == c.SenderUniqueId && r.PersonTypeId == c.SenderTypeId)
                                                            || (r.UniqueId == c.RecipientUniqueId && r.PersonTypeId == c.RecipientTypeId))) > 0).ToList();


            var otherMessages = studentStaff.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                !(unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)
                                                || recentMessages.Any(rm => rm.StudentUniqueId == x.StudentUniqueId))).ToList();

            result.AddRange(unreadMessages);
            result.AddRange(recentMessages);
            result.AddRange(otherMessages);

            var model = new AllRecipients
            {
                EndOfData = totalRecipients <= rowsToSkip + rowsToRetrieve,
                StudentRecipients = result.Skip(rowsToSkip).Take(rowsToRetrieve).ToList()
            };

            return model;
        }

        public async Task<int> UnreadMessageCount(int studentUsi, string recipientUniqueId, int recipientTypeId, string senderUniqueid, int? senderTypeId)
        {
            var result = await (from c in _edFiDb.ChatLogs
                                join s in _edFiDb.Students on c.StudentUniqueId equals s.StudentUniqueId
                                where s.StudentUsi == studentUsi && !c.RecipientHasRead
                                && c.RecipientUniqueId == recipientUniqueId && c.RecipientTypeId == recipientTypeId
                                && (senderUniqueid != null ? (c.SenderUniqueId == senderUniqueid && c.SenderTypeId == senderTypeId) : true)
                                select c).CountAsync();

            return result;
        }

        public async Task SetRecipientRead(ChatLogItemModel model)
        {
            var dbModel = _edFiDb.ChatLogs
                .Where(x => x.RecipientUniqueId == model.RecipientUniqueId &&
                        x.RecipientTypeId == model.RecipientTypeId &&
                        x.SenderUniqueId == model.SenderUniqueId &&
                        x.SenderTypeId == model.SenderTypeId &&
                        x.StudentUniqueId == model.StudentUniqueId)
                .OrderByDescending(x => x.DateSent).FirstOrDefault();

            dbModel.RecipientHasRead = true;

            await _edFiDb.SaveChangesAsync();
        }

        private string[] GetSearchValues(string searchValue)
        {
            searchValue = searchValue.Trim();

            if (searchValue.Contains(" "))
                return searchValue.Split(' ');

            return new string[] { searchValue };
        }

        public async Task<AllRecipients> GetAllStaffBriefRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {
            var parents = await (from seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations
                                 join sta in _edFiDb.Staffs on seoaa.StaffUsi equals sta.StaffUsi
                                 join ssa in _edFiDb.StudentSchoolAssociations on seoaa.EducationOrganizationId equals ssa.EducationOrganizationId
                                 join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                                 join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                                 join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                                 from pro in _edFiDb.ParentProfiles.Where(pro => p != null && p.ParentUniqueId == pro.ParentUniqueId).DefaultIfEmpty()
                                 from cl in _edFiDb.ChatLogs.Where(cl => cl.RecipientUniqueId == sta.StaffUniqueId && cl.SenderUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                                 where sta.StaffUniqueId == recipientUniqueId
                                 group new { s, p, pro } by s.StudentUsi into g
                                 select new StudentRecipients
                                 {
                                     StudentUsi = g.Key,
                                     StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                     FirstName = g.FirstOrDefault().s.FirstName,
                                     MiddleName = g.FirstOrDefault().s.MiddleName,
                                     LastSurname = g.FirstOrDefault().s.LastSurname,
                                     MostRecentMessageDate = _edFiDb.ChatLogs.Where(c =>
                                                     (c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                     || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                     && c.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId).Max(x => x.DateSent),
                                     Recipients = g.Where(x => x.p != null).Select(recipient => new RecipientModel
                                     {
                                         FirstName = recipient.p.FirstName,
                                         LastSurname = recipient.p.LastSurname,
                                         Usi = recipient.p.ParentUsi,
                                         UniqueId = recipient.p.ParentUniqueId,
                                         PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                                         ReplyExpectations = recipient.pro != null ? recipient.pro.ReplyExpectations : "",
                                         UnreadMessageCount = _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                                 && c.RecipientUniqueId == recipientUniqueId
                                                                 && c.RecipientTypeId == recipientTypeId
                                                                 && c.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId
                                                                 && recipient.p.ParentUniqueId == c.SenderUniqueId
                                                                 && ChatLogPersonTypeEnum.Parent.Value == c.SenderTypeId)
                                     }).ToList(),
                                 }).ToListAsync();

            var totalRecipients = parents.Count();

            List<StudentRecipients> result = new List<StudentRecipients>();

            // If they selected a student
            if (studentUsi.HasValue)
                result.Add(parents.FirstOrDefault(x => x.StudentUsi == studentUsi.Value));

            var unreadMessages = parents.Where(x => x.UnreadMessageCount > 0 && (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true)).ToList();

            parents = parents.Where(x => !unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)).ToList();

            var recentMessages = parents.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true)
            && x.MostRecentMessageDate != null).OrderByDescending(x => x.MostRecentMessageDate).ToList();

            parents = parents.Where(x => !recentMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)).ToList();

            var otherMessages = parents.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true)).ToList();

            result.AddRange(unreadMessages);
            result.AddRange(recentMessages);
            result.AddRange(otherMessages);

            var model = new AllRecipients
            {
                EndOfData = totalRecipients <= rowsToSkip + rowsToRetrieve,
                StudentRecipients = result.Skip(rowsToSkip).Take(rowsToRetrieve).ToList()
            };

            return model;
        }

        public async Task<List<UnreadMessageModel>> RecipientUnreadBriefMessages(string recipientUniqueId, int recipientTypeId)
        {
            var result = new List<UnreadMessageModel>();

            if (recipientTypeId == ChatLogPersonTypeEnum.Staff.Value)
            {
                result = await (from seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations
                                join sta in _edFiDb.Staffs on seoaa.StaffUsi equals sta.StaffUsi
                                join ssa in _edFiDb.StudentSchoolAssociations on seoaa.EducationOrganizationId equals ssa.SchoolId
                                join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                                join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                                join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                                where sta.StaffUniqueId == recipientUniqueId
                                group new { p, s } by new { s.StudentUsi } into g
                                select new UnreadMessageModel
                                {
                                    FirstName = g.FirstOrDefault().p.FirstName,
                                    LastSurname = g.FirstOrDefault().p.LastSurname,
                                    UniqueId = g.FirstOrDefault().p.ParentUniqueId,
                                    Usi = g.FirstOrDefault().p.ParentUsi,
                                    StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                    StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                    StudentFirstName = g.FirstOrDefault().s.FirstName,
                                    StudentLastSurname = g.FirstOrDefault().s.LastSurname,
                                    OldestMessageDateSent = _edFiDb.ChatLogs.Where(c =>
                                                     (c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                     || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                     && c.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId).Max(x => x.DateSent),
                                    UnreadMessageCount = _edFiDb.ChatLogs.Count(x => !x.RecipientHasRead && x.RecipientUniqueId == recipientUniqueId && x.RecipientTypeId == recipientTypeId && x.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId)
                                }).Where(x => x.UnreadMessageCount > 0).ToListAsync();

            }
            return result.ToList();
        }

        public async Task<ParentStudentCountModel> GetFamilyMembersByGradesAndPrograms(int staffUsi, ParentStudentCountFilterModel model, string[] validParentDescriptors, DateTime today)
        {
            //Here we got the information for the school first 
            var school = await (from s in _edFiDb.Schools
                                            .Include(x => x.EducationOrganization)
                                join sf in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.SchoolId equals sf.EducationOrganizationId
                                where sf.StaffUsi == staffUsi && s.SchoolId == model.SchoolId
                                select new
                                {
                                    s.EducationOrganization.EducationOrganizationId,
                                    s.EducationOrganization.NameOfInstitution
                                }).FirstOrDefaultAsync();

            //ToDo: refactor and join in 25 version
            var result = await (from s in _edFiDb.Students
                                join pa in _edFiDb.StudentParentAssociations on s.StudentUsi equals pa.StudentUsi
                                join pt in _edFiDb.Parents on pa.ParentUsi equals pt.ParentUsi
                                join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                join edorg in _edFiDb.EducationOrganizations on ssa.SchoolId equals edorg.EducationOrganizationId
                                join spa in _edFiDb.StudentProgramAssociations on s.StudentUsi equals spa.StudentUsi
                                join p in _edFiDb.Programs on spa.ProgramName equals p.ProgramName
                                //join d in _edFiDb.Descriptors on spa.ProgramTypeDescriptorId equals d.DescriptorId
                                where edorg.EducationOrganizationId == school.EducationOrganizationId
                                //&& s.StudentParentAssociations.Any(spa => validParentDescriptors.Contains(spa.RelationDescriptor.Descriptor.CodeValue))
                                //&& model.Programs.Contains(spa.ProgramTypeDescriptorId)
                                && model.Grades.Contains(ssa.EntryGradeLevelDescriptorId)
                                group new { pt, s } by new { pt.ParentUsi } into g
                                select new ParentStudentCountModel
                                {
                                    FamilyMembersCount = g.Count(),
                                    StudentsCount = g.Count(),
                                    CampusName = school.NameOfInstitution,
                                }).FirstOrDefaultAsync();
            return result;
        }

        public async Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndPrograms(int staffUsi, int[] grades, int[] programs, string[] validParentDescriptors, string[] validEmailTypeDescriptors, DateTime today)
        {
            //Here we got the information for the school first 
            var schoolId = await (from s in _edFiDb.Schools
                                  join sf in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.SchoolId equals sf.EducationOrganizationId
                                  where sf.StaffUsi == staffUsi
                                  select s.SchoolId).FirstOrDefaultAsync();

            var baseQuery = (from p in _edFiDb.Parents
                             join pe in _edFiDb.ParentElectronicMails on p.ParentUsi equals pe.ParentUsi
                             //join ped in _edFiDb.Descriptors on pe.ElectronicMailTypeDescriptorId equals ped.DescriptorId
                             join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                             //join dspa in _edFiDb.Descriptors on spa.RelationDescriptorId equals dspa.DescriptorId
                             join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                             join studsec in _edFiDb.StudentSectionAssociations
                                        on new { s.StudentUsi, ssa.SchoolId }
                                        equals new { studsec.StudentUsi, studsec.SchoolId }
                                        //join sess in _edFiDb.Sessions
                                        //            on new { studsec.SchoolId, studsec.SessionName, studsec.SchoolYear }
                                        //            equals new { sess.SchoolId, sess.SessionName, sess.SchoolYear }
                                        //join sy in _edFiDb.SchoolYearTypes on sess.SchoolYear equals sy.SchoolYear

                                        // Left join
                                        //from seoapp in _edFiDb.StudentEducationOrganizationAssociationProgramParticipations.Where(x => x.EducationOrganizationId == ssa.SchoolId).DefaultIfEmpty()
                                        //from ptd in _edFiDb.Descriptors.Where(x => x.DescriptorId == seoapp.ProgramTypeDescriptorId).DefaultIfEmpty()
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             from ppe in _edFiDb.ParentProfileElectronicMails
                                 .Where(x => x.ParentUniqueId == p.ParentUniqueId && x.PrimaryEmailAddressIndicator == true)
                                 .DefaultIfEmpty()
                             from ppt in _edFiDb.ParentProfileTelephones.Where(x =>
                                 x.ParentUniqueId == p.ParentUniqueId && x.PrimaryMethodOfContact == true &&
                                 x.TextMessageCapabilityIndicator == true).DefaultIfEmpty()
                             from pptc in _edFiDb.TextMessageCarrierTypes
                                 .Where(x => x.TextMessageCarrierTypeId == ppt.TelephoneCarrierTypeId).DefaultIfEmpty()
                             where ssa.SchoolId == schoolId
                             //&& sy.CurrentSchoolYear
                             //&& sess.BeginDate <= startDate && sess.EndDate >= endDate
                             //&& sess.BeginDate <= DateTime.Now && sess.EndDate >= DateTime.Now
                             //&& validParentDescriptors.Contains(dspa.CodeValue)
                             //&& validEmailTypeDescriptors.Contains(ped.CodeValue)
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,
                                 EdFiEmail = pe.ElectronicMailAddress,
                                 ProfileEmail = ppe.ElectronicMailAddress,
                                 ProfileTelephone = ppt.TelephoneNumber,
                                 ProfileTelephoneSMSSuffixDomain = pptc.SmsSuffixDomain,
                                 LanguageCode = pp.LanguageCode,
                                 // This validation is for prod database, the PreferredMethodOfContactTypeId some times is null
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId != null ? pp.PreferredMethodOfContactTypeId : 0,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Grade and Programs info for filtering,
                                 Grades = ssa.EntryGradeLevelDescriptorId,
                                 //Programs = ptd.DescriptorId
                             });

            if (grades.Length > 0)
                baseQuery = baseQuery.Where(x => grades.Contains(x.Grades));

            //if (programs.Length > 0)
            //    baseQuery = baseQuery.Where(x => programs.Contains(x.Programs));

            var query = (from q in baseQuery
                         group new { q } by new { q.ParentUsi } into g
                         select new ParentStudentsModel
                         {
                             ParentUsi = g.FirstOrDefault().q.ParentUsi,
                             ParentUniqueId = g.FirstOrDefault().q.ParentUniqueId,
                             ParentFirstName = g.FirstOrDefault().q.ParentFirstName,
                             ParentLastSurname = g.FirstOrDefault().q.ParentLastSurname,
                             EdFiEmail = g.FirstOrDefault().q.EdFiEmail,
                             ProfileEmail = g.FirstOrDefault().q.ProfileEmail,
                             ProfileTelephone = g.FirstOrDefault().q.ProfileTelephone,
                             ProfileTelephoneSMSSuffixDomain = g.FirstOrDefault().q.ProfileTelephoneSMSSuffixDomain,
                             LanguageCode = g.FirstOrDefault().q.LanguageCode,
                             PreferredMethodOfContactTypeId = g.FirstOrDefault().q.PreferredMethodOfContactTypeId,
                             StudentFirstName = g.FirstOrDefault().q.StudentFirstName,
                             StudentLastSurname = g.FirstOrDefault().q.StudentLastSurname,
                             StudentUsi = g.FirstOrDefault().q.StudentUsi,
                             StudentUniqueId = g.FirstOrDefault().q.StudentUniqueId
                         });

            var studentsAssociatedWithStaff = await query.ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task<GroupMessagesQueueLogModel> PersistQueueGroupMessage(GroupMessagesQueueLogModel model)
        {
            var persisModel = new GroupMessagesQueueLog();
            persisModel.Type = model.Type;
            persisModel.QueuedDateTime = model.QueuedDateTime;
            persisModel.StaffUniqueIdSent = model.StaffUniqueId;
            persisModel.SchoolId = model.SchoolId;
            persisModel.Audience = model.Audience;
            persisModel.FilterParams = model.FilterParams;
            persisModel.Subject = model.Subject;
            persisModel.Body = model.BodyMessage;
            persisModel.SentStatus = model.SentStatus;
            persisModel.Data = model.Data;

            _edFiDb.GroupMessagesQueueLogs.Add(persisModel);

            await _edFiDb.SaveChangesAsync();

            return model;
        }

        public async Task<GroupMessagesChatLogModel> PersistChatGroupMessage(GroupMessagesChatLogModel model)
        {
            var persistModel = new GroupMessagesLogChatLog();
            persistModel.GroupMessagesLogId = model.GroupMessagesLogId;
            persistModel.ChatLogId = model.ChatLogId;
            persistModel.Status = model.Status.Value;
            persistModel.ErrorMessage = model.ErrorMessage;

            _edFiDb.GroupMessagesLogChatLogs.Add(persistModel);

            await _edFiDb.SaveChangesAsync();

            return model;
        }

        public async Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndPrograms(string personUniqueId, int[] grades, int[] programs, string[] validParentDescriptors, string[] validEmailTypeDescriptors, DateTime today)
        {
            //Here we got the information for the school first 
            var schoolId = await (from s in _edFiDb.Schools
                                  join sf in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.SchoolId equals sf.EducationOrganizationId
                                  join stf in _edFiDb.Staffs on sf.StaffUsi equals stf.StaffUsi
                                  where stf.StaffUniqueId == personUniqueId
                                  select s.SchoolId).FirstOrDefaultAsync();

            var baseQuery = (from p in _edFiDb.Parents
                             join pe in _edFiDb.ParentElectronicMails on p.ParentUsi equals pe.ParentUsi
                             //join ped in _edFiDb.Descriptors on pe.ElectronicMailTypeDescriptorId equals ped.DescriptorId
                             join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                             //join dspa in _edFiDb.Descriptors on spa.RelationDescriptorId equals dspa.DescriptorId
                             join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                             join studsec in _edFiDb.StudentSectionAssociations
                                        on new { s.StudentUsi, ssa.SchoolId }
                                        equals new { studsec.StudentUsi, studsec.SchoolId }
                                        //join sess in _edFiDb.Sessions
                                        //            on new { studsec.SchoolId, studsec.SessionName, studsec.SchoolYear }
                                        //            equals new { sess.SchoolId, sess.SessionName, sess.SchoolYear }
                                        //join sy in _edFiDb.SchoolYearTypes on sess.SchoolYear equals sy.SchoolYear
                                        // Left join
                                        //from seoapp in _edFiDb.StudentEducationOrganizationAssociationProgramParticipations.Where(x => x.EducationOrganizationId == ssa.SchoolId).DefaultIfEmpty()
                                        //from ptd in _edFiDb.Descriptors.Where(x => x.DescriptorId == seoapp.ProgramTypeDescriptorId).DefaultIfEmpty()
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             from ppe in _edFiDb.ParentProfileElectronicMails
                                 .Where(x => x.ParentUniqueId == p.ParentUniqueId && x.PrimaryEmailAddressIndicator == true)
                                 .DefaultIfEmpty()
                             from ppt in _edFiDb.ParentProfileTelephones.Where(x =>
                                 x.ParentUniqueId == p.ParentUniqueId && x.PrimaryMethodOfContact == true &&
                                 x.TextMessageCapabilityIndicator == true).DefaultIfEmpty()
                             from pptc in _edFiDb.TextMessageCarrierTypes
                                 .Where(x => x.TextMessageCarrierTypeId == ppt.TelephoneCarrierTypeId).DefaultIfEmpty()
                             where ssa.SchoolId == schoolId
                             //&& sy.CurrentSchoolYear
                             //&& sess.BeginDate <= today && sess.EndDate >= today
                             //&& validParentDescriptors.Contains(dspa.CodeValue)
                             //&& validEmailTypeDescriptors.Contains(ped.CodeValue)
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,
                                 EdFiEmail = pe.ElectronicMailAddress,
                                 ProfileEmail = ppe.ElectronicMailAddress,
                                 ProfileTelephone = ppt.TelephoneNumber,
                                 ProfileTelephoneSMSSuffixDomain = pptc.SmsSuffixDomain,
                                 LanguageCode = pp.LanguageCode,
                                 // This validation is for prod database, the PreferredMethodOfContactTypeId some times is null
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId != null ? pp.PreferredMethodOfContactTypeId : 0,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Grade and Programs info for filtering,
                                 Grades = ssa.EntryGradeLevelDescriptorId,
                                 //Programs = ptd.DescriptorId
                             });

            if (grades.Length > 0)
                baseQuery = baseQuery.Where(x => grades.Contains(x.Grades));

            //if (programs.Length > 0)
            //    baseQuery = baseQuery.Where(x => programs.Contains(x.Programs));

            var query = (from q in baseQuery
                         group new { q } by q.StudentUsi into g
                         select new ParentStudentsModel
                         {
                             ParentUsi = g.FirstOrDefault().q.ParentUsi,
                             ParentUniqueId = g.FirstOrDefault().q.ParentUniqueId,
                             ParentFirstName = g.FirstOrDefault().q.ParentFirstName,
                             ParentLastSurname = g.FirstOrDefault().q.ParentLastSurname,
                             EdFiEmail = g.FirstOrDefault().q.EdFiEmail,
                             ProfileEmail = g.FirstOrDefault().q.ProfileEmail,
                             ProfileTelephone = g.FirstOrDefault().q.ProfileTelephone,
                             ProfileTelephoneSMSSuffixDomain = g.FirstOrDefault().q.ProfileTelephoneSMSSuffixDomain,
                             LanguageCode = g.FirstOrDefault().q.LanguageCode,
                             PreferredMethodOfContactTypeId = g.FirstOrDefault().q.PreferredMethodOfContactTypeId,
                             StudentFirstName = g.FirstOrDefault().q.StudentFirstName,
                             StudentLastSurname = g.FirstOrDefault().q.StudentLastSurname,
                             StudentUsi = g.FirstOrDefault().q.StudentUsi,
                             StudentUniqueId = g.FirstOrDefault().q.StudentUniqueId
                         });

            var studentsAssociatedWithStaff = await query.ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueuesQueued()
        {
            // Get the metadata for the status:"queued",  and "Error" with a retry count less than 4.
            var model = await (from gmq in _edFiDb.GroupMessagesQueueLogs
                               where gmq.SentStatus == GroupMessagesStatusEnum.Queued.Value
                                     || (gmq.SentStatus == GroupMessagesStatusEnum.Error.Value && gmq.RetryCount < 4)
                               select new GroupMessagesQueueLogModel
                               {
                                   Id = gmq.Id,
                                   SentStatus = gmq.SentStatus,
                                   FilterParams = gmq.FilterParams,
                                   StaffUniqueId = gmq.StaffUniqueIdSent,
                                   SchoolId = gmq.SchoolId,
                                   QueuedDateTime = gmq.QueuedDateTime,
                                   Type = gmq.Type,
                                   Audience = gmq.Audience,
                                   BodyMessage = gmq.Body,
                                   Subject = gmq.Subject,
                                   Data = gmq.Data
                               }).OrderBy(x => x.QueuedDateTime).ToListAsync();
            return model;
        }

        public async Task<GroupMessagesQueueLogModel> UpdateGroupMessagesQueue(GroupMessagesQueueLogModel model)
        {
            var updateModel = await (from gmq in _edFiDb.GroupMessagesQueueLogs
                                     where gmq.Id == model.Id
                                     select gmq).FirstOrDefaultAsync();


            updateModel.DateSent = model.DateSent;
            updateModel.Audience = model.Audience;
            updateModel.SentStatus = model.SentStatus;
            updateModel.RetryCount = model.RetryCount;

            await _edFiDb.SaveChangesAsync();

            var returnModel = new GroupMessagesQueueLogModel
            {
                Id = updateModel.Id,
                Audience = updateModel.Audience,
                SchoolId = updateModel.SchoolId,
                FilterParams = updateModel.FilterParams,
                SentStatus = updateModel.SentStatus,
                StaffUniqueId = updateModel.StaffUniqueIdSent,
                QueuedDateTime = updateModel.QueuedDateTime,
                Type = updateModel.Type,
                Subject = updateModel.Subject,
                BodyMessage = updateModel.Body,
                RetryCount = updateModel.RetryCount,
                DateSent = updateModel.DateSent,
                Data = updateModel.Data
            };
            return returnModel;
        }

        public async Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndSearchTerm(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today, int schoolId)
        {
            int studentUniqueId = 0;
            string firstName = "", lastName = "";
            var searchName = new List<string>();
            var isStudentId = int.TryParse(term, out studentUniqueId);

            if (!string.IsNullOrEmpty(term) && !isStudentId)
            {
                searchName = term.Split(' ').ToList();
                firstName = searchName[0];
                lastName = searchName.Count > 1 ? searchName[1] : string.Empty;
            }


            var queryBase = (from p in _edFiDb.Parents
                             join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                             join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                             join studsec in _edFiDb.StudentSectionAssociations
                                        on new { s.StudentUsi, ssa.SchoolId }
                                        equals new { studsec.StudentUsi, studsec.SchoolId }
                             join sess in _edFiDb.Sessions
                                         on new { studsec.SchoolId, studsec.SchoolYear }
                                         equals new { sess.SchoolId, sess.SchoolYear }
                             join sy in _edFiDb.SchoolYearTypes on sess.SchoolYear equals sy.SchoolYear
                             // Left join
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             where ssa.SchoolId == schoolId
                                   && sy.CurrentSchoolYear
                                   && sess.BeginDate <= today && sess.EndDate >= today
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,
                                 LanguageCode = pp.LanguageCode,

                                 // This validation is for prod database, the PreferredMethodOfContactTypeId some times is null
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId != null ? pp.PreferredMethodOfContactTypeId : 0,
                                 ParentRelation = spa.EmergencyContactStatus == true ? "Emergency Contact" : "Parent",

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Grade and Programs info for filtering,
                                 GradeLevelId = gld.DescriptorId,
                                 GradeLevel = gld.CodeValue
                             });

            if (string.IsNullOrEmpty(term))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             select q);
            }

            if (isStudentId)
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId) && q.StudentUniqueId == term
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             && (((q.StudentFirstName.Contains(firstName) && q.StudentLastSurname.Contains(lastName)) || (q.StudentFirstName.Contains(lastName) && q.StudentLastSurname.Contains(firstName))) ||
                                 ((q.ParentFirstName.Contains(firstName) && q.ParentLastSurname.Contains(lastName)) || (q.ParentFirstName.Contains(lastName) && q.ParentLastSurname.Contains(firstName))))
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(firstName) && string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             && ((q.StudentFirstName.Contains(firstName) || q.StudentLastSurname.Contains(firstName)) || (q.ParentFirstName.Contains(firstName) || q.ParentLastSurname.Contains(firstName)))
                             select q);
            }

            if (model.SkipRows > 0)
            {
                queryBase = queryBase.OrderBy(x => x.StudentFirstName).Skip(model.SkipRows);
            }

            queryBase = (from q in queryBase
                         group new { q } by q.ParentUsi into g
                         select g.FirstOrDefault().q);


            if (model.PageSize.HasValue)
            {
                queryBase = queryBase.Take(model.PageSize.Value);
            }

            var query = (from q in queryBase
                         select new ParentStudentsModel
                         {
                             ParentUsi = q.ParentUsi,
                             ParentUniqueId = q.ParentUniqueId,
                             ParentFirstName = q.ParentFirstName,
                             ParentLastSurname = q.ParentLastSurname,
                             ParentRelation = q.ParentRelation,
                             LanguageCode = q.LanguageCode,
                             PreferredMethodOfContactTypeId = q.PreferredMethodOfContactTypeId,
                             StudentFirstName = q.StudentFirstName,
                             StudentLastSurname = q.StudentLastSurname,
                             StudentUsi = q.StudentUsi,
                             StudentUniqueId = q.StudentUniqueId,
                             GradeLevel = q.GradeLevel
                         });


            var students = await query.ToListAsync();

            return students;
        }

        public async Task<GroupMessagesQueueLogModel> GetGroupMessagesQueue(Guid Id)
        {
            var model = await (from gmq in _edFiDb.GroupMessagesQueueLogs
                               where gmq.Id == Id
                               select new GroupMessagesQueueLogModel
                               {
                                   Id = gmq.Id,
                                   SentStatus = gmq.SentStatus,
                                   FilterParams = gmq.FilterParams,
                                   StaffUniqueId = gmq.StaffUniqueIdSent,
                                   SchoolId = gmq.SchoolId,
                                   QueuedDateTime = gmq.QueuedDateTime,
                                   Type = gmq.Type,
                                   Audience = gmq.Audience,
                                   BodyMessage = gmq.Body,
                                   Subject = gmq.Subject,
                                   Data = gmq.Data
                               }).FirstOrDefaultAsync();
            return model;
        }

        public async Task<List<ParentStudentsModel>> GetParentsByPanrentUsisAndGradeLevels(string personUniqueId, int[] parentUsis, int[] gradeLevels, string[] validParentDescriptors, string[] validEmailTypeDescriptors, DateTime today)
        {
            //Here we got the information for the school first 
            var schoolId = await (from s in _edFiDb.Schools
                                  join sf in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.SchoolId equals sf.EducationOrganizationId
                                  join stf in _edFiDb.Staffs on sf.StaffUsi equals stf.StaffUsi
                                  where stf.StaffUniqueId == personUniqueId
                                  select s.SchoolId).FirstOrDefaultAsync();

            var baseQuery = (from p in _edFiDb.Parents
                             join pe in _edFiDb.ParentElectronicMails on p.ParentUsi equals pe.ParentUsi
                             //join ped in _edFiDb.Descriptors on pe.ElectronicMailTypeDescriptorId equals ped.DescriptorId
                             join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                             //join dspa in _edFiDb.Descriptors on spa.RelationDescriptorId equals dspa.DescriptorId
                             join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                             join studsec in _edFiDb.StudentSectionAssociations
                                        on new { s.StudentUsi, ssa.SchoolId }
                                        equals new { studsec.StudentUsi, studsec.SchoolId }
                             join sess in _edFiDb.Sessions
                                         on new { studsec.SchoolId, studsec.SchoolYear }
                                         equals new { sess.SchoolId, sess.SchoolYear }
                             join sy in _edFiDb.SchoolYearTypes on sess.SchoolYear equals sy.SchoolYear
                             // Left join
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             from ppe in _edFiDb.ParentProfileElectronicMails
                                 .Where(x => x.ParentUniqueId == p.ParentUniqueId && x.PrimaryEmailAddressIndicator == true)
                                 .DefaultIfEmpty()
                             from ppt in _edFiDb.ParentProfileTelephones.Where(x =>
                                 x.ParentUniqueId == p.ParentUniqueId && x.PrimaryMethodOfContact == true &&
                                 x.TextMessageCapabilityIndicator == true).DefaultIfEmpty()
                             from pptc in _edFiDb.TextMessageCarrierTypes
                                 .Where(x => x.TextMessageCarrierTypeId == ppt.TelephoneCarrierTypeId).DefaultIfEmpty()
                             where ssa.SchoolId == schoolId
                                   && sy.CurrentSchoolYear
                                   && sess.BeginDate <= today && sess.EndDate >= today
                             //&& validParentDescriptors.Contains(dspa.CodeValue)
                             //&& validEmailTypeDescriptors.Contains(ped.CodeValue)
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,
                                 EdFiEmail = pe.ElectronicMailAddress,
                                 ProfileEmail = ppe.ElectronicMailAddress,
                                 ProfileTelephone = ppt.TelephoneNumber,
                                 ProfileTelephoneSMSSuffixDomain = pptc.SmsSuffixDomain,
                                 LanguageCode = pp.LanguageCode,
                                 // This validation is for prod database, the PreferredMethodOfContactTypeId some times is null
                                 // *Note: In case of the PreferredMethodOfContactTypeId is null should be Email by Default
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId != null ? pp.PreferredMethodOfContactTypeId : 1,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Grade and Programs info for filtering,
                                 Grades = ssa.EntryGradeLevelDescriptorId
                             });

            if (gradeLevels.Length > 0)
                baseQuery = baseQuery.Where(x => gradeLevels.Contains(x.Grades));

            if (parentUsis.Length > 0)
                baseQuery = baseQuery.Where(x => parentUsis.Contains(x.ParentUsi));

            baseQuery = (from q in baseQuery
                         group new { q } by q.ParentUsi into g
                         select g.FirstOrDefault().q);

            var query = (from q in baseQuery
                         select new ParentStudentsModel
                         {
                             ParentUsi = q.ParentUsi,
                             ParentUniqueId = q.ParentUniqueId,
                             ParentFirstName = q.ParentFirstName,
                             ParentLastSurname = q.ParentLastSurname,
                             EdFiEmail = q.EdFiEmail,
                             ProfileEmail = q.ProfileEmail,
                             ProfileTelephone = q.ProfileTelephone,
                             ProfileTelephoneSMSSuffixDomain = q.ProfileTelephoneSMSSuffixDomain,
                             LanguageCode = q.LanguageCode,
                             PreferredMethodOfContactTypeId = q.PreferredMethodOfContactTypeId,
                             StudentFirstName = q.StudentFirstName,
                             StudentLastSurname = q.StudentLastSurname,
                             StudentUsi = q.StudentUsi,
                             StudentUniqueId = q.StudentUniqueId
                         });


            var students = await query.ToListAsync();

            return students;
        }

        public async Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueuesQueued(string staffUniqueId, int schoolId, QueuesFilterModel model)
        {
            List<GroupMessagesQueueLogModel> result = new List<GroupMessagesQueueLogModel>();
            var baseQuery = (from gmq in _edFiDb.GroupMessagesQueueLogs
                             where gmq.StaffUniqueIdSent == staffUniqueId
                             && gmq.SchoolId == schoolId
                             select new GroupMessagesQueueLogModel
                             {
                                 Id = gmq.Id,
                                 SentStatus = gmq.SentStatus,
                                 FilterParams = gmq.FilterParams,
                                 StaffUniqueId = gmq.StaffUniqueIdSent,
                                 SchoolId = gmq.SchoolId,
                                 QueuedDateTime = gmq.QueuedDateTime,
                                 Type = gmq.Type,
                                 Audience = gmq.Audience,
                                 BodyMessage = gmq.Body,
                                 Subject = gmq.Subject,
                                 Data = gmq.Data,
                                 RetryCount = gmq.RetryCount
                             });

            if (model.From != null && model.To != null)
                baseQuery = baseQuery.Where(x => x.QueuedDateTime >= model.From && x.QueuedDateTime <= model.To);

            if (!string.IsNullOrEmpty(model.SearchTerm))
            {
                baseQuery = baseQuery.Where(x => x.Subject.Contains(model.SearchTerm));
            }

            var query = await baseQuery.OrderBy(x => x.QueuedDateTime).ToListAsync();

            result.AddRange(query);
            if (model.GradeLevels.Any())
            {
                foreach (var q in query)
                {
                    if (q.Type == GroupMessagesQueueTypeEnum.Group.DisplayName)
                    {
                        var queueFilter = JsonConvert.DeserializeObject<GroupMessagesFilterParamsModel>(q.FilterParams);
                        var queueFilterResult = model.GradeLevels.Where(x => queueFilter.gradeLevels.Contains(x.Value));
                        if (!queueFilterResult.Any())
                        {
                            result.Remove(q);
                        }
                    }

                    if (q.Type == GroupMessagesQueueTypeEnum.IndividualGroup.DisplayName)
                    {
                        var queueFilter = JsonConvert.DeserializeObject<IndividualGroupMessagesFilterParamsModel>(q.FilterParams);
                        var queueFilterResult = model.GradeLevels.Where(x => queueFilter.gradeLevels.Contains(x.Value));
                        if (!queueFilterResult.Any())
                        {
                            result.Remove(q);
                        }
                    }

                }
            }

            if (model.Programs.Any())
            {
                foreach (var q in query)
                {
                    if (q.Type == GroupMessagesQueueTypeEnum.Group.DisplayName)
                    {
                        var queueFilter = JsonConvert.DeserializeObject<GroupMessagesFilterParamsModel>(q.FilterParams);
                        var queueFilterResult = model.Programs.Where(x => queueFilter.programs.Contains(x.Value));
                        if (!queueFilterResult.Any())
                        {
                            result.Remove(q);
                        }
                    }
                }
            }



            return result;
        }

        public async Task<List<UnreadMessageModel>> PrincipalRecipientMessages(string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, string searchTerm, bool onlyUnreadMessages)
        {
            var baseQuery = (from seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations
                             join sta in _edFiDb.Staffs on seoaa.StaffUsi equals sta.StaffUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on seoaa.EducationOrganizationId equals ssa.SchoolId
                             join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                             join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                             join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                             where sta.StaffUniqueId == recipientUniqueId
                             group new { p, s } by new { p.ParentUniqueId } into g
                             select new UnreadMessageModel
                             {
                                 FirstName = g.FirstOrDefault().p.FirstName,
                                 LastSurname = g.FirstOrDefault().p.LastSurname,
                                 UniqueId = g.FirstOrDefault().p.ParentUniqueId,
                                 Usi = g.FirstOrDefault().p.ParentUsi,
                                 StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                 StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                 StudentFirstName = g.FirstOrDefault().s.FirstName,
                                 StudentLastSurname = g.FirstOrDefault().s.LastSurname,
                                 OldestMessageDateSent = _edFiDb.ChatLogs.Where(c =>
                                                   (c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                   || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)).Max(x => x.DateSent),
                                 UnreadMessageCount = _edFiDb.ChatLogs.Count(x => !x.RecipientHasRead && x.RecipientUniqueId == recipientUniqueId
                                                                                                      && x.RecipientTypeId == recipientTypeId
                                                                                                      && x.SenderUniqueId == g.FirstOrDefault().p.ParentUniqueId)
                             });



            if (onlyUnreadMessages)
            {
                baseQuery = baseQuery.Where(x => x.UnreadMessageCount > 0);
            }

            if (rowsToSkip > 0)
            {
                baseQuery = baseQuery.OrderBy(x => x.OldestMessageDateSent).Skip(rowsToSkip);
            }

            if (rowsToRetrieve > 0)
            {
                baseQuery = baseQuery.Take(rowsToRetrieve);
            }

            if (!string.IsNullOrEmpty(searchTerm))
            {
                baseQuery = baseQuery.Where(x => x.FirstName.Contains(searchTerm) || x.LastSurname.Contains(searchTerm) || x.StudentFirstName.Contains(searchTerm) || x.StudentLastSurname.Contains(searchTerm));
            }

            var query = await baseQuery.ToListAsync();

            return query;
        }

        public async Task<int> GetParentsByGradeLevelsAndSearchTermCount(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today, int schoolId)
        {
            int studentUniqueId = 0;
            string firstName = "", lastName = "";
            var searchName = new List<string>();
            var isStudentId = int.TryParse(term, out studentUniqueId);

            if (!string.IsNullOrEmpty(term) && !isStudentId)
            {
                searchName = term.Split(' ').ToList();
                firstName = searchName[0];
                lastName = searchName.Count > 1 ? searchName[1] : string.Empty;
            }


            var queryBase = (from p in _edFiDb.Parents
                             join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                             //join dspa in _edFiDb.Descriptors on spa.RelationDescriptorId equals dspa.DescriptorId
                             join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                             join studsec in _edFiDb.StudentSectionAssociations
                                        on new { s.StudentUsi, ssa.SchoolId }
                                        equals new { studsec.StudentUsi, studsec.SchoolId }
                             join sess in _edFiDb.Sessions
                                         on new { studsec.SchoolId, studsec.SchoolYear }
                                         equals new { sess.SchoolId, sess.SchoolYear }
                             join sy in _edFiDb.SchoolYearTypes on sess.SchoolYear equals sy.SchoolYear
                             // Left join
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             where ssa.SchoolId == schoolId
                                   && sy.CurrentSchoolYear
                                   && sess.BeginDate <= today && sess.EndDate >= today
                             //&& validParentDescriptors.Contains(dspa.CodeValue)
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUniqueId = s.StudentUniqueId,
                                 // Grade and Programs info for filtering,
                                 GradeLevelId = gld.DescriptorId,
                             });

            if (string.IsNullOrEmpty(term))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             select q);
            }

            if (isStudentId)
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId) && q.StudentUniqueId == term
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             && (((q.StudentFirstName.Contains(firstName) && q.StudentLastSurname.Contains(lastName)) || (q.StudentFirstName.Contains(lastName) && q.StudentLastSurname.Contains(firstName))) ||
                                 ((q.ParentFirstName.Contains(firstName) && q.ParentLastSurname.Contains(lastName)) || (q.ParentFirstName.Contains(lastName) && q.ParentLastSurname.Contains(firstName))))
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(firstName) && string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelId)
                             && ((q.StudentFirstName.Contains(firstName) || q.StudentLastSurname.Contains(firstName)) || (q.ParentFirstName.Contains(firstName) || q.ParentLastSurname.Contains(firstName)))
                             select q);
            }

            queryBase = (from q in queryBase
                         group new { q } by q.ParentUsi into g
                         select g.FirstOrDefault().q).OrderBy(x => x.StudentFirstName);

            var query = (from q in queryBase
                         select new ParentStudentsModel
                         {
                             ParentUsi = q.ParentUsi,
                         });


            var studentsCount = await query.CountAsync();

            return studentsCount;
        }

        public async Task<int> PrincipalRecipientMessagesCount(string recipientUniqueId, int recipientTypeId, string searchTerm, bool onlyUnreadMessages)
        {
            var baseQuery = (from seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations
                             join sta in _edFiDb.Staffs on seoaa.StaffUsi equals sta.StaffUsi
                             join ssa in _edFiDb.StudentSchoolAssociations on seoaa.EducationOrganizationId equals ssa.SchoolId
                             join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                             join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                             join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                             where sta.StaffUniqueId == recipientUniqueId
                             group new { p, s } by new { p.ParentUniqueId } into g
                             select new UnreadMessageModel
                             {
                                 FirstName = g.FirstOrDefault().p.FirstName,
                                 LastSurname = g.FirstOrDefault().p.LastSurname,
                                 UniqueId = g.FirstOrDefault().p.ParentUniqueId,
                                 Usi = g.FirstOrDefault().p.ParentUsi,
                                 StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                 StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                 StudentFirstName = g.FirstOrDefault().s.FirstName,
                                 StudentLastSurname = g.FirstOrDefault().s.LastSurname
                             });
            if (onlyUnreadMessages)
            {
                baseQuery = baseQuery.Where(x => x.UnreadMessageCount > 0);
            }

            if (!string.IsNullOrEmpty(searchTerm))
            {
                baseQuery = baseQuery.Where(x => x.FirstName.Contains(searchTerm) || x.LastSurname.Contains(searchTerm) || x.StudentFirstName.Contains(searchTerm) || x.StudentLastSurname.Contains(searchTerm));
            }

            var query = await baseQuery.CountAsync();

            return query;
        }

        public async Task SetRecipientsRead(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId)
        {
            var unreadMessagesData = await (from c in _edFiDb.ChatLogs
                                            where c.StudentUniqueId == studentUniqueId && c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId && c.RecipientTypeId == senderTypeid && c.RecipientUniqueId == senderUniqueId
                                            && !c.RecipientHasRead
                                            select c).ToListAsync();

            unreadMessagesData.ForEach(x => x.RecipientHasRead = true);

            await _edFiDb.SaveChangesAsync();
        }

        public Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndSearchTerm(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }

        public Task<int> GetParentsByGradeLevelsAndSearchTermCount(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }
    }
}