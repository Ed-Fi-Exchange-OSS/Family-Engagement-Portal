angular.module('app')
    .run(['$anchorScroll', function ($anchorScroll) {
        $anchorScroll.yOffset = 50;   // always scroll by 50 extra pixels
    }])
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.studentdetail', {
            url: '/studentdetail/:studentId/:?anchor',
            views: { 'content@': 'studentdetail' },
            resolve: {
                model: ['$stateParams', 'api', function ($stateParams, api) {
                    return api.students.getStudentBriefDetail($stateParams.studentId);
                }],
                customParams: ['api', function (api) {
                    return api.customParams.getAll();
                }],
                anchor: ['$stateParams', function ($stateParams) {
                    return $stateParams.anchor || '';
                }],
                studentIds: ['api', function (api) {
                    return api.students.getStudentIds();
                }],
                currentStudent: ['$stateParams', function ($stateParams) {
                    return $stateParams.studentId;
                }],
                studentDetailFeatures: ['api', function (api) {
                    return api.admin.getStudentDetailFeatures();
                }]
            }
        });
    }])
    .component('studentdetail', {
        bindings: {
            model: "<",
            customParams: "<",
            anchor: "<",
            studentIds: "<",
            currentStudent: "<",
            studentDetailFeatures: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/studentdetail/studentdetail.view.html',
        controllerAs: 'ctrl',
        controller: ['$scope', 'api', '$anchorScroll', '$location', 'landingRouteService', '$translate', '$rootScope', 'appConfig',
            function ($scope, api, $anchorScroll, $location, landingRouteService, $translate, $rootScope, appConfig) {

                var ctrl = this;
                ctrl.urls = [];
                ctrl.showAbsences = false;
                ctrl.currentPos = 0;
                ctrl.sections = [
                    { name: 'Absences', id: 'attendance' },
                    { name: 'Behavior', id: 'behaviour-log' },
                    { name: 'Grades', id: 'grades' },
                    { name: 'Assignments', id: 'missing-assignments' },
                    { name: 'Schedule', id: 'schedule' },
                    { name: 'Success Team', id: 'success-team' },
                    { name: 'College Initiative Corner', id: 'college-corner' },
                    { name: 'Assesments', id: 'assesments' }
                ];
                ctrl.heroClient = appConfig.hero.client;

                ctrl.sections = [
                    { name: 'Absences', id: 'attendance' },
                    { name: 'Behavior', id: 'behaviour-log' },
                    { name: 'Grades', id: 'grades' },
                    { name: 'Assignments', id: 'missing-assignments' },
                    { name: 'Schedule', id: 'schedule' },
                    { name: 'Success Team', id: 'success-team' },
                    { name: 'College Initiative Corner', id: 'college-corner' },
                    { name: 'Assesments', id: 'assesments' }
                ];

                ctrl.showARC = true;

                ctrl.generateTranslationKey = function (prefix, value) {
                    return prefix + value;
                };

                ctrl.gotoAnchor = function (x) {
                    var newHash = x;

                    if (newHash == 'attendance') {
                        ctrl.showAbsences = true;
                    }

                    if ($location.hash() !== newHash) {
                        // set the $location.hash to `newHash` and
                        // $anchorScroll will automatically scroll to it
                        $location.hash(x);
                    } else {
                        // call $anchorScroll() explicitly,
                        // since $location.hash hasn't changed
                        $anchorScroll(x);
                    }
                };

                ctrl.previousStudent = function () {
                    return ctrl.studentIds[ctrl.currentPos - 1];
                };

                ctrl.nextStudent = function () {
                    return ctrl.studentIds[ctrl.currentPos + 1];
                };

                ctrl.findWorstStarPerformanceLevelInterpretation = function () {
                    var interpretations = ['bad', 'warning']; // The Client didn't need the last indicator for this section.
                    var worstInterpretation = "";
                    interpretations.forEach(interpretation => {
                        if (ctrl.model.assessment.starAssessments.some(x => x.interpretation == interpretation)) {
                            worstInterpretation =  interpretation;
                        }
                            
                    });
                    return worstInterpretation;
                };

                landingRouteService.getRoute().then(function (route) {
                    ctrl.urls.push({ displayName: $translate.instant('Home'), url: route });
                });

                ctrl.convertToDatesCalendar = function (model) {
                    model.studentCalendar.startDate = new Date(model.studentCalendar.startDate);
                    model.studentCalendar.endDate = new Date(model.studentCalendar.endDate);

                    model.studentCalendar.days.forEach(d => d.date = new Date(d.date));
                    model.studentCalendar.nonInstructionalDays.forEach(d => d.date = new Date(d.date));
                    model.studentCalendar.instructionalDays.forEach(d => d.date = new Date(d.date));
                    model.studentCalendar.attendanceEventDays.forEach(d => d.date = new Date(d.date));
                };

                // Returns full months' list with the attendance events assigned
                ctrl.calculateCalendar = function (calendar) {
                    var attMonths = ctrl.model.attendanceEventsByMonth;
                    var newMonths = [];

                    if (!calendar) { return null; }

                    var startMonth = new Date(calendar.startDate.getUTCFullYear()
                        , calendar.startDate.getMonth()
                        , 1);
                    for (let dMonth = new Date(startMonth);
                        dMonth.getTime() <= calendar.endDate.getTime();
                        dMonth.setMonth(dMonth.getMonth() + 1)) {
                        var nm = { date: new Date(dMonth) };
                        if (dMonth.getTime() == startMonth.getTime()) {
                            nm.startDay = calendar.startDate.getUTCDate();
                        }
                        if (dMonth.getUTCFullYear() == calendar.endDate.getUTCFullYear()
                            && dMonth.getUTCMonth() == calendar.endDate.getUTCMonth()) {
                            nm.stopDay = calendar.endDate.getDate();
                        }
                        /*  Dates are compared using the getTime function. 
                            The getTime() returns the numeric value corresponding to the time for the specified date according to universal time.
                            getTime() returns a number representing the milliseconds elapsed between 1 January 1970 00:00:00 UTC and the given date.
                        */
                        //var orMonth = attMonths.filter(m => m.date.getTime() == dMonth.getTime());
                        //if (orMonth.length > 0) {
                        //    nm.events = orMonth[0].events;
                        //} else {
                        nm.events = [];
                        //}

                        // Non instructional days
                        let nonInstructional = calendar.nonInstructionalDays
                            .filter(nid => nid.date.getUTCFullYear() == dMonth.getUTCFullYear()
                                && nid.date.getUTCMonth() == dMonth.getUTCMonth())
                            .map(nid => {
                                return {
                                    date: nid.date,
                                    attendanceEvent: {
                                        id: 'nonDay',
                                        description: 'Non Instructional Day'
                                    },
                                    comments: nid.event.description
                                }
                            });

                        if (nonInstructional.length > 0)
                            Array.prototype.push.apply(nm.events, nonInstructional);

                        // Excused Attendance Events
                        let excusedAttendaceEvents = calendar.attendanceEventDays
                            .filter(nid => nid.event.name.includes("Excused") && nid.date.getUTCFullYear() == dMonth.getUTCFullYear()
                                && nid.date.getUTCMonth() == dMonth.getUTCMonth())
                            .map(nid => {
                                return {
                                    date: nid.date,
                                    attendanceEvent: {
                                        id: 4,
                                        description: nid.event.name
                                    },
                                    comments: nid.event.description
                                }
                            });

                        if (excusedAttendaceEvents.length > 0)
                            Array.prototype.push.apply(nm.events, excusedAttendaceEvents);

                        // Unexcused Attendance Events
                        let unexcusedAttendaceEvents = calendar.attendanceEventDays
                            .filter(nid => nid.event.name.includes("Unexcused") && nid.date.getUTCFullYear() == dMonth.getUTCFullYear()
                                && nid.date.getUTCMonth() == dMonth.getUTCMonth())
                            .map(nid => {
                                return {
                                    date: nid.date,
                                    attendanceEvent: {
                                        id: 8,
                                        description: nid.event.name
                                    },
                                    comments: nid.event.description
                                }
                            });

                        if (unexcusedAttendaceEvents.length > 0)
                            Array.prototype.push.apply(nm.events, unexcusedAttendaceEvents);

                        // Tardy Attendance Events
                        let tardyAttendaceEvents = calendar.attendanceEventDays
                            .filter(nid => nid.event.name.includes("Tardy") && nid.date.getUTCFullYear() == dMonth.getUTCFullYear()
                                && nid.date.getUTCMonth() == dMonth.getUTCMonth())
                            .map(nid => {
                                return {
                                    date: nid.date,
                                    attendanceEvent: {
                                        id: 10,
                                        description: nid.event.name
                                    },
                                    comments: nid.event.description
                                }
                            });

                        if (tardyAttendaceEvents.length > 0)
                            Array.prototype.push.apply(nm.events, tardyAttendaceEvents);

                        nm.events = nm.events.sort((a, b) => {
                            return (a.date.getTime() > b.date.getTime())
                                ? 1
                                : ((a.date.getTime() < b.date.getTime())
                                    ? -1
                                    : 0);
                        });

                        newMonths.push(nm)
                    }
                    return newMonths
                };

                // On Init needed for life-cycle purposes.
                // Model is not binded until resolved.
                ctrl.$onInit = function () {

                    $scope.$on('studentARC', function (evt, data) {
                        ctrl.showARC = data;
                        console.log("ARC", ctrl.showARC);
                    });

                    ctrl.convertToDatesCalendar(ctrl.model);
                    ctrl.model.attendanceEventsByMonth = ctrl.calculateCalendar(ctrl.model.studentCalendar);

                    $rootScope.loadingOverride = false;

                    ctrl.behaviorIndicatorCategories = [
                        //{
                        //    tooltip: $translate.instant('Referrals'),
                        //    textDisplay: $translate.instant('Referrals'),
                        //    value: ctrl.model.behavior.yearToDateDisciplineReferralIncidentCount,
                        //    interpretation: ctrl.model.behavior.referralInterpretation,
                        //},
                        //{
                        //    tooltip: $translate.instant('Suspensions'),
                        //    textDisplay: $translate.instant('Suspensions'),
                        //    value: ctrl.model.behavior.yearToDateDisciplineSuspensionIncidentCount,
                        //    interpretation: ctrl.model.behavior.suspensionInterpretation,
                        //}
                    ];
                    ctrl.attendanceIndicatorCategories = [
                        {
                            tooltip: "Unexcused Absences",
                            textDisplay: "Abv Unexcused Absences",
                            value: ctrl.model.attendance.unexcusedAttendanceEvents.length,
                            interpretation: ctrl.model.attendance.unexcusedInterpretation,
                        },
                        {
                            tooltip: "Excused Absences",
                            textDisplay: "Abv Excused Absences",
                            value: ctrl.model.attendance.excusedAttendanceEvents.length,
                            interpretation: ctrl.model.attendance.excusedInterpretation,
                        },
                        {
                            tooltip: "Tardy Absences",
                            textDisplay: "Abv Tardy Absences",
                            value: ctrl.model.attendance.tardyAttendanceEvents.length,
                            interpretation: ctrl.model.attendance.tardyInterpretation,
                        }

                    ];
                    ctrl.starIndicatorCategories = [];



                    ctrl.currentPos = ctrl.studentIds.indexOf(parseInt(ctrl.currentStudent));

                    ctrl.gotoAnchor(ctrl.anchor);

                    api.students.getStudentAttendance(ctrl.currentStudent).then(function (data) {

                        ctrl.model.attendance = data;
                        ctrl.absentInterpretation = ctrl.model.attendance.absentInterpretation;
                        ctrl.attendanceIndicatorCategories = [
                            {
                                tooltip: "Unexcused Absences",
                                textDisplay: "Abv Unexcused Absences",
                                value: ctrl.model.attendance.unexcusedAttendanceEvents.length,
                                interpretation: ctrl.model.attendance.unexcusedInterpretation,
                            },
                            {
                                tooltip: "Excused Absences",
                                textDisplay: "Abv Excused Absences",
                                value: ctrl.model.attendance.excusedAttendanceEvents.length,
                                interpretation: ctrl.model.attendance.excusedInterpretation,
                            },
                            {
                                tooltip: "Tardy Absences",
                                textDisplay: "Abv Tardy Absences",
                                value: ctrl.model.attendance.tardyAttendanceEvents.length,
                                interpretation: ctrl.model.attendance.tardyInterpretation,
                            }

                        ];
                    });
                    api.students.getStudentBehavior(ctrl.currentStudent).then(function (data) {
                        ctrl.model.behavior = data;
                        ctrl.behaviorInterpretation = ctrl.model.behavior.interpretation;

                        var indicatorReferrals = {
                            tooltip: $translate.instant('Referrals'),
                            textDisplay: $translate.instant('Referrals'),
                            value: ctrl.model.behavior.yearToDateDisciplineIncidentCount,
                            interpretation: 'good',
                        }
                        var indicatorSuspensions = {
                            tooltip: $translate.instant('Suspensions'),
                            textDisplay: $translate.instant('Suspensions'),
                            value: ctrl.model.behavior.yearToDateDisciplineIncidentCount,
                            interpretation: 'good',
                        }
                        ctrl.behaviorIndicatorCategories.push(indicatorSuspensions);
                        ctrl.behaviorIndicatorCategories.push(indicatorReferrals);
                       
                    });
                    api.students.getStudentCourseGrades(ctrl.currentStudent).then(function (data) {
                        ctrl.model.courseGrades = data;
                    });
                    api.students.getStudentMissingAssignments(ctrl.currentStudent).then(function (data) {
                        ctrl.model.missingAssignments = data;
                    });
                    api.students.getStudentAssessments(ctrl.currentStudent).then(function (data) {
                        ctrl.model.assessment = data;

                        ctrl.accessOverall = []; //ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Overall'));
                        ctrl.accessListening = []; //ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Listening'));
                        ctrl.accessReading = []; //ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Reading'));
                        ctrl.accessSpeaking = []; //ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Speaking'));
                        ctrl.accessWriting = []; //ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Writing'));


                        ctrl.model.assessment.accessAssessments.forEach(accessAssessment => {
                            ctrl.accessOverall.push({ proficiencyLevel: accessAssessment.result, version: accessAssessment.version });
                        })



                        ctrl.model.assessment.accessAssessments.forEach(accessAssessment => {
                            if (accessAssessment.objectiveAssessments.length > 0) {
                                var listening = accessAssessment.objectiveAssessments.filter(x => x.identificationCode.includes('Listening'));
                                if (listening !== null && listening !== undefined && listening.length > 0) {
                                    ctrl.accessListening.push({ proficiencyLevel: listening[0].englishResult, version: accessAssessment.version });
                                }

                            }

                        })
                        ctrl.model.assessment.accessAssessments.forEach(accessAssessment => {
                            if (accessAssessment.objectiveAssessments.length > 0) {
                                var reading = accessAssessment.objectiveAssessments.filter(x => x.identificationCode.includes('Reading'));
                                if (reading !== null && reading !== undefined && reading.length > 0) {
                                    ctrl.accessReading.push({ proficiencyLevel: reading[0].englishResult, version: accessAssessment.version });
                                }

                            }

                        })
                        ctrl.model.assessment.accessAssessments.forEach(accessAssessment => {
                            if (accessAssessment.objectiveAssessments.length > 0) {
                                var speaking = accessAssessment.objectiveAssessments.filter(x => x.identificationCode.includes('Speaking'));
                                if (speaking !== null && speaking !== undefined && speaking.length > 0) {
                                    ctrl.accessSpeaking.push({ proficiencyLevel: speaking[0].englishResult, version: accessAssessment.version });
                                }

                            }

                        })
                        ctrl.model.assessment.accessAssessments.forEach(accessAssessment => {
                            if (accessAssessment.objectiveAssessments.length > 0) {
                                var writing = accessAssessment.objectiveAssessments.filter(x => x.identificationCode.includes('Writing'));
                                if (writing !== null && writing !== undefined && writing.length > 0) {
                                    ctrl.accessWriting.push({ proficiencyLevel: writing[0].englishResult, version: accessAssessment.version });
                                }

                            }

                        })
                        //ctrl.accessOverall = ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Overall'));
                        //ctrl.accessListening = ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Listening'));
                        //ctrl.accessReading = ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Reading'));
                        //ctrl.accessSpeaking = ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Speaking'));
                        //ctrl.accessWriting = ctrl.accessAssessments.filter(x => x.reportingMethodCodeValue.includes('Writing'));

                        

                        //ctrl.model.assessment.starAssessments[0].interpretation = ctrl.model.assessment.assessmentIndicators[1].interpretation;
                        //ctrl.model.assessment.starAssessments[1].interpretation = ctrl.model.assessment.assessmentIndicators[2].interpretation;
                        //ctrl.model.assessment.starAssessments[2].interpretation = ctrl.model.assessment.assessmentIndicators[3].interpretation;

                        //ctrl.model.assessment.starAssessments[0].performanceLevelMet = ctrl.model.assessment.assessmentIndicators[1].performanceLevelMet;
                        //ctrl.model.assessment.starAssessments[1].performanceLevelMet = ctrl.model.assessment.assessmentIndicators[2].performanceLevelMet;
                        //ctrl.model.assessment.starAssessments[2].performanceLevelMet = ctrl.model.assessment.assessmentIndicators[3].performanceLevelMet;



                        ctrl.model.assessment.starAssessments.forEach(assessment => {

                            var indicator = {
                                tooltip: "STAAR",
                                textDisplay: assessment.identifier,
                                value: assessment.performanceLevelMet,
                                interpretation: assessment.interpretation,
                            }
                            ctrl.starIndicatorCategories.push(indicator);

                        });
                        ctrl.starGeneralIndicator = ctrl.findWorstStarPerformanceLevelInterpretation();
                        if (ctrl.model.gradeLevel != 'First grade' && ctrl.model.gradeLevel != 'Second grade' && ctrl.model.gradeLevel != 'Kindergarten') {

                            for (let i = 0; i < ctrl.model.assessment.starAssessments.length; i++) {
                                if (ctrl.model.assessment.starAssessments[i].identifier != null && ctrl.model.assessment.starAssessments[i].identifier.indexOf('EarlyLiteracy') >= 0) {
                                    ctrl.model.assessment.starAssessments.splice(i, 1);
                                    break;
                                }
                            }

                            for (let i = 0; i < ctrl.starIndicatorCategories.length; i++) {
                                if (ctrl.starIndicatorCategories[i].textDisplay.indexOf('STAR EL') >= 0) {
                                    ctrl.starIndicatorCategories.splice(i, 1);
                                    break;
                                }
                            }

                            if (ctrl.model.studentDomainMastery != null && ctrl.model.studentDomainMastery.length > 0) {
                                let newList = [];
                                for (let i = 0; i < ctrl.model.studentDomainMastery.length; i++) {
                                    if (ctrl.model.studentDomainMastery[i].mainName != 'Early Literacy') {
                                        newList.push(ctrl.model.studentDomainMastery[i]);
                                    }
                                }
                                ctrl.model.studentDomainMastery = newList;
                            }
                        }

                    });
                    ctrl.heroTextDesc = $translate.instant('view.disciplineIncidents.moreDetail');
                    $rootScope.$on('$translateChangeSuccess', function (event, current, previous) {
                        ctrl.heroTextDesc = $translate.instant('view.disciplineIncidents.moreDetail');
                    });
                };
            }]
    });
