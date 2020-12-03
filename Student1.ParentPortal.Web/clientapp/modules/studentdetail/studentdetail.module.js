angular.module('app')
    .run(['$anchorScroll', function ($anchorScroll) {
        $anchorScroll.yOffset = 50;   // always scroll by 50 extra pixels
    }])
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.studentdetail', {
            url: '/studentdetail/:studentId/:?anchor',
            views: {
                'content@': 'studentdetail'
            },
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
        controller: ['$scope','api', '$anchorScroll', '$location', 'landingRouteService', '$translate', '$rootScope', 'appConfig',
            function ($scope, api, $anchorScroll, $location, landingRouteService, $translate, $rootScope, appConfig) {

                var ctrl = this;
                ctrl.urls = [];
                ctrl.showAbsences = false;
                ctrl.currentPos = 0;
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

                landingRouteService.getRoute().then(function (route) {
                    ctrl.urls.push({ displayName: $translate.instant('Home'), url: route });
                });
                // On Init needed for life-cycle purposes.
                // Model is not binded until resolved.
                ctrl.$onInit = function () {

                    $scope.$on('studentARC', function (evt, data) {
                        ctrl.showARC = data;
                    });

                    $rootScope.loadingOverride = false;
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
                        },
                    ];
                    ctrl.currentPos = ctrl.studentIds.indexOf(parseInt(ctrl.currentStudent));

                    ctrl.gotoAnchor(ctrl.anchor);
                    api.students.getStudentAttendance(ctrl.currentStudent).then(function (data) {
                        ctrl.model.attendance = data;
                    });
                    api.students.getStudentBehavior(ctrl.currentStudent).then(function (data) {
                        ctrl.model.behavior = data;
                    });
                    api.students.getStudentCourseGrades(ctrl.currentStudent).then(function (data) {
                        ctrl.model.courseGrades = data;
                    });
                    api.students.getStudentMissingAssignments(ctrl.currentStudent).then(function (data) {
                        ctrl.model.missingAssignments = data;
                    });
                    api.students.getStudentAssessments(ctrl.currentStudent).then(function (data) {
                        ctrl.model.assessment = data;
                        ctrl.model.assessment.starAssessments.forEach(assessment => {
                            if (assessment.identifier != null && assessment.identifier != '') {
                                if (assessment.identifier.indexOf('EarlyLiteracy') >= 0) {
                                    ctrl.starIndicatorCategories.push({
                                        tooltip: "STAR Early Literacy",
                                        textDisplay: "STAR EL",
                                        value: ctrl.model.assessment.assessmentIndicators[1].performanceLevelMet,
                                        interpretation: ctrl.model.assessment.assessmentIndicators[1].interpretation,
                                    });
                                }
                                else if (assessment.identifier.indexOf('Math') >= 0) {
                                    ctrl.starIndicatorCategories.push({
                                        tooltip: "STAR Math",
                                        textDisplay: "STAR Math",
                                        value: ctrl.model.assessment.assessmentIndicators[2].performanceLevelMet,
                                        interpretation: ctrl.model.assessment.assessmentIndicators[2].interpretation,
                                    });
                                }
                                else {
                                    ctrl.starIndicatorCategories.push({
                                        tooltip: "STAR Reading",
                                        textDisplay: "STAR Reading",
                                        value: ctrl.model.assessment.assessmentIndicators[3].performanceLevelMet,
                                        interpretation: ctrl.model.assessment.assessmentIndicators[3].interpretation,
                                    });
                                }
                            }
                        });
                        if (ctrl.model.gradeLevel != 'First grade' && ctrl.model.gradeLevel != 'Second grade' && ctrl.model.gradeLevel != 'Kindergarten') {

                            if (ctrl.model.assessment.starAssessments != undefined && ctrl.model.assessment.starAssessments != null) {
                                for (let i = 0; i < ctrl.model.assessment.starAssessments.length; i++) {
                                    if (ctrl.model.assessment.starAssessments[i].identifier != null && ctrl.model.assessment.starAssessments[i].identifier.indexOf('EarlyLiteracy') >= 0) {
                                        ctrl.model.assessment.starAssessments.splice(i, 1);
                                        break;
                                    }
                                }
                            }

                            if (ctrl.starIndicatorCategories != undefined && ctrl.starIndicatorCategories != null) {
                                for (let i = 0; i < ctrl.starIndicatorCategories.length; i++) {
                                    if (ctrl.starIndicatorCategories[i].textDisplay.indexOf('STAR EL') >= 0) {
                                        ctrl.starIndicatorCategories.splice(i, 1);
                                        break;
                                    }
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
