angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.navbar', {
            views: {
                'navbar@': { component: 'navbar' }
            }
        });

    }])
    .component('navbar', {
        templateUrl: 'clientapp/modules/navbar/navbar.view.html',
        controllerAs: 'ctrl',
        controller: ['landingRouteService', 'api', '$window', '$translate', '$location', '$rootScope', 'impersonateService', '$state', 'communicationService',
            function (landingRouteService, api, $window, $translate, $location, $rootScope, impersonateService, $state, communicationService) {

                var ctrl = this;
                ctrl.role = "";
                ctrl.name = "";
                ctrl.externalUrl = "";
                ctrl.isAdminUser = false;
                ctrl.impersonateMode = impersonateService.isimpersonatingUser();
                ctrl.recipientUnreadMessages = null;
                ctrl.impersonateRole = sessionStorage.getItem('adal.impersonateRole');
                ctrl.showGroupMessaging = false;
                ctrl.showCommButton = true;

                ctrl.model = {
                    user: {
                    },
                    urls: []
                };

                landingRouteService.getRoute().then(function (route) {
                    ctrl.model.urls.push({ displayName: $translate.instant('Home'), url: route, icon: 'ion-md-home' });
                });

                $rootScope.$on('$translateChangeSuccess', function (event, current, previous) {
                    ctrl.model.urls[0].displayName = $translate.instant('Home');
                });

                api.me.getMyBriefProfile().then(function (data) {
                    ctrl.name = data.fullName;
                    ctrl.role = data.role;
                    ctrl.externalUrl = data.feedbackExternalUrl;
                    $rootScope.$broadcast('showProfileDescription', { methodOfContact: data.deliveryMethodOfContact, language: data.languageCode })
                });

                api.communications.recipientUnread().then(function (data) {
                    ctrl.recipientUnreadMessages = data;
                });

                api.me.getRole().then(function (role) {
                    if (role == 'Staff')
                        ctrl.showGroupMessaging = true;
                    if (role == 'CampusLeader')
                        ctrl.showCommButton = false;
                    if (role == 'Admin')
                        ctrl.isAdminUser = true;
                });

                ctrl.inLoginScreen = function () {
                    return $location.url().indexOf('login') != -1;
                };

                ctrl.logOutSSO = function () {
                    localStorage.removeItem('access_token');
                    $rootScope.isAuthenticated = false;
                };

                ctrl.showFeedbackModal = function () {
                    $rootScope.feedback = true;
                };

                ctrl.goToExternalUrl = function () {
                    $window.open(ctrl.externalUrl);
                };

                ctrl.disabledImpersonate = function () {
                    sessionStorage.removeItem('adal.impersonateRole');
                    impersonateService.impersonateUser(
                        sessionStorage.getItem('adal.oldidtoken'),
                        sessionStorage.getItem('adal.idtoken'),
                        false
                    )
                    $state.go('app.login');
                }

                $rootScope.$on('messageReceived', function (event, current, previous) {
                    api.communications.recipientUnread().then(function (data) {
                        ctrl.recipientUnreadMessages = data;
                    });
                });
                $rootScope.$on('readMessages', function (event, current, previous) {
                    api.communications.recipientUnread().then(function (data) {
                        ctrl.recipientUnreadMessages = data;
                    });
                });

                communicationService.start();
            }]
    });