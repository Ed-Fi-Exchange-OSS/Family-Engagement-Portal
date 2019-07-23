angular.module('app.api')
    .service('apiImage', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'image';

        return {
            getStudentImage: function (studentUniqueId) { return $http.get(apiResourceUri + '/student/' + studentUniqueId).then(function (response) { return response.data; }); },
        };
    }]);