angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.adminLanding', {
            url: '/adminLanding',
            views: {
                'content@': { component: 'adminLanding' }
            }
        });
    }])
    .component('adminLanding', {
        bindings: {
            model: "<"
        },
        templateUrl: 'clientapp/modules/admin/landing/landing.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$state', 'impersonateService', '$rootScope', function (api, $translate, $state, impersonateService, $rootScope) {
            var ctrl = this;
            
            ctrl.save = function () {
                if (ctrl.model != undefined) {
                    return api.admin.impersonate({ impersonateEmail: ctrl.model.emailInterpeson, token: sessionStorage.getItem('adal.idtoken') }).then(function (data) {
                        sessionStorage.setItem('adal.impersonateRole', data.impersonatingRole);
                        impersonateService.impersonateUser(data.token, sessionStorage.getItem('adal.idtoken'), true);
                        $state.go('app.login');
                    });
                } else {
                    return new Promise(function (resolve) {
                        resolve();
                        toastr.error("Please enter a email valid");
                    });
                }
            }
        }]
    });