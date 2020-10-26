using System;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Date;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentBehaviorService
    {
        Task<StudentBehavior> GetStudentBehaviorAsync(int studentUsi);
    }

    public class StudentBehaviorService : IStudentBehaviorService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly IDateProvider _dateProvider;

        public StudentBehaviorService(IStudentRepository studentRepository, ICustomParametersProvider customParametersProvider, IDateProvider dateProvider)
        {
            _studentRepository = studentRepository;
            _customParametersProvider = customParametersProvider;
            _dateProvider = dateProvider;
        }

        public async Task<StudentBehavior> GetStudentBehaviorAsync(int studentUsi)
        {
            var incidents = await _studentRepository.GetStudentDisciplineIncidentsAsync(studentUsi, _customParametersProvider.GetParameters().descriptors.disciplineIncidentDescriptor, _dateProvider.Today());

            var externalLink = _customParametersProvider.GetParameters().behavior.linkToSystemWithDetails;
            var behaviorLink = new LinkModel { Title = externalLink.title, LinkText = externalLink.linkText, Url = externalLink.url };

            var model = new StudentBehavior
            {
                DateAsOf = DateTime.Now,
                YearToDateDisciplineIncidentCount = incidents.Count,
                Interpretation = InterpretIncidentCount(incidents.Count),
                DisciplineIncidents = incidents,
                ExternalLink = behaviorLink
            };


            return model;
        }

        private string InterpretIncidentCount(int incidentCount)
        {
            return _customParametersProvider.GetParameters().behavior.thresholdRules.GetRuleThatApplies(incidentCount).interpretation;
        }
    }
}
