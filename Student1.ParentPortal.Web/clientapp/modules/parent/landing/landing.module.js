angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.parentLanding', {
                url: '/landing',
                requireADLogin: true,
                views: {
                    'content@': { component:'parentLanding' }
                },
                resolve: {
                    model: ['api', function (api) {
                        return api.parents.getStudents();
                    }]
                }
            });
    }])
    .component('parentLanding', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/parent/landing/landing.view.html',
        controllerAs:'ctrl',
        controller: ['$location','api',function ($location, api) {
            var ctrl = this;
            ctrl.$onInit = function () {
                api.students.setStudentIds(ctrl.model.map(function (x) { return x.studentUsi }));
            }
        }]
    });