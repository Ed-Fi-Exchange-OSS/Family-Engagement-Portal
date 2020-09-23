// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class CommunicationsRepository : ICommunicationsRepository
    {
        private readonly EdFi31Context _edFiDb;

        public CommunicationsRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }


        public async Task<ChatLogHistoryModel> GetThreadByParticipantsAsync(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount, int rowsToRetrieve = 15)
        {

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
                OriginalMessage = x.OriginalMessage,
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
            persistModel.StudentUniqueId= model.StudentUniqueId;
            persistModel.EnglishMessage = model.EnglishMessage;
            persistModel.OriginalMessage = model.OriginalMessage;
            persistModel.SenderTypeId = model.SenderTypeId;
            persistModel.RecipientTypeId = model.RecipientTypeId;

            _edFiDb.ChatLogs.Add(persistModel);

            await _edFiDb.SaveChangesAsync();

            model.DateSent = persistModel.DateSent;

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

        public async Task<List<UnreadMessageModel>> RecipientUnreadMessages(string recipientUniqueId, int recipientTypeId)
        {

            var result = new List<UnreadMessageModel>();

            if (recipientTypeId == ChatLogPersonTypeEnum.Staff.Value)
            {
              result = await (from ssa in _edFiDb.StudentSectionAssociations
                                join staffsa in _edFiDb.StaffSectionAssociations
                                on new { ssa.LocalCourseCode, ssa.SchoolId, ssa.SchoolYear, ssa.SectionIdentifier, ssa.SessionName }
                                equals new { staffsa.LocalCourseCode, staffsa.SchoolId, staffsa.SchoolYear, staffsa.SectionIdentifier, staffsa.SessionName }
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


        public async Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {

            // Get all related students and their related courses
            var students = await (from staffsa in _edFiDb.StaffSectionAssociations
                           
                            join ssa in _edFiDb.StudentSectionAssociations
                                on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.LocalCourseCode, staffsa.SessionName, staffsa.SectionIdentifier }
                                equals new { ssa.SchoolId, ssa.SchoolYear, ssa.LocalCourseCode, ssa.SessionName, ssa.SectionIdentifier }
                            join shsa in _edFiDb.StudentSchoolAssociations on new { ssa.StudentUsi, ssa.SchoolId } equals new { shsa.StudentUsi, shsa.SchoolId }
                            join co in _edFiDb.CourseOfferings
                                            on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.SessionName, staffsa.LocalCourseCode }
                                            equals new { co.SchoolId, co.SchoolYear, co.SessionName, co.LocalCourseCode }
                            join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                            join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                            where staff.StaffUniqueId == recipientUniqueId && sy.CurrentSchoolYear
                            group new {ssa, co} by ssa.StudentUsi into g
                            select new { StudentUsi = g.Key, CourseTitles = g.GroupBy(x => x.co.LocalCourseTitle).Select(x => x.Key) } )
                            .ToListAsync();
            // Get all students with their parents
            var studentIds = students.Select(x => x.StudentUsi).ToList();
            var parents = await (from s in _edFiDb.Students
                                 from spa in _edFiDb.StudentParentAssociations.Where(x => x.StudentUsi == s.StudentUsi).DefaultIfEmpty()
                                 from p in _edFiDb.Parents.Where(p => spa.ParentUsi == p.ParentUsi).DefaultIfEmpty()
                                 where studentIds.Contains(s.StudentUsi)
                                 group new { s, p } by s.StudentUsi into g
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
                                        UnreadMessageCount= _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                                               && c.RecipientUniqueId == recipientUniqueId
                                                               && c.RecipientTypeId == recipientTypeId
                                                               && c.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId
                                                               && recipient.p.ParentUniqueId == c.SenderUniqueId
                                                               && ChatLogPersonTypeEnum.Parent.Value == c.SenderTypeId)
                                    }).ToList(),
                                }).ToListAsync();

            var totalRecipients = parents.Count();
            // Map Course Titles
            parents.ForEach(x => x.RelationsToStudent = students.Find(s => s.StudentUsi == x.StudentUsi).CourseTitles.ToList());

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


        public async Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
        {


            var students = await (from spa in _edFiDb.StudentParentAssociations
                                  join p in _edFiDb.Parents
                                  on spa.ParentUsi equals p.ParentUsi
                                  where p.ParentUniqueId == recipientUniqueId
                                  select spa.StudentUsi).ToListAsync();


            var teachers = await (from staffsa in _edFiDb.StaffSectionAssociations
                                  join ssa in _edFiDb.StudentSectionAssociations
                                     on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.LocalCourseCode, staffsa.SessionName, staffsa.SectionIdentifier }
                                     equals new { ssa.SchoolId, ssa.SchoolYear, ssa.LocalCourseCode, ssa.SessionName, ssa.SectionIdentifier }
                                  join co in _edFiDb.CourseOfferings
                                            on new { staffsa.SchoolId, staffsa.SchoolYear, staffsa.SessionName, staffsa.LocalCourseCode }
                                            equals new { co.SchoolId, co.SchoolYear, co.SessionName, co.LocalCourseCode }
                                  join s in _edFiDb.Students
                                              on ssa.StudentUsi equals s.StudentUsi
                                  join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                                  join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                                  where students.Contains(s.StudentUsi) && sy.CurrentSchoolYear
                                  group new { s, staff, co } by new { s.StudentUsi, staff.StaffUsi } into g
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
                                      RelationsToStudent = g.GroupBy(x => x.co.LocalCourseTitle).Select(x => x.Key).ToList(),
                                  }).ToListAsync();

            var studentTeachers = teachers.GroupBy(x => x.StudentUsi)
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
                        RelationsToStudent = recipient.RelationsToStudent,        
                    }).ToList()
                }).ToList();


            foreach(var st in studentTeachers)
            {
                 st.MostRecentMessageDate = await (from c in _edFiDb.ChatLogs
                                          where (c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                && c.StudentUniqueId == st.StudentUniqueId
                                          orderby c.DateSent descending
                                          select c.DateSent).FirstOrDefaultAsync();


            // TODO: Code to be Refactored 
                st.Recipients = st.Recipients.Select(r =>
                {
                    r.UnreadMessageCount = _edFiDb.ChatLogs.Count(c => !c.RecipientHasRead
                                            && c.RecipientUniqueId == recipientUniqueId
                                            && c.RecipientTypeId == recipientTypeId
                                            && c.StudentUniqueId == st.StudentUniqueId
                                            && r.UniqueId == c.SenderUniqueId
                                            && ChatLogPersonTypeEnum.Staff.Value == c.SenderTypeId);

                    return r;
                }).ToList();
            }
            var totalRecipients = studentTeachers.Count();

            List<StudentRecipients> result = new List<StudentRecipients>();

            // If they selected a student
            if (studentUsi.HasValue)
            {
                result.Add(studentTeachers.FirstOrDefault(x => x.StudentUsi == studentUsi.Value));
                studentTeachers = studentTeachers.Where(x => x.StudentUsi != studentUsi.Value).ToList();
            }


            var unreadMessages = studentTeachers.Where(x => x.UnreadMessageCount > 0).ToList();

            studentTeachers = studentTeachers.Where(x => !unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)).ToList();

            var recentMessages = studentTeachers.Where(x => x.MostRecentMessageDate != null).OrderByDescending(x => x.MostRecentMessageDate).ToList();

            studentTeachers = studentTeachers.Where(x => !recentMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)).ToList();

            result.AddRange(unreadMessages);
            result.AddRange(recentMessages);
            result.AddRange(studentTeachers);

            var model = new AllRecipients
            {
                EndOfData = totalRecipients <= rowsToSkip + rowsToRetrieve,
                StudentRecipients = result.Skip(rowsToSkip).Take(rowsToRetrieve).ToList()
            };

            return model;
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
    }
}
