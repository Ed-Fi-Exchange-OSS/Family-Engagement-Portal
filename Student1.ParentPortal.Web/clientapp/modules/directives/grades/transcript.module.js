angular.module('app.directives')
    .component('transcript', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/grades/transcript.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });