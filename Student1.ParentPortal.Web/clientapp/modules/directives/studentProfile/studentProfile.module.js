angular.module('app')
    .component('studentProfile', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentProfile/studentProfile.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$rootScope', function (api, $rootScope) {
            var ctrl = this;

            ctrl.$onInit = function () {
                $rootScope.$on('messageReceived', function (event, current, previous) {
                    api.communications.recipientUnread().then(function (data) {
                        ctrl.model.unreadMessageCount = data.unreadMessagesCount;
                    });

                });
            }
        }]
    });