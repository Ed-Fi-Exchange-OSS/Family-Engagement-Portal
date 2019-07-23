angular.module('app')
    .component('studentCard', {
        bindings: {
            model: "<",
            cssClasses: "@"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentCard/studentCard.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;

            ctrl.showStudentGPA = function(gradeLevel) {
                var dbGradeLevels = ["Eighth grade", "Ninth grade", "Tenth grade", "Eleventh grade", "Twelfth grade", "8", "08", "9", "09", "10", "11", "12"];
                return dbGradeLevels.includes(gradeLevel);
            };

            ctrl.$onInit = function () { };

            ctrl.readAlerts = function (studentUniqueId) {
                api.alerts.parentHasReadStudentAlerts(studentUniqueId).then(function (result) {
                    ctrl.model.alerts = [];
                });
            }

        }]
    });