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

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class TeacherRepository : ITeacherRepository
    {

        private readonly EdFi25Context _edFiDb;

        public TeacherRepository(EdFi25Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StaffSectionModel>> GetStaffSectionsAsync(int staffUsi, DateTime today)
        {
            // Get the current sections for this teacher.
            var data = await (from sec in _edFiDb.StaffSectionAssociations
                              join ses in _edFiDb.Sessions
                                    on new { sec.SchoolId, sec.SchoolYear, sec.TermDescriptorId }
                                    equals new { ses.SchoolId, ses.SchoolYear, ses.TermDescriptorId }
                              join sy in _edFiDb.SchoolYearTypes on sec.SchoolYear equals sy.SchoolYear
                              where sec.StaffUsi == staffUsi
                                    && ses.BeginDate <= today && ses.EndDate >= today
                              //&& sy.CurrentSchoolYear
                              group sec by new { sec.SchoolId, sec.ClassPeriodName, sec.ClassroomIdentificationCode, sec.LocalCourseCode, sec.TermDescriptorId, sec.SchoolYear, sec.UniqueSectionCode, sec.SequenceOfCourse } into g
                              select new StaffSectionModel
                              {
                                  SchoolId = g.Key.SchoolId,
                                  ClassPeriodName = g.Key.ClassPeriodName,
                                  ClassroomIdentificationCode = g.Key.ClassroomIdentificationCode,
                                  LocalCourseCode = g.Key.LocalCourseCode,
                                  TermDescriptorId = g.Key.TermDescriptorId,
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
                                                     join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                                     join eo in _edFiDb.EducationOrganizations on ssa.EducationOrganizationId equals eo.EducationOrganizationId
                                                     join studSec in _edFiDb.StudentSectionAssociations
                                                       on new { ssa.StudentUsi, ssa.SchoolId } equals new { studSec.StudentUsi, studSec.SchoolId }
                                                     join staffSec in _edFiDb.StaffSectionAssociations
                                                                   on new { studSec.SchoolId, studSec.ClassPeriodName, studSec.ClassroomIdentificationCode, studSec.LocalCourseCode, studSec.TermDescriptorId, studSec.SchoolYear, studSec.UniqueSectionCode, studSec.SequenceOfCourse }
                                                                equals new { staffSec.SchoolId, staffSec.ClassPeriodName, staffSec.ClassroomIdentificationCode, staffSec.LocalCourseCode, staffSec.TermDescriptorId, staffSec.SchoolYear, staffSec.UniqueSectionCode, staffSec.SequenceOfCourse }
                                                     where staffSec.StaffUsi == staffUsi
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
                                                         StudentUniqueId = g.FirstOrDefault().s.StudentUniqueId,
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
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberType))
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
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 where s.StaffUniqueId == staffUniqueId
                                 select new StaffProfileModel { Staff = staff, Profile = s }).SingleOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                           .Include(x => x.StaffAddresses.Select(y => y.AddressType))
                                           .Include(x => x.StaffElectronicMails.Select(y => y.ElectronicMailType))
                                           .Include(x => x.StaffTelephones.Select(y => y.TelephoneNumberType))
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
                                 join staff in _edFiDb.Staffs on s.StaffUniqueId equals staff.StaffUniqueId
                                 join ssa in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals ssa.StaffUsi
                                 //Left join
                                 from spa in _edFiDb.StaffProfileAddresses.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                 from spem in _edFiDb.StaffProfileElectronicMails.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                 from spt in _edFiDb.StaffProfileTelephones.Where(x => x.StaffUniqueId == s.StaffUniqueId).DefaultIfEmpty()
                                 where staff.StaffUsi == staffUsi
                                 select new StaffProfileModel { Staff = staff, Profile = s }).FirstOrDefaultAsync();

            var edfiProfile = await (from s in _edFiDb.Staffs
                                     join ssa in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.StaffUsi equals ssa.StaffUsi
                                     //Left join
                                     from spa in _edFiDb.StaffAddresses.Where(x => x.StaffUsi == s.StaffUsi).DefaultIfEmpty()
                                     from spem in _edFiDb.StaffElectronicMails.Where(x => x.StaffUsi == s.StaffUsi).DefaultIfEmpty()
                                     from spt in _edFiDb.StaffAddresses.Where(x => x.StaffUsi == s.StaffUsi).DefaultIfEmpty()
                                     where s.StaffUsi == staffUsi
                                     select s).FirstOrDefaultAsync();

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

        public async Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndPrograms(int staffUsi, int[] grades, int[] programs, string[] validParentDescriptors, string[] validEmailTypeDescriptors)
        {
            //Here we got the information for the school first 
            var school = await (from s in _edFiDb.Schools
                    .Include(x => x.EducationOrganization)
                                join sf in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.SchoolId equals sf.EducationOrganizationId
                                where sf.StaffUsi == staffUsi
                                select new
                                {
                                    s.EducationOrganization.EducationOrganizationId,
                                    s.EducationOrganization.NameOfInstitution
                                }).FirstOrDefaultAsync();


            var baseQuery = (from s in _edFiDb.Students
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join spas in _edFiDb.StudentProgramAssociations on s.StudentUsi equals spas.StudentUsi
                             join spa in _edFiDb.StudentParentAssociations on s.StudentUsi equals spa.StudentUsi
                             join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                             join pr in _edFiDb.StudentParentAssociations on s.StudentUsi equals pr.StudentUsi
                             join p in _edFiDb.Parents on pr.ParentUsi equals p.ParentUsi
                             join pe in _edFiDb.ParentElectronicMails on p.ParentUsi equals pe.ParentUsi
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
                             where ssa.SchoolId == school.EducationOrganizationId && sy.CurrentSchoolYear
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
                                 pp.PreferredMethodOfContactTypeId,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Grade and Programs info for filtering,
                                 Grades = ssa.EntryGradeLevelDescriptorId
                             });

            if (grades.Length > 0)
                baseQuery = baseQuery.Where(x => grades.Contains(x.Grades));

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

            var studentsAssociatedWithStaff = await query.ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task SaveStaffLanguage(string staffUniqueId, string languageCode)
        {
            var staff = await _edFiDb.StaffProfiles.FirstOrDefaultAsync(x => x.StaffUniqueId == staffUniqueId);
            staff.LanguageCode = languageCode;

            await _edFiDb.SaveChangesAsync();
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
