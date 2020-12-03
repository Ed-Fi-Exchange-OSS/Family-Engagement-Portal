using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Student;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentAllAboutService
    {
        Task<StudentAllAbout> AddStudentAllAbout(StudentAllAbout studentAllAbout);
        Task<StudentAllAbout> UpdateStudentAllAbout(StudentAllAbout studentAllAbout);
        Task<StudentAllAbout> GetStudentAllAbout(int studentUsi);
    }

    public class StudentAllAboutService : IStudentAllAboutService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentAllAboutService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<StudentAllAbout> AddStudentAllAbout(StudentAllAbout studentAllAbout)
        {
            return await _studentRepository.AddStudentAllAbout(studentAllAbout);
        }

        public async Task<StudentAllAbout> UpdateStudentAllAbout(StudentAllAbout studentAllAbout)
        {
            return await _studentRepository.UpdateStudentAllAbout(studentAllAbout);
        }

        public async Task<StudentAllAbout> GetStudentAllAbout(int studentUsi)
        {
            return await _studentRepository.GetStudentAllAbout(studentUsi);
        }
    }
}
