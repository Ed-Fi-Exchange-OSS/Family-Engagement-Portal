using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Schools;
using Student1.ParentPortal.Models.Shared;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Resources.Cache;

namespace Student1.ParentPortal.Resources.Services.Schools
{
    public interface ISchoolsService 
    {
        [NoCache]
        Task<List<GradeModel>> GetGradeLevelsBySchoolId(int schoolId);
        [NoCache]
        Task<List<ProgramsModel>> GetProgramssBySchoolId(int schoolId);
        [NoCache]
        Task<List<SchoolBriefDetailModel>> GetSchoolsByPrincipal(int staffUsi);
        [NoCache]
        Task<List<SchoolBriefDetailModel>> GetDistinctSchoolsByPrincipal(int staffUsi);
        [NoCache]
        Task<List<GradeModel>> GetOnlyGradeLevelsBySchoolId(int schoolId);
    }
    public class SchoolsService : ISchoolsService
    {
        private readonly ISchoolsRepository _schoolsRepository;

        public SchoolsService(ISchoolsRepository schoolsRepository) 
        {
            _schoolsRepository = schoolsRepository;
        }

        public async Task<List<GradeModel>> GetGradeLevelsBySchoolId(int schoolId)
        {
            var gradeSort = new GradeSortExtensionMethods();
            var gradesLevels = await _schoolsRepository.GetGradeLevelsBySchoolId(schoolId);
            gradesLevels.Sort(gradeSort);
            gradesLevels.Insert(0, new GradeModel { Id = 0, Name = "All Grade Levels" });
            return gradesLevels;
        }

        public async Task<List<ProgramsModel>> GetProgramssBySchoolId(int schoolId)
        {
            var programs = await _schoolsRepository.GetProgramsBySchoolId(schoolId);
            programs.Insert(0, new ProgramsModel { Id = 0, Name = "All Programs" });
            return programs;
        }

        public async Task<List<SchoolBriefDetailModel>> GetSchoolsByPrincipal(int staffUsi)
        {
            return await _schoolsRepository.GetSchoolsByPrincipal(staffUsi);
        }

        public async Task<List<SchoolBriefDetailModel>> GetDistinctSchoolsByPrincipal(int staffUsi)
        {
            List<SchoolBriefDetailModel> result = new List<SchoolBriefDetailModel>();
            List<SchoolBriefDetailModel> listSchools = await _schoolsRepository.GetSchoolsByPrincipal(staffUsi);
            List<int> idsSchools = listSchools.Select(rec => rec.SchoolId).Distinct().ToList();
            idsSchools.ForEach(rec => result.Add(listSchools.FirstOrDefault(sch => sch.SchoolId == rec)));
            return result;
        }

        public async Task<List<GradeModel>> GetOnlyGradeLevelsBySchoolId(int schoolId)
        {
            var gradeSort = new GradeSortExtensionMethods();
            var gradesLevels = (await _schoolsRepository.GetGradeLevelsBySchoolId(schoolId)).OrderBy(rec => rec.Name).ToList();
            gradesLevels.Sort(gradeSort); 
            return gradesLevels;
        }
    }
}
