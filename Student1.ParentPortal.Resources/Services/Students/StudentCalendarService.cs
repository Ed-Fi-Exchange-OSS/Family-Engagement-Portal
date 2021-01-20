using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Models.Student;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentCalendarService
    {
        Task<StudentCalendar> GetStudentCalendar(int studentUsi);
    }

    public class StudentCalendarService : IStudentCalendarService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly IStudentAttendanceService _studentAtttendanceRepository;
        private readonly ICustomParametersProvider _customParametersProvider;

        public StudentCalendarService(
            IStudentRepository studentRepository, 
            ICustomParametersProvider customParametersProvider,
            IStudentAttendanceService studentAtttendanceRepository)
        {
            _studentRepository = studentRepository;
            _customParametersProvider = customParametersProvider;
            _studentAtttendanceRepository = studentAtttendanceRepository;
        }

        public async Task<StudentCalendar> GetStudentCalendar(int studentUsi)
        {
            StudentAttendance studentAttendance = await _studentAtttendanceRepository.GetStudentAttendanceAsync(studentUsi);

            var descriptors = _customParametersProvider.GetParameters().descriptors;
            var days = await _studentRepository.GetStudentCalendarDays(studentUsi);

            var calendar = new StudentCalendar();

            calendar.InstructionalDays = days.Where(x => x.Event.Description == descriptors.instructionalDayDescriptorCodeValue).ToList();
            calendar.NonInstructionalDays = days.Where(x => x.Event.Description == descriptors.nonInstrunctionalDayDescriptorCodeValue).ToList();

            calendar.AttendanceEventDays = new List<StudentCalendarDay>();
            calendar.AttendanceEventDays.AddRange(studentAttendance.ExcusedAttendanceEvents.Select(x => new StudentCalendarDay
            {
                Date = x.DateOfEvent,
                Event = new StudentCalendarEvent { Name = x.EventCategory, Description = x.EventDescription }

            }).ToList());

            calendar.AttendanceEventDays.AddRange(studentAttendance.UnexcusedAttendanceEvents.Select(x => new StudentCalendarDay
            {
                Date = x.DateOfEvent,
                Event = new StudentCalendarEvent { Name = x.EventCategory, Description = x.EventDescription }

            }).ToList());

            calendar.AttendanceEventDays.AddRange(studentAttendance.TardyAttendanceEvents.Select(x => new StudentCalendarDay
            {
                Date = x.DateOfEvent,
                Event = new StudentCalendarEvent { Name = x.EventCategory, Description = x.EventDescription }

            }).ToList());

            return calendar;
        }
    }
}
