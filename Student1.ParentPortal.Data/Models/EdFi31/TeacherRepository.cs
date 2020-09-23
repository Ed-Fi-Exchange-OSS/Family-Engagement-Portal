// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class TeacherRepository : ITeacherRepository
    {
        private readonly EdFi31Context _edFiDb;

        public TeacherRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StaffSectionModel>> GetStaffSectionsAsync(int staffUsi)
        {
            // Get the current sections for this teacher.

            var data = await (from sec in _edFiDb.StaffSectionAssociations
                              join sy in _edFiDb.SchoolYearTypes on sec.SchoolYear equals sy.SchoolYear
                              join scp in _edFiDb.SectionClassPeriods
                                     on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.SectionIdentifier, sec.SessionName }
                                     equals new { scp.LocalCourseCode, scp.SchoolId, scp.SchoolYear, scp.SectionIdentifier, scp.SessionName }
                              join s in _edFiDb.Sections
                                     on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.SectionIdentifier, sec.SessionName }
                                     equals new { s.LocalCourseCode, s.SchoolId, s.SchoolYear, s.SectionIdentifier, s.SessionName }
                              join co in _edFiDb.CourseOfferings
                                     on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.SessionName }
                                     equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.SessionName }
                              where sec.StaffUsi == staffUsi && sy.CurrentSchoolYear
                              group sec by new { sec.SchoolId, scp.ClassPeriodName, sec.SessionName, sec.LocalCourseCode, sec.SchoolYear, sec.SectionIdentifier, co.LocalCourseTitle } into g
                              select new StaffSectionModel
                              {
                                  SchoolId = g.Key.SchoolId,
                                  SessionName = g.Key.SessionName,
                                  LocalCourseCode = g.Key.LocalCourseCode,
                                  SchoolYear = g.Key.SchoolYear,
                                  UniqueSectionCode = g.Key.SectionIdentifier,
                                  CourseTitle = g.Key.LocalCourseTitle,
                                  BeginDate = g.Max(x => x.BeginDate),
                                  ClassPeriodName = g.Key.ClassPeriodName,
                              }).ToListAsync();

            return data;
        }

        public async Task<List<StudentBriefModel>> GetTeacherStudents(int staffUsi, TeacherStudentsRequestModel model, string recipientUniqueId, int recipientTypeId)
        {

            var upperStudentName = model.StudentName?.ToUpper();
            var sectionIsNotNull = model.Section.SessionName != null;
            var studentNameNotNull = model.StudentName != null;

            var studentsAssociatedWithStaff = await (from s in _edFiDb.Students
                                                      join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                                      join eo in _edFiDb.EducationOrganizations on ssa.EducationOrganizationId equals eo.EducationOrganizationId
                                                      join studSec in _edFiDb.StudentSectionAssociations 
                                                        on new { ssa.StudentUsi, ssa.SchoolId } equals new { studSec.StudentUsi, studSec.SchoolId }
                                                      join staffSec in _edFiDb.StaffSectionAssociations
                                                                  on new { studSec.SchoolId, studSec.SessionName, studSec.SectionIdentifier, studSec.LocalCourseCode, studSec.SchoolYear }
                                                                  equals new { staffSec.SchoolId, staffSec.SessionName, staffSec.SectionIdentifier, staffSec.LocalCourseCode, staffSec.SchoolYear }
                                                      where staffSec.StaffUsi == staffUsi
                                                            && (sectionIsNotNull ? (studSec.SchoolId == model.Section.SchoolId
                                                            && studSec.LocalCourseCode == model.Section.LocalCourseCode
                                                            && studSec.SchoolYear == model.Section.SchoolYear
                                                            && studSec.SectionIdentifier == model.Section.UniqueSectionCode
                                                            && studSec.SessionName == model.Section.SessionName) : true)
                                                            && (studentNameNotNull && model.StudentName.Length > 0 ?
                                                            (s.FirstName.ToUpper().Contains(upperStudentName) || 
                                                            s.MiddleName.ToUpper().Contains(upperStudentName) || 
                                                            s.LastSurname.ToUpper().Contains(upperStudentName)) 
                                                            : true )
                                                      orderby s.LastSurname
                                                group new { s, eo } by new { s.StudentUniqueId } into g
                                                select new StudentBriefModel
                                                {
                                                          StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                                          ExternalLinks = _edFiDb.SpotlightIntegrations.Where(x => x.StudentUniqueId == g.Key.StudentUniqueId)
                                                          .Select(x => new StudentExternalLink { Url = x.Url, UrlType = x.UrlType.Description }),
                                                          UnreadMessageCount = _edFiDb.ChatLogs
                                                            .Count(x => x.StudentUniqueId == g.Key.StudentUniqueId
                                                                && x.RecipientUniqueId == recipientUniqueId 
                                                                && x.RecipientTypeId == recipientTypeId && !x.RecipientHasRead),
                                                          CurrentSchool = g.FirstOrDefault().eo.NameOfInstitution
                                                      }).ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task<UserProfileModel> GetStaffProfileAsync(int staffUsi)
        {
            var profile = await (from s in _edFiDb.StaffProfiles
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                     from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                     where s.StaffUsi == staffUsi
                                     select new StaffBiographyModel { Staff = s, StaffBiography = bio }).SingleOrDefaultAsync();

            if (profile == null)
                return ToUserProfileModel(edfiProfile.Staff, edfiProfile.StaffBiography);

            return ToUserProfileModel(edfiProfile.StaffBiography, profile);
        }

        public async Task<UserProfileModel> GetStaffProfileAsync(string staffUniqueId)
        {
            var profile = await (from s in _edFiDb.StaffProfiles
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 where s.StaffUniqueId == staffUniqueId
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                     from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                     where s.StaffUniqueId == staffUniqueId
                                     select new StaffBiographyModel { Staff = s, StaffBiography = bio }).SingleOrDefaultAsync();

            if (profile == null)
                return ToUserProfileModel(edfiProfile.Staff, edfiProfile.StaffBiography);

            return ToUserProfileModel(edfiProfile.StaffBiography, profile);
        }

        public async Task<BriefProfileModel> GetBriefStaffProfileAsync(int staffUsi)
        {
            var profile = await (from s in _edFiDb.StaffProfiles
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                                     where s.StaffUsi == staffUsi
                                     select s).SingleOrDefaultAsync();

            if (profile == null)
                return ToBriefProfileModel(edfiProfile);

            var model = ToBriefProfileModel(profile);

            return model;
        }

        public async Task<UserProfileModel> SaveStaffProfileAsync(int staffUsi, UserProfileModel model)
        {
            var profile = await (from staff in _edFiDb.Staffs
                                join s in _edFiDb.StaffProfiles
                                           .Include(x => x.StaffProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                           .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor)) 
                                        on staff.StaffUniqueId equals s.StaffUniqueId into pro
                                from spro in pro.DefaultIfEmpty()
                                where staff.StaffUsi == staffUsi
                                select new StaffProfileModel { Staff = staff, Profile = spro }).SingleOrDefaultAsync();

            // If the parent portal extended profile is not null remove it and add it again with the submitted changes.
            if (profile.Profile != null)
                _edFiDb.StaffProfiles.Remove(profile.Profile);

            var newProfile = await AddNewProfileAsync(profile.Staff.StaffUniqueId, model);

            var biography = await SaveStaffBiographyAsync(staffUsi, model);


            return ToUserProfileModel(biography, new StaffProfileModel { Staff = profile.Staff, Profile = UserProfileModelToStaffProfile(profile.Staff.StaffUniqueId, newProfile) });
        }

        public async Task<UserProfileModel> AddNewProfileAsync(string staffUniqueId, UserProfileModel model)
        {

            var staffProfile = UserProfileModelToStaffProfile(staffUniqueId, model);

            _edFiDb.StaffProfiles.Add(staffProfile);

            await _edFiDb.SaveChangesAsync();

            return model;
        }

        private StaffProfile UserProfileModelToStaffProfile(string staffUniqueId, UserProfileModel model)
        {
            var staffProfile = new StaffProfile
            {
                StaffUniqueId = staffUniqueId,
                FirstName = model.FirstName,
                MiddleName = model.MiddleName,
                LastSurname = model.LastSurname,
                NickName = model.Nickname,
                PreferredMethodOfContactTypeId = model.PreferredMethodOfContactTypeId,
                ReplyExpectations = model.ReplyExpectations,
                LanguageCode = model.LanguageCode,
                StaffProfileElectronicMails = model.ElectronicMails.Select(x => new StaffProfileElectronicMail
                {
                    StaffUniqueId = staffUniqueId,
                    ElectronicMailTypeDescriptorId = x.ElectronicMailTypeId,
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                StaffProfileTelephones = model.TelephoneNumbers.Select(x => new StaffProfileTelephone
                {
                    StaffUniqueId = staffUniqueId,
                    TelephoneNumberTypeDescriptorId = x.TelephoneNumberTypeId,
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    PrimaryMethodOfContact = x.PrimaryMethodOfContact,
                    TelephoneCarrierTypeId = x.TelephoneCarrierTypeId,
                }).ToList(),
                StaffProfileAddresses = model.Addresses.Select(x => new StaffProfileAddress
                {
                    StaffUniqueId = staffUniqueId,
                    AddressTypeDescriptorId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationDescriptorId = x.StateAbbreviationTypeId,
                    PostalCode = x.PostalCode,
                    NameOfCounty = x.NameOfCounty,
                }).ToList(),
            };
            return staffProfile;
        }

        private async Task<StaffBiography> SaveStaffBiographyAsync(int staffUsi, UserProfileModel model)
        {
            var staff = await _edFiDb.Staffs.SingleOrDefaultAsync(p => p.StaffUsi == staffUsi);
            // Check if model has values, if not, dont save biography
            if (model.Biography == null && model.ShortBiography == null && model.FunFact == null)
                return null;

            // Fetch current biography if any.
            var biography = await _edFiDb.StaffBiographies.SingleOrDefaultAsync(x => x.StaffUniqueId == staff.StaffUniqueId);

            // If its a new one.
            if (biography == null)
            {
                biography = new StaffBiography
                {
                    StaffUniqueId = staff.StaffUniqueId,
                    FunFact = model.FunFact,
                    ShortBiography = model.ShortBiography,
                    Biography = model.Biography
                };

                _edFiDb.StaffBiographies.Add(biography);
            }
            else
            { // We are updating
                biography.FunFact = model.FunFact;
                biography.ShortBiography = model.ShortBiography;
                biography.Biography = model.Biography;
            }

            // Persist changes to db.
            await _edFiDb.SaveChangesAsync();

            return biography;
        }

        private UserProfileModel ToUserProfileModel(Staff edfiPerson, StaffBiography staffBiography)
        {
            var model = new UserProfileModel
            {
                Usi = edfiPerson.StaffUsi,
                UniqueId  = edfiPerson.StaffUniqueId,
                PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                FirstName = edfiPerson.FirstName,
                MiddleName = edfiPerson.MiddleName,
                LastSurname = edfiPerson.LastSurname,
                Addresses = edfiPerson.StaffAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeDescriptorId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationDescriptorId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = edfiPerson.StaffElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeDescriptorId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = edfiPerson.StaffTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeDescriptorId
                }).ToList()
            };

            if (staffBiography != null)
            {
                model.FunFact = staffBiography.FunFact;
                model.ShortBiography = staffBiography.ShortBiography;
                model.Biography = staffBiography.Biography;
            }

            return model;
        }

        private UserProfileModel ToUserProfileModel(StaffBiography biography, StaffProfileModel profile)
        {
            var model = new UserProfileModel
            {
                Usi = profile.Staff.StaffUsi,
                UniqueId = profile.Staff.StaffUniqueId,
                PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                FirstName = profile.Profile.FirstName,
                MiddleName = profile.Profile.MiddleName,
                LastSurname = profile.Profile.LastSurname,
                Nickname = profile.Profile.NickName,
                PreferredMethodOfContactTypeId = profile.Profile.PreferredMethodOfContactTypeId,
                ReplyExpectations = profile.Profile.ReplyExpectations,
                LanguageCode = profile.Profile.LanguageCode,
                Addresses = profile.Profile.StaffProfileAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeDescriptorId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationDescriptorId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = profile.Profile.StaffProfileElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeDescriptorId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = profile.Profile.StaffProfileTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeDescriptorId,
                    PrimaryMethodOfContact = x.PrimaryMethodOfContact,
                    TelephoneCarrierTypeId = x.TelephoneCarrierTypeId,
                }).ToList()
            };

            if (biography != null)
            {
                model.FunFact = biography.FunFact;
                model.ShortBiography = biography.ShortBiography;
                model.Biography = biography.Biography;
            }

            return model;
        }

        private BriefProfileModel ToBriefProfileModel(StaffProfileModel profile)
        {
            var briefProfileModel = new BriefProfileModel();
            var preferredMail = profile.Profile.StaffProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value)?.ElectronicMailAddress;
            var mail = profile.Profile.StaffProfileElectronicMails.FirstOrDefault();
            var selectedMail = mail != null ? mail.ElectronicMailAddress : null;
            briefProfileModel.FirstName = profile.Profile.FirstName;
            briefProfileModel.MiddleName = profile.Profile.MiddleName;
            briefProfileModel.LastSurname = profile.Profile.LastSurname;
            briefProfileModel.Usi = profile.Staff.StaffUsi;
            briefProfileModel.UniqueId = profile.Staff.StaffUniqueId;
            briefProfileModel.LanguageCode = profile.Profile.LanguageCode;
            briefProfileModel.PersonTypeId = ChatLogPersonTypeEnum.Staff.Value;
            briefProfileModel.Role = "Staff";
            briefProfileModel.Email = preferredMail != null ? preferredMail : selectedMail;

            return briefProfileModel;
        }

        private BriefProfileModel ToBriefProfileModel(Staff profile)
        {
            var briefProfileModel = new BriefProfileModel();
            var preferredMail = profile.StaffElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value)?.ElectronicMailAddress;
            var mail = profile.StaffElectronicMails.FirstOrDefault();
            var selectedMail = mail != null ? mail.ElectronicMailAddress : null;
            briefProfileModel.FirstName = profile.FirstName;
            briefProfileModel.MiddleName = profile.MiddleName;
            briefProfileModel.LastSurname = profile.LastSurname;
            briefProfileModel.Usi = profile.StaffUsi;
            briefProfileModel.UniqueId = profile.StaffUniqueId;
            briefProfileModel.PersonTypeId = ChatLogPersonTypeEnum.Staff.Value;
            briefProfileModel.Role = "Staff";
            briefProfileModel.Email = preferredMail != null ? preferredMail : selectedMail;

            return briefProfileModel;
        }

        public bool HasAccessToStudent(int staffUsi, int studentUsi)
        {
            return _edFiDb.Staffs
                .Where(x => x.StaffUsi == staffUsi)
                .Include(x => x.StaffSectionAssociations.Select(ssa => ssa.Section.StudentSectionAssociations))
                .Any(x => x.StaffSectionAssociations.Any(ssa => ssa.Section.StudentSectionAssociations.Any(studsa => studsa.StudentUsi == studentUsi)));
        }

        public bool HasAccessToStudent(int staffUsi, string studentUniqueId)
        {
            return _edFiDb.Staffs
                .Where(x => x.StaffUsi == staffUsi)
                .Include(x => x.StaffSectionAssociations.Select(ssa => ssa.Section.StudentSectionAssociations.Select(studsa => studsa.Student)))
                .Any(x => x.StaffSectionAssociations.Any(ssa => ssa.Section.StudentSectionAssociations.Any(studsa => studsa.Student.StudentUniqueId == studentUniqueId)));
        }

        private class StaffBiographyModel
        {
            public Staff Staff { get; set; }
            public StaffBiography StaffBiography { get; set; }
        }

        private class StaffProfileModel
        {
            public Staff Staff { get; set; }
            public StaffProfile Profile { get; set; }
        }
    }
}
