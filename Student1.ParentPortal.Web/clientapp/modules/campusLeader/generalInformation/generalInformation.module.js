angular.module('app')
    .component('generalInformation', {
        templateUrl: 'clientapp/modules/campusLeader/generalInformation/generalInformation.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {

            var ctrl = this;
            ctrl.schools = [];
            ctrl.grades = [];
            ctrl.search = {};
            ctrl.information = [];
            ctrl.searchClick = false;

            ctrl.$onInit = function () {
                api.teachers.getSchools().then(function (data) {
                    ctrl.schools = data;
                    if (ctrl.schools.length == 1) {
                        ctrl.search.school = ctrl.schools[0];
                        ctrl.updateSchool();
                    }
                });
            };

            ctrl.updateSchool = function () {
                ctrl.grades = [];
                api.teachers.getGrades(ctrl.search.school.schoolId).then(function (data) {
                    ctrl.grades = data;
                    if (ctrl.grades.length == 1) {
                        ctrl.search.grade = ctrl.grades[0];
                    }
                });
            };

            ctrl.searchInformation = function () {
                ctrl.information = [];

                var requestInfo = {
                    schoolId: 0,
                    gradeId: 0,
                    Text: ''
                };

                if (ctrl.search.school)
                    requestInfo.schoolId = ctrl.search.school.schoolId;

                if (ctrl.search.grade)
                    requestInfo.gradeId = ctrl.search.grade.id;

                if (ctrl.search.text)
                    requestInfo.text = ctrl.search.text;

                ctrl.searchClick = false;

                api.teachers.getCampusLeaderLandingInformation(requestInfo).then(function (data) {
                    ctrl.searchClick = true;
                    ctrl.information = data;
                });
            };
        }]
    });