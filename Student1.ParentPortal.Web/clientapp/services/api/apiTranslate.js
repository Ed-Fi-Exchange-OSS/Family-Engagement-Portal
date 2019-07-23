angular.module('app.api')
    .service('apiTranslate', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'translate';

        return {
            getAvailableLanguages: function () { return $http.get(apiResourceUri + '/languages').then(function (response) { return response.data.filter(function (x) {return x.code != 'tlh' }); }); },
            autoDetectTranslate: function (model) { return $http.post(apiResourceUri + '/autoDetect', model).then(function (response) { return response.data; }); },
            translate: function (model) { return $http.post(apiResourceUri, model).then(function (response) { return response.data; }); },
        }
    }]);