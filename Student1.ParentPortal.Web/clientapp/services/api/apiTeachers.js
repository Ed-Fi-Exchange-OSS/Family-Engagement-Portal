angular.module('app.api')
    .service('apiTeachers', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'teachers';

        return {
            getAllSections: function () { return $http.get(apiResourceUri + '/sections').then(function (response) { return response.data; }); },
            getStudentsInSection: function (sectionModel) { return $http.post(apiResourceUri + '/students', sectionModel).then(function (response) { return response.data; }); },
        }
    }]);