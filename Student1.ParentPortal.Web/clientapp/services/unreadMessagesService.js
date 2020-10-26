angular.module('app.services')
    .service('unreadMessagesServices', ['appConfig', '$http', 'signalRService', 'api', function (appConfig, $http, signalRService, api) {
        
        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'communications';
        this.message = null;
        this.unreadMessages = null;

        this.getUnreadMessages = function () {
            $http.get(apiResourceUri + '/recipientUnread').then(function (response) {
                this.unreadMessages = response.data;
            });
        }
    }]);