using Student1.ParentPortal.Resources.Providers.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Student;
using Assessment = Student1.ParentPortal.Models.Student.Assessment;
using StudentAssessment = Student1.ParentPortal.Models.Student.StudentAssessment;
using Student1.ParentPortal.Resources.ExtensionMethods;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentAssessmentService
    {
        Task<StudentAssessment> GetStudentAssessmentsAsync(int studentUsi);
        Task<List<AssessmentSubSection>> GetStudentStaarAssessmentHistoryAsync(int studentUsi);
    }

    public class StudentAssessmentService : IStudentAssessmentService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly ICustomParametersProvider _customParametersProvider;

        public StudentAssessmentService(IStudentRepository studentRepository, ICustomParametersProvider customParametersProvider)
        {
            _studentRepository = studentRepository;
            _customParametersProvider = customParametersProvider;
        }

        public async Task<StudentAssessment> GetStudentAssessmentsAsync(int studentUsi)
        {
            var model = new StudentAssessment();

            foreach(var assessmentParam in _customParametersProvider.GetParameters().assessments)
            {
                var assessment = await GetStudentAssessmentAsync(studentUsi, assessmentParam.assessmentReportingMethodTypeDescriptor, assessmentParam.title, assessmentParam.assessmentIdentifiers, assessmentParam.shortDescription);

                if (assessment != null)
                {
                    assessment.SubSections = FillNotTakenSubsections(assessmentParam.assessmentIdentifiers, assessment.SubSections);
                }
                else // Add default empty ones
                {
                    // Student hasnt taken assessment
                    assessment = FillNotTakenassessment(assessmentParam.title, assessmentParam.assessmentIdentifiers, assessmentParam.shortDescription);
                    
                }
                assessment.ExternalLink = assessmentParam.externalLink;
                model.Assessments.Add(assessment);
            }

            var customparams = _customParametersProvider.GetParameters();

            model.AssessmentIndicators = new List<Assessment>();
            model.StarAssessments = new List<Assessment>();
            model.AccessAssessments = new List<Assessment>();

            foreach (var assessment in customparams.arcAssessments)
            {
                if (assessment.assessmentReportingMethodTypeDescriptor == "ARC Power Goal Abbreviation")
                {
                    var performanceLevel = await _studentRepository.GetStudentAssesmentPerformanceLevel(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                    if (performanceLevel == null)
                    {
                        performanceLevel = new Assessment();
                        performanceLevel.Title = assessment.title;
                        performanceLevel.Result = "-";
                        performanceLevel.PerformanceLevelMet = "Not Yet Taken";
                        performanceLevel.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                    }
                    else
                    {
                        performanceLevel.Result = performanceLevel.PerformanceLevelMet;
                    }
                    model.ArcAssessments.Add(performanceLevel);
                }
                else
                {
                    var newAssessment = await _studentRepository.GetStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                    if (newAssessment == null)
                    {
                        newAssessment = new Assessment();
                        newAssessment.Title = assessment.title;
                        newAssessment.Result = "-";
                        newAssessment.PerformanceLevelMet = "Not Yet Taken";
                        newAssessment.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                    }
                    model.ArcAssessments.Add(newAssessment);
                }
            }

            foreach (var assessment in customparams.assessmentIndicators)
            {
                var newAssessment = new Assessment();
                if (assessment.getPerformanceLevel)
                    newAssessment = await _studentRepository.GetStudentAssesmentPerformanceLevel(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                else
                    newAssessment = await _studentRepository.GetStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);

                if (newAssessment == null)
                {
                    newAssessment = new Assessment();
                    newAssessment.Title = assessment.title;
                    newAssessment.Result = "0";
                    newAssessment.PerformanceLevelMet = "Not Yet Taken";
                    newAssessment.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                    newAssessment.Interpretation = "";
                }
                else if (assessment.getPerformanceLevel)
                    newAssessment.Interpretation = InterpretAssessmentPerformanceLevel(newAssessment.PerformanceLevelMet);
                else
                    newAssessment.Interpretation = "";

                model.AssessmentIndicators.Add(newAssessment);
            }

            foreach (var assessment in customparams.starAssessments)
            {
                var newAssessment = await _studentRepository.GetStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                if (newAssessment == null)
                {
                    newAssessment = new Assessment();
                    newAssessment.Title = assessment.title;
                    newAssessment.Result = "0";
                    newAssessment.PerformanceLevelMet = "Not Yet Taken";
                    newAssessment.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                }
                model.StarAssessments.Add(newAssessment);
            }

            foreach (var assessment in customparams.accessAssessments)
            {
                var assessments = await _studentRepository.GetACCESSStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                var proficiencyAssessments = await _studentRepository.GetACCESSStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptorProficiency, assessment.title);

                if (assessments.Count == proficiencyAssessments.Count)
                    foreach (var a in assessments)
                        a.ProficiencyLevel = proficiencyAssessments[assessments.FindIndex(x => x.Title == a.Title && x.ReportingMethodCodeValue == a.ReportingMethodCodeValue && x.Version == a.Version)].Result;

                model.AccessAssessments.AddRange(assessments);
            }

            return model;
        }

        public async Task<List<AssessmentSubSection>> GetStudentStaarAssessmentHistoryAsync(int studentUsi)
        {

            var assessmentParam =_customParametersProvider.GetParameters().staarAssessmentHistory;

           List<AssessmentSubSection> assessments = await GetStudentStaarAssessmentAsync(studentUsi, assessmentParam.title, assessmentParam.assessmentReportingMethodTypeDescriptor, assessmentParam.title, assessmentParam.assessmentIdentifiers, assessmentParam.shortDescription);

            return assessments;
        }

        private async Task<List<AssessmentSubSection>> GetStudentStaarAssessmentAsync(int studentUsi, string title, string assessmentReportingMethodTypeDescriptor,  string title1, List<string> assessmentIdentifiers, string shortDescription)
        {
            var data = await _studentRepository.GetStudentAssessmentAsync(studentUsi, assessmentReportingMethodTypeDescriptor, title);

            // We are grouping here because we only want the latest administration.
            var model = (from d in data
                                where assessmentIdentifiers.Contains(d.Identifier)
                                orderby d.GradeLevel ascending
                                group d by new { d.Title, d.Identifier, d.GradeLevel } into g
                                select new AssessmentSubSection
                                {
                                Title = g.Key.Identifier,
                                Score = Convert.ToInt32(g.First(x => x.AdministrationDate == g.Max(d => d.AdministrationDate)).Result),
                                PerformanceLevelMet = g.First(x => x.AdministrationDate == g.Max(d => d.AdministrationDate)).PerformanceLevelMet,
                                GradeLevel = g.Key.GradeLevel
                                }).ToList();

            return model;
        }

        private Assessment FillNotTakenassessment(string title, List<string> assessmentIdentifiers, string shortDescription)
        {
            var assessment = new Assessment {
                Title = title,
                ShortDescription = shortDescription,
                MaxRawScore = 0,
                SubSections = FillNotTakenSubsections(assessmentIdentifiers, new List<AssessmentSubSection>())
            };

            return assessment;

        }

        private List<AssessmentSubSection> FillNotTakenSubsections(List<string> assessmentIdentifiers, List<AssessmentSubSection> subsections)
        {
            List<AssessmentSubSection> result = new List<AssessmentSubSection>();
            assessmentIdentifiers.ForEach(assesmnentIdentifier => {
                var assesment = subsections.FirstOrDefault(x => x.Title == assesmnentIdentifier);
                if (assesment == null)
                {
                    var subsection = new AssessmentSubSection
                    {
                        Title = assesmnentIdentifier,
                        Score = 0,
                        PerformanceLevelMet = "Not yet Taken"
                    };
                    result.Add(subsection);
                }
                else
                    result.Add(assesment);
            });

            return result;
        }

        private async Task<Assessment> GetStudentAssessmentAsync(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle, List<string> assessmentIdentifiers, string shortDescription)
        {
            var data = await _studentRepository.GetStudentAssessmentAsync(studentUsi, assessmentReportingMethodTypeDescriptor, assessmentTitle);

            // We are grouping here because we only want the latest administration.
            var groupingForLatestDate  = (from d in data
                                          where assessmentIdentifiers.Contains(d.Identifier) 
                         group d by new { d.Title, d.Identifier, d.MaxRawScore } into g
                         select new {
                             g.Key.Title,
                             g.Key.Identifier,
                             g.Key.MaxRawScore,
                             LatestAdminitrationDate = g.Max(x=>x.AdministrationDate),
                             g.First(x=>x.AdministrationDate == g.Max(d=>d.AdministrationDate)).Result,
                             g.First(x => x.AdministrationDate == g.Max(d => d.AdministrationDate)).PerformanceLevelMet
                         });

            var model = groupingForLatestDate
                            .GroupBy(a => a.Title)
                            .Select(g => new Assessment
                                            {
                                                Title = g.Key,
                                                ShortDescription = shortDescription,
                                                MaxRawScore = g.Sum(s => s.MaxRawScore),
                                                SubSections = g.Select(x => new AssessmentSubSection
                                                {
                                                    Title = x.Identifier,
                                                    Score = Convert.ToInt32(x.Result),
                                                    PerformanceLevelMet = x.PerformanceLevelMet,
                                                    AdministrationDate = x.LatestAdminitrationDate
                                                }).ToList()
                                            }).SingleOrDefault();

            return model;
        }

        private string InterpretAssessmentPerformanceLevel(string performanceLevel)
        {
            return _customParametersProvider.GetParameters().assessmentPerformanceLevel.thresholdRules.GetRuleThatApplies(performanceLevel).interpretation;
        }
    }
}
