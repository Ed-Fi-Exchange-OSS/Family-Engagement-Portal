angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.alert', {
            url: '/alert',
                requireADLogin: true,
                views: {
                    'content@': { component:'alert' }
                },
                resolve: {
                    model: ['api', function (api) { return api.alerts.getParentAlerts(); }],
                }
            });
    }])
    .component('alert', {
        bindings: {
            model: "<",
        }, // One way data binding.
        templateUrl: 'clientapp/modules/alert/alert.view.html',
        controllerAs:'ctrl',
        controller: ['api', '$translate', '$scope', 'landingRouteService', function (api, $translate, $scope, landingRouteService) {

            var ctrl = this;
            ctrl.urls = [];
            ctrl.save = function () {
                    return api.alerts.saveParentAlerts(ctrl.model).then(function (data) {
                        toastr.success($translate.instant('Information saved') + ".");
                    });
            };

            landingRouteService.getRoute().then(function (route) {
                ctrl.urls.push({ displayName: 'Home', url: route });
            });

            ctrl.changeAll = function () {
                ctrl.model.alerts.forEach(function (alert) {
                    if (ctrl.model.alertsEnabled)
                        alert.enabled = false;
                });
            }

            ctrl.$onInit = function () {

                var alert = ctrl.model.alerts.find(function (alert) { return alert.alertTypeId == 1 });

                alert.thresholds = alert.thresholds.filter(function (threshold) { return threshold.thresholdTypeId == 1 });
                alert.thresholds.find(function (threshold) { return threshold.thresholdTypeId == 1 }).description = "ADA Absence Threshold";
            }
        }]
    });