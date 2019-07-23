angular.module('app.api')
    .service('apiAlerts', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'alerts';

        return {
            getParentAlerts: function () { return $http.get(apiResourceUri + '/parent').then(function (response) { return response.data; }); },
            saveParentAlerts: function (model) { return $http.post(apiResourceUri + '/parent', model).then(function (response) { return response.data; }); },
            parentHasReadStudentAlerts: function (studentUniqueId) { return $http.get(apiResourceUri + '/parent/' + studentUniqueId).then(function (response) { return response.data }); },
        }
    }]);