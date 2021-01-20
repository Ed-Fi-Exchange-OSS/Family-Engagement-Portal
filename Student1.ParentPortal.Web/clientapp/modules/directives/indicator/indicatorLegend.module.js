angular.module('app.directives')
    .component('indicatorLegend', {
        bindings: {
            indicatorTitle: '@',
            tooltip: '@',
            indicatorCategories: '<', // [{tooltip:'', value: 10, interpretation: ''}]
            anchorid: '@',
            textualEvaluation: '<',
            bgclass: '@'
        },
        templateUrl: 'clientapp/modules/directives/indicator/indicatorLegend.view.html',
        controllerAs: 'ctrl',
        controller: ['$location',function ($location) {
            var ctrl = this;

            ctrl.$onInit = function() {
                ctrl.interpretationTypes = ['bad', 'warning', 'good', 'great'];
            };
        }]
    });