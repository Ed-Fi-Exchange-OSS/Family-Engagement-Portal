angular.module('app.services')
    .service('impersonateService', ['$rootScope', 'jwtHelper', function ($rootScope, jwtHelper) {
        return {
            impersonateUser: function (newSession, oldSession, showMark) {
                sessionStorage.setItem('old_access_token', oldSession);
                sessionStorage.setItem('access_token', newSession);
                sessionStorage.setItem('impersonate', showMark);
            },
            isimpersonatingUser: function () {
                var jwt = jwtHelper.decodeToken(sessionStorage.getItem('access_token'));
                if (jwt.impersonate !== undefined) {
                    var impersonate = (jwt.impersonate == "true");
                    sessionStorage.setItem('impersonate', impersonate);
                    return impersonate;
                }
                sessionStorage.setItem('impersonate', false);
                return false;
            },
            getImpersonateUser: function () {
                if (this.isimpersonatingUser()) {
                    var user = jwtHelper.decodeToken(sessionStorage.getItem('access_token'));
                    return {
                        emails: [user.email],
                        exp: user.exp
                    }
                }                
            }
        }
    }]);