angular.module('app.api')
    .service('apiSchools', ['$http', 'appConfig', function ($http, appConfig) {
        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri +'schools';
       
        return {
            getGrades: function (schoolId) { return $http.get(apiResourceUri + '/' + schoolId + '/gradesLevels').then(function (resopnse) { return resopnse.data; }); },
            getPrograms: function (schoolId) { return $http.get(apiResourceUri + '/' + schoolId + '/programs').then(function (response) { return response.data; }); },
            getSchools: function () { return $http.get(apiResourceUri).then(function (response) { return response.data; }); }
        }
    }]);