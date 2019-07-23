angular.module('app.services')
    .service('userAuthenticationService', ['adalAuthenticationService', function (adalService) {
        return {
            isUserAuthenticated: function () {
                return adalService.userInfo.isAuthenticated;
            }
        };
    }]);