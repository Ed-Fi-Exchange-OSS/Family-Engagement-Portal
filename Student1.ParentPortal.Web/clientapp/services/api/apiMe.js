angular.module('app.api')
    .service('apiMe', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'me';
        var config = {
            headers: { 'Content-Type': undefined },
        };
        var briefProfile = null;

        return {
            getRole: function () { return $http.get(apiResourceUri + '/role').then(function (response) { return response.data; }); },
            getMyProfile: function () { return $http.get(apiResourceUri + '/profile').then(function (response) { return response.data; }); },
            getMyBriefProfile: function () { return $http.get(apiResourceUri + '/briefProfile').then(function (response) { briefProfile = response.data; return response.data; }); },
            saveMyProfile: function (model) { return $http.post(apiResourceUri + '/profile', model).then(function (response) { return response.data; }); },
            uploadImage: function (formData) { return $http.post(apiResourceUri + '/image', formData, config).then(function (response) { return response.data; }); },
            setBriefProfile: function (newBriefProfile) { briefProfile = newBriefProfile },
            getBriefProfile: function () { return briefProfile },
            persistFeedback: function (model) { return $http.post(apiResourceUri + '/feedback', model).then(function (response) { return response.data; }); }
        }
    }]);