angular.module('app.services')
    .service('userAuthenticationService', ['$rootScope', function ($rootScope) {
        return {
            isUserAuthenticated: function () {
                return $rootScope.isAuthenticated;
            }
        };
    }]);