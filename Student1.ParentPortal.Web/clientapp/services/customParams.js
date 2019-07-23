angular.module('app.services')
    .service('customParams', ['$http', 'appConfig', function ($http, appConfig) {

        var resourceUri = appConfig.api.rootApiUri + "CustomParameters";

        return {
            getAll: function () { return $http.get(resourceUri).then(function (response) { return response.data; }); },
        }
    }]);