using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class TeacherRepository : ITeacherRepository
    {

        private readonly EdFi26Context _edFiDb;

        public TeacherRepository(EdFi26Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StaffSectionModel>> GetStaffSectionsAsync(int staffUsi)
        {
            // Get the current sections for this teacher.
            var data = await (from sec in _edFiDb.StaffSectionAssociations
                              join sy in _edFiDb.SchoolYearTypes on sec.SchoolYear equals sy.SchoolYear
                              join co in _edFiDb.CourseOfferings
                                 on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.TermDescriptorId}
                                 equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId }
                              where sec.StaffUsi == staffUsi
                              && sy.CurrentSchoolYear
                              group sec by new { sec.SchoolId, sec.ClassPeriodName, sec.ClassroomIdentificationCode, sec.LocalCourseCode, sec.TermDescriptorId, sec.SchoolYear, sec.UniqueSectionCode, sec.SequenceOfCourse, co.LocalCourseTitle } into g
                              select new StaffSectionModel
                              {
                                  SchoolId = g.Key.SchoolId,
                                  ClassPeriodName = g.Key.ClassPeriodName,
                                  ClassroomIdentificationCode = g.Key.ClassroomIdentificationCode,
                                  LocalCourseCode = g.Key.LocalCourseCode,
                                  TermDescriptorId = g.Key.TermDescriptorId,
                                  CourseTitle = g.Key.LocalCourseTitle,
                                  SchoolYear = g.Key.SchoolYear,
                                  UniqueSectionCode = g.Key.UniqueSectionCode,
                                  SequenceOfCourse = g.Key.SequenceOfCourse,
                                  BeginDate = g.Max(x => x.BeginDate)
                              }).ToListAsync();

            return data;
        }

        public async Task<List<StudentBriefModel>> GetTeacherStudents(int staffUsi, TeacherStudentsRequestModel model, string recipientUniqueId, int recipientTypeId)
        {

            var upperStudentName = model.StudentName?.ToUpper();
            var sectionIsNotNull = model.Section.SessionName != null;
            var studentNameNotNull = model.StudentName != null;

            var studentsAssociatedWithStaff = await (from s in _edFiDb.Students
                                                     .Include(x => x.StudentIdentificationCodes)
                                                     join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                                     join eo in _edFiDb.EducationOrganizations on ssa.SchoolId equals eo.EducationOrganizationId
                                                     join studSec in _edFiDb.StudentSectionAssociations
                                                       on new { ssa.StudentUsi, ssa.SchoolId } equals new { studSec.StudentUsi, studSec.SchoolId }
                                                     join staffSec in _edFiDb.StaffSectionAssociations
                                                                   on new { studSec.SchoolId, studSec.ClassPeriodName, studSec.ClassroomIdentificationCode, studSec.LocalCourseCode, studSec.TermDescriptorId, studSec.SchoolYear, studSec.UniqueSectionCode, studSec.SequenceOfCourse }
                                                                equals new { staffSec.SchoolId, staffSec.ClassPeriodName, staffSec.ClassroomIdentificationCode, staffSec.LocalCourseCode, staffSec.TermDescriptorId, staffSec.SchoolYear, staffSec.UniqueSectionCode, staffSec.SequenceOfCourse }
                                                     where staffSec.StaffUsi == staffUsi && ssa.ExitWithdrawDate == null
                                                           && (sectionIsNotNull ? (studSec.SchoolId == model.Section.SchoolId
                                                           && studSec.LocalCourseCode == model.Section.LocalCourseCode
                                                           && studSec.SchoolYear == model.Section.SchoolYear
                                                           && studSec.ClassPeriodName == model.Section.ClassPeriodName
                                                           && studSec.ClassroomIdentificationCode == model.Section.ClassroomIdentificationCode
                                                           && studSec.TermDescriptorId == model.Section.TermDescriptorId
                                                           && studSec.UniqueSectionCode == model.Section.UniqueSectionCode
                                                           && studSec.SequenceOfCourse == model.Section.SequenceOfCourse) : true)
                                                           && (studentNameNotNull && model.StudentName.Length > 0 ?
                                                           (s.FirstName.ToUpper().Contains(upperStudentName) ||
                                                           s.MiddleName.ToUpper().Contains(upperStudentName) ||
                                                           s.LastSurname.ToUpper().Contains(upperStudentName))
                                                           : true)
                                                     orderby s.LastSurname
                                                     group new { s, eo } by new { s.StudentUniqueId } into g
                                                     select new StudentBriefModel
                                                     {
                                                         StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                                         StudentIdentificationCode = g.FirstOrDefault().s.StudentIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID").IdentificationCode,
                                                         ExternalLinks = _edFiDb.SpotlightIntegrations.Where(x => x.StudentUniqueId == g.Key.StudentUniqueId)
                                                               .Select(x => new StudentExternalLink { Url = x.Url, UrlType = x.UrlType.Description }),
                                                         UnreadMessageCount = _edFiDb.ChatLogs
                                                                 .Count(x => x.StudentUniqueId == g.Key.StudentUniqueId
                                                                     && x.RecipientUniqueId == recipientUniqueId
                                                                     && x.RecipientTypeId == recipientTypeId && !x.RecipientHasRead),
                                                         CurrentSchool = g.FirstOrDefault().eo.NameOfInstitution,
                                                     }).ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task<UserProfileModel> GetStaffProfileAsync(int staffUsi)
        {
            var profile = await (from s in _edFiDb.StaffProfiles
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressType))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailType))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberType))
                                 join staff in _edFiDb.Staffs.Include(x => x.StaffIdentificationCodes)
                                    on s.StaffUniqueId equals staff.StaffUniqueId
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberType))
                                           .Include(x => x.StaffIdentificationCodes)
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
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressType))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailType))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberType))
                                 join staff in _edFiDb.Staffs.Include(x => x.StaffIdentificationCodes)
                                    on s.StaffUniqueId equals staff.StaffUniqueId
                                 where s.StaffUniqueId == staffUniqueId
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberType))
                                           .Include(x => x.StaffIdentificationCodes)
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
                                            .Include(x => x.StaffProfileAddresses.Select(y => y.AddressType))
                                            .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailType))
                                            .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberType))
                                 join staff in _edFiDb.Staffs.Include(x => x.StaffIdentificationCodes)
                                    on s.StaffUniqueId equals staff.StaffUniqueId
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberType))
                                           .Include(x => x.StaffIdentificationCodes)
                                     where s.StaffUsi == staffUsi
                                     select s).SingleOrDefaultAsync();

            if (profile == null)
                return ToBriefProfileModel(edfiProfile);

            var model = ToBriefProfileModel(profile);

            return model;
        }

        public async Task<UserProfileModel> SaveStaffProfileAsync(int staffUsi, UserProfileModel model)
        {
            var profile = await (from s in _edFiDb.StaffProfiles
                                           .Include(x => x.StaffProfileAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffProfileElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffProfileTelephones.Select(y => y.TelephoneNumberType))
                                 from staff in _edFiDb.Staffs.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

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
                    ElectronicMailTypeId = x.ElectronicMailTypeId,
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                StaffProfileTelephones = model.TelephoneNumbers.Select(x => new StaffProfileTelephone
                {
                    StaffUniqueId = staffUniqueId,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeId,
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    PrimaryMethodOfContact = x.PrimaryMethodOfContact,
                    TelephoneCarrierTypeId = x.TelephoneCarrierTypeId,
                }).ToList(),
                StaffProfileAddresses = model.Addresses.Select(x => new StaffProfileAddress
                {
                    StaffUniqueId = staffUniqueId,
                    AddressTypeId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationTypeId,
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
                UniqueId = edfiPerson.StaffUniqueId,
                FirstName = edfiPerson.FirstName,
                MiddleName = edfiPerson.MiddleName,
                LastSurname = edfiPerson.LastSurname,
                FunFact = staffBiography?.FunFact,
                ShortBiography = staffBiography?.ShortBiography,
                Biography = staffBiography?.Biography,
                IdentificationCode = edfiPerson.StaffIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode,
                Addresses = edfiPerson.StaffAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationTypeId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = edfiPerson.StaffElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = edfiPerson.StaffTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeId
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
                FirstName = profile.Profile.FirstName,
                MiddleName = profile.Profile.MiddleName,
                LastSurname = profile.Profile.LastSurname,
                Nickname = profile.Profile.NickName,
                PreferredMethodOfContactTypeId = profile.Profile.PreferredMethodOfContactTypeId,
                ReplyExpectations = profile.Profile.ReplyExpectations,
                LanguageCode = profile.Profile.LanguageCode,
                IdentificationCode = profile.Staff.StaffIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode,
                Addresses = profile.Profile.StaffProfileAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationTypeId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = profile.Profile.StaffProfileElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = profile.Profile.StaffProfileTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeId,
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
            var preferredMail = profile.Profile.StaffProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value).ElectronicMailAddress;
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
            briefProfileModel.IdentificationCode = profile.Staff.StaffIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode;

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
            briefProfileModel.IdentificationCode = profile.StaffIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode;

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

        public async Task<List<StaffSectionModel>> GetStaffSectionsAsync(int staffUsi, DateTime today)
        {
            // Get the current sections for this teacher.
            var data = await (from sec in _edFiDb.StaffSectionAssociations
                              join sy in _edFiDb.SchoolYearTypes on sec.SchoolYear equals sy.SchoolYear
                              join co in _edFiDb.CourseOfferings
                                 on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.TermDescriptorId }
                                 equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId }
                              where sec.StaffUsi == staffUsi
                              && sy.CurrentSchoolYear
                              group sec by new { sec.SchoolId, sec.ClassPeriodName, sec.ClassroomIdentificationCode, sec.LocalCourseCode, sec.TermDescriptorId, sec.SchoolYear, sec.UniqueSectionCode, sec.SequenceOfCourse, co.LocalCourseTitle } into g
                              select new StaffSectionModel
                              {
                                  SchoolId = g.Key.SchoolId,
                                  ClassPeriodName = g.Key.ClassPeriodName,
                                  ClassroomIdentificationCode = g.Key.ClassroomIdentificationCode,
                                  LocalCourseCode = g.Key.LocalCourseCode,
                                  TermDescriptorId = g.Key.TermDescriptorId,
                                  CourseTitle = g.Key.LocalCourseTitle,
                                  SchoolYear = g.Key.SchoolYear,
                                  UniqueSectionCode = g.Key.UniqueSectionCode,
                                  SequenceOfCourse = g.Key.SequenceOfCourse,
                                  BeginDate = g.Max(x => x.BeginDate)
                              }).ToListAsync();

            return data;
        }

        public Task SaveStaffLanguage(string staffUniqueId, string languageCode)
        {
            throw new NotImplementedException();
        }

        public async Task<List<StudentCampusLeaderModel>> GetTeacherStudentsByCampusLeader(CampusLeaderStudentSearchModel model)
        {
            string text = string.Empty;
            if (!string.IsNullOrEmpty(model.Text)) text = model.Text.ToLower();

            var studentsAssociatedWithStaff = await (from s in _edFiDb.Students
                                                     join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                                     join d in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals d.DescriptorId
                                                     join eo in _edFiDb.EducationOrganizations on ssa.SchoolId equals eo.EducationOrganizationId
                                                     join studSec in _edFiDb.StudentSectionAssociations
                                                       on new { ssa.StudentUsi, ssa.SchoolId } equals new { studSec.StudentUsi, studSec.SchoolId }
                                                     join staffSec in _edFiDb.StaffSectionAssociations
                                                                   on new { studSec.SchoolId, studSec.ClassPeriodName, studSec.ClassroomIdentificationCode, studSec.LocalCourseCode, studSec.TermDescriptorId, studSec.SchoolYear, studSec.UniqueSectionCode, studSec.SequenceOfCourse }
                                                                equals new { staffSec.SchoolId, staffSec.ClassPeriodName, staffSec.ClassroomIdentificationCode, staffSec.LocalCourseCode, staffSec.TermDescriptorId, staffSec.SchoolYear, staffSec.UniqueSectionCode, staffSec.SequenceOfCourse }
                                                     join staff in _edFiDb.Staffs on staffSec.StaffUsi equals staff.StaffUsi
                                                     where (model.SchoolId == 0 || ssa.SchoolId == model.SchoolId) &&
                                                           (model.GradeId == 0 || ssa.EntryGradeLevelDescriptorId == model.GradeId) &&
                                                           (s.FirstName.ToUpper().Contains(text) || s.MiddleName.ToUpper().Contains(text) || s.LastSurname.ToUpper().Contains(text) || staff.FirstName.ToUpper().Contains(text) ||
                                                           staff.MiddleName.ToUpper().Contains(text) || staff.LastSurname.ToUpper().Contains(text))
                                                     orderby s.LastSurname
                                                     group new { s, eo, ssa, staff, d } by new { s.StudentUniqueId } into g
                                                     select new StudentCampusLeaderModel
                                                     {
                                                         StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                                         StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
                                                         FirstName = g.FirstOrDefault().s.FirstName,
                                                         LastSurname = g.FirstOrDefault().s.LastSurname,
                                                         MiddleName = g.FirstOrDefault().s.MiddleName,
                                                         TeacherFirstName = g.FirstOrDefault().staff.FirstName,
                                                         TeacherLastSurname = g.FirstOrDefault().staff.LastSurname,
                                                         TeacherMiddleName = g.FirstOrDefault().staff.MiddleName,
                                                         StaffUsi = g.FirstOrDefault().staff.StaffUsi,
                                                         StaffUniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                                         GradeLevel = g.FirstOrDefault().d.CodeValue,
                                                         CurrentSchool = g.FirstOrDefault().eo.NameOfInstitution
                                                     }).ToListAsync();

            if (studentsAssociatedWithStaff.Any())
                studentsAssociatedWithStaff = studentsAssociatedWithStaff.OrderBy(rec => rec.TeacherCompleteName).ThenBy(rec => rec.GradeLevel).ThenBy(rec => rec.StudentCompleteName).ToList();

            return studentsAssociatedWithStaff;
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
