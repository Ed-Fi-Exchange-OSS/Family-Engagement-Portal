angular.module('app')
    .config([
        '$stateProvider', function($stateProvider) {
            $stateProvider.state('app.login',
                {
                    url: '/login',
                    views: {
                        'navbar@': '',
                        'content@': 'login'
                    },
                    resolve: {
                        isApplicationOffline: ['api', function (api) {
                            return api.application.getIsApplicationOffline();
                        }]//['api', function (api) { return api.application.getIsApplicationOffline(); }]
                    }
                });
        }
    ])
    .component('login', {
        bindings: { isApplicationOffline: "<" },
        templateUrl: 'clientapp/modules/login/login.view.html',
        controllerAs: 'ctrl',
        controller: ['adalAuthenticationService', '$state', 'appConfig', 'landingRouteService', function (adalService, $state, appConfig, landingRouteService) {
            var ctrl = this;

            ctrl.model = {
                version: appConfig.version,
                userInfo: adalService.userInfo,
            };

            ctrl.loginSSO = function () {
                adalService.login();
            };

            ctrl.logOutSSO = function () {
                adalService.logOut();
            };

            if (adalService.userInfo.isAuthenticated) {
                ctrl.model.tokenExpires = new Date(adalService.userInfo.profile.exp * 1000);

                // Redirect user to appropriate landing page based on role.
                landingRouteService.redirectToLanding();
            }
        }]
    });