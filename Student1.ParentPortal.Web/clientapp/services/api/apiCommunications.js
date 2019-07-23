angular.module('app.api')
    .service('apiCommunications', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'communications';

        return {
            getChatThread: function (model) { return $http.post(apiResourceUri + '/thread', model).then(function (response) { return response.data; }); },
            postMessage: function (model) { return $http.post(apiResourceUri + '/persist', model).then(function (response) { return response.data; }); },
            recipientRead: function (model) { return $http.post(apiResourceUri + '/recipientRead', model).then(function (response) { return response.data; }); },
            unreadCount: function (model) { return $http.post(apiResourceUri + '/unreadCount', model).then(function (response) { return response.data; }); },
            recipientUnread: function () { return $http.get(apiResourceUri + '/recipientUnread').then(function (response) { return response.data; }); },
            allRecipients: function (model) { return $http.post(apiResourceUri + '/allRecipients', model).then(function (response) { return response.data; }); },
        };
    }]);