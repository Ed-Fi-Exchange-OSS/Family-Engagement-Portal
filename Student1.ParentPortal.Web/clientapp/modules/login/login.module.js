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
        controller: ['adalAuthenticationService', '$state', 'appConfig', 'landingRouteService', '$rootScope', 'api', '$window', 'impersonateService', function (adalService, $state, appConfig, landingRouteService, $rootScope, api, $window, impersonateService) {
            var ctrl = this;
            ctrl.externalUrl = "";
            api.customParams.getAll().then(function (data) {
                ctrl.externalUrl = data.feedbackExternalUrl;
            });

            ctrl.model = {
                version: appConfig.version,
                userInfo: adalService.userInfo,
            };

            ctrl.loginSSO = function () {
                adalService.login();
            };

            ctrl.logOutSSO = function () {
                /*remove all the sessions impersonate variables*/
                sessionStorage.removeItem('adal.oldidtoken');
                sessionStorage.removeItem('adal.impersonate');
                
                adalService.logOut();
            };

            ctrl.showFeedbackModal = function () {
                $rootScope.feedback = true;
            };

            ctrl.showFeedbackModal = function () {
                $rootScope.feedback = true;
            };

            ctrl.goToExternalUrl = function () {
                $window.open(ctrl.externalUrl);
            };

            if (adalService.userInfo.isAuthenticated) {
                if (adalService.userInfo.profile == undefined) {
                    var user = impersonateService.getImpersonateUser();
                    adalService.userInfo.profile = user;
                }
                ctrl.model.tokenExpires = new Date(adalService.userInfo.profile.exp * 1000);
                api.log.saveLogInfo({ message: "Identity verified for email : " + (ctrl.model.userInfo.userName || ctrl.model.userInfo.profile.emails[0]) });              
                // Redirect user to appropriate landing page based on role.
                landingRouteService.redirectToLanding();
            }
        }]
    });