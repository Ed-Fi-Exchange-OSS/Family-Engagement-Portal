angular.module('app.api')
    .service('apiParents', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'parents';

        return {
            getStudents: function () { return $http.get(apiResourceUri + '/students').then(function (response) { return response.data; }); },
        }
    }]);