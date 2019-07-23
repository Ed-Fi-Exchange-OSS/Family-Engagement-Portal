angular.module('app.directives')
    .component('indicator', {
        bindings: {
            indicatorTitle: '@',
            tooltip: '@',
            value: '<',
            bgclass: '@',
            textualEvaluation: '<'

        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/indicator/indicator.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });