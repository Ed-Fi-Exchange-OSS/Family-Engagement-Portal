angular.module('app.api')
    .service('apiStudents', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'students';
        var serviceStudentIds = [];
        return {
            get: function (id) { return $http.get(apiResourceUri + '/' + id).then(function (response) { return response.data; }); },
            getStudentBrief: function (id) { return $http.get(apiResourceUri + '/' + id + '/brief').then(function (response) { return response.data; }); },
            setStudentIds: function (studentIds) { serviceStudentIds = studentIds; },
            getStudentIds: function () { return serviceStudentIds; }
        };
    }]);