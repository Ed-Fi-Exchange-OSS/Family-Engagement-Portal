using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class AdminRepository : IAdminRepository
    {
        private readonly EdFi31Context _edFiDb;
        public AdminRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<PersonIdentityModel>> GetAdminIdentityByEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Staffs
                                         join sa in _edFiDb.StaffElectronicMails on s.StaffUsi equals sa.StaffUsi
                                         join a in _edFiDb.Admins on sa.ElectronicMailAddress equals a.ElectronicMailAddress
                                         where a.ElectronicMailAddress == email
                                         select new PersonIdentityModel
                                         {
                                             Usi = s.StaffUsi,
                                             UniqueId = s.StaffUniqueId,
                                             PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                             FirstName = s.FirstName,
                                             LastSurname = s.LastSurname,
                                             Email = a.ElectronicMailAddress
                                         }).ToListAsync();
            if(!identity.Any())
                identity = await (from p in _edFiDb.Parents
                                    join pa in _edFiDb.ParentElectronicMails on p.ParentUsi equals pa.ParentUsi
                                    join a in _edFiDb.Admins on pa.ElectronicMailAddress equals a.ElectronicMailAddress
                                    where a.ElectronicMailAddress == email
                                    select new PersonIdentityModel
                                    {
                                        Usi = p.ParentUsi,
                                        UniqueId = p.ParentUniqueId,
                                        PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                                        FirstName = p.FirstName,
                                        LastSurname = p.LastSurname,
                                        Email = a.ElectronicMailAddress
                                    }).ToListAsync();

            return identity;
        }

        public async Task<AdminStudentDetailFeatureModel> GetStudentDetailFeatures()
        {
            AdminStudentDetailFeatureModel result = new AdminStudentDetailFeatureModel();
            var exist = await _edFiDb.AdminStudentDetailFeatures.FirstOrDefaultAsync();

            if (exist != null)
            {
                result.AdminStudentDetailFeaturesId = exist.AdminStudentDetailFeaturesId;
                result.AllAboutMe = exist.AllAboutMe;
                result.Arc = exist.Arc;
                result.Assessment = exist.Assessment;
                result.AttendanceIndicator = exist.AttendanceIndicator;
                result.AttendanceLog = exist.AttendanceLog;
                result.BehaviorIndicator = exist.BehaviorIndicator;
                result.BehaviorLog = exist.BehaviorLog;
                result.Calendar = exist.Calendar;
                result.CollegeInitiativeCorner = exist.CollegeInitiativeCorner;
                result.CourseAverageIndicator = exist.CourseAverageIndicator;
                result.CourseGrades = exist.CourseGrades;
                result.DateCreated = exist.DateCreated;
                result.DateUpdated = exist.DateUpdated;
                result.Goals = exist.Goals;
                result.MissingAssignments = exist.MissingAssignments;
                result.MissingAssignmentsIndicator = exist.MissingAssignmentsIndicator;
                result.Profile = exist.Profile;
                result.StaarAssessment = exist.StaarAssessment;
                result.SuccessTeam = exist.SuccessTeam;
            }

            return result;
        }

        public async Task<AdminStudentDetailFeatureModel> SaveStudentDetailFeatures(AdminStudentDetailFeatureModel model)
        {
            AdminStudentDetailFeatureModel result = new AdminStudentDetailFeatureModel();

            if (model.AdminStudentDetailFeaturesId == 0)
            {
                var newRecord = _edFiDb.AdminStudentDetailFeatures.Add(new AdminStudentDetailFeature
                {
                    AllAboutMe = model.AllAboutMe,
                    Arc = model.Arc,
                    Assessment = model.Assessment,
                    AttendanceIndicator = model.AttendanceIndicator,
                    AttendanceLog = model.AttendanceLog,
                    CourseAverageIndicator = model.CourseAverageIndicator,
                    MissingAssignments = model.MissingAssignments,
                    MissingAssignmentsIndicator = model.MissingAssignmentsIndicator,
                    StaarAssessment = model.StaarAssessment,
                    BehaviorIndicator = model.BehaviorIndicator,
                    BehaviorLog = model.BehaviorLog,
                    Calendar = model.Calendar,
                    CollegeInitiativeCorner = model.CollegeInitiativeCorner,
                    CourseGrades = model.CourseGrades,
                    Goals = model.Goals,
                    Profile = model.Profile,
                    SuccessTeam = model.SuccessTeam,
                    DateCreated = DateTime.Now,
                    DateUpdated = DateTime.Now,
                });

                await _edFiDb.SaveChangesAsync();
                model.AdminStudentDetailFeaturesId = newRecord.AdminStudentDetailFeaturesId;
                model.DateCreated = newRecord.DateCreated;
                model.DateUpdated = newRecord.DateUpdated;
            }
            else
            {
                var recordToUpdate = await _edFiDb.AdminStudentDetailFeatures.FirstOrDefaultAsync(rec => rec.AdminStudentDetailFeaturesId == model.AdminStudentDetailFeaturesId);
                recordToUpdate.AdminStudentDetailFeaturesId = model.AdminStudentDetailFeaturesId;
                recordToUpdate.AllAboutMe = model.AllAboutMe;
                recordToUpdate.Arc = model.Arc;
                recordToUpdate.Assessment = model.Assessment;
                recordToUpdate.AttendanceIndicator = model.AttendanceIndicator;
                recordToUpdate.AttendanceLog = model.AttendanceLog;
                recordToUpdate.BehaviorIndicator = model.BehaviorIndicator;
                recordToUpdate.BehaviorLog = model.BehaviorLog;
                recordToUpdate.Calendar = model.Calendar;
                recordToUpdate.CollegeInitiativeCorner = model.CollegeInitiativeCorner;
                recordToUpdate.CourseAverageIndicator = model.CourseAverageIndicator;
                recordToUpdate.CourseGrades = model.CourseGrades;
                recordToUpdate.DateCreated = model.DateCreated;
                recordToUpdate.DateUpdated = model.DateUpdated;
                recordToUpdate.Goals = model.Goals;
                recordToUpdate.MissingAssignments = model.MissingAssignments;
                recordToUpdate.MissingAssignmentsIndicator = model.MissingAssignmentsIndicator;
                recordToUpdate.Profile = model.Profile;
                recordToUpdate.StaarAssessment = model.StaarAssessment;
                recordToUpdate.SuccessTeam = model.SuccessTeam;
                recordToUpdate.DateUpdated = DateTime.Now;                
                await _edFiDb.SaveChangesAsync();
            }

            result = model;
            return result;
        }
    }
}
