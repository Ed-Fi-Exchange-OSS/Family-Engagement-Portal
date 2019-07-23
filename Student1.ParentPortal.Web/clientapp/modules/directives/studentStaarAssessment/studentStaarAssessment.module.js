angular.module('app.directives')
    .component('studentStaarAssessment', {
        bindings: {
            model: "<",
            link: '@'
        },
        templateUrl: 'clientapp/modules/directives/studentStaarAssessment/studentStaarAssessment.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });