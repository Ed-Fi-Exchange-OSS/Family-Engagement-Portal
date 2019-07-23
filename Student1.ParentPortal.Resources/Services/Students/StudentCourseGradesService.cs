using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.ExtensionMethods;
using Student1.ParentPortal.Resources.Providers.ClassPeriodName;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentCourseGradesService
    {
        Task<StudentCourseGrades> GetStudentCourseGradesAsync(int studentUsi, bool withStaffPictures=true);
    }

    public class StudentCourseGradesService : IStudentCourseGradesService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly IImageProvider _imageProvider;
        private readonly IClassPeriodNameProvider _classPeriodNameProvider;

        public StudentCourseGradesService(IStudentRepository studentRepository, ICustomParametersProvider customParametersProvider, IImageProvider imageProvider, IClassPeriodNameProvider classPeriodNameProvider)
        {
            _studentRepository = studentRepository;
            _customParametersProvider = customParametersProvider;
            _imageProvider = imageProvider;
            _classPeriodNameProvider = classPeriodNameProvider;
        }

        public async Task<StudentCourseGrades> GetStudentCourseGradesAsync(int studentUsi, bool withStaffPictures = true)
        {
            var gpa = await GetStudentGPAAsync(studentUsi);
            var currentCourses = await GetStudentGradesByGradingPeriod(studentUsi, withStaffPictures);

            var externalLink = _customParametersProvider.GetParameters().courseGrades.linkToSystemWithDetails;
            var courseGradesLink = new LinkModel { Title = externalLink.title, LinkText = externalLink.linkText, Url = externalLink.url };

            currentCourses.ForEach(x =>
            {
                x.ClassPeriodName = _classPeriodNameProvider.ParseClassPeriodName(x.ClassPeriodName);
                interpretCourseGrades(x.GradesByGradingPeriod);
                interpretCourseGrades(x.GradesByExam);
                interpretCourseGrades(x.GradesBySemester);
                interpretCourseGrades(x.GradesByFinal);
                x.GradesByGradingPeriod = mapGradingPeriodGrades(x.GradesByGradingPeriod);
                x.GradesByExam = mapGradingPeriodExam(x.GradesByExam);
                x.GradesBySemester = mapGradingPeriodExam(x.GradesBySemester);
            });

            var model = new StudentCourseGrades
            {
                GPA = new StudentGPA
                {
                    GPA = gpa,
                    Interpretation = gpa.HasValue ? InterpretGPA(gpa.Value) : "",
                    NationalAverageGPA = _customParametersProvider.GetParameters().courseGrades.gpa.nationalAverage
                },
                CurrentCourses = currentCourses,
                CurrentGradeAverage = GetStudentCurrentGradeAverage(currentCourses),
                Transcript = await GetStudentTranscriptAsync(studentUsi),
            };
            model.ExternalLink = courseGradesLink;

            return model;
        }

        private List<StudentCourseGrade> mapGradingPeriodExam(List<StudentCourseGrade> gradesByExam)
        {
            var gradingPeriods = _customParametersProvider.GetParameters().descriptors.examGradingPeriods;

            var resultList = new List<StudentCourseGrade>();

            for (int i = 0; i < gradingPeriods.Length; i++)
            {
                var gradePeriod = gradesByExam.Find(x => x.GradingPeriodType == gradingPeriods[i]);

                if (gradePeriod == null)
                    resultList.Add(new StudentCourseGrade { GradingPeriodType = gradingPeriods[i] });
                else
                    resultList.Add(gradePeriod);
            }

            return resultList;
        }

        private List<StudentCourseGrade> mapGradingPeriodGrades(List<StudentCourseGrade> gradesByGradingPeriod)
        {
            var gradingPeriods = _customParametersProvider.GetParameters().descriptors.schoolGradingPeriodDescriptors;
            var resultList = new List<StudentCourseGrade>();

            for (int i = 0; i < gradingPeriods.Length; i++)
            {
                var gradePeriod = gradesByGradingPeriod.Find(x => x.GradingPeriodType == gradingPeriods[i]);

                if (gradePeriod == null)
                    resultList.Add(new StudentCourseGrade { GradingPeriodType = gradingPeriods[i] });
                else
                    resultList.Add(gradePeriod);
            }

            return resultList;
        }

        private void interpretCourseGrades(List<StudentCourseGrade> courseGrades)
        {
            courseGrades.ForEach(x =>
            {
                if(x.NumericGradeEarned.HasValue)
                x.GradeInterpretation = _customParametersProvider.GetParameters()
                                                .courseGrades.courseAverage.thresholdRules
                                                .GetRuleThatApplies(x.NumericGradeEarned.Value).interpretation;
            });
        }

        private async Task<decimal?> GetStudentGPAAsync(int studentUsi)
        {
            var gpa = await _studentRepository.GetStudentGPAAsync(studentUsi);
            return gpa;
        }

        private async Task<List<StudentCourseSessionTaken>> GetStudentTranscriptAsync(int studentUsi)
        {            
            var transcript = await _studentRepository.GetStudentTranscriptCoursesAsync(studentUsi);

            // Add a gradelevel index for sorting if needed.
            foreach (var t in transcript)
                t.GradeLevelIndex = GetGradeLevelIndex(t.GradeLevelTaken);

            // Group into SchoolYear -> Gradelevel -> SessionName
            var coursesBySession = (from c in transcript
                        group c by new {c.SchoolYearTaken, c.GradeLevelTaken, c.SessionName} into g
                        select new StudentCourseSessionTaken
                        {
                            SchoolYearTaken = g.Key.SchoolYearTaken,
                            GradeLevelTaken = g.Key.GradeLevelTaken,
                            SessionName = g.Key.SessionName,
                            Courses = g.ToList()
                        }).OrderByDescending(x=>x.SchoolYearTaken).ThenByDescending(x=>x.GradeLevelTaken).ToList();

            return coursesBySession;
        }

        private int GetGradeLevelIndex(string gl)
        {
            var edfiGradeLevels = new[] { "First grade", "Second grade", "Third grade", "Fourth grade", "Fith grade", "Sixth grade", "Seventh grade", "Eighth grade", "Ninth grade", "Tenth grade", "Eleventh grade", "Twelfth grade" };

            for (var i = 0; i < edfiGradeLevels.Length; i++)
                if (edfiGradeLevels[i] == gl)
                    return i;

            return -1;
        }

        private string InterpretGPA(decimal gpa)
        {
            return _customParametersProvider.GetParameters()
                            .courseGrades.gpa.thresholdRules
                            .GetRuleThatApplies(gpa).interpretation;
        }

        private async Task<List<StudentCurrentCourse>> GetStudentGradesByGradingPeriod(int studentUsi, bool withStaffPictures=true)
        {

            var descriptors = _customParametersProvider.GetParameters().descriptors;
            var courses = await _studentRepository.GetStudentGradesByGradingPeriodAsync(studentUsi, descriptors.gradeTypeGradingPeriodDescriptor, descriptors.gradeTypeSemesterDescriptor, descriptors.gradeTypeExamDescriptor, descriptors.gradeTypeFinalDescriptor);

            if (!withStaffPictures) return courses;
            
            // Group the staff to get images on a more performant way.
            var staffUniqueIds = courses.GroupBy(x => x.StaffUniqueId).Select(g => g.Key);

            foreach (var staffUniqueId in staffUniqueIds)
            {
                var imgUrl = await _imageProvider.GetStaffImageUrlAsync(staffUniqueId);
                foreach (var course in courses.Where(x=>x.StaffUniqueId==staffUniqueId))
                    course.ImageUrl = imgUrl;
            }

            return courses;
        }

        private StudentCurrentGradeAverage GetStudentCurrentGradeAverage(List<StudentCurrentCourse> currentCourses)
        {
            // If we have the final grades then lets calculate based on that and return.
            // If we have the Semesters lets calculate based on that.
            // If not lets calculate based on grading periods.

            // Final grade calculation
            if (currentCourses.Any(x => x.GradesByFinal.Any()))
                return CalcualteByFinalGrade(currentCourses);

            // Semester calculation
            if (currentCourses.Any(x => x.GradesBySemester.Any()))
                return CalcualteBySemesterGrades(currentCourses);

            // Exam calculation
            if (currentCourses.Any(x => x.GradesByExam.Any()))
                return CalcualteByExamAndGradePeriodsGrades(currentCourses);

            // Grading period calculation
            if (currentCourses.Any(x => x.GradesByGradingPeriod.Any()))
                    return CalcualteByGradingPeriodGrades(currentCourses);

            return null;
        }

        private StudentCurrentGradeAverage CalcualteByFinalGrade(List<StudentCurrentCourse> currentCourses)
        {
            var missingFinalGrades = 0;
            var totalGradesTakenIntoAccount = 0;
            decimal sumOfGrades = 0;

            foreach (var c in currentCourses)
            {
                var finalGrade = c.GradesByFinal.SingleOrDefault();
                if (finalGrade != null && finalGrade.NumericGradeEarned != null)
                {
                    sumOfGrades += finalGrade.NumericGradeEarned.Value;
                    totalGradesTakenIntoAccount++;
                }
                else { missingFinalGrades++; }
            }

            var gradeAverage = sumOfGrades / totalGradesTakenIntoAccount;

            return new StudentCurrentGradeAverage
            {
                GradeAverage = gradeAverage,
                Evaluation = InterpretCurrentGradeAverage(gradeAverage)
            };
        }

        private StudentCurrentGradeAverage CalcualteBySemesterGrades(List<StudentCurrentCourse> currentCourses)
        {
            var gradeAverage = currentCourses.Average(x => x.GradesBySemester.Average(g => g.NumericGradeEarned));

            if (!gradeAverage.HasValue)
                return null;

            return new StudentCurrentGradeAverage
            {
                GradeAverage = gradeAverage.Value,
                Evaluation = InterpretCurrentGradeAverage(gradeAverage.Value)
            };
        }

        private StudentCurrentGradeAverage CalcualteByGradingPeriodGrades(List<StudentCurrentCourse> currentCourses)
        {
            var gradeAverage = currentCourses.Average(x => x.GradesByGradingPeriod.Average(g => g.NumericGradeEarned));


            if (!gradeAverage.HasValue)
                return null;

            return new StudentCurrentGradeAverage
            {
                GradeAverage = gradeAverage.Value,
                Evaluation = InterpretCurrentGradeAverage(gradeAverage.Value)
            };
        }

        private StudentCurrentGradeAverage CalcualteByExamAndGradePeriodsGrades(List<StudentCurrentCourse> currentCourses)
        {
            var gradeAverage = currentCourses.Average(x => x.GradesByExam.Concat(x.GradesByGradingPeriod).Average(g => g.NumericGradeEarned));


            if (!gradeAverage.HasValue)
                return null;

            return new StudentCurrentGradeAverage
            {
                GradeAverage = gradeAverage.Value,
                Evaluation = InterpretCurrentGradeAverage(gradeAverage.Value)
            };
        }

        private string InterpretCurrentGradeAverage(decimal gradeAverage)
        {
            return _customParametersProvider.GetParameters()
                            .courseGrades.courseAverage.thresholdRules
                            .GetRuleThatApplies(gradeAverage).interpretation;
        }
    }
}
