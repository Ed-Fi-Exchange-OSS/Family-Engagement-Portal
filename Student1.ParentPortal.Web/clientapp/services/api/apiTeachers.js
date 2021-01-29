angular.module('app.api')
    .service('apiTeachers', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'teachers';

        return {
            getAllSections: function () { return $http.get(apiResourceUri + '/sections').then(function (response) { return response.data; }); },
            getAllSectionsByTeacherId: function (teacherId) { return $http.get(apiResourceUri + '/teacher/sections/' + teacherId).then(function (response) { return response.data; }); },
            getStudentsInSection: function (sectionModel) { return $http.post(apiResourceUri + '/students', sectionModel).then(function (response) { return response.data; }); },
            getSchools: function () { return $http.get(apiResourceUri + '/schools').then(function (response) { return response.data; }); },
            getGrades: function (schoolId) { return $http.get(apiResourceUri + '/grades/' + schoolId).then(function (response) { return response.data; }); },
            getCampusLeaderLandingInformation: function (searchModel) { return $http.post(apiResourceUri + '/campusleader/information', searchModel).then(function (response) { return response.data; }); }
        }
    }]);