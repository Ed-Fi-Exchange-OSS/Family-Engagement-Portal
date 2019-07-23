using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class ParentRepository : IParentRepository
    {
        private readonly EdFi31Context _edFiDb;

        public ParentRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StudentBriefModel>> GetStudentsAssociatedWithParent(int parentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var studentsAssociatedWithParent = await (from s in _edFiDb.Students
                                                join sp in _edFiDb.StudentParentAssociations on s.StudentUsi equals sp.StudentUsi
                                                join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                                join eo in _edFiDb.EducationOrganizations on ssa.EducationOrganizationId equals eo.EducationOrganizationId
                                                      where sp.ParentUsi == parentUsi
                                                group new { s , eo } by s.StudentUniqueId into g
                                                select new StudentBriefModel
                                                {
                                                    StudentUsi = g.FirstOrDefault().s.StudentUsi,
                                                    ExternalLinks = _edFiDb.SpotlightIntegrations.Where(x => x.StudentUniqueId == g.Key)
                                                          .Select(x => new StudentExternalLink { Url = x.Url, UrlType = x.UrlType.Description }),
                                                    UnreadMessageCount = _edFiDb.ChatLogs
                                                            .Count(x => x.StudentUniqueId == g.FirstOrDefault().s.StudentUniqueId
                                                                && x.RecipientUniqueId == recipientUniqueId
                                                                && x.RecipientTypeId == recipientTypeId && !x.RecipientHasRead),
                                                    CurrentSchool = g.FirstOrDefault().eo.NameOfInstitution,
                                                }).ToListAsync();
            

            return studentsAssociatedWithParent;
        }

        private IQueryable<ParentProfileModel> GetParentProfile(int parentUsi)
        {
            var profile = (from pp in _edFiDb.ParentProfiles
                                    .Include(x => x.ParentProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                    .Include(x => x.ParentProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                    .Include(x => x.ParentProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                           join p in _edFiDb.Parents on pp.ParentUniqueId equals p.ParentUniqueId
                           where p.ParentUsi == parentUsi
                           select new ParentProfileModel { Parent = p, ParentProfile = pp });

            return profile;
        }

        private IQueryable<ParentBiographyModel> GetODSParentProfile(int parentUsi)
        {
            var edfiProfile = (from p in _edFiDb.Parents
                                        .Include(x => x.ParentAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                        .Include(x => x.ParentElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                        .Include(x => x.ParentTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                               from bio in _edFiDb.ParentBiographies.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                               where p.ParentUsi == parentUsi
                               select new ParentBiographyModel { Parent = p, ParentBiography = bio });

            return edfiProfile;
        }

        private IQueryable<ParentProfileModel> GetParentProfile(string parentUniqueId)
        {
            var profile = (from pp in _edFiDb.ParentProfiles
                                    .Include(x => x.ParentProfileAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                    .Include(x => x.ParentProfileElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                    .Include(x => x.ParentProfileTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                           join p in _edFiDb.Parents on pp.ParentUniqueId equals p.ParentUniqueId
                           where pp.ParentUniqueId == parentUniqueId
                           select new ParentProfileModel { Parent = p, ParentProfile = pp });

            return profile;
        }

        private IQueryable<ParentBiographyModel> GetODSParentProfile(string parentUniqueId)
        {
            var edfiProfile = (from p in _edFiDb.Parents
                                        .Include(x => x.ParentAddresses.Select(y => y.AddressTypeDescriptor.Descriptor))
                                        .Include(x => x.ParentElectronicMails.Select(y => y.ElectronicMailTypeDescriptor.Descriptor))
                                        .Include(x => x.ParentTelephones.Select(y => y.TelephoneNumberTypeDescriptor.Descriptor))
                               from bio in _edFiDb.ParentBiographies.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                               where p.ParentUniqueId == parentUniqueId
                               select new ParentBiographyModel { Parent = p, ParentBiography = bio });

            return edfiProfile;
        }

        public async Task<UserProfileModel> GetParentProfileAsync(int parentUsi)
        {
            var profile = await (GetParentProfile(parentUsi)).SingleOrDefaultAsync();

            var edfiProfile = await (GetODSParentProfile(parentUsi)).SingleOrDefaultAsync();

            if (profile == null)
                return ToUserProfileModel(edfiProfile.Parent, edfiProfile.ParentBiography);

            var model = ToUserProfileModel(edfiProfile.ParentBiography, profile);

            return model;
        }

        public async Task<UserProfileModel> GetParentProfileAsync(string parentUniqueId)
        {
            // If no EdFi profile then it wont exist.
            var edfiProfile = await (GetODSParentProfile(parentUniqueId)).SingleOrDefaultAsync();
            if (edfiProfile == null)
                return null;

            var profile = await (GetParentProfile(parentUniqueId)).SingleOrDefaultAsync();
            if (profile == null)
                return ToUserProfileModel(edfiProfile.Parent, edfiProfile.ParentBiography);

            var model = ToUserProfileModel(edfiProfile.ParentBiography, profile);

            return model;
        }

        public async Task<BriefProfileModel> GetBriefParentProfileAsync(int parentUsi)
        {
            var profile = await (GetParentProfile(parentUsi)).SingleOrDefaultAsync();

            var edfiProfile = await (GetODSParentProfile(parentUsi)).SingleOrDefaultAsync();

            if (profile == null)
                return ToBriefProfileModel(edfiProfile.Parent);

            var model = ToBriefProfileModel(profile);


            return model;
        }

        public async Task<UserProfileModel> SaveParentProfileAsync(int parentUsi, UserProfileModel model)
        {
            var newProfile = await SaveProfileAsync(parentUsi, model);

            var biography = await SaveParentBiographyAsync(parentUsi, model);

            var parent = await _edFiDb.Parents.SingleOrDefaultAsync(x => x.ParentUniqueId == newProfile.ParentUniqueId);

            return ToUserProfileModel(biography, new ParentProfileModel { Parent = parent, ParentProfile = newProfile });
        }

        public async Task<List<PersonIdentityModel>> GetParentIdentityByEmailAsync(string email, string[] validParentDescriptors)
        {
            var identity = await (from p in _edFiDb.Parents
                                                    .Include(x => x.StudentParentAssociations.Select(spa => spa.RelationDescriptor.Descriptor))
                join pa in _edFiDb.ParentElectronicMails on p.ParentUsi equals pa.ParentUsi
                where pa.ElectronicMailAddress == email &&
                      p.StudentParentAssociations.Any(x => validParentDescriptors.Contains(x.RelationDescriptor.Descriptor.CodeValue))
                select new PersonIdentityModel
                {
                    Usi = p.ParentUsi,
                    UniqueId = p.ParentUniqueId,
                    PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                    FirstName = p.FirstName,
                    LastSurname = p.LastSurname,
                    Email = pa.ElectronicMailAddress
                }).ToListAsync();

            return identity;
        }

        public async Task<List<PersonIdentityModel>> GetParentIdentityByProfileEmailAsync(string email, string[] validParentDescriptors)
        {
            var identity = await (from p in _edFiDb.Parents
                                                .Include(x => x.StudentParentAssociations.Select(spa => spa.RelationDescriptor.Descriptor))
                                  join pe in _edFiDb.ParentProfileElectronicMails on p.ParentUniqueId equals pe.ParentUniqueId
                                  where pe.ElectronicMailAddress == email &&
                                        p.StudentParentAssociations.Any(x => validParentDescriptors.Contains(x.RelationDescriptor.Descriptor.CodeValue))
                                  select new PersonIdentityModel
                                  {
                                      Usi = p.ParentUsi,
                                      UniqueId = p.ParentUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                                      FirstName = p.FirstName,
                                      LastSurname = p.LastSurname,
                                      Email = pe.ElectronicMailAddress
                                  }).ToListAsync();

            return identity;
        }

        public bool HasAccessToStudent(int parentUsi, int studentUsi)
        {
            return _edFiDb.StudentParentAssociations.Any(x => x.ParentUsi == parentUsi && x.StudentUsi == studentUsi);
        }

        public bool HasAccessToStudent(int parentUsi, string studentUniqueId)
        {
            return _edFiDb.StudentParentAssociations.Include(x => x.Student).Any(x => x.ParentUsi == parentUsi && x.Student.StudentUniqueId == studentUniqueId);
        }

        private async Task<ParentProfile> SaveProfileAsync(int parentUsi, UserProfileModel model)
        {
            var currentProfile = await (GetParentProfile(parentUsi)).SingleOrDefaultAsync();

            var parent = await _edFiDb.Parents.SingleOrDefaultAsync(x => x.ParentUsi == model.Usi);
            var parentUniqueId = parent.ParentUniqueId;

            // If the parent portal extended profile is not null remove it and add it again with the submitted changes.
            if (currentProfile != null)
                _edFiDb.ParentProfiles.Remove(currentProfile.ParentProfile);

            var profile = new ParentProfile
            {
                ParentUniqueId = parentUniqueId,
                FirstName = model.FirstName,
                MiddleName = model.MiddleName,
                LastSurname = model.LastSurname,
                NickName = model.Nickname,
                PreferredMethodOfContactTypeId = model.PreferredMethodOfContactTypeId,
                ReplyExpectations = model.ReplyExpectations,
                LanguageCode = model.LanguageCode,
                ParentProfileElectronicMails = model.ElectronicMails.Select(x => new ParentProfileElectronicMail
                {
                    ParentUniqueId = parentUniqueId,
                    ElectronicMailTypeDescriptorId = x.ElectronicMailTypeId,
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                ParentProfileTelephones = model.TelephoneNumbers.Select(x => new ParentProfileTelephone
                {
                    ParentUniqueId = parentUniqueId,
                    TelephoneNumberTypeDescriptorId = x.TelephoneNumberTypeId,
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    PrimaryMethodOfContact = x.PrimaryMethodOfContact,
                    TelephoneCarrierTypeId = x.TelephoneCarrierTypeId,
                }).ToList(),
                ParentProfileAddresses = model.Addresses.Select(x => new ParentProfileAddress
                {
                    ParentUniqueId = parentUniqueId,
                    AddressTypeDescriptorId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationDescriptorId = x.StateAbbreviationTypeId,
                    PostalCode = x.PostalCode,
                    NameOfCounty = x.NameOfCounty,
                }).ToList(),
            };

            _edFiDb.ParentProfiles.Add(profile);

            await _edFiDb.SaveChangesAsync();

            return profile;
        }

        private async Task<ParentBiography> SaveParentBiographyAsync(int parentUsi, UserProfileModel model)
        {
            var parent = await _edFiDb.Parents.SingleOrDefaultAsync(x => x.ParentUsi == parentUsi);
            // Check if model has values, if not, dont save biography
            if (model.Biography == null && model.ShortBiography == null && model.FunFact == null)
                return null;

            // Fetch current biography if any.
            var biography = await _edFiDb.ParentBiographies.SingleOrDefaultAsync(x => x.ParentUniqueId == parent.ParentUniqueId);

            // If its a new one.
            if (biography == null)
            {
                biography = new ParentBiography
                {
                    ParentUniqueId = parent.ParentUniqueId,
                    FunFact = model.FunFact,
                    ShortBiography = model.ShortBiography,
                    Biography = model.Biography,
                };

                _edFiDb.ParentBiographies.Add(biography);
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

        private UserProfileModel ToUserProfileModel(Parent edfiPerson, ParentBiography parentBiography)
        {
            var model = new UserProfileModel
            {
                Usi = edfiPerson.ParentUsi,
                UniqueId = edfiPerson.ParentUniqueId,
                FirstName = edfiPerson.FirstName,
                MiddleName = edfiPerson.MiddleName,
                LastSurname = edfiPerson.LastSurname,

                Addresses = edfiPerson.ParentAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeDescriptorId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationDescriptorId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = edfiPerson.ParentElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeDescriptorId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = edfiPerson.ParentTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeDescriptorId
                }).ToList()
            };

            if (parentBiography != null)
            {
                model.FunFact = parentBiography.FunFact;
                model.ShortBiography = parentBiography.ShortBiography;
                model.Biography = parentBiography.Biography;
            }

            return model;
        }

        private UserProfileModel ToUserProfileModel(ParentBiography biography, ParentProfileModel profile)
        {
            var model = new UserProfileModel
            {
                Usi = profile.Parent.ParentUsi,
                UniqueId = profile.Parent.ParentUniqueId,
                FirstName = profile.ParentProfile.FirstName,
                MiddleName = profile.ParentProfile.MiddleName,
                LastSurname = profile.ParentProfile.LastSurname,
                Nickname = profile.ParentProfile.NickName,
                PreferredMethodOfContactTypeId = profile.ParentProfile.PreferredMethodOfContactTypeId,
                ReplyExpectations = profile.ParentProfile.ReplyExpectations,
                LanguageCode = profile.ParentProfile.LanguageCode,
                Addresses = profile.ParentProfile.ParentProfileAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeDescriptorId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationDescriptorId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = profile.ParentProfile.ParentProfileElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeDescriptorId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = profile.ParentProfile.ParentProfileTelephones.Select(x => new TelephoneModel
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

        private BriefProfileModel ToBriefProfileModel(ParentProfileModel profile)
        {
            var briefProfileModel = new BriefProfileModel();
            var preferredMail = profile.ParentProfile.ParentProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value)?.ElectronicMailAddress;
            var mail = profile.ParentProfile.ParentProfileElectronicMails.FirstOrDefault();
            var selectedMail = mail != null ? mail.ElectronicMailAddress : null;

            briefProfileModel.FirstName = profile.ParentProfile.FirstName;
            briefProfileModel.MiddleName = profile.ParentProfile.MiddleName;
            briefProfileModel.LastSurname = profile.ParentProfile.LastSurname;
            briefProfileModel.Usi = profile.Parent.ParentUsi;
            briefProfileModel.UniqueId = profile.Parent.ParentUniqueId;
            briefProfileModel.LanguageCode = profile.ParentProfile.LanguageCode;
            briefProfileModel.PersonTypeId = ChatLogPersonTypeEnum.Parent.Value;
            briefProfileModel.Role = "Parent";
            briefProfileModel.Email = preferredMail != null ? preferredMail : selectedMail;

            return briefProfileModel;
        }

        private BriefProfileModel ToBriefProfileModel(Parent profile)
        {
            var briefProfileModel = new BriefProfileModel();
            var preferredMail = profile.ParentElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value)?.ElectronicMailAddress;
            var mail = profile.ParentElectronicMails.FirstOrDefault();
            var selectedMail = mail != null ? mail.ElectronicMailAddress : null;

            briefProfileModel.FirstName = profile.FirstName;
            briefProfileModel.MiddleName = profile.MiddleName;
            briefProfileModel.LastSurname = profile.LastSurname;
            briefProfileModel.Usi = profile.ParentUsi;
            briefProfileModel.UniqueId = profile.ParentUniqueId;
            briefProfileModel.PersonTypeId = ChatLogPersonTypeEnum.Parent.Value;
            briefProfileModel.Role = "Parent";
            briefProfileModel.Email = preferredMail != null ? preferredMail : selectedMail;

            return briefProfileModel;
        }

        private class ParentBiographyModel
        {
            public Parent Parent { get; set; }
            public ParentBiography ParentBiography { get; set; }
        }

        private class ParentProfileModel
        {
            public Parent Parent { get; set; }
            public ParentProfile ParentProfile { get; set; }
        }
    }
}
