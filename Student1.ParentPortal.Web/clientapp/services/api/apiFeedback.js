angular.module('app.api')
    .service('apiFeedback', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'feedback';

        return {
            persist: function (model) { return $http.post(apiResourceUri + '/persist', model).then(function (response) { return response.data; }); }
        }
    }]);