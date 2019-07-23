angular.module('app.directives')
    .component('indicator3', {
        bindings: {
            indicatorTitle: '@',
            tooltip: '@',
            indicatorCategories: '<', // [{tooltip:'', value: 10, interpretation: ''}]
            anchorid: '@',
            textualEvaluation: '<',
            bgclass: '@'
        },
        templateUrl: 'clientapp/modules/directives/indicator/indicator3.view.html',
        controllerAs: 'ctrl',
        controller: ['$location',function ($location) {
            var ctrl = this;

            ctrl.$onInit = function () {
                ctrl.interpretation = ctrl.getGeneralInterpretation();
                ctrl.categoryWidth = 100 / ctrl.indicatorCategories.length;
                ctrl.textualEvaluation += ctrl.interpretation;
            }

            ctrl.getGeneralInterpretation = function () {
                var interpretationTypes = ['bad', 'warning', 'good', 'great'];

                for (var x = 0; x < interpretationTypes.length; x++) {
                    if (ctrl.indicatorCategories.filter(function (i) { return i.interpretation === interpretationTypes[x] }).length > 0)
                        return interpretationTypes[x];
                }
            }
            ctrl.isNotLast = function (i) {
                return ctrl.indicatorCategories.indexOf(i) < ctrl.indicatorCategories.length - 1;
            }
        }]
    });