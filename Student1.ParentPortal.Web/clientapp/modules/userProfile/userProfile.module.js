angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.userProfile', {
            url: '/userProfile',
                //requireADLogin: true,
                views: {
                    'content@': { component:'userProfile' }
                },
                resolve: {
                    model: ['api', function (api) { return api.me.getMyProfile(); }],
                    methodOfContactTypes: ['api', function (api) { return api.types.getMethodOfContactTypes(); }],
                    languages: ['api', function (api) { return api.translate.getAvailableLanguages(); }],
                }
            });
    }])
    .component('userProfile', {
        bindings: {
            sections: "<",
            model: "<",
            methodOfContactTypes: "<",
            languages: "<",
        }, // One way data binding.
        templateUrl: 'clientapp/modules/userProfile/userProfile.view.html',
        controllerAs:'ctrl',
        controller: ['api', '$translate', '$scope', 'landingRouteService', '$rootScope', function (api, $translate, $scope, landingRouteService, $rootScope) {

            var ctrl = this;
            ctrl.urls = [];
            ctrl.save = function () {
                ctrl.changeLanguage(ctrl.model.languageCode);
                return api.me.saveMyProfile(ctrl.model).then(function (data) {
                        toastr.success($translate.instant('Information saved') + ".");
                });
            };


            ctrl.changeLanguage = function (code) {
                $rootScope.$broadcast('languageChange', { code: code });
            }

            landingRouteService.getRoute().then(function (route) {
                ctrl.urls.push({ displayName: $translate.instant('Home'), url: route, icon: 'ion-md-home' });
            });

            ctrl.uploadImage = function (e) {
                var file = e.target.files[0];

                if (!file)
                    return;

                ctrl.getBase64(file).then(function (data) {
                    $scope.$apply(function () {
                        ctrl.model.imageUrl = data;
                        var fd = new FormData();
                        fd.append("file", file);

                        api.me.uploadImage(fd).then(function (data) {
                            toastr.success($translate.instant('Information saved') + ".");
                        });
                    });
                   
                })
            }

            ctrl.getBase64 = function(file) {
                return new Promise(function(resolve, reject){
                    const reader = new FileReader();
                    reader.readAsDataURL(file);
                    reader.onload = function () { resolve(reader.result) };
                    reader.onerror = function (error) { reject(error) };
                });
            }

        }]
    });