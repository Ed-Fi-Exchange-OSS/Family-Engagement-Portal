angular.module('app.api')
    .service('apiLog', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'log';

        return {
            saveLogError: function (model) { return $http.post(apiResourceUri + '/error', model).then(function (response) { return response; }); },
            saveLogWarning: function (model) { return $http.post(apiResourceUri + '/warning', model).then(function (response) { return response; }); },
            saveLogInfo: function (model) { return $http.post(apiResourceUri + '/info', model).then(function (response) { return response; }); },
        }
    }]);