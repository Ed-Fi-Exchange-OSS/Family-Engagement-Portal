angular.module('app.api')
    .service('apiFeatures', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'ApplicationFeatures';

        return {
            getUIFeatures: function () { return $http.get(apiResourceUri + '/UIFeatures').then(function (response) { return response.data; }); }
        };
    }]);