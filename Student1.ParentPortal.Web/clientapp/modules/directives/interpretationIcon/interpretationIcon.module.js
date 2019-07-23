angular.module('app.directives')
    .component('interpretationIcon', {
        bindings: {
            model: '<', // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
            types: '<',
            tooltipText: '<', // Optional one way data binding
            fontclass: '@'
        }, 
        templateUrl: 'clientapp/modules/directives/interpretationIcon/interpretationIcon.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;

            ctrl.$onInit = function () {
                if (!ctrl.types)
                    ctrl.types = ['great', 'good', 'bad', 'warning', 'default'];
            }

        }]
    });