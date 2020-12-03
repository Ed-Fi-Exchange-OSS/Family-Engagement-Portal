angular.module('app.api')
    .service('apiOAuth', ['$http', 'appConfig', function ($http, appConfig) {

        var rootUri = appConfig.api.rootUri;
        var apiResourceUri = rootUri + 'OAuth';

        return {
            exchangeToken: function (model) { return $http.post(apiResourceUri + '/ExchangeToken', model).then(function (response) { return response.data; }); },
            getUrlSSO: function (service) { return $http.get(apiResourceUri + '/GetUrlForSSO?service=' + service).then(function (response) { return response.data; }); },
        };
    }]);