angular.module('app.api')
    .service('apiAdmin', ['$http', 'appConfig', function ($http, appConfig) {
        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUriOAuth = 'OAuth';
        
        return {
            impersonate: function (model) { return $http.post(apiResourceUriOAuth + '/ImpersonExchangeToken', model).then(function (response) { return response.data; }); }
        }
    }]);