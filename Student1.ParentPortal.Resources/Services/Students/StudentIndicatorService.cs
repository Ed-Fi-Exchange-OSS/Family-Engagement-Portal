using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using Student1.ParentPortal.Data.Models.EdFi25;
using StudentIndicator = Student1.ParentPortal.Models.Student.StudentIndicator;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentIndicatorService
    {
        Task<List<StudentIndicator>> GetStudentIndicatorsAsync(int studentUsi);
    }

    public class StudentIndicatorService : IStudentIndicatorService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentIndicatorService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<List<StudentIndicator>> GetStudentIndicatorsAsync(int studentUsi)
        {
            return await _studentRepository.GetStudentIndicatorsAsync(studentUsi);
        }
    }
}
