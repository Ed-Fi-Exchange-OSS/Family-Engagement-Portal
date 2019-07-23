angular.module('app')
    .component('submitButton', {
        bindings: {
            form: '<',
            label: '@',
            promiseToExecute: '&'
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/forms/submitButton/submitButton.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;

            ctrl.resolvingPromise = false;

            ctrl.executePromise = function () {
                
                ctrl.resolvingPromise = true;
                ctrl.promiseToExecute().then(function () {
                    ctrl.resolvingPromise = false;
                });
            };
        }]
    });