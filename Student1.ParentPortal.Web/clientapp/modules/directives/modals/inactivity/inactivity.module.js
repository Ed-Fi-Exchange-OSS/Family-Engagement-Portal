angular.module('app')
    .component('inactivityModal', {
        bindings: {
            modalInstance: "<",
            resolve: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/modals/inactivity/inactivity.view.html',
        controllerAs: 'ctrl',
        controller: ['$timeout', '$interval','$scope', function ($timeout, $interval, $scope) {
            var ctrl = this;
            ctrl.timer
            ctrl.counter = 0;
            ctrl.$onInit = function () {
                ctrl.timer = ctrl.resolve.body;
                ctrl.counter = (ctrl.timer / 1000);

                ctrl.timer = setInterval(function () {
                    ctrl.counter--;
                    if (ctrl.counter == 0) {
                        clearInterval(ctrl.timer);
                    }
                    $scope.$apply();
                }, 1000);  
            }
            

            ctrl.logout = function () {
                ctrl.modalInstance.close(false);
            }

            ctrl.cancel = function () {
                ctrl.modalInstance.close(true);
                clearInterval(ctrl.timer);
                ctrl.modalInstance.dismiss("cancel");
            }
        }]
    });