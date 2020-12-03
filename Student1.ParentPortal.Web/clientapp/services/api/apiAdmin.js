angular.module('app.api')
    .service('apiAdmin', ['$http', 'appConfig', function ($http, appConfig) {
        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUriOAuth = 'OAuth';
        var apiAdmin = rootApiUri + 'Admin';
        
        return {
            impersonate: function (model) { return $http.post(apiResourceUriOAuth + '/ImpersonExchangeToken', model).then(function (response) { return response.data; }); },
            getStudentDetailFeatures: function () { return $http.get(apiAdmin + '/GetStudentDetailFeatures').then(function (response) { return response.data; }); },
            saveStudentDetailFeatures: function (model) { return $http.post(apiAdmin + '/SaveStudentDetailFeatures', model).then(function (response) { return response.data; }); }
        }
    }]);