angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.navbar', {
                views: {
                    'navbar@': { component:'navbar' }
                },
                resolve: {
                    model: ['$stateParams', 'api', function ($stateParams, api) {
                        return api.students.get($stateParams.studentId);
                    }]
                }
        });

    }])
    .component('navbar', {
        templateUrl: 'clientapp/modules/navbar/navbar.view.html',
        controllerAs:'ctrl',
        controller: ['adalAuthenticationService', 'landingRouteService', 'api', '$rootScope', '$window', '$timeout', function (adalService, landingRouteService, api, $rootScope, $window, $timeout) {
            var ctrl = this;
            ctrl.role = "";
            ctrl.name = "";
            ctrl.externalUrl = "";
            ctrl.recipientUnreadMessages = null;
            ctrl.model = {
                user: {
                    name: adalService.userInfo.profile.name,
                    email: adalService.userInfo.userName
                },
                urls: []
            };

            landingRouteService.getRoute().then(function (route) {
                ctrl.model.urls.push({ displayName: 'Home', url: route, icon: 'ion-md-home' });
            });

            api.me.getMyBriefProfile().then(data => {
                ctrl.name = data.name;
                ctrl.role = data.role;
                ctrl.externalUrl = data.feedbackExternalUrl;
            }); 

            api.communications.recipientUnread().then(function (data) {
                console.log(data);
                ctrl.recipientUnreadMessages = data;
            });

            ctrl.logOutSSO = function () {
                adalService.logOut();
            };

            ctrl.showFeedbackModal = function () {
                $rootScope.feedback = true;
            };

            ctrl.goToExternalUrl = function () {
                $window.open(ctrl.externalUrl);
            };
            ctrl.getStudentImage = function (studentUniqueId) {
                api.image.getStudentImage(studentUniqueId).then(function (result) { return result; });
            };
        }]
    });