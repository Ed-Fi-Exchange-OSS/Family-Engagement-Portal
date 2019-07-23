angular.module('app.directives')
    .component('studentAttendance', {
        bindings: {
            model: "<",
            showAll: "="
        },
        templateUrl: 'clientapp/modules/directives/studentAttendance/studentAttendance.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });