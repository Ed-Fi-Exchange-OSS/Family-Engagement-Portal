angular.module('app.services')
    .service('communicationService', ['signalRService', '$rootScope','api', function (signalRService, $rootScope, api) {
        return {
            start: function () {

                api.me.getMyBriefProfile().then(function (data) {
                    api.me.setBriefProfile(data);

                    var chatHub = signalRService.init('ChatHub');

                    chatHub.on('messageReceived', function (message) {
                        $rootScope.$broadcast('messageReceived', message);
                    });

                    chatHub.start();
                });
            }
        };

        
    }]);