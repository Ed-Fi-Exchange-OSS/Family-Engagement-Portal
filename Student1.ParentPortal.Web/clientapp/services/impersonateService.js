angular.module('app.services')
    .service('impersonateService', ['$rootScope', 'jwtHelper', function ($rootScope, jwtHelper) {
        return {
            impersonateUser: function (newSession, oldSession, showMark) {
                //sessionStorage.setItem('adal.oldidtoken', oldSession);
                //sessionStorage.setItem('adal.idtoken', newSession);
                //for (var i = 0; i < sessionStorage.length; i++) {
                //    if (sessionStorage.key(i).match(/adal.access.token*/)) {
                //        sessionStorage.setItem(sessionStorage.key(i), newSession);
                //    }
                //}
                //sessionStorage.setItem('adal.impersonate', showMark);
            },
            isimpersonatingUser: function () {
                //var jwt = jwtHelper.decodeToken(sessionStorage.getItem('adal.idtoken'));
                //if (jwt.impersonate !== undefined) {
                //    var impersonate = (jwt.impersonate == "true");
                //    sessionStorage.setItem('adal.impersonate', impersonate);
                //    return impersonate;
                //}
                //sessionStorage.setItem('adal.impersonate', false);
                return false;
            },
            getImpersonateUser: function () {
                if (this.isimpersonatingUser()) {
                    var user = jwtHelper.decodeToken(sessionStorage.getItem('adal.idtoken'));
                    return {
                        emails: [user.email],
                        exp: user.exp
                    }
                }
                
            }
        }
    }]);