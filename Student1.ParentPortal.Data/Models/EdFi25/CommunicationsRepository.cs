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
            persistModel.StudentUniqueId = model.StudentUniqueId;
            persistModel.EnglishMessage = model.EnglishMessage;
            persistModel.OriginalMessage = model.OriginalMessage;
            persistModel.SenderTypeId = model.SenderTypeId;
            persistModel.RecipientTypeId = model.RecipientTypeId;

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

        public async Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
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


        public async Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve)
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

            var studentTeachers = teachers.GroupBy(x => x.StudentUsi).Select(x => new StudentRecipients
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

            var totalRecipients = studentTeachers.Count();

            List<StudentRecipients> result = new List<StudentRecipients>();


            // If they selected a Student
            if (studentUsi.HasValue)
                result.Add(studentTeachers.FirstOrDefault(x => x.StudentUsi == studentUsi.Value));

            var unreadMessages = studentTeachers.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
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

            var recentMessages = studentTeachers.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
                                                    _edFiDb.ChatLogs.Count(c =>
                                                    ((c.RecipientUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId)
                                                    || (c.SenderUniqueId == recipientUniqueId && c.SenderTypeId == recipientTypeId))
                                                    && c.StudentUniqueId == x.StudentUniqueId
                                                    && !unreadMessages.Any(um => um.StudentUniqueId == x.StudentUniqueId)
                                                    && x.Recipients
                                                            .Any(r => (r.UniqueId == c.SenderUniqueId && r.PersonTypeId == c.SenderTypeId)
                                                            || (r.UniqueId == c.RecipientUniqueId && r.PersonTypeId == c.RecipientTypeId))) > 0).ToList();


            var otherMessages = studentTeachers.Where(x => (studentUsi.HasValue ? studentUsi.Value != x.StudentUsi : true) &&
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
                where  s.StudentUsi == studentUsi && !c.RecipientHasRead 
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
    }
}