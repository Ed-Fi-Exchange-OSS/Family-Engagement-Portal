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
                let countInactives = 0;
                if ($rootScope.featureToggles.comms.studentAbc != undefined) {
                    Object.keys($rootScope.featureToggles.comms.studentAbc).forEach(function (key) {
                        if (!$rootScope.featureToggles.comms.studentAbc[key])
                            countInactives++
                    });
                }
                switch (countInactives) {
                    case 0:
                        ctrl.indicatorStyle = 'col-3';
                        break;
                    case 1:
                        ctrl.indicatorStyle = 'col-4';
                        break;
                    case 2:
                        ctrl.indicatorStyle = 'col-6';
                        break;
                    case 3:
                        ctrl.indicatorStyle = 'col-12';
                        break;
                    case 4:
                        break;
                }
            }
        }]
    });