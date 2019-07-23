using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using System;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Resources.Providers.Date;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentScheduleService
    {
        Task<StudentScheduleEntry> GetStudentScheduleAsync(int studentUsi);
    }

    public class StudentScheduleService : IStudentScheduleService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly IDateProvider _dateProvider;

        public StudentScheduleService(IStudentRepository studentRepository, IDateProvider dateProvider)
        {
            _studentRepository = studentRepository;
            _dateProvider = dateProvider;
        }

        public async Task<StudentScheduleEntry> GetStudentScheduleAsync(int studentUsi)
        {
            var data = await _studentRepository.GetStudentScheduleAsync(studentUsi, _dateProvider.Monday(), _dateProvider.Friday());

            var scheduleDays = (from m in data
                                group m by m.Date into g
                                select new ScheduleDay
                                {
                                    Date = g.Key,
                                    ScheduleName = g.First().BellScheduleName,
                                    Events = g.Select(x => new ScheduleEvent
                                    {
                                        ScheduleName = x.BellScheduleName,
                                        Date = x.Date,
                                        CourseTitle = x.CourseTitle,
                                        StartTime = x.StartTime.SetTimeOnDate(g.Key),
                                        EndTime = x.EndTime.SetTimeOnDate(g.Key),
                                        ClassroomIdentificationCode = x.ClassroomIdentificationCode,
                                        FirstName = x.FirstName,
                                        MiddleName = x.MiddleName,
                                        LastSurname = x.LastSurname,
                                    }).ToList()
                                }).ToList();

            return new StudentScheduleEntry { Days = scheduleDays };
        }

    }
}
