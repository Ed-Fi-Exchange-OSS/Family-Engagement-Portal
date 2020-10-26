using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentProgramService
    {
        Task<List<StudentProgram>> GetStudentProgramsAsync(int studentUsi);
    }

    public class StudentProgramService : IStudentProgramService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentProgramService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<List<StudentProgram>> GetStudentProgramsAsync(int studentUsi)
        {

            return await _studentRepository.GetStudentProgramsAsync(studentUsi);
        }
    }
}
