angular.module('app')
    .component('studentCard', {
        bindings: {
            model: "<",
            cssClasses: "@"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentCard/studentCard.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$rootScope', function (api, $rootScope) {
            var ctrl = this;
            ctrl.indicatorStyle = 'col-3';
            ctrl.showStudentGPA = function(gradeLevel) {
                var dbGradeLevels = ["Eighth grade", "Ninth grade", "Tenth grade", "Eleventh grade", "Twelfth grade", "8", "08", "9", "09", "10", "11", "12"];
                return dbGradeLevels.indexOf(gradeLevel) != -1;
            };

            ctrl.$onInit = function () {
                ctrl.styleStudentAbc();

                $rootScope.$on('messageReceived', function (event, current, previous) {
                    api.communications.recipientUnread().then(function (data) {
                        ctrl.model.unreadMessageCount = data.unreadMessagesCount;
                    });
                    
                });
            };

            ctrl.readAlerts = function (studentUniqueId) {
                api.alerts.parentHasReadStudentAlerts(studentUniqueId).then(function (result) {
                    ctrl.model.alerts = [];
                });
            }

            ctrl.styleStudentAbc = function () {
                ctrl.indicatorStyle = 'col-6'
            }
        }]
    });

angular.module('app').filter('ifEmpty', function () {
    return function (input, defaultValue) {
        if (angular.isUndefined(input) || input === null || input === '') {
            return defaultValue;
        }

        return input;
    }
});