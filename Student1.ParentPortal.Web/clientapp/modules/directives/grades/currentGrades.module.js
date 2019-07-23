angular.module('app.directives')
    .component('currentGrades', {
        bindings: {
            model: "<",
            studentUsi: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/grades/currentGrades.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
            ctrl.$onInit = function () {
                ctrl.gradeThresholdTypes = ['bad', 'warning'];
            }
            ctrl.hasFinalGrade = function () {
                return ctrl.model.currentCourses.some(function (c) { c.gradesByFinal.length > 0 });
            }
        }]
    });