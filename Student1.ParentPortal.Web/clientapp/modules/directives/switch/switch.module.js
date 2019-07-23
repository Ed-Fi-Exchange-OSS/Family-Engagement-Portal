angular.module('app.directives')
    .component('switch', {
        bindings: {
            model: "=",
            label: "@"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/switch/switch.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });