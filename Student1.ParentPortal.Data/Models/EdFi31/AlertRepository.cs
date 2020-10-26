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
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class AlertRepository : IAlertRepository
    {
        private readonly EdFi31Context _edFiDb;

        public AlertRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task AddAlertLog(SchoolYearTypeModel currentSchoolYear, int alertTypeId, string parentUniqueId, string studentUniqueId, string absencesCount)
        {
            _edFiDb.AlertLogs.Add(new AlertLog
            {
                SchoolYear = currentSchoolYear.SchoolYear,
                AlertTypeId = alertTypeId,
                ParentUniqueId = parentUniqueId,
                StudentUniqueId = studentUniqueId,
                Value = absencesCount
            });
        }

        public async Task<SchoolYearTypeModel> getCurrentSchoolYear()
        {
            var currentSchoolYear = await _edFiDb.SchoolYearTypes.Where(x => x.CurrentSchoolYear)
                 .Select(x => new SchoolYearTypeModel
                 {
                     CurrentSchoolYear = x.CurrentSchoolYear,
                     SchoolYear = x.SchoolYear,
                     SchoolYearDescription = x.SchoolYearDescription
                 })
                 .FirstOrDefaultAsync();

            return currentSchoolYear;
        }

        public async Task SaveChanges()
        {
            await _edFiDb.SaveChangesAsync();
        }

        public async Task<ParentAlertTypeModel> GetParentAlertTypes(int usi)
        {
            var parentAlertTypes = new ParentAlertTypeModel();

            var parentAlert = await (from pa in _edFiDb.ParentAlerts
                                        .Include(x => x.AlertTypes)
                                    join p in _edFiDb.Parents on pa.ParentUniqueId equals p.ParentUniqueId
                                    where p.ParentUsi == usi
                                    select pa).FirstOrDefaultAsync();

            //Note: This flag was true always by the user feedback
            parentAlertTypes.AlertsEnabled = true;

            var alertTypes = (await _edFiDb.AlertTypes
                .Include(x => x.ThresholdTypes)
                .ToListAsync()).Select(alertType => new AlertTypeModel()
                {
                    AlertTypeId = alertType.AlertTypeId,
                    Description = alertType.Description,
                    ShortDescription = alertType.ShortDescription,
                    Enabled = false,
                    Thresholds = alertType.ThresholdTypes.Select(tt => new ThresholdTypeModel()
                    {
                        ThresholdTypeId = tt.ThresholdTypeId,
                        Description = tt.Description,
                        ShortDescription = tt.ShortDescription,
                        ThresholdValue = tt.ThresholdValue,
                    }).ToList()
                }).ToList();

            var alertTypesResult = alertTypes.Select(alertType =>
            {
                alertType.Enabled = parentAlert?.AlertTypes.Any(x => x.AlertTypeId == alertType.AlertTypeId);
                return alertType;
            });

            parentAlertTypes.Alerts = alertTypesResult.ToList();

            return parentAlertTypes;
        }

        public async Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi)
        {
            var parent = await _edFiDb.Parents.Where(p => p.ParentUsi == usi).FirstOrDefaultAsync();

            var parentAlert = await _edFiDb.ParentAlerts
                                        .Include(x => x.AlertTypes)
                                  .Where(x => x.ParentUniqueId == parent.ParentUniqueId)
                                  .FirstOrDefaultAsync();

            var alertTypes = await _edFiDb.AlertTypes
                .ToListAsync();

            var parentAlerts = alertTypes.Where(x => parentAlertTypes.Alerts.Any(pa => pa.AlertTypeId == x.AlertTypeId && pa.Enabled.HasValue && pa.Enabled.Value)).ToList();

            if (parentAlert == null)
            {
                parentAlert = createParentAlert(parent.ParentUniqueId);
                parentAlert.AlertTypes = parentAlerts;

                _edFiDb.ParentAlerts.Add(parentAlert);
            }
            else
            {
                parentAlert.AlertTypes = parentAlerts;
            }

            await SaveChanges();

            return parentAlertTypes;
        }

        private ParentAlert createParentAlert(string uniqueId)
        {
            var newParentAlert = new ParentAlert();
            newParentAlert.ParentUniqueId = uniqueId;

            return newParentAlert;
        }

        public async Task<List<StudentAlertModel>> studentsOverThresholdAbsence(decimal excusedThreshold, decimal unexcusedThreshold, decimal tardyThreshold, string excusedDescriptor, string unexcusedDescriptor, string tardyDescriptor)
        {
            var studentsOverThreshold = await (from s in _edFiDb.Students
                                               join spa in _edFiDb.StudentParentAssociations
                                                           .Include(x => x.Parent.ParentElectronicMails)
                                                           .Include(x => x.Parent.ParentTelephones)
                                                   on s.StudentUsi equals spa.StudentUsi
                                               join palerts in _edFiDb.ParentAlerts
                                                            .Include(x => x.AlertTypes)
                                                     on spa.Parent.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                               from pa in ppa.DefaultIfEmpty()
                                               join pro in _edFiDb.ParentProfiles
                                                            .Include(x => x.ParentProfileElectronicMails)
                                                            .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                                    on spa.Parent.ParentUniqueId equals pro.ParentUniqueId into ppro
                                               from profile in ppro.DefaultIfEmpty()
                                               join ssae in _edFiDb.StudentSchoolAttendanceEvents
                                                            .Include(x => x.AttendanceEventCategoryDescriptor.Descriptor)
                                               on s.StudentUsi equals ssae.StudentUsi
                                               join sy in _edFiDb.SchoolYearTypes on ssae.SchoolYear equals sy.SchoolYear
                                               where pa.AlertsEnabled
                                                   && sy.CurrentSchoolYear // Only for current School Year
                                               group new { s, ssae, pa, profile, spa } by  new { s.StudentUsi, pa.ParentUniqueId } into g
                                               where g.Where(x => x.ssae.AttendanceEventCategoryDescriptor.Descriptor.CodeValue == excusedDescriptor).Count() >= excusedThreshold
                                                    || g.Where(x => x.ssae.AttendanceEventCategoryDescriptor.Descriptor.CodeValue == unexcusedDescriptor).Count() >= unexcusedThreshold
                                                    || g.Where(x => x.ssae.AttendanceEventCategoryDescriptor.Descriptor.CodeValue == tardyDescriptor).Count() >= tardyThreshold
                                               select new
                                               {
                                                   StudentUSI = g.Key.StudentUsi,
                                                   Data = g.GroupBy(x => x.pa.ParentUniqueId).Select(data => new StudentParentsAlertsProfilesModel
                                                   {
                                                       StudentParentAssociation = data.FirstOrDefault().spa,
                                                       ParentAlert = g.Select(x => x.pa).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault(),
                                                       ParentProfile = g.Select(x => x.profile).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault()
                                                   }),
                                                   excusedCount = g.Where(x => x.ssae.AttendanceEventCategoryDescriptorId == 242).Count(),
                                                   unexcusedCount = g.Where(x => x.ssae.AttendanceEventCategoryDescriptorId == 246).Count(),
                                                   tardyCount = g.Where(x => x.ssae.AttendanceEventCategoryDescriptorId == 245).Count(),
                                                   g.FirstOrDefault().s.FirstName,
                                                   g.FirstOrDefault().s.LastSurname,
                                                   g.FirstOrDefault().s.StudentUniqueId,
                                               }).ToListAsync();

            var result = studentsOverThreshold.ToList()
                .Select(x => new StudentAlertModel
                {
                    StudentUSI = x.StudentUSI,
                    StudentUniqueId = x.StudentUniqueId,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    StudentParentAssociations = x.Data.Select(spa => new StudentParentAssociationModel
                    {
                        ParentUsi = spa.StudentParentAssociation.ParentUsi,
                        Parent = MapParentModel(spa.StudentParentAssociation.Parent, spa.ParentProfile, spa.ParentAlert)
                    }).ToList(),
                    ExcusedCount = x.excusedCount,
                    TardyCount = x.tardyCount,
                    UnexcusedCount = x.unexcusedCount,
                }).ToList();

            return result;
        }

        public async Task<List<StudentAlertModel>> studentsOverThresholdAdaAbsence(decimal unexcusedThreshold, string absentDescriptor)
        {
            var studentsOverThreshold = await (from s in _edFiDb.Students
                                               join spa in _edFiDb.StudentParentAssociations
                                                           .Include(x => x.Parent.ParentElectronicMails)
                                                           .Include(x => x.Parent.ParentTelephones)
                                                   on s.StudentUsi equals spa.StudentUsi
                                               join palerts in _edFiDb.ParentAlerts
                                                            .Include(x => x.AlertTypes)
                                                     on spa.Parent.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                               from pa in ppa.DefaultIfEmpty()
                                               join pro in _edFiDb.ParentProfiles
                                                            .Include(x => x.ParentProfileElectronicMails)
                                                            .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                                    on spa.Parent.ParentUniqueId equals pro.ParentUniqueId into ppro
                                               from profile in ppro.DefaultIfEmpty()
                                               join ssae in _edFiDb.StudentSchoolAttendanceEvents
                                                            .Include(x => x.AttendanceEventCategoryDescriptor.Descriptor)
                                               on s.StudentUsi equals ssae.StudentUsi
                                               join sy in _edFiDb.SchoolYearTypes on ssae.SchoolYear equals sy.SchoolYear
                                               where pa.AlertsEnabled
                                                   && sy.CurrentSchoolYear
                                               group new { s, ssae, pa, profile, spa } by new { s.StudentUsi, pa.ParentUniqueId } into g
                                               where g.Where(x => x.ssae.AttendanceEventCategoryDescriptor.Descriptor.CodeValue == absentDescriptor).Count() >= unexcusedThreshold
                                               select new
                                               {
                                                   StudentUSI = g.Key.StudentUsi,
                                                   Data = g.GroupBy(x => x.pa.ParentUniqueId).Select(data => new StudentParentsAlertsProfilesModel
                                                   {
                                                       StudentParentAssociation = data.FirstOrDefault().spa,
                                                       ParentAlert = g.Select(x => x.pa).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault(),
                                                       ParentProfile = g.Select(x => x.profile).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault()
                                                   }),
                                                   g.FirstOrDefault().s.FirstName,
                                                   g.FirstOrDefault().s.LastSurname,
                                                   g.FirstOrDefault().s.StudentUniqueId,
                                                   valueCount = g.Where(x => x.ssae.AttendanceEventCategoryDescriptor.Descriptor.CodeValue == absentDescriptor).Count()
                                               }).ToListAsync();

            var result = studentsOverThreshold.ToList()
                .Select(x => new StudentAlertModel
                {
                    StudentUSI = x.StudentUSI,
                    StudentUniqueId = x.StudentUniqueId,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    StudentParentAssociations = x.Data.Select(spa => new StudentParentAssociationModel
                    {
                        ParentUsi = spa.StudentParentAssociation.ParentUsi,
                        Parent = MapParentModel(spa.StudentParentAssociation.Parent, spa.ParentProfile, spa.ParentAlert)
                    }).ToList(),
                    ValueCount = x.valueCount
                }).ToList();

            return result;
        }

        public async Task<List<StudentAlertModel>> studentsOverThresholdBehavior(decimal behaviorThreshold, string disciplineIncidentDescriptor)
        {
            var studentsOverThreshold = await (from s in _edFiDb.Students
                                               join spa in _edFiDb.StudentParentAssociations
                                                           .Include(x => x.Parent.ParentElectronicMails)
                                                           .Include(x => x.Parent.ParentTelephones)
                                                   on s.StudentUsi equals spa.StudentUsi
                                               join palerts in _edFiDb.ParentAlerts
                                                            .Include(x => x.AlertTypes)
                                                     on spa.Parent.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                               from pa in ppa.DefaultIfEmpty()
                                               join pro in _edFiDb.ParentProfiles
                                                            .Include(x => x.ParentProfileElectronicMails)
                                                            .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                                    on spa.Parent.ParentUniqueId equals pro.ParentUniqueId into ppro
                                               from profile in ppro.DefaultIfEmpty()
                                               join sdia in _edFiDb.StudentDisciplineIncidentAssociations on s.StudentUsi equals sdia.StudentUsi
                                               join spcd in _edFiDb.Descriptors on sdia.StudentParticipationCodeDescriptorId equals spcd.DescriptorId
                                               join di in _edFiDb.DisciplineIncidents on sdia.IncidentIdentifier equals di.IncidentIdentifier
                                               where pa.AlertsEnabled
                                                && _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId).Max(x => x.BeginDate) <= di.IncidentDate
                                                && spcd.CodeValue == disciplineIncidentDescriptor
                                               group new { s, pa, profile, spa } by new { s.StudentUsi, pa.ParentUniqueId } into g
                                               where g.Count() >= behaviorThreshold
                                               select new
                                               {
                                                   StudentUSI = g.Key.StudentUsi,
                                                   Data = g.GroupBy(x => x.pa.ParentUniqueId).Select(data => new StudentParentsAlertsProfilesModel
                                                   {
                                                       StudentParentAssociation = data.FirstOrDefault().spa,
                                                       ParentAlert = g.Select(x => x.pa).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault(),
                                                       ParentProfile = g.Select(x => x.profile).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault()
                                                   }),
                                                   behaviorCount = g.Count(),
                                                   g.FirstOrDefault().s.FirstName,
                                                   g.FirstOrDefault().s.LastSurname,
                                                   g.FirstOrDefault().s.StudentUniqueId,
                                               }).ToListAsync();

            var result = studentsOverThreshold.ToList()
                .Select(x => new StudentAlertModel
                {
                    StudentUSI = x.StudentUSI,
                    StudentUniqueId = x.StudentUniqueId,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    StudentParentAssociations = x.Data.Select(spa => new StudentParentAssociationModel
                    {
                        ParentUsi = spa.StudentParentAssociation.ParentUsi,
                        Parent = MapParentModel(spa.StudentParentAssociation.Parent, spa.ParentProfile, spa.ParentAlert)
                    }).ToList(),
                    ValueCount = x.behaviorCount

                }).ToList();

            return result;
        }

        public async Task<List<StudentAlertModel>> studentsOverThresholdAssignment(decimal assignmentThreshold, string[] gradeBookMissingAssignmentTypeDescriptors, string missingAssignmentLetterGrade)
        {

            var studentsOverThreshold = await (from s in _edFiDb.Students
                                               join spa in _edFiDb.StudentParentAssociations
                                                            .Include(x => x.Parent.ParentElectronicMails)
                                                            .Include(x => x.Parent.ParentTelephones)
                                                    on s.StudentUsi equals spa.StudentUsi
                                               join palerts in _edFiDb.ParentAlerts
                                                            .Include(x => x.AlertTypes)
                                                     on spa.Parent.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                               from pa in ppa.DefaultIfEmpty()
                                               join pro in _edFiDb.ParentProfiles
                                                            .Include(x => x.ParentProfileElectronicMails)
                                                            .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                                    on spa.Parent.ParentUniqueId equals pro.ParentUniqueId into ppro
                                               from profile in ppro.DefaultIfEmpty()
                                               join sge in _edFiDb.StudentGradebookEntries
                                                            .Include(x => x.GradebookEntry.GradebookEntryTypeDescriptor.Descriptor)
                                               on s.StudentUsi equals sge.StudentUsi
                                               join sy in _edFiDb.SchoolYearTypes on sge.SchoolYear equals sy.SchoolYear
                                               where pa.AlertsEnabled 
                                               && sge.DateFulfilled == null
                                               && sge.LetterGradeEarned == missingAssignmentLetterGrade
                                               && sge.GradebookEntry.GradebookEntryTypeDescriptorId != null
                                               && gradeBookMissingAssignmentTypeDescriptors.Contains(sge.GradebookEntry.GradebookEntryTypeDescriptor.Descriptor.CodeValue)
                                               && sy.CurrentSchoolYear
                                               group new { s, pa, profile, spa } by new { s.StudentUsi, pa.ParentUniqueId } into g
                                               where g.Count() >= assignmentThreshold
                                               select new
                                               {
                                                   StudentUSI = g.Key.StudentUsi,
                                                   Data = g.GroupBy(x => x.pa.ParentUniqueId).Select(data => new StudentParentsAlertsProfilesModel
                                                   {
                                                       StudentParentAssociation = data.FirstOrDefault().spa,
                                                       ParentAlert = g.Select(x => x.pa).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault(),
                                                       ParentProfile = g.Select(x => x.profile).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault()
                                                   }),
                                                   behaviorCount = g.Count(),
                                                   g.FirstOrDefault().s.FirstName,
                                                   g.FirstOrDefault().s.LastSurname,
                                                   g.FirstOrDefault().s.StudentUniqueId,
                                               }).ToListAsync();

            var result = studentsOverThreshold.ToList()
                .Select(x => new StudentAlertModel
                {
                    StudentUniqueId = x.StudentUniqueId,
                    StudentUSI = x.StudentUSI,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    StudentParentAssociations = x.Data.Select(spa => new StudentParentAssociationModel
                    {
                        ParentUsi = spa.StudentParentAssociation.ParentUsi,
                        Parent = MapParentModel(spa.StudentParentAssociation.Parent, spa.ParentProfile, spa.ParentAlert)
                    }).ToList(),
                    ValueCount = x.behaviorCount

                }).ToList();

            return result;
        }

        public async Task<List<StudentAlertModel>> studentsOverThresholdCourse(decimal courseThreshold, string gradeTypeGradingPeriodDescriptor)
        {

                var studentsOverThreshold = await (from s in _edFiDb.Students
                                                   join spa in _edFiDb.StudentParentAssociations
                                                                .Include(x => x.Parent.ParentElectronicMails)
                                                                .Include(x => x.Parent.ParentTelephones)
                                                        on s.StudentUsi equals spa.StudentUsi
                                                   join palerts in _edFiDb.ParentAlerts
                                                                .Include(x => x.AlertTypes)
                                                   on spa.Parent.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                                   from pa in ppa.DefaultIfEmpty()
                                                   join pro in _edFiDb.ParentProfiles
                                                                .Include(x => x.ParentProfileElectronicMails)
                                                                .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                                        on spa.Parent.ParentUniqueId equals pro.ParentUniqueId into ppro
                                                   from profile in ppro.DefaultIfEmpty()
                                                   join gra in _edFiDb.Grades
                                                                .Include(x => x.GradeTypeDescriptor.Descriptor)
                                                                .Include(x => x.GradingPeriod.GradingPeriodDescriptor.Descriptor)
                                                        on s.StudentUsi equals gra.StudentUsi
                                                   join sy in _edFiDb.SchoolYearTypes on gra.SchoolYear equals sy.SchoolYear
                                                   join co in _edFiDb.CourseOfferings
                                                           .Include(x => x.Course)
                                                           on new { gra.LocalCourseCode, gra.SchoolId, gra.SchoolYear, gra.SessionName }
                                                           equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.SessionName }
                                                   where pa.AlertsEnabled &&
                                                           gra.NumericGradeEarned.HasValue
                                                           && sy.CurrentSchoolYear
                                                           && gra.NumericGradeEarned.Value <= courseThreshold
                                                           && gra.GradeTypeDescriptor.Descriptor.CodeValue == gradeTypeGradingPeriodDescriptor
                                                   orderby gra.GradingPeriod.GradingPeriodDescriptor.Descriptor.CodeValue ascending
                                                   group new { s, co, gra, pa, profile, spa } by s.StudentUsi into g
                                                   select g).ToListAsync();

                var newdata = studentsOverThreshold
                    .Select(g => new {
                        StudentUSI = g.Key,
                        Data = g.GroupBy(x => x.pa.ParentUniqueId).Select(data => new StudentParentsAlertsProfilesModel
                        {
                            StudentParentAssociation = data.FirstOrDefault().spa,
                            ParentAlert = g.Select(x => x.pa).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault(),
                            ParentProfile = g.Select(x => x.profile).Where(x => x.ParentUniqueId == data.FirstOrDefault().spa.Parent.ParentUniqueId).FirstOrDefault()
                        }),
                        courseCount = g.Count(),
                        courses = g.Select(x => new ParentAlertCourseModel {
                            CourseTitle = $"{ x.co.Course.CourseTitle } {x.co.Course.CourseCode} ({x.gra.GradingPeriod.GradingPeriodDescriptor.Descriptor.CodeValue})",
                            GradeNumber = x.gra.NumericGradeEarned
                        }).ToList(),
                        g.FirstOrDefault().s.FirstName,
                        g.FirstOrDefault().s.LastSurname,
                        g.FirstOrDefault().s.StudentUniqueId,
                    });

                var result = newdata.ToList()
                .Select(x => new StudentAlertModel
                {
                    StudentUniqueId = x.StudentUniqueId,
                    StudentUSI = x.StudentUSI,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    Courses = x.courses,
                    StudentParentAssociations = x.Data.Select(spa => new StudentParentAssociationModel
                    {
                        ParentUsi = spa.StudentParentAssociation.ParentUsi,
                        Parent = MapParentModel(spa.StudentParentAssociation.Parent, spa.ParentProfile, spa.ParentAlert)
                    }).ToList(),
                    ValueCount = x.courseCount
                }).ToList();

                return result;
        }

        public async Task<bool> unreadMessageAlertWasSentBefore()
        {
            var today = DateTime.Today;
            return await _edFiDb.AlertLogs.AnyAsync(x => DbFunctions.TruncateTime(x.UtcSentDate) == today && x.AlertTypeId == AlertTypeEnum.Message.Value);
        }

        public async Task<bool> wasSentBefore(string parentUniqueId, string studentUniqueId, string absencesCount, SchoolYearTypeModel currentSchoolYear, int alertType)
        {
            var wasSentBefore = await _edFiDb.AlertLogs.AnyAsync(x =>
                                         x.SchoolYear == currentSchoolYear.SchoolYear
                                         && x.AlertTypeId == alertType
                                         && x.ParentUniqueId == parentUniqueId
                                         && x.StudentUniqueId == studentUniqueId
                                         && x.Value == absencesCount);
            return wasSentBefore;
        }

        public async Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId)
        {
            return await _edFiDb.AlertLogs
                            .Include(x => x.AlertType)
                            .Where(x => x.ParentUniqueId == parentUniqueId && x.StudentUniqueId == studentUniqueId && !x.Read)
                            .Select(x => new ParentStudentAlertLogModel
                            {
                                ParentUniqueId = x.ParentUniqueId,
                                StudentUniqueId = x.StudentUniqueId,
                                Value = x.Value,
                                AlertTypeName = x.AlertType.ShortDescription,
                                SentDate = x.UtcSentDate
                            }).ToListAsync();
        }

        public async Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId)
        {
            var alertlogs = _edFiDb.AlertLogs.Where(x => x.StudentUniqueId == studentUniqueId && x.ParentUniqueId == parentUniqueId && !x.Read).ToList();

            alertlogs.ForEach(log =>
            {
                log.Read = true;
            });

            await SaveChanges();
        }

        private ParentModel MapParentModel(Parent parent, ParentProfile profile, ParentAlert parentAlert)
        {
            var parentModel = new ParentModel();
            parentModel.ParentUniqueId = parent.ParentUniqueId;
            if (profile != null)
                SetParentContactInfo(parentModel, profile);
            if (profile == null || parentModel.Email == null)
                SetParentContactInfo(parentModel, parent);

            if (parentAlert == null)
                return parentModel;

            parentModel.ParentAlert.PreferredMethodOfContactTypeId = profile?.PreferredMethodOfContactTypeId;
            parentModel.ParentAlert.AlertTypeIds = parentAlert.AlertTypes.Select(x => x.AlertTypeId).ToList();
            parentModel.LanguageCode = profile.LanguageCode;
            return parentModel;
        }

        private void SetParentContactInfo(ParentModel parentModel, Parent parent)
        {
            var preferredMail = parent.ParentElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? parent.ParentElectronicMails.FirstOrDefault();

            parentModel.Email = mail?.ElectronicMailAddress;
        }

        private void SetParentContactInfo(ParentModel parentModel, ParentProfile parentProfile)
        {
            var preferredMail = parentProfile.ParentProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? parentProfile.ParentProfileElectronicMails.FirstOrDefault();

            var preferredTelephone = parentProfile.ParentProfileTelephones.FirstOrDefault(x => x.PrimaryMethodOfContact.HasValue && x.PrimaryMethodOfContact.Value);

            var telephone = preferredTelephone ?? parentProfile.ParentProfileTelephones.FirstOrDefault();

            parentModel.Email = mail?.ElectronicMailAddress;
            parentModel.Telephone = telephone?.TelephoneNumber;
            parentModel.SMSDomain = telephone?.TextMessageCarrierType?.SmsSuffixDomain;

        }

        public async Task<List<UnreadMessageAlertModel>> ParentsAndStaffWithUnreadMessages()
        {
            var parents = await (from p in _edFiDb.Parents
                                .Include(x => x.ParentElectronicMails)
                                .Include(x => x.ParentTelephones)
                                 join palerts in _edFiDb.ParentAlerts
                                                .Include(x => x.AlertTypes) 
                                         on p.ParentUniqueId equals palerts.ParentUniqueId into ppa
                                 from pa in ppa.DefaultIfEmpty()
                                 join pro in _edFiDb.ParentProfiles
                                               .Include(x => x.ParentProfileElectronicMails)
                                               .Include(x => x.ParentProfileTelephones.Select(t => t.TextMessageCarrierType))
                                         on p.ParentUniqueId equals pro.ParentUniqueId into ppro
                                  from profile in ppro.DefaultIfEmpty()
                                 where _edFiDb.ChatLogs.Any(cl => cl.RecipientTypeId == ChatLogPersonTypeEnum.Parent.Value && cl.RecipientUniqueId == p.ParentUniqueId && !cl.RecipientHasRead) &&
                                     pa != null && pa.AlertsEnabled
                                 select new ParentProfileAlertModel { Parent = p, ParentProfile = profile, ParentAlert = pa }).ToListAsync();

            var returnParents = parents.Select(x => new UnreadMessageAlertModel
            {
                FirstName = x.Parent.FirstName,
                LastSurname = x.Parent.LastSurname,
                UnreadMessageCount = _edFiDb.ChatLogs.Where(cl => cl.RecipientTypeId == ChatLogPersonTypeEnum.Parent.Value && cl.RecipientUniqueId == x.Parent.ParentUniqueId && !cl.RecipientHasRead).Count(),
                Email = getParentMail(x.ParentProfile) ?? getParentMail(x.Parent),
                Telephone = getParentTelephone(x.ParentProfile),
                SMSDomain = getParentSMSDomain(x.ParentProfile),
                PreferredMethodOfContactTypeId = x.ParentProfile?.PreferredMethodOfContactTypeId,
                AlertTypeIds = x.ParentAlert.AlertTypes.Select(pa => pa.AlertTypeId).ToList(),
                PersonUniqueId = x.Parent.ParentUniqueId,
                PersonType = "Parent",
                LanguageCode = x.ParentProfile.LanguageCode
            }).ToList();

            var staffs = await (from s in _edFiDb.Staffs
                                .Include(x => x.StaffElectronicMails)
                                .Include(x => x.StaffTelephones)
                                join pro in _edFiDb.StaffProfiles
                                                   .Include(x => x.StaffProfileElectronicMails)
                                                   .Include(x => x.StaffProfileTelephones.Select(t => t.TextMessageCarrierType))
                                             on s.StaffUniqueId equals pro.StaffUniqueId into spro
                                from profile in spro.DefaultIfEmpty()
                                where _edFiDb.ChatLogs.Any(cl => cl.RecipientTypeId == ChatLogPersonTypeEnum.Staff.Value && cl.RecipientUniqueId == s.StaffUniqueId && !cl.RecipientHasRead) 
                                select new
                                {
                                    Staff = s,
                                    Profile = profile,
                                }).ToListAsync();

            var returnstaffs = staffs.Select(x => new UnreadMessageAlertModel
            {
                FirstName = x.Staff.FirstName,
                LastSurname = x.Staff.LastSurname,
                UnreadMessageCount = _edFiDb.ChatLogs.Where(cl => cl.RecipientTypeId == ChatLogPersonTypeEnum.Staff.Value && cl.RecipientUniqueId == x.Staff.StaffUniqueId && !cl.RecipientHasRead).Count(),
                Email = getStaffMail(x.Profile) ?? getStaffMail(x.Staff),
                Telephone = getStaffTelephone(x.Profile),
                SMSDomain = getStaffSMSDomain(x.Profile),
                PreferredMethodOfContactTypeId = x.Profile?.PreferredMethodOfContactTypeId,
                //Note: As of when this code was written Staff do not have a way to configure what alerts they receive. 
                //Requirement specified for them to receive all types of alerts
                AlertTypeIds = new List<int>() { 1, 2, 3, 4, 5 },
                PersonUniqueId = x.Staff.StaffUniqueId,
                PersonType = "Staff"
            }).ToList();

            var result = returnParents;
            if (result == null)
                result = returnstaffs;
            else if (returnstaffs != null && returnstaffs.Count() > 0)
                result = returnParents.Concat(returnstaffs).ToList();

            return result;
        }

        private string getParentMail(Parent parent)
        {
            var preferredMail = parent.ParentElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? parent.ParentElectronicMails.FirstOrDefault();

            return mail?.ElectronicMailAddress;

        }

        private string getParentMail(ParentProfile parentProfile)
        {
            if (parentProfile == null)
                return null;

            var preferredMail = parentProfile.ParentProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? parentProfile.ParentProfileElectronicMails.FirstOrDefault();

            return mail?.ElectronicMailAddress;

        }

        private string getParentTelephone(ParentProfile parentProfile)
        {
            if(parentProfile == null)
                return null;

            var preferredTelephone = parentProfile.ParentProfileTelephones.FirstOrDefault(x => x.PrimaryMethodOfContact.HasValue && x.PrimaryMethodOfContact.Value);

            var telephone = preferredTelephone ?? parentProfile.ParentProfileTelephones.FirstOrDefault();

            return telephone?.TelephoneNumber;

        }

        private string getParentSMSDomain(ParentProfile parentProfile)
        {
            if(parentProfile == null)
                return null;

            var preferredTelephone = parentProfile.ParentProfileTelephones.FirstOrDefault(x => x.PrimaryMethodOfContact.HasValue && x.PrimaryMethodOfContact.Value);

            var telephone = preferredTelephone ?? parentProfile.ParentProfileTelephones.FirstOrDefault();

            return telephone?.TextMessageCarrierType?.SmsSuffixDomain;

        }

        private string getStaffMail(Staff staff)
        {
            var preferredMail = staff.StaffElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? staff.StaffElectronicMails.FirstOrDefault();

            return mail?.ElectronicMailAddress;

        }

        private string getStaffMail(StaffProfile staffProfile)
        {
            if (staffProfile == null)
                return null;

            var preferredMail = staffProfile.StaffProfileElectronicMails.FirstOrDefault(x => x.PrimaryEmailAddressIndicator.HasValue && x.PrimaryEmailAddressIndicator.Value);

            var mail = preferredMail ?? staffProfile.StaffProfileElectronicMails.FirstOrDefault();

            return mail?.ElectronicMailAddress;

        }

        private string getStaffTelephone(StaffProfile staffProfile)
        {
            if (staffProfile == null)
                return null;

            var preferredTelephone = staffProfile.StaffProfileTelephones.FirstOrDefault(x => x.PrimaryMethodOfContact.HasValue && x.PrimaryMethodOfContact.Value);

            var telephone = preferredTelephone ?? staffProfile.StaffProfileTelephones.FirstOrDefault();

            return telephone?.TelephoneNumber;

        }

        private string getStaffSMSDomain(StaffProfile staffProfile)
        {
            if (staffProfile == null)
                return null;

            var preferredTelephone = staffProfile.StaffProfileTelephones.FirstOrDefault(x => x.PrimaryMethodOfContact.HasValue && x.PrimaryMethodOfContact.Value);

            var telephone = preferredTelephone ?? staffProfile.StaffProfileTelephones.FirstOrDefault();

            return telephone?.TextMessageCarrierType?.SmsSuffixDomain;

        }

        private class StudentParentsAlertsProfilesModel
        {
            public StudentParentAssociation StudentParentAssociation { get; set; }
            public ParentAlert ParentAlert { get; set; }
            public ParentProfile ParentProfile { get; set; }
        }

        private class ParentProfileAlertModel
        {
            public Parent Parent { get; set; }
            public ParentAlert ParentAlert { get; set; }
            public ParentProfile ParentProfile { get; set; }
        }
    }
}
