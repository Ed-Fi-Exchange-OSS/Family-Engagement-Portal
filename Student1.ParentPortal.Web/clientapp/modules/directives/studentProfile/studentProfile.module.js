angular.module('app')
    .component('studentProfile', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentProfile/studentProfile.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });