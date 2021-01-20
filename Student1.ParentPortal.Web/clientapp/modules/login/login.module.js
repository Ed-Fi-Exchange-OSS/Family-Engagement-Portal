angular.module('app')
    .config([
        '$stateProvider', function ($stateProvider) {
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
                        }]
                    }
                });
        }
    ])
    .component('login', {
        bindings: { isApplicationOffline: "<" },
        templateUrl: 'clientapp/modules/login/login.view.html',
        controllerAs: 'ctrl',
        controller: ['jwtHelper', '$state', 'appConfig', 'landingRouteService', '$rootScope', 'api', '$window', function (jwtHelper, $state, appConfig, landingRouteService, $rootScope, api, $window) {

            var ctrl = this;
            ctrl.externalUrl = "";
            ctrl.showAzure = false;
            ctrl.showGoogle = false;
            ctrl.showHotmail = false;
            ctrl.showFacebook = false;

            api.customParams.getAll().then(function (data) {
                ctrl.externalUrl = data.feedbackExternalUrl;
            });

            ctrl.model = {
                version: appConfig.version,
                userInfo: {}
            };

            ctrl.$onInit = function () {

                api.features.getUIFeatures().then(function (response) {
                    ctrl.showAzure = response.oAuthAzure;
                    ctrl.showGoogle = response.oAuthGoogle;
                    ctrl.showHotmail = response.oAuthHotmail;
                    ctrl.showFacebook = response.oAuthFacebook;
                });

                var existTokenToValidate = sessionStorage.getItem('existTokenToValidate');
                var serviceSelected = sessionStorage.getItem('ssoServiceSelected');
                if (existTokenToValidate != undefined && existTokenToValidate != null && existTokenToValidate != '') {

                    sessionStorage.removeItem('existTokenToValidate');
                    sessionStorage.removeItem('ssoServiceSelected');

                    var model = { id_token: existTokenToValidate, grant_type: 'client_credentials', service: serviceSelected, code: existTokenToValidate };
                    if (serviceSelected == 'facebook')
                        model.id_token = null;

                    api.oauth.exchangeToken(model).then(function (response) {
                        sessionStorage.setItem('access_token', response.access_token);
                        var tokenPayload = jwtHelper.decodeToken(response.access_token);
                        ctrl.model.userInfo = {
                            userName: tokenPayload.name,
                            email: tokenPayload.email
                        };
                        api.log.saveLogInfo({ message: "Identity verified for email : " + (ctrl.model.userInfo.userName || ctrl.model.userInfo.email) });
                        landingRouteService.redirectToLanding();
                    });
                }
            };

            ctrl.loginSSO = function (service) {
                api.oauth.getUrlSSO(service).then(function (url_sso) {
                    if (url_sso == undefined || url_sso == null || url_sso == '') {
                        toastr.error('No service for ' + service, 'Error Login');
                        return;
                    }
                    sessionStorage.setItem('ssoServiceSelected', service);
                    $window.open(url_sso, '_self');
                });
            };

            ctrl.logOutSSO = function () {
                sessionStorage.removeItem('id_token');
                sessionStorage.removeItem('access_token');
                $rootScope.isAuthenticated = false;
            };

            ctrl.showFeedbackModal = function () {
                $rootScope.feedback = true;
            };

            ctrl.goToExternalUrl = function () {
                $window.open(ctrl.externalUrl);
            };

            function AuthAndRedirect() {

                var access_token = sessionStorage.getItem('access_token');

                if (!access_token) {
                    $rootScope.isAuthenticated = false;
                    console.log("No Access Token");
                    return;
                }

                if (jwtHelper.isTokenExpired(access_token)) {
                    sessionStorage.removeItem('access_token');
                    $rootScope.isAuthenticated = false;
                    console.log("Token expired");
                    return;
                }

                var tokenPayload = jwtHelper.decodeToken(access_token);
                console.log(tokenPayload);
                ctrl.model.userInfo = {
                    userName: tokenPayload.name,
                    email: tokenPayload.email
                };

                api.log.saveLogInfo({ message: "Identity verified for email : " + (ctrl.model.userInfo.userName || ctrl.model.userInfo.email) });
                landingRouteService.redirectToLanding();
            }

            // If we are already authenticated then Auth and Redirect 
            if ($rootScope.isAuthenticated)
                AuthAndRedirect();
        }]
    });