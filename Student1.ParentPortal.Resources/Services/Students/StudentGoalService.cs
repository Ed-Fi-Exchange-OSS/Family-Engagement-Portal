using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Student;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentGoalService
    {
        Task<StudentGoal> AddStudentGoal(StudentGoal studentGoal);
        Task<StudentGoal> UpdateStudentGoal(StudentGoal studentGoal);
        Task<bool> AddStudentGoalStep(StudentGoalStep studentGoalStep);
        Task<bool> UpdateStudentGoalStep(StudentGoalStep studentGoalStep);
        Task<List<StudentGoal>> GetStudentGoals(int studentUsi);
        Task<List<StudentGoalLabel>> GetStudentGoalLabels();
        Task<StudentGoal> UpdateStudentGoalIntervention(StudentGoalIntervention entity);
    }

    public class StudentGoalService: IStudentGoalService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentGoalService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<StudentGoal> AddStudentGoal(StudentGoal studentGoal)
        {
            return await _studentRepository.AddStudentGoal(studentGoal);
        }

        public async Task<StudentGoal> UpdateStudentGoal(StudentGoal studentGoal)
        {
            return await _studentRepository.UpdateStudentGoal(studentGoal);
        }

        public async Task<bool> AddStudentGoalStep(StudentGoalStep studentGoalStep)
        {
            return await _studentRepository.AddStudentGoalStep(studentGoalStep);
        }

        public async Task<bool> UpdateStudentGoalStep(StudentGoalStep studentGoalStep)
        {
            return await _studentRepository.UpdateStudentGoalStep(studentGoalStep);
        }

        public async Task<List<StudentGoal>> GetStudentGoals(int studentUsi)
        {
            return await _studentRepository.GetStudentGoals(studentUsi);
        }

        public async Task<List<StudentGoalLabel>> GetStudentGoalLabels()
        {
            return await _studentRepository.GetStudentGoalLabels();
        }

        public async Task<StudentGoal> UpdateStudentGoalIntervention(StudentGoalIntervention entity)
        {
            return await _studentRepository.UpdateStudentGoalIntervention(entity);
        }
    }
}
