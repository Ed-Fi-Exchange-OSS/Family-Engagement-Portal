angular.module('app')
    .component('confirmationModal', {
        bindings: {
            //confirmButtonTitle: "@",
            //body:"<",
            //functionToExecute: "&",
            modalInstance: "<",
            resolve: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/modals/confirmation/confirmation.view.html',
        controllerAs: 'ctrl',
        controller: [function ($uibModalInstance) {
            var ctrl = this;

            ctrl.$onInit = function () {
                ctrl.body = ctrl.resolve.body;
                ctrl.confirmButtonLabel = ctrl.resolve.confirmButtonLabel;
            }

            ctrl.confirm = function () {
                ctrl.modalInstance.close(true);
            }

            ctrl.cancel = function () {
                ctrl.modalInstance.dismiss("cancel");
            }
    }]
    });