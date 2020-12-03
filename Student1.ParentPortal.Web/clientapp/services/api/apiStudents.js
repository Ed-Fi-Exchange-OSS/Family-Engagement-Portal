angular.module('app.api')
    .service('apiStudents', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'students';
        var serviceStudentIds = [];
        return {
            get: function (id) { return $http.get(apiResourceUri + '/' + id).then(function (response) { return response.data; }); },
            getStudentBrief: function (id) { return $http.get(apiResourceUri + '/' + id + '/brief').then(function (response) { return response.data; }); },
            setStudentIds: function (studentIds) { serviceStudentIds = studentIds; },
            getStudentIds: function () { return serviceStudentIds; },
            getStudentsByGrades: function (grades) { return $http.post(apiResourceUri + '/grades', grades).then(function (response) { return response.data; }); },
            getStudentBriefDetail: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail').then(function (response) { return response.data; }); },
            getStudentAttendance: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/attendance').then(function (response) { return response.data; }); },
            getStudentBehavior: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/behavior').then(function (response) { return response.data; }); },
            getStudentCourseGrades: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/courseGrades').then(function (response) { return response.data; }); },
            getStudentMissingAssignments: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/missingAssignments').then(function (response) { return response.data; }); },
            getStudentSuccessTeamMembers: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/successTeamMembers').then(function (response) { return response.data; }); },
            getStudentSchedule: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/schedule').then(function (response) { return response.data; }); },
            getStudentAssessments: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/assessments').then(function (response) { return response.data; }); },
            getStudentStaarAssessmentHistory: function (id) { return $http.get(apiResourceUri + '/' + id + '/detail/staarAssessmentHistory').then(function (response) { return response.data; }); },
            addStudentGoal: function (item) { return $http.post(apiResourceUri + '/AddStudentGoal', item).then(function (response) { return response.data; }); },
            updateStudentGoal: function (item) { return $http.post(apiResourceUri + '/UpdateStudentGoal', item).then(function (response) { return response.data; }); },
            updateStudentGoalStep: function (item) { return $http.post(apiResourceUri + '/UpdateStudentGoalStep', item).then(function (response) { return response.data; }); },
            getStudentGoalLabels: function () { return $http.get(apiResourceUri + '/StudentLabels').then(function (response) { return response.data; }); },
            addStudentAllAboutMe: function (item) { return $http.post(apiResourceUri + '/AddStudentAllAbout', item).then(function (response) { return response.data; }); },
            updateStudentAllAboutMe: function (item) { return $http.post(apiResourceUri + '/UpdateStudentAllAbout', item).then(function (response) { return response.data; }); },
            updateStudentGoalIntervention: function (item) { return $http.post(apiResourceUri + '/UpdateStudentGoalIntervention', item).then(function (response) { return response.data; }); }
        };
    }]);