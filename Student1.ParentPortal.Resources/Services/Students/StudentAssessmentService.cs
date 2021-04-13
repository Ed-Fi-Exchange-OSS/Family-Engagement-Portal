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

        Task<List<StudentDomainMastery>> GetStudentDomainMasteryAsync(int studentUsi);
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
                    var objectivesAssessments = await _studentRepository.GetStudentObjectiveAssessments(studentUsi);
                    if (newAssessment == null)
                    {
                        newAssessment = new Assessment();
                        newAssessment.Title = assessment.title;
                        newAssessment.Result = "-";
                        newAssessment.PerformanceLevelMet = "Not Yet Taken";
                        newAssessment.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                    }
                    else {
                        newAssessment.ObjectiveAssessments = objectivesAssessments.Where(x => x.AssessmentIdentifier == newAssessment.Identifier).ToList();
                        
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
                var performanceLevel = await _studentRepository.GetStudentAssesmentPerformanceLevel(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                if (newAssessment == null)
                {
                    newAssessment = new Assessment();
                    newAssessment.Title = assessment.title;
                    newAssessment.Result = "0";
                    newAssessment.PerformanceLevelMet = "Not Yet Taken";
                    newAssessment.ReportingMethodCodeValue = assessment.assessmentReportingMethodTypeDescriptor;
                    newAssessment.Interpretation = "";
                }
                if (performanceLevel != null) {
                    newAssessment.Interpretation = InterpretAssessmentPerformanceLevel(performanceLevel.PerformanceLevelMet);
                    newAssessment.PerformanceLevelMet = performanceLevel.PerformanceLevelMet;
                }
                
                    

                model.StarAssessments.Add(newAssessment);
            }

            foreach (var assessment in customparams.accessAssessments)
            {
                var assessments = await _studentRepository.GetACCESSStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptor, assessment.title);
                var objectivesAssessments = await _studentRepository.GetStudentObjectiveAssessments(studentUsi);
                var proficiencyAssessments = await _studentRepository.GetACCESSStudentAssesmentScore(studentUsi, assessment.assessmentReportingMethodTypeDescriptorProficiency, assessment.title);

                //if (assessments.Count == proficiencyAssessments.Count)
                //    foreach (var a in assessments)
                //        a.ProficiencyLevel = proficiencyAssessments[assessments.FindIndex(x => x.Title == a.Title && x.ReportingMethodCodeValue == a.ReportingMethodCodeValue && x.Version == a.Version)].Result;

                foreach (var item in assessments) {
                    item.ObjectiveAssessments = objectivesAssessments.Where(x => x.AssessmentIdentifier == item.Identifier).ToList();
                }

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
        public async Task<List<StudentDomainMastery>> GetStudentDomainMasteryAsync(int studentUsi)
        {
            string identifierELEnglish = string.Empty;
            string identifierELSpanish = string.Empty;
            var objectiveAssessmentsIdentifiers = _customParametersProvider.GetParameters().objectiveAssessmentsIdentifiers;

            if (objectiveAssessmentsIdentifiers != null)
            {
                identifierELEnglish = objectiveAssessmentsIdentifiers.earlyLiteracyEnglishAssessmentIdentifier;
                identifierELSpanish = objectiveAssessmentsIdentifiers.earlyLiteracySpanishAssessmentIdentifier;
            }

            var result = new List<StudentDomainMastery>();
            var data = await _studentRepository.GetStudentObjectiveAssessments(studentUsi);

            var familyNames = data.Where(x => x.ParentIdentificationCode != null).GroupBy(x => x.ParentIdentificationCode).Where(x => !x.Key.Contains("_")).Select(x => x.Key);

            foreach (var fName in familyNames)
            {
                var domains = data.Where(x => x.ParentIdentificationCode == fName);

                foreach (var domain in domains)
                    domain.SkillAreas = data.Where(x => x.ParentIdentificationCode == domain.IdentificationCode).ToList();

                result.Add(new StudentDomainMastery { FamilyName = fName, Domains = domains.ToList() });
            }

            var earlyLiteracySpanishObjectiveAssessments = data.Where(x => x.AssessmentIdentifier.Contains(identifierELSpanish));
            var eLDomainsSpanish = earlyLiteracySpanishObjectiveAssessments.Where(x => x.ParentIdentificationCode == null);
            if (eLDomainsSpanish.Count() > 0)
                result.Add(new StudentDomainMastery { FamilyName = "Early Literacy Spanish", Domains = eLDomainsSpanish.ToList() });

            var earlyLiteracyObjectiveAssessments = data.Where(x => x.AssessmentIdentifier.Contains(identifierELEnglish));
            var eLDomains = earlyLiteracyObjectiveAssessments.Where(x => x.ParentIdentificationCode == null);
            foreach (var domain in eLDomains)
                domain.SkillAreas = earlyLiteracyObjectiveAssessments.Where(x => x.ParentIdentificationCode == domain.IdentificationCode).ToList();
            if (eLDomains.Count() > 0)
                result.Add(new StudentDomainMastery { FamilyName = "Early Literacy English", Domains = eLDomains.ToList() });

            result.ForEach(p => {
                string firstAssessmentIdentifier = string.Empty;
                DateTime administrationDate = DateTime.Now;
                if (p.Domains != null && p.Domains.Any())
                {
                    firstAssessmentIdentifier = p.Domains.First().AssessmentIdentifier;
                    administrationDate = p.Domains.First().AdministrationDate;
                }
                if (firstAssessmentIdentifier.ToLower().Contains("reading")) firstAssessmentIdentifier = "Reading";
                if (firstAssessmentIdentifier.ToLower().Contains("math")) firstAssessmentIdentifier = "Math";
                if (firstAssessmentIdentifier.ToLower().Contains(identifierELSpanish.ToLower())) firstAssessmentIdentifier = "Early Literacy Spanish";
                if (firstAssessmentIdentifier.ToLower().Contains(identifierELEnglish.ToLower())) firstAssessmentIdentifier = "Early Literacy English";
                p.MainName = firstAssessmentIdentifier;
                p.AdministrationDate = administrationDate;
            });

            result = result.OrderBy(p => p.MainName).ToList();
            return result;
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
