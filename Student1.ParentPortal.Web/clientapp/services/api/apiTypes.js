angular.module('app.api')
    .service('apiTypes', ['$http', 'appConfig', function ($http, appConfig) {

        var rootApiUri = appConfig.api.rootApiUri;
        var apiResourceUri = rootApiUri + 'types';

        return {
            getAddressTypes: function () { return $http.get(apiResourceUri + '/Address').then(function (response) { return response.data; }); },
            getElectronicMailTypes: function () { return $http.get(apiResourceUri + '/ElectronicMail').then(function (response) { return response.data; }); },
            getStateAbbreviationTypes: function () { return $http.get(apiResourceUri + '/StateAbbreviation').then(function (response) { return response.data; }); },
            getTelephoneNumberTypes: function () { return $http.get(apiResourceUri + '/TelephoneNumber').then(function (response) { return response.data; }); },
            getTextMessageCarrierTypes: function () { return $http.get(apiResourceUri + '/TextMessageCarrier').then(function (response) { return response.data; }); },
            getMethodOfContactTypes: function () { return $http.get(apiResourceUri + '/MethodOfContact').then(function (response) { return response.data; }); },
        }
    }]);