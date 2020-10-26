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
            sendSectionGroupMessage: function (model) { return $http.post(apiResourceUri + '/groupMessages', model).then(function (response) { return response.data; }); },
            sendPrincipalGroupMessage: function (model) { return $http.post(apiResourceUri + '/groupMessages/principals', model).then(function (response) { return response.data; }); },
            sendPrincipalIndividualGroupMessage: function (model) { return $http.post(apiResourceUri + '/groupMessages/individual/principals', model).then(function (response) { return response.data; }); },
            principalRecipientMessages: function (model) { return $http.post(apiResourceUri + '/recipient/principals', model).then(function (response) { return response.data; }); },
            getParentStudentCountInGradesAndPrograms: function (model) { return $http.post(apiResourceUri + '/families/calculate', model).then(function (response) { return response.data; }); },
            getParentStudentInGradesAndSearchTerm: function (model) { return $http.post(apiResourceUri + '/families/search', model).then(function (response) { return response.data }) },
            getGroupMessagesQueues: function (schoolId, model) { return $http.post(apiResourceUri + '/groupMessages/' + schoolId + '/queue', model).then(function (response) { return response.data }) },
            getParentStudentCountInSection: function (model) { return $http.post(apiResourceUri + '/families/calculate/section', model).then(function (response) { return response.data; }); } ,
            getParentsCountInGreadesAndSearchTermCount: function (model) { return $http.post(apiResourceUri + '/families/count', model).then(function (response) { return response.data }) },
        };
    }]);