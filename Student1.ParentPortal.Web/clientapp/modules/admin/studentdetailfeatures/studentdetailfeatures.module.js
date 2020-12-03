angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.studentdetailfeatures', {
            url: '/studentdetailfeatures',
            views: {
                'content@': { component: 'studentdetailfeatures' }
            }
        });
    }])
    .component('studentdetailfeatures', {
        bindings: {
            model: "<"
        },
        templateUrl: 'clientapp/modules/admin/studentdetailfeatures/studentdetailfeatures.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$state', '$rootScope', function (api, $translate, $state, $rootScope) {
            var ctrl = this;
            ctrl.studentDetailFeatures = {
                profile : true,
                attendanceIndicator : true,
                courseAverageIndicator : true,
                behaviorIndicator : true,
                missingAssignmentsIndicator : true,
                allAboutMe : true,
                goals : true,
                attendanceLog : true,
                behaviorLog : true,
                courseGrades : true,
                missingAssignments : true,
                calendar : true,
                successTeam : true,
                collegeInitiativeCorner : true,
                arc : true,
                staarAssessment : true,
                assessment : true,
            };

            ctrl.$onInit = function () {
                api.admin.getStudentDetailFeatures().then(function (response) {
                    console.log(ctrl.studentDetailFeatures);
                    ctrl.studentDetailFeatures = response;
                    console.log(response);
                });
            };

            ctrl.save = function () {
                console.log(ctrl.studentDetailFeatures);
                api.admin.saveStudentDetailFeatures(ctrl.studentDetailFeatures).then(function (response) {
                    ctrl.studentDetailFeatures = response;
                    toastr.success('Information updated', 'Information');
                });
            };
        }]
    });