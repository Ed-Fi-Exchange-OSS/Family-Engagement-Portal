using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.Providers.Configuration;
using System.Linq;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentAttendanceService
    {
        Task<StudentAttendance> GetStudentAttendanceAsync(int studentUsi);
        Task<List<StudentAbsencesCount>> GetStudentsWithAbsenceCountGreaterOrEqualThanThresholdCountAsync(int thresholdCount);
    }

    public class StudentAttendanceService : IStudentAttendanceService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly ICustomParametersProvider _customParametersProvider;

        public StudentAttendanceService(IStudentRepository studentRepository, ICustomParametersProvider customParametersProvider)
        {
            _studentRepository = studentRepository;
            _customParametersProvider = customParametersProvider;
        }

        public async Task<StudentAttendance> GetStudentAttendanceAsync(int studentUsi)
        {
            var attendanceEvents = await _studentRepository.GetStudentAttendanceEventsAsync(studentUsi);

            var absenceThresholdDays = _customParametersProvider.GetParameters().attendance.ADA.maxAbsencesCountThreshold;
            var descriptors = _customParametersProvider.GetParameters().descriptors;

            var excusedEvents = attendanceEvents.Where(ae => ae.EventCategory == descriptors.excusedAbsenceDescriptorCodeValue).ToList();
            var unexcusedEvents = attendanceEvents.Where(ae => ae.EventCategory == descriptors.unexcusedAbsenceDescriptorCodeValue).ToList();
            var tardyEvents = attendanceEvents.Where(ae => ae.EventCategory == descriptors.tardyDescriptorCodeValue).ToList();
            var abscentEvents = attendanceEvents.Where(ae => ae.EventCategory == descriptors.absentDescriptorCodeValue).ToList();

            return new StudentAttendance
            {
                AbsenceThresholdDays = absenceThresholdDays,
                ExcusedInterpretation = InterpretExcusedAbsencesCount(excusedEvents.Count()),
                UnexcusedInterpretation = InterpretUnexcusedAbsencesCount(unexcusedEvents.Count()),
                TardyInterpretation = InterpretTardiesCount(tardyEvents.Count()),
                AbsentInterpretation = InterpretUnexcusedAbsencesCount(abscentEvents.Count()),
                YearToDateAbsenceCount = abscentEvents.Count(),
                ExcusedAttendanceEvents = excusedEvents,
                UnexcusedAttendanceEvents = unexcusedEvents,
                TardyAttendanceEvents = tardyEvents,
                AbsentAttendanceEvents = abscentEvents
            };
        }

        public async Task<List<StudentAbsencesCount>> GetStudentsWithAbsenceCountGreaterOrEqualThanThresholdCountAsync(int thresholdCount)
        {
            var studentsAndAbsenceCount = await _studentRepository.GetStudentsWithAbsenceCountGreaterOrEqualThanThresholdAsync(thresholdCount);

            return studentsAndAbsenceCount;
        }

        private string InterpretExcusedAbsencesCount(int absencesCount)
        {
            return _customParametersProvider.GetParameters().attendance.ADA.excused.thresholdRules.GetRuleThatApplies(absencesCount).interpretation;
        }
        private string InterpretUnexcusedAbsencesCount(int absencesCount)
        {
            return _customParametersProvider.GetParameters().attendance.ADA.unexcused.thresholdRules.GetRuleThatApplies(absencesCount).interpretation;
        }
        private string InterpretTardiesCount(int absencesCount)
        {
            return _customParametersProvider.GetParameters().attendance.ADA.tardy.thresholdRules.GetRuleThatApplies(absencesCount).interpretation;
        }
    }
}
