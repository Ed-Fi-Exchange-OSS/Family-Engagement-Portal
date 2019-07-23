angular.module('app.api')
    .service('apiApplication', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'ApplicationOffline';

        return {
            getIsApplicationOffline: function () { return $http.get(apiResourceUri).then(function (response) { return response.data; }); }
        };
    }]);