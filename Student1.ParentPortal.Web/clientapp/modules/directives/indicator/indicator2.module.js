angular.module('app.directives')
    .component('indicator2', {
        bindings: {
            indicatorTitle: '@',
            tooltip: '@',
            value: '<',
            interpretation: '<',
            anchorid:'@',
            bgclass: '@',
            textualEvaluation: '<'
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/indicator/indicator2.view.html',
        controllerAs: 'ctrl',
        controller: ['$location',function ($location) {
            var ctrl = this;
        }]
    });